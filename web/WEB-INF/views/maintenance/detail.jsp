<%--
  Created by IntelliJ IDEA.
  User: dhj
  Date: 2014. 6. 11.
  Time: 오후 12:22
  의뢰하기 관리 상세 화면
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-C000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-C000-0000-0000-000000000002" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.maintenance"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="maintenanceForm" method="POST">
        <input type="hidden" name="maintenanceId"       value='<c:out value="${maintenance.maintenanceId}" />' />
        <input type="hidden" name="physicalFileName"    value='<c:out value="${maintenance.physicalFileName}" />' />
        <input type="hidden" name="logicalFileName"     value='<c:out value="${maintenance.logicalFileName}" />' />
        <input type="hidden" name="sysCode"             value='<c:out value="${maintenance.sysCode}" />' />
        <input type="hidden" name="typeCode"            value='<c:out value="${maintenance.typeCode}" />' />
        <input type="hidden" name="impCode"             value='<c:out value="${maintenance.impCode}" />' />
        <input type="hidden" name="status"              value='<c:out value="${maintenance.status}" />' />
        <input type="hidden" name="reviewComment"       value='<c:out value="${maintenance.reviewComment}" />' />

        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 t_style03">
                    <colgroup>
                        <col style="width:16%">  <!-- 01 -->
                        <col style="width:34%">  <!-- 02 -->
                        <col style="width:16%">  <!-- 03 -->
                        <col style="width:*">    <!-- 04 -->
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><spring:message code="maintenance.column.clientName"/></th>
                            <td><c:out value="${maintenance.requestUserId}" /></td>
                            <th><spring:message code="maintenance.column.requestDate"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${maintenance.requestDate}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.deviceCode"/></th>
                            <td><jabber:codeSelectBox groupCodeId="C005" codeId="${maintenance.deviceCode}" htmlTagId="selectDeviceCode" allModel="false" /></td>
                            <th><spring:message code="maintenance.column.reqEmail"/></th>
                            <td><c:out value="${maintenance.requestUserEmail}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.sysCode"/></th>
                            <td><jabber:codeSelectBox groupCodeId="C001" codeId="${maintenance.sysCode}" htmlTagId="selectSysCode" allModel="false" /></td>
                            <th><spring:message code="maintenance.column.typeCode"/></th>
                            <td><jabber:codeSelectBox groupCodeId="C002" codeId="${maintenance.typeCode}" htmlTagId="selectTypeCode" allModel="false" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.impCode"/></th>
                            <td><jabber:codeSelectBox groupCodeId="C006" codeId="${maintenance.impCode}" htmlTagId="selectImpCode" allModel="false" /></td>
                            <th><spring:message code="maintenance.column.status"/></th>
                            <td><jabber:codeSelectBox groupCodeId="C003" codeId="${maintenance.status}" htmlTagId="selectStatus" allModel="false" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.title"/></th>
                            <td colspan="3">${maintenance.title}</td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.requestText"/></th>
                            <td colspan="3">
                                <textarea name="requestComment" class="textboard" readonly="readonly"><c:out value="${maintenance.requestComment}" /></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.fileAttach"/></th>
                            <td colspan="3">
                                <!-- 파일 첨부 시작 -->
                                <div class="infile_set">
                                    <c:if test="${empty maintenance}">
                                        <input type="text"  readonly="readonly" title="File Route" id="file_route">
                                        <span class="btn_infile btype03 bstyle04">
                                            <input type="file" name="maintenanceFile" onchange="javascript:document.getElementById('file_route').value=this.value">
                                        </span>
                                    </c:if>
                                    <c:if test="${!empty maintenance.logicalFileName}">
                                        <p class="before_file">
                                            <a href="${rootPath}/maintenance/download.html?id=${maintenance.maintenanceId}" title="${maintenance.logicalFileName}">${maintenance.logicalFileName}</a>
                                        </p>
                                    </c:if>
                                </div>
                                <!-- 파일 첨부 끝  -->
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.reviewName"/></th>
                            <td colspan="3"><c:out value="${maintenance.reviewUserId}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.reviewStartDate"/></th>
                            <td class="date_input">
                                <input type="text" name="reviewStartDate" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${maintenance.reviewStartDate}" />"/>
                            </td>
                            <th><spring:message code="maintenance.column.reviewEndDate"/></th>
                            <td class="date_input">
                                <input type="text" name="reviewEndDate" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${maintenance.reviewEndDate}" />"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="maintenance.column.reviewText"/></th>
                            <td colspan="3">
                                <textarea name="reviewComment" class="textboard"><c:out value="${maintenance.reviewComment}" /></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:saveUser(); return false;"><spring:message code="common.button.save"/> </button>
                    <button class="btn btype01 bstyle03" onclick="javascript:removeUser(); return false;"><spring:message code="common.button.remove"/> </button>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<!-- END : contents -->
<script type="text/javascript" charset="UTF-8">

    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#maintenanceForm');
    var removeFileNameArr = [];

    var urlConfig = {
        addUrl      :   "${rootPath}/maintenance/add.json"
        ,saveUrl    :   "${rootPath}/maintenance/save.json"
        ,removeUrl  :   "${rootPath}/maintenance/remove.json"
        ,listUrl    :   "${rootPath}/maintenance/list.html"
    };

    /*
     message define
     @author kst
     */
    var messageConfig = {
        saveConfirm     :'<spring:message code="common.message.saveConfirm"/>',
        saveFailure     :'<spring:message code="maintenance.message.saveFailure"/>',
        removeFailure   :'<spring:message code="maintenance.message.removeFailure"/>',
        removeComplete  :'<spring:message code="maintenance.message.removeComplete"/>',
        saveComplete    :'<spring:message code="maintenance.message.saveComplete"/>',
        removeConfirm   :'<spring:message code="common.message.removeConfirm"/>'
    };

    /*
     ajax error handler
     @author kst
     */
    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author kst
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    /*
     save method
     @author kst
     */
    function saveUser(){
        if(!confirm("[ ${maintenance.title} ]" + messageConfig['saveConfirm'])){
            return false;
        }

//        $("input[name='physicalFileName']").val(fileLayout.getPhysicalFileObj());
//        $("input[name='logicalFileName']").val(fileLayout.getLogicalFileObj());
//        $("input[name='removeFileNames']").val(fileLayout.getRemoveFiles());

        $('input:hidden[name=reviewComment]').val($("textarea[name=reviewComment]").val());
        callAjaxWithFile('save', form);
    }

    /*
    * 의뢰하기 삭제
    * @author dhj
    */
    function removeUser(){
        if(!confirm("[ ${maintenance.title} ]" + messageConfig['removeConfirm'])){
            return false;
        }

        callAjaxWithFile('remove', form);
    }

    /*
     ajax with file call
     @author kst
     */
    function callAjaxWithFile(actionType, form){
        sendAjaxFileRequest(urlConfig[actionType + 'Url'],form,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    /*
     ajax success handler
     @author kst
     */
    function requestCode_successHandler(data, dataType, actionType){
        alertMessage(actionType + 'Complete');
        switch(actionType){
            case 'save':
            case 'remove':
                cancel();
                break;
        }
    }

    /*
     ajax error handler
     @author kst
     */
    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     cancel method
     @author dhj
     */
    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }

    $(document).ready(function(){

        $("input[name='maintenanceFile']").change(function(e) {
            var fileName = e.target.files[0].name;
            $("input[name='logicalFileName']").val(fileName);
        });

        $( "#selectSysCode" ).change(function() {
            var formName = menuModel.getFormName();
            $('input:hidden[name=sysCode]').val($("select[id=selectSysCode]").val());
        });

        $( "#selectImpCode" ).change(function() {
            var formName = menuModel.getFormName();
            $('input:hidden[name=impCode]').val($("select[id=selectImpCode]").val());
        });

        $( "#selectTypeCode" ).change(function() {
            var formName = menuModel.getFormName();
            $('input:hidden[name=typeCode]').val($("select[id=selectTypeCode]").val());
        });

        $( "#selectStatus" ).change(function() {
            var formName = menuModel.getFormName();
            $('input:hidden[name=status]').val($("select[id=selectStatus]").val());
        });

        calendarHelper.load(form.find('input[name=reviewStartDate]'));
        calendarHelper.load(form.find('input[name=reviewEndDate]'));
    });
</script>