<%--
  Created by IntelliJ IDEA.
  User: psb
  Date: 2014. 7. 28.
  Time: 오후 02:22
  다음에디터 사진첨부 페이지
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>

<c:set var="rootPath" value="${pageContext.servletContext.contextPath}" scope="application"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%--<meta charset="utf-8">--%>
    <%--<meta http-equiv="X-UA-Compatible" content="IE=edge">--%>
    <%--<meta name="viewport" content="width=device-width, initial-scale=1">--%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Jabber Admin</title>
    <%-- dynatree, dhj --%>
    <link rel="stylesheet" type="text/css" href="${rootPath}/assets/css/dynatree/skin-vista/ui.dynatree.css" >
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui.custom.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/default.js"></script>
    <%-- dynatree, dhj --%>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.cookie.js"></script>

    <%-- dynatree, dhj --%>
    <script src="${rootPath}/assets/js/page/menu/MenuModel.js" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuCtrl.js" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuView.js" type="text/javascript" charset="UTF-8"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';
    </script>

    <link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
    <link rel="stylesheet" href="${rootPath}/assets/css/daumeditor/popup.css" type="text/css" charset="utf-8"/>

    <!-- jcrop -->
    <script type="text/javascript" src="${rootPath}/assets/library/jcrop/jquery.Jcrop.js"></script>
    <link rel='stylesheet' type='text/css' href='${rootPath}/assets/library/jcrop/jquery.Jcrop.css'>

    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/daumeditor/popup.js" charset="utf-8"></script>
</head>
<body>

<div class="wrapper">
	<div class="header">
		<h1>사진 첨부</h1>
	</div>
    <form id="uploadImageForm" method="POST">
        <input type="hidden" name="maxWidth" value="600" />
        <input type="hidden" name="photoX" />
        <input type="hidden" name="photoY" />
        <input type="hidden" name="photoW" />
        <input type="hidden" name="photoH" />

        <div class="body request_type">
            <dl class="alert">
                <dt>사진 첨부 확인</dt>
                <dd>
                    <div id="loadingBar" style="display:none; position:absolute;top:41px;left:50%;margin:-20px 0 0 -20px;z-index: 1001;">
                        <img src="${rootPath}/assets/images/editor/loading_s.gif"  style="height: initial;"/>
                    </div>
                    <div class="fileinput">
                        <input type="file" id="imageUploadFile" name="imageUploadFile" onchange="changePhoto(this);" />
                    </div>
                </dd>
            </dl>
        </div>
        <!--  사진편집 창 -->
        <section class="photoeditBox">
            <!--  사진 넣는 곳 height 크기 140 로 조정 -->
            <div class="photoedit">
                <img/>
            </div>
        </section>
    </form>
	<div class="footer">
		<p><a href="#" onclick="closeWindow();" title="닫기" class="close">닫기</a></p>
		<ul>
			<li class="submit"><a href="#" onclick="addImageFile();" title="등록" class="btnlink">등록</a> </li>
			<li class="cancel"><a href="#" onclick="closeWindow();" title="취소" class="btnlink">취소</a></li>
		</ul>
	</div>
</div>


<script type="text/javascript">
    var form = $('#uploadImageForm');
    var jcrop;

    var urlConfig = {
        'uploadUrl':'${rootPath}/common/uploadImage.json'
    };

    var messageConfig = {
        'emptyFile':'<spring:message code="common.message.emptyFile"/>'
        ,'uploadComplete':'<spring:message code="common.message.uploadComplete"/>'
        ,'imageFormatFailure':'<spring:message code="common.message.imageFormatFailure"/>'
        ,'uploadFailure':'<spring:message code="common.message.uploadFailure"/>'
        ,'emptyCrop':'<spring:message code="common.message.emptySelectarea"/>'
    };

    /*
     이미지 파일 첨부
     @author psb
     */
    function addImageFile(){
        if(validate(1)){
            form.append($('<INPUT>').attr('type','hidden').attr('name','path').attr('value',opener.parent.type));
            callAjax('upload', form);
        }
    }

    function callAjax(actionType, data){
        $("#loadingBar").show();
        sendAjaxFileRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        alert(messageConfig[actionType + 'Complete']);
        $("#loadingBar").hide();

        switch(actionType){
            case 'upload':
                done(data);
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(messageConfig[actionType + 'Failure']);
        $("#loadingBar").hide();
    }

    function done(result) {
        result = JSON.parse(result);

        if (typeof(execAttach) == 'undefined') { //Virtual Function
            return;
        }

        var _mockdata = {
            'imageurl': result.uploadPath+result.physicalFileName,
            'filename': result.logicalFileName,
            'filesize': result.fileSize,
            'imagealign': 'C',
            'originalurl': result.uploadPath+result.physicalFileName,
            'thumburl': result.uploadPath+result.physicalFileName,
            'width':result.width,
            'height':result.height
        };
        execAttach(_mockdata);
        closeWindow();
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function initUploader(){
        var _opener = PopupUtil.getOpener();
        if (!_opener) {
            alert('잘못된 경로로 접근하셨습니다.');
            return;
        }

        var _attacher = getAttacher('image', _opener);
        registerAction(_attacher);
    }

    $(document).ready(function() {
        initUploader();
    });

    /**
     * 사진변경 event handler
     * @author kst
     */
    function changePhoto(element){
        var fileStr = $(element).val();
        var extension = fileStr.substring(fileStr.lastIndexOf('.') + 1 , fileStr.length);

        switch(extension.toLowerCase()){
            case 'gif':
            case 'jpg':
            case 'jpeg':
            case 'png':
                break;
            default:
                alertMessage('imageFormatFailure');
                return;
        }

        initJcrop();

        var reader = new FileReader();
        reader.onload = function (e) {
            var image = new Image();
            image.src = e.target.result;
            image.onload = function(){};
            jcrop.setImage(e.target.result);
            setTimeout(function(){jcrop.animateTo([0,0,300,300])},300);
        };
        reader.readAsDataURL(element.files[0]);
    }

    /**
     * 사진 crop component initialize
     * @author kst
     */
    function initJcrop(){
        if(jcrop != null){
            jcrop.destroy();
        }

        $(".photoedit img").Jcrop({
            allowSelect : true,
            minSize : [40,40],
            boxWidth : 440,
            boxHeight : 210,
            onSelect: updateCoords,
            onChange: updateCoords,
            addClass: 'jcrop-centered'
        },function(){
            jcrop = this;
        });

        $('.photoeditBox .btnBox input').val(null);
    }

    /**
     * 사진 crop정보 갱신
     * @author kst
     * @param c
     */
    function updateCoords(c)
    {
        form.find('input[name=photoX]').val(c.x);
        form.find('input[name=photoY]').val(c.y);
        form.find('input[name=photoW]').val(c.w);
        form.find('input[name=photoH]').val(c.h);
    }

    function validate(){
        if(form.find('input:file').val().length == 0){
            alertMessage('emptyFile');
            return false;
        }

        if(form.find('input[name=photoW]').val() == "0" || form.find('input[name=photoH]').val()=="0"){
            alertMessage('emptyCrop');
            return false;
        }
        return true;
    }
</script>

</body>
</html>