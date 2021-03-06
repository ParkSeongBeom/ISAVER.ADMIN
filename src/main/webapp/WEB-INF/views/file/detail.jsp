<!-- Map파일관리 상세 -->
<!-- @author psb -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="L00011" var="menuId"/>
<c:set value="L00010" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.file"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <form id="fileForm" method="POST">
        <input type="hidden" name="fileId" value="${file.fileId}" />
        <input type="hidden" name="physicalFileName" value="${file.physicalFileName}" />
        <input type="hidden" name="logicalFileName" value="${file.logicalFileName}" />

        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 filedetail_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>  <!-- 04 -->
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="point"><spring:message code="file.column.title"/></th>
                        <td class="point">
                            <input type="text" name="title" value="${file.title}"/>
                        </td>
                        <th class="point"><spring:message code="file.column.useYn"/></th>
                        <td class="point">
                            <div class="checkbox_set csl_style03">
                                <input type="hidden" name="useYn" value="${!empty file && file.useYn == 'Y' ? 'Y' : 'N'}"/>
                                <input type="checkbox" ${!empty file && file.useYn == 'Y' ? 'checked' : ''} onchange="setCheckBoxYn(this,'useYn')"/>
                                <label></label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="file.column.fileType"/></th>
                        <td class="point">
                            <isaver:codeSelectBox groupCodeId="FTA" codeId="${file.fileType}" htmlTagName="fileType"/>
                        </td>
                        <th class="point"><spring:message code="file.column.fileName"/></th>
                        <td class="point">
                            <!-- 파일 첨부 시작 -->
                            <div class="infile_set">
                                <input type="text" readonly="readonly" title="File Route" id="file_route">
                                    <span class="btn_infile btype03 bstyle04">
                                        <input type="file" name="file" onchange="javascript:document.getElementById('file_route').value=this.value" />
                                    </span>
                                <c:if test="${!empty file.logicalFileName}">
                                    <p class="before_file">
                                        <a href="${rootPath}/file/download.html?fileId=${file.fileId}" title="${file.logicalFileName}">${file.logicalFileName}</a>
                                    </p>
                                </c:if>
                            </div>
                            <!-- 파일 첨부 끝  -->
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="file.column.description"/></th>
                        <td colspan="3">
                            <textarea name="description">${file.description}</textarea>
                        </td>
                    </tr>
                    <c:if test="${!empty file}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${file.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${file.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${file.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${file.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty file.fileId}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addFile(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty file.fileId}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveFile(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeFile('${file.fkUseYn}'); return false;"><spring:message code="common.button.remove"/> </button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.list"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#fileForm');

    var urlConfig = {
        'addUrl':'${rootPath}/file/add.json'
        ,'saveUrl':'${rootPath}/file/save.json'
        ,'removeUrl':'${rootPath}/file/remove.json'
        ,'listUrl':'${rootPath}/file/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="file.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="file.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="file.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="file.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="file.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="file.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="file.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="file.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="file.message.removeComplete"/>'
        ,'titleEmpty':'<spring:message code="file.message.titleEmpty"/>'
        ,'fileTypeEmpty':'<spring:message code="file.message.fileTypeEmpty"/>'
        ,'fileEmpty':'<spring:message code="file.message.fileEmpty"/>'
        ,'usedFile':'<spring:message code="file.message.usedFile"/>'
    };

    $(document).ready(function() {
        $("input[name='file']").change(function(e) {
            var fileName = "";
            if(e.target.files.length>0){
                fileName = e.target.files[0].name;
            }
            $("input[name='logicalFileName']").val(fileName);
        });
    });

    function validate(){
        if(form.find('input[name=title]').val().length == 0){
            alertMessage('titleEmpty');
            return false;
        }

        if(form.find('select[name=fileType] option:selected').val().length == 0){
            alertMessage('fileTypeEmpty');
            return false;
        }

        if(form.find('input[name=physicalFileName]').val().length == 0 && form.find('input[name=logicalFileName]').val().length == 0){
            alertMessage('fileEmpty');
            return false;
        }
        return true;
    }

    function addFile(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjaxWithFile('add', form);
        }
    }

    function saveFile(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjaxWithFile('save', form);
        }
    }

    function removeFile(fkUseYn){
        if(fkUseYn!='N'){
            alertMessage('usedFile');
            return false;
        }

        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(2)){
            callAjax('remove', form.serialize());
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function callAjaxWithFile(actionType, form){
        sendAjaxFileRequest(urlConfig[actionType + 'Url'],form,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'save':
            case 'add':
            case 'remove':
                alertMessage(actionType + 'Complete');
                cancel();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>