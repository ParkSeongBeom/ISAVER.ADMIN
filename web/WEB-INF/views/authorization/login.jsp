<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!doctype html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="format-detection" content = "telephone=no">
    <meta name="autocomplete" content="off" />
    <meta http-equiv="imagetoolbar" content="no" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${rootPath}/assets/css/base.css" rel="stylesheet" type="text/css" />
    <!--[if lt IE 9] -->
    <script src="${rootPath}/assets/js/util/html5.js"></script>
    <!--[endif] -->
    <title>i-saver Admin</title>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.cookie.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/md5.min.js"></script>
</head>
<body class="login_mode">
<form id="loginForm" method="POST">
    <div class="wrap">
        <!-- hearder Start 고통부분 -->
        <section class="login_area">
            <article>
                <div class="login_logo_area"><p></p></div>

                <!-- 로그인 입력 폼 Start -->
                <div class="login_input_area">
                    <input type="text" name="userId" placeholder="ID" class="log_id"/>
                    <input type="password" name="userPassword" placeholder="Password" class="log_pw"/>
                    <p class="caps" style="display: none;">CapsLock이 켜져 있습니다!</p>
                    <input type="checkbox" id="saveAdminIdCheck" name="id_save" />아이디 저장
                </div>
                <!-- 로그인 입력 폼 End -->

                <button href="#" alt="로그인" class="btn_login fa" onclick="javascript:login(); return false;">로그인</button>
            </article>
        </section>
        <!-- section End -->
    </div>
</form>
<%--<script type="text/javascript" src="${rootPath}/assets/js/retina.js"></script>--%>
<script type="text/javascript">

    var form = $('#loginForm');
    var autoLoginFlag = "${autoLoginFlag}"

    var urlConfig = {
        'loginUrl':'${rootPath}/login.json'
        ,'mainUrl':'${rootPath}/dashboard/all.html'
    };

    $(document).ready(function(){
        if(autoLoginFlag=="true"){
            location.href=urlConfig['mainUrl'];
        }

        var userId = $.cookie("userId");

        if(userId != null && userId.length > 0){
            form.find('input[name=userId]').val($.cookie("userId"));
            $("#saveAdminIdCheck").attr("checked", true);
        }

        form.find('input[name=userId], input[name=userPassword]').bind("keyup", function(evt){
            var code = evt.keyCode || evt.which;
            if(code == 13){
                login();
            }
        });

        $('.log_pw').keypress(function(e) {
            e = e || window.event;
            if (this.value === '') {
                $('.caps').hide();
                return;
            }
            var character = String.fromCharCode(e.keyCode || e.which);
            if (character.toUpperCase() === character.toLowerCase()) {
                return;
            }
            if ((e.shiftKey && character.toLowerCase() === character) ||
                    (!e.shiftKey && character.toUpperCase() === character)) {
                $('.caps').show();
                $('.log_pw').addClass("red");
            } else {
                $('.caps').hide();
                $('.log_pw').removeClass("red");
            }
        });
    });

    function validate(){
        if(form.find('input[name=userId]').val() == ''){
            alertMessage('requiredAdminId');
            return false;
        }

        if(form.find('input[name=userPassword]').val() == ''){
            alertMessage('requiredPassword');
            return false;
        }

        return true;
    }

    function setCookieAdminId(){
        if($('#saveAdminIdCheck').is(':checked')){
            $.cookie('userId',form.find('input[name=userId]').val());
        }else{
            $.cookie('userId','');
        }
    }

    function login(){
        if(validate()){
            setCookieAdminId();

            var userInfo = {
                'userId' : $("input[name=userId]").val(),
                'userPassword' : md5($("input[name=userPassword]").val())
            };
            sendAjaxPostRequest(urlConfig['loginUrl'], userInfo,login_successHandler,login_failureHandler);
        }
    }

    function login_successHandler(data, dataType, actionType){
        location.href=urlConfig['mainUrl'];
    }

    function login_failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage('loginFailure');
    }


    var messageConfig = {
        'requiredAdminId':'<spring:message code="common.message.requestId"/>'
        ,'requiredPassword':'<spring:message code="common.message.requiredPassword"/>'
        ,'loginFailure':'<spring:message code="common.message.loginFailure"/>'
    };
    function alertMessage(type){
        alert(messageConfig[type]);
    }

</script>
</body>
</html>