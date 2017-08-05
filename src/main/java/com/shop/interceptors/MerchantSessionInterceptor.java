package com.shop.interceptors;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * <p>Description:商家拦截器</p>
 *
 * @Author 姚洪斌
 * @Date 2017/8/4 7:45
 */
public class MerchantSessionInterceptor implements HandlerInterceptor {

    private List<String> excludeUrls;
    public void setExcludeUrls(List<String> excludeUrls) {
        this.excludeUrls = excludeUrls;
    }
    public List<String> getExcludeUrls() {
        return excludeUrls;
    }

    // 执行controller前执行
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        String requestUri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String url = requestUri.substring(contextPath.length());
        if (excludeUrls.contains(url)) {
            return true;
        } else if (request.getSession().getAttribute("loginUser") == null) {
            request.setAttribute("message","您还没有登录或登录已超时，请重新登录");
            request.getRequestDispatcher("/WEB-INF/jsp/user/login.jsp").forward(request,response);
            return false;
        } else if(request.getSession().getAttribute("loginMerchant") == null) {
            request.getRequestDispatcher("/WEB-INF/jsp/user/add_merchant.jsp").forward(request,response);
            return false;
        }
        return true;
    }

    // 执行controller后,返回ModelAndView前执行
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object o, ModelAndView modelAndView) throws Exception {

    }

    // 返回ModelAndView后执行
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object o, Exception e) throws Exception {

    }
}
