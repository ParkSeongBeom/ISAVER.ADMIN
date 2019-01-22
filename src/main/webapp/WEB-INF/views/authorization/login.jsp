<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content = "telephone=no">
    <meta name="autocomplete" content="off" />
    <meta http-equiv="imagetoolbar" content="no" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${rootPath}/assets/css/reset.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/css/layouts.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/css/elements.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/css/dashboard.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/css/admin.css?version=${version}" rel="stylesheet" type="text/css" />
    <!--[endif] -->
    <title>i-Saver Login</title>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.cookie.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/md5.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.iframe-post-form.js"></script>
</head>
<body class="login_mode ${mainTarget.targetId=='taekwon'?'taekwon_mode':''}">
    <div class="wrap">
        <!-- hearder Start 공통부분 -->
        <section class="login_area">
            <article>
                <h1>${majorVersion}</h1>
                <!-- 로그인 입력 폼 Start -->
                <!-- 다국어 지원 추가 -->
                <%--<select class="language" onchange="javascript:window.location.href='?lang='+$(this).val();">--%>
                    <%--<option value="ko_KR" ${pageContext.response.locale=='ko_KR'?'selected':''}><spring:message code="common.selectbox.korean"/></option>--%>
                    <%--<option value="en_US" ${pageContext.response.locale=='en_US'?'selected':''}><spring:message code="common.selectbox.english"/></option>--%>
                <%--</select>--%>

                <form id="loginForm" method="POST">
                    <div class="login_input_area">
                        <input type="text" name="userId" placeholder="ID" class="log_id"/>
                        <input type="password" name="userPassword" placeholder="Password" class="log_pw"/>
                        <p class="caps"><spring:message code="login.message.capsLockPress"/></p>
                    </div>

                    <div class="checkbox_set csl_style01">
                        <input type="checkbox" id="saveAdminIdCheck" name="id_save" />
                        <label></label>
                        <span><spring:message code="login.column.saveId"/></span>
                    </div>
                </form>
                <!-- 로그인 입력 폼 End -->
                <button href="#" alt="Login" class="btn" onclick="javascript:login(); return false;"><spring:message code="login.button.login"/></button>

                <div class='license_notice <c:if test="${license.status != 0 and license.status != -99}">on</c:if>'>
                    <p>
                        <c:choose>
                            <c:when test="${license.status == -1}">
                                <spring:message code='common.message.expireLicense'/>
                            </c:when>
                            <c:when test="${license.status == -4}">
                                <spring:message code='common.message.emptyLicense'/>
                            </c:when>
                            <c:otherwise>
                                <spring:message code='common.message.emptyLicense'/>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </article>
        </section>
        <!-- section End -->
    </div>
    <script type="text/javascript">

        var form = $('#loginForm');
        var autoLoginFlag = "${autoLoginFlag}";

        var urlConfig = {
            'loginUrl':'${rootPath}/login.json'
            ,'mainUrl':'${rootPath}/dashboard/list.html'
        };

        var commonMessageConfig = {
            'inProgress':'<spring:message code="common.message.inProgress"/>'
        };

        var licenseInfo = {
            status : "${license.status}"
            ,message : "${license.message}"
        };

        var messageConfig = {
            'requiredAdminId':'<spring:message code="common.message.requestId"/>'
            ,'requiredPassword':'<spring:message code="common.message.requiredPassword"/>'
            ,'loginFailure':'<spring:message code="common.message.loginFailure"/>'
            ,'emptyLicense':'<spring:message code="common.message.emptyLicense"/>'
            ,'expireLicense':'<spring:message code="common.message.expireLicense"/>'
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

            $('.caps').hide();
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
            var license = data['license'];
            switch (license['status']){
                case 0:
                case -99: // 라이센스 인가 체크 안함
                    location.href=urlConfig['mainUrl'];
                    break;
                case -1: // 기한만료
                    alertMessage('expireLicense');
                    break;
                default : // 기타 오류
                    alertMessage('emptyLicense');
            }
        }

        function login_failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
            alertMessage('loginFailure');
        }

        function alertMessage(type){
            alert(messageConfig[type]);
        }

    </script>
</body>
</html>