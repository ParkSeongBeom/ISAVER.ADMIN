<%--
  에러페이지
  @author kst
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<%--<html lang="ko-KR">--%>
<head>
  <meta charset="UTF-8">
  <title>Error</title>
  <link rel="stylesheet" type="text/css" href="${rootPath}/assets/css/base.css?version=${version}">
  <link rel="stylesheet" type="text/css" href="${rootPath}/assets/css/common.css?version=${version}">
  <link rel="stylesheet" type="text/css" href="${rootPath}/assets/css/intro.css?version=${version}">
  <link rel="stylesheet" type="text/css" href="${rootPath}/assets/hub_css/board.css?version=${version}">
  <!-- jquery -->
  <script type="text/javascript" src="${rootPath}/assets/library/jquery/jquery-1.9.0.js?version=${version}"></script>
  <!-- util -->
  <script type="text/javascript" src="${rootPath}/assets/js/util/consolelog-helper.js?version=${version}"></script>
  <script type="text/javascript" src="${rootPath}/assets/js/util/cs.communicator.js?version=${version}" charset="UTF-8"></script>
</head>
<body class="main_talk_body">
<div class="main_talk" style="width: 90%">
  <div class="mt_icon">
    <img src="${rootPath}/assets/images/error/info.gif"/>
  </div>

  <h1><spring:message code="error.message.title"/></h1>

  <p class="mt_text_box">
    <spring:message code="error.message.subTitle" />
  </p>

  <button href="#" onclick="javascript:history.go(-1)" class="btn b_type02 go_login"><spring:message code="error.button.retry"/></button>
  <button href="#" id="loginBtn" onclick="moveIntro()" class="btn b_type02 go_login" style="display:none"><spring:message code="error.button.login"/></button>

  <br>
  <p style="cursor:pointer" onclick="showMessage()"><spring:message code="error.message.errorDetail"/></p>
  <textarea id="errorMessage" style="display:none" readonly>${result.data}</textarea>
</div>

<script type="text/javascript">
  var urlConfig = {
    'introUrl':'${rootPath}/index.html'
  };

  function showMessage(){
    document.getElementById('errorMessage').style['display']= 'block';
  }

  function moveIntro(){
    var form = $('<FORM>').attr('method','POST').attr('action',urlConfig['introUrl']);
    form.append($('<INPUT>').attr('type','hidden').attr('name','logout').attr('value','Y'));
    form.appendTo(document.body);
    form.submit();
  }
</script>
</body>
</html>
