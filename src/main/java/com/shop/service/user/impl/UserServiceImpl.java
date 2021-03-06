package com.shop.service.user.impl;

import com.shop.been.AjaxResult;
import com.shop.dao.user.UserMapper;
import com.shop.model.user.User;
import com.shop.service.user.UserService;
import com.shop.util.FtpUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import sun.misc.BASE64Decoder;
import javax.servlet.http.HttpSession;
import java.io.ByteArrayInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;
import java.util.Properties;

/**
 * <p>Title: UserServiceImpl</p>
 * <p>Description:</p>
 *
 * @Author 姚洪斌
 * @Date 2017/7/18 20:17
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;

    /**
     * 图片服务器的地址
     */
    @Autowired
    private Properties properties;

    public String selectUser(User user) {
        // 查询条件是用and，会查询出多个对象
        List<User> userList = userMapper.selectUser(user);
        for (User newUser : userList ) {
            if (newUser != null) {
                if (user.getUsername() != null && user.getUsername().equals(newUser.getUsername())) {
                    return "用户名已被注册，请重新注册!";
                }
                /*要判断""是因为前台原因，注册与找回密码时如果邮箱跟手机号有一个没填传过来的值不是null,会影响判断，
                user.getEmail() == null这个条件是修改绑定邮箱时用到，该页面不会有前台传值不是null的问题
                 */
                if ("".equals(user.getEmail()) || user.getEmail() == null) {
                    // 表示用户是用手机号码注册（修改绑定）的，判断手机号码是否已被注册即可
                    if (user.getPhoneNumber().equals(newUser.getPhoneNumber())) {
                        return "该手机号已被注册，请重新注册！";
                    }
                } else {
                    // 用户是用邮箱注册（修改绑定）的，判断邮箱是否已被注册即可
                    if (user.getEmail().equals(newUser.getEmail())) {
                        return "该邮箱已被注册，请重新注册！";
                    }
                }
            }
        }
        return null;   // 注册（修改）没有问题，不用返回错误信息
    }

    public String selectUser(User user, Integer identify) {
        // identify==0则表示是用户找回密码操作，发送验证码需要判断手机号/邮箱是否已经注册
        if (identify == 0) {
            User newUser = new User();
            List<User> newUserLsit = null;
            // 因为是ajax请求，所以不会有多余的值传过来，直接判断是否为空即可
            if (user.getPhoneNumber() == null) {
                newUser.setEmail(user.getEmail());
                newUserLsit = userMapper.selectUser(newUser);
                if (newUserLsit.isEmpty()) {
                    return "该邮箱尚未注册！";
                }
            } else {
                newUser.setPhoneNumber(user.getPhoneNumber());
                newUserLsit = userMapper.selectUser(newUser);
                if (newUserLsit.isEmpty()) {
                    return "该手机号码尚未注册！";
                }
            }
        }
        return null;
    }

    /**
     * 插入前先判断是因为前台原因导致注册时如果手机号和邮箱如果有一个没填传过来的值不是null,插入数据库时有值
     * @param user
     */
    public void saveUser(User user) {
        if ("".equals(user.getPhoneNumber())) {
            // 如果不设为null，则插入数据库时有值，查询出来时值不是null
            user.setPhoneNumber(null);
        } else if ("".equals(user.getEmail())) {
            user.setEmail(null);
        }
        userMapper.insert(user);
    }

    public User login(User user) {
       // mysql查询不区分大小写，登录查询时在password前面加上binary区分大小写
       List<User> loginUser =  userMapper.login(user);
       if (loginUser.isEmpty()) {
           return null;
       } else {
           // 返回登录对象，用于存进session域
           return loginUser.get(0);
       }
    }

    public void resetPassword(User user) {
        // 如果隐藏域没有传userId过来，如果有则表示是找回密码的操作，否则直接修改密码即可
        if (user.getUserId() == null) {
            User newUser = new User();
            newUser.setPassword(user.getPassword());
            // 前台原因如果有一个值没填传过来的值不是null,会影响sql
            if ("".equals(user.getPhoneNumber())) {
                newUser.setEmail(user.getEmail());
            } else {
                newUser.setPhoneNumber(user.getPhoneNumber());
            }
            // 找回密码，根据验证通过的手机号/邮箱修改密码
            userMapper.resetPassword(newUser);
        } else {
            // 用户帐户安全页面修改密码，根据id值修改密码
            userMapper.resetPassword(user);
        }
    }

    public String updateUser(User user) {
        // 个人资料的修改，如果手机号和邮箱为空，则表示是个人资料的修改，直接根据主键更新即可
        if (user.getEmail() == null && user.getPhoneNumber() == null) {
            userMapper.updateByPrimaryKeySelective(user);
            return null;
        }
        // 修改绑定手机号/邮箱前先判断是否已被注册
        String message = selectUser(user);
        if (message == null) {
            // 根据主键更新非null的字段
            userMapper.updateByPrimaryKeySelective(user);
        } else {
            return message;
        }
        return null;
    }

    public void updateSession(Integer userId, HttpSession session) {
        // 更新登录用户数据后根据登录用户的主键查询出新的数据
        User loginUser = userMapper.selectByPrimaryKey(userId);
        session.removeAttribute("loginUser");
        // 将新的登录用户对象保存进session域
        session.setAttribute("loginUser",loginUser);
    }

    public AjaxResult avatarUpload(String img, HttpSession session) {
        img = img.split("base64,")[1];
        // base64数据解析
        BASE64Decoder base = new BASE64Decoder();
        User user = (User)session.getAttribute("loginUser");
        try {
            byte[] b = base.decodeBuffer(img);
            // 将字节流转成inputStream
            InputStream inputStream = new ByteArrayInputStream(b);
            // 头像根据用户的id命名
            // 用户头像在图片服务器的保存地址
            boolean result = FtpUtil.uploadFile(properties.getProperty("FTP_ADDRESS"), Integer.parseInt(properties.getProperty("FTP_PORT")),
                    properties.getProperty("FTP_USER"),  properties.getProperty("FTP_PASSWORD"), properties.getProperty("BASE_PATH"),
                    properties.getProperty("FILE_PATH_USER"), user.getUserId() + ".jpg", inputStream);
            // ftp上传图片失败，抛出异常
            if (result == false) {
                throw new Exception();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new AjaxResult(false, "上传失败，请稍后重试");
        }
        // 保存图片上传到图片服务器后的名字
        user.setImage(user.getUserId() + ".jpg");
        // 更新用户数据
        userMapper.updateByPrimaryKeySelective(user);
        return new AjaxResult(true, "上传成功");
    }
}
