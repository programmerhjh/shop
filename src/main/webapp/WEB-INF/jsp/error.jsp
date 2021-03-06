<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <link rel="stylesheet" type="text/css" />
    <script src="${pageContext.request.contextPath}/resources/theme/js/jquery-3.1.1.min.js" type="text/javascript"></script>
    <style>
        *{margin:0;padding:0}
        body{font-family:"微软雅黑";background:#DAD9D7}
        img{border:none}
        a *{cursor:pointer}
        ul,li{list-style:none}
        table{table-layout:fixed;}
        table tr td{word-break:break-all; word-wrap:break-word;}

        a{text-decoration:none;outline:none}
        a:hover{text-decoration:underline}
        .cf:after{content: ".";display: block;height: 0;font-size: 0;clear:both;visibility: hidden;}
        .cf{zoom: 1;clear:both}

        .bg{width:100%;background:url("${pageContext.request.contextPath}/resources/404/01.jpg") no-repeat center top #DAD9D7;position:absolute;top:0;left:0;height:600px;overflow:hidden}
        .cont{margin:0 auto;width:500px;line-height:20px;}
        .c1{height:360px;text-align:center}
        .c1 .img1{margin-top:180px}
        .c1 .img2{margin-top:165px}
        .cont h2{text-align:center;color:#555;font-size:18px;font-weight:normal;height:35px}
        .c2{height:35px;text-align:center}
        .c2 a{display:inline-block;margin:0 4px;font-size:14px;height:23px;color:#626262;padding-top:1px;text-decoration:none;text-align:left}
        .c2 a:hover{color:#626262;text-decoration:none;}
        .c2 a.home{width:66px;background:url("${pageContext.request.contextPath}/resources/404/02.png");padding-left:30px}
        .c2 a.home:hover{background:url("$${pageContext.request.contextPath}/resources/404/02.png") 0 -24px}
        .c2 a.home:active{background:url("${pageContext.request.contextPath}/resources/404/02.png") 0 -48px}
        .c2 a.re{width:66px;background:url("${pageContext.request.contextPath}/resources/404/03.png");padding-left:30px}
        .c2 a.re:hover{background:url("${pageContext.request.contextPath}/resources/404/03.png") 0 -24px}
        .c2 a.re:active{background:url("${pageContext.request.contextPath}/resources/404/03.png") 0 -48px}
        .c2 a.sr{width:153px;background:url("${pageContext.request.contextPath}/resources/404/04.png");padding-left:28px}
        .c2 a.sr:hover{background:url("${pageContext.request.contextPath}/resources/404/04.png") 0 -24px}
        .c2 a.sr:active{background:url("${pageContext.request.contextPath}/resources/404/04.png") 0 -48px}
        .c3{height:180px;text-align:center;color:#999;font-size:12px}
        #bf{position:absolute;top:269px;left:0;width:100%}
        .bf1{margin:0 auto;width:99px;padding-left:32px}
        .bd{height:600px;overflow:hidden}
        #box{position:absolute;top:165px;left:0;width:100%;text-align:center}
        .bf1{margin:0 auto;width:99px;padding-left:32px}
    </style>


</head>
</html>
