<%--
  Created by IntelliJ IDEA.
  User: psb
  Date: 2014. 10. 13.
  Time: 오전 11:42
  도움말 상세 페이지
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-C000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-C000-0000-0000-000000000005" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.fnq"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="fnqForm" method="POST">
        <c:if test="${!empty fnq}">
            <input type="hidden" name="fnqId" value="${fnq.fnqId}" />
        </c:if>
        <input type="hidden" name="comment" />
        <input type="hidden" name="physicalFileName" value="${fnq.physicalFileName}" />
        <input type="hidden" name="logicalFileName" value="${fnq.logicalFileName}" />

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
                            <th class="point"><spring:message code="fnq.column.title"/></th>
                            <td class="point" colspan="3">
                                <input type="text" name="title" value='<c:out value="${fnq.title}"/>' placeholder="<spring:message code="fnq.message.requireTitle"/>"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="fnq.column.type"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="F001" codeId="${fnq.headerCode}" htmlTagName="headerCode"/>
                            </td>
                            <th class="point"><spring:message code="fnq.column.device"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="C005" codeId="${fnq.device}" htmlTagName="device"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.fileAttach"/></th>
                            <td colspan="3">
                                <!-- 파일 첨부 시작 -->
                                <div class="infile_set">
                                    <input type="text"  readonly="readonly" title="File Route" id="file_route">
                                    <span class="btn_infile btype03 bstyle04">
                                        <input type="file" name="fnqFile" onchange="javascript:document.getElementById('file_route').value=this.value">
                                    </span>
                                    <c:if test="${!empty fnq.logicalFileName}">
                                        <p class="before_file">
                                            <a href="${rootPath}/fnq/download.html?fnqId=${fnq.fnqId}" title="${fnq.logicalFileName}">${fnq.logicalFileName}</a>
                                        </p>
                                    </c:if>
                                </div>
                                <!-- 파일 첨부 끝  -->
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="height:400px; vertical-align:top; padding: 0;margin:0;line-height: 0;">
                                <iframe id="editorFrame" name="editorFrame" src="${rootPath}/common/editor.html" width="100%" height="100%" style="padding:0;margin:0;" ></iframe>
                            </td>
                        </tr>
                        <c:if test="${!empty fnq}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td><c:out value="${fnq.insertUserId}" /></td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${fnq.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td><c:out value="${fnq.updateUserId}" /></td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${fnq.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <%--<h4>테이블 타이틀</h4>--%>
                <div class="table_btn_set">
                    <c:if test="${empty fnq}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addFnq(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty fnq}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveFnq(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeFnq(); return false;"><spring:message code="common.button.remove"/> </button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<textarea id="comment" name="comment" style="display:none;">${fnq.comment}</textarea>
<!-- END : contents -->

<script type="text/javascript">

    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#fnqForm');
    var type = 'fnq';

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        addUrl      :   "${rootPath}/fnq/add.json"
        ,saveUrl    :   "${rootPath}/fnq/save.json"
        ,removeUrl  :   "${rootPath}/fnq/remove.json"
        ,listUrl    :   "${rootPath}/fnq/list.html"
    };

    /*
     message define
     @author kst
     */
    var messageConfig = {
        'addConfirm':'<spring:message code="fnq.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="fnq.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="fnq.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="fnq.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="fnq.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="fnq.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="fnq.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="fnq.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="fnq.message.removeComplete"/>'
        ,'requireTitle':'<spring:message code="fnq.message.requireTitle"/>'
    };

    /*
     validate method
     @author kst
     */
    function validate(type){
        if(form.find('input[name=title]').val().trim().length == 0){
            $('input[name=title]').focus();
            alertMessage('requireTitle');
            return false;
        }

        return true;
    }

    /*
     add method
     @author kst
     */
    function addFnq(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            $("input[name='comment']").val(editorFrame.Editor.getContent());
            callAjaxWithFile('add', form);
        }
    }

    /*
     save method
     @author kst
     */
    function saveFnq(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(2)){
            $("input[name='comment']").val(editorFrame.Editor.getContent());
            callAjaxWithFile('save', form);
        }
    }
    /*
     remove method
     @author kst
     */
    function removeFnq(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(3)){
            callAjax('remove', form.serialize());
        }
    }

    /*
     ajax call
     @author kst
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
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
                cancel();
                break;
            case 'add':
                cancel();
                break;
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
     alert message method
     @author dhj
     */
    function alertMessage(type){
        alert(messageConfig[type]);
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

    window.onload = function() {
        editorFrame.Editor.modify({
            content: document.getElementById("comment").value
        });
    }

    $(document).ready(function(){

        $("input[name='fnqFile']").change(function(e) {
            var fileName = e.target.files[0].name;
            $("input[name='logicalFileName']").val(fileName);
        });
    });
</script>