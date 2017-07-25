<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Document</title>

    <script src="${pageContext.request.contextPath}/resources/avatar/head/jquery.min.js"></script>

    <link rel="stylesheet" type="text/css" href="http://apps.bdimg.com/libs/bootstrap/3.3.4/css/bootstrap.css">
    <link href="${pageContext.request.contextPath}/resources/avatar/head/cropper.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/avatar/head/sitelogo.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="http://cdn.bootcss.com/font-awesome/4.6.0/css/font-awesome.min.css">
    <script src="${pageContext.request.contextPath}/resources/avatar/head/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/avatar/head/cropper.js"></script>
    <script src="${pageContext.request.contextPath}/resources/avatar/head/sitelogo.js"></script>

    <style type="text/css">
        .avatar-btns button {
            height: 35px;
        }
    </style>


</head>

<body>



<div class="user_pic" style="margin: 10px;">
    <c:if test="${loginUser.image != null}">
        <img src="/image/${loginUser.image}" />
    </c:if>
    <c:if test="${loginUser.image == null}">
        <img src="/image/user/null.jpg"/>
    </c:if>
</div>
<button type="button" class="btn btn-primary"  data-toggle="modal" data-target="#avatar-modal" style="margin: 10px;">修改头像</button>
<div class="modal fade" id="avatar-modal" aria-hidden="true" aria-labelledby="avatar-modal-label" role="dialog" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <!--<form class="avatar-form" action="upload-logo.php" enctype="multipart/form-data" method="post">-->
            <form class="avatar-form">
                <div class="modal-header">
                    <button class="close" data-dismiss="modal" type="button">&times;</button>
                    <h4 class="modal-title" id="avatar-modal-label">上传图片</h4>
                </div>
                <div class="modal-body">
                    <div class="avatar-body">
                        <div class="avatar-upload">
                            <input class="avatar-src" name="avatar_src" type="hidden">
                            <input class="avatar-data" name="avatar_data" type="hidden">
                            <label for="avatarInput" style="line-height: 35px;">图片上传</label>
                            <button class="btn btn-danger"  type="button" style="height: 35px;" onClick="$('input[id=avatarInput]').click();">请选择图片</button>
                            <span id="avatar-name"></span>
                            <input class="avatar-input hide" id="avatarInput" name="avatar_file" type="file"></div>
                        <div class="row">
                            <div class="col-md-9">
                                <div class="avatar-wrapper"></div>
                            </div>
                            <div class="col-md-3">
                                <div class="avatar-preview preview-lg" id="imageHead"></div>
                                <!--<div class="avatar-preview preview-md"></div>
                        <div class="avatar-preview preview-sm"></div>-->
                            </div>
                        </div>
                        <div class="row avatar-btns">
                            <div class="col-md-4">
                                <div class="btn-group">
                                    <button class="btn btn-danger fa fa-undo" data-method="rotate" data-option="-90" type="button" title="Rotate -90 degrees"> 向左旋转</button>
                                </div>
                                <div class="btn-group">
                                    <button class="btn  btn-danger fa fa-repeat" data-method="rotate" data-option="90" type="button" title="Rotate 90 degrees"> 向右旋转</button>
                                </div>
                            </div>
                            <div class="col-md-5" style="text-align: right;">
                                <button class="btn btn-danger fa fa-arrows" data-method="setDragMode" data-option="move" type="button" title="移动">
							            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;setDragMode&quot;, &quot;move&quot;)">
							            </span>
                                </button>
                                <button type="button" class="btn btn-danger fa fa-search-plus" data-method="zoom" data-option="0.1" title="放大图片">
							            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;zoom&quot;, 0.1)">
							              <!--<span class="fa fa-search-plus"></span>-->
							            </span>
                                </button>
                                <button type="button" class="btn btn-danger fa fa-search-minus" data-method="zoom" data-option="-0.1" title="缩小图片">
							            <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;zoom&quot;, -0.1)">
							              <!--<span class="fa fa-search-minus"></span>-->
							            </span>
                                </button>
                                <button type="button" class="btn btn-danger fa fa-refresh" data-method="reset" title="重置图片">
                                    <span class="docs-tooltip" data-toggle="tooltip" title="" data-original-title="$().cropper(&quot;reset&quot;)" aria-describedby="tooltip866214"></span>
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-danger btn-block avatar-save fa fa-save" type="button" data-dismiss="modal"> 保存修改</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="loading" aria-label="Loading" role="img" tabindex="-1"></div>
<script src="${pageContext.request.contextPath}/resources/avatar/head/html2canvas.min.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    //做个下简易的验证  大小 格式
    $('#avatarInput').on('change', function(e) {
        var filemaxsize = 1024 * 5;//5M
        var target = $(e.target);
        var Size = target[0].files[0].size / 1024;
        if(Size > filemaxsize) {
            alert('图片过大，请重新选择!');
            $(".avatar-wrapper").childre().remove;
            return false;
        }
        if(!this.files[0].type.match(/image.*/)) {
            alert('请选择正确的图片!')
        } else {
            var filename = document.querySelector("#avatar-name");
            var texts = document.querySelector("#avatarInput").value;
            var teststr = texts; //你这里的路径写错了
            testend = teststr.match(/[^\\]+\.[^\(]+/i); //直接完整文件名的
            filename.innerHTML = testend;
        }

    });

    $(".avatar-save").on("click", function() {
        var img_lg = document.getElementById('imageHead');
        // 截图小的显示框内的内容
        // 调用html2canvas(js类库)
        html2canvas(img_lg, {
            allowTaint: true,
            taintTest: false,
            onrendered: function(canvas) {
                //canvas.id = "mycanvas";
                // 生成base64图片数据
                var dataUrl = canvas.toDataURL("image/jpeg");
                //var newImg = document.createElement("img");
                //newImg.src = dataUrl;
                imagesAjax(dataUrl)
            }
        });
    })

    function imagesAjax(src) {
        var userId = '${loginUser.userId}';
        var data = {};
        data.userId = userId;
        data.img = src;
       // data.jid = $('#jid').val();
        $.ajax({
            url: "${pageContext.request.contextPath }/user/avatarUpload",
            data: data,
            type: "POST",
            dataType: 'json',
            success: function(result) {
                alert(result.message);
                if (result.success == true) {
                    // 页面刷新，这样才能显示新的session里面的数据
                   window.location.reload();
                }
            }
        });
    }
</script>
</body>

</html>