<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Daum에디터 - 파일 첨부</title> 
<script src="../../js/popup.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="../../css/popup.css" type="text/css"  charset="utf-8"/>

<link rel="stylesheet" href="<c:url value="/css/jquery-ui.css"/>">
<link rel='stylesheet' type='text/css' href='<c:url value="/css/common.css"/>' />
<link rel="stylesheet" type='text/css' href='<c:url value="/js/library/noty/buttons.css"/>' />

<!-- jquery -->
<script type="text/javascript" src="<c:url value="/js/common/jquery-1.10.2.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/common/jquery-ui.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/common/jquery.form.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/common/jquery.nicescroll.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/common/jquery.easing.1.3.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/icent/common.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/common/jquery.ui.datepicker-ko.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/common/icent.common.util.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/library/noty/packaged/jquery.noty.packaged.min.js"/>"></script>

<script type="text/javascript">

	function uploadFile(){
		$("#form").ajaxSubmit({
			dataType: "json",
			type: "POST",
			url: '<c:url value="/file/upFile.json"/>',
			data : { path : "note" },
			beforeSend: function () {
				$("#loadingBar").show();
			},
			success: function(result) {
				if(result.fileList.length!=0){
					setTimeout(function(){
						$("#loadingBar").hide();
						
						done(result.fileList[0]);
					},1000);
				}else{
					alertMessage(result.message);
					$("#loadingBar").hide();
				}
			},
			error: function(e){
				errorMessage(e);
				$("#loadingBar").hide();
			}
		});
	}

	function checkFile(){
		var file_str = $("#upfile0").val();
		var inx = file_str.lastIndexOf('.');

		if (file_str==""){
			alertMessage("파일을 선택해주세요.");
			return;
		}

		uploadFile();
	}

	function done(_result) {
		if (typeof(execAttach) == 'undefined') { //Virtual Function
	        return;
	    }

		var _mockdata = {
			'attachurl': '/upload/note/'+_result.saveFileName,
			'filemime': 'image/gif',
			'filename': _result.orgFileName,
			'filesize': _result.fileSize
		};
		execAttach(_mockdata);
		closeWindow();
	}

	function initUploader(){
	    var _opener = PopupUtil.getOpener();
	    if (!_opener) {
	        alert('잘못된 경로로 접근하셨습니다.');
	        return;
	    }
	    
	    var _attacher = getAttacher('file', _opener);
	    registerAction(_attacher);
	}
	
</script>
</head>
<body onload="initUploader();">
<div class="wrapper">
	<div class="header">
		<h1>파일 첨부</h1>
	</div>	
<form id="form" method="post" enctype="multipart/form-data">
	<div class="body request_type">
		<dl class="alert">
		    <dt>파일 첨부 확인</dt>
		    <dd>
		    	<div id="loadingBar" style="display:none; position:absolute;top:41px;left:50%;margin:-20px 0 0 -20px;z-index: 1001;">
					<img src="<c:url value="/images/notice/roading_s.gif"/>" style="height: initial" alt="로딩바">
				</div>
			    <span class="fileinput">
					<input type="text" id="filePath" name="filePath" readonly="readonly">
					<input type="file" id="upfile0" name="upfile0" onchange="javascript: document.getElementById('filePath').value = this.value"><button>찾아보기</button>
				</span>
			</dd>
		</dl>
	</div>
</form>
	<div class="footer">
		<p><a href="#" onclick="closeWindow();" title="닫기" class="close">닫기</a></p>
		<ul>
			<li class="submit"><a href="#" onclick="checkFile();" title="등록" class="btnlink">등록</a> </li>
			<li class="cancel"><a href="#" onclick="closeWindow();" title="취소" class="btnlink">취소</a></li>
		</ul>
	</div>
</div>
</body>
</html>