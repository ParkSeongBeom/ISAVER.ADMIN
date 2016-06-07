<%--
  Created by IntelliJ IDEA.
  User: dhj
  Date: 2014. 6. 11.
  Time: 오전 11:42
  공지 사항 상세 페이지
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-C000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-C000-0000-0000-000000000001" var="menuId"/>
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
        <h3 class="1depth_title"><spring:message code="common.title.notice"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="noticeForm" method="POST">
        <c:if test="${!empty notice}">
            <input type="hidden" name="noticeId" value="${notice.noticeId}" />
        </c:if>
        <input type="hidden" name="headerCode" />
        <input type="hidden" name="comment" />
        <input type="hidden" name="startDatetime" value="${notice.startDatetime}" />
        <input type="hidden" name="endDatetime" value="${notice.endDatetime}" />
        <input type="hidden" name="physicalFileName" value="${notice.physicalFileName}" />
        <input type="hidden" name="logicalFileName" value="${notice.logicalFileName}" />
        <input type="hidden" name="pinYn" value="${notice.pinYn}" />
        <input type="hidden" name="popYn" value="${notice.popYn}" />

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
                            <th class="point"><spring:message code="notice.column.title"/></th>
                            <td class="point" colspan="3">
                                <input type="text" name="title" value='<c:out value="${notice.title}"/>' placeholder="<spring:message code="notice.message.requireTitle"/>"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="notice.column.type"/></th>
                            <td colspan="3">
                                <jabber:codeSelectBox groupCodeId="C007" codeId="${notice.headerCode}" htmlTagId="selectHeaderCode"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="notice.column.startDatetime"/></th>
                            <td class="point date_input">
                                <input type="text" name="startDatetimeStr" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${notice.startDatetime}" />"/>
                                <select id="selectMMstart"></select>
                            </td>
                            <th class="point"><spring:message code="notice.column.endDatetime"/></th>
                            <td class="point date_input">
                                <input type="text" name="endDatetimeStr" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${notice.endDatetime}" />"/>
                                <select id="selectMMend"></select>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="notice.column.pinYn"/></th>
                            <td>
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${notice.pinYn}" htmlTagId="pinYn"/>
                            </td>
                            <th><spring:message code="notice.column.popYn"/></th>
                            <td>
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${notice.popYn}" htmlTagId="popYn"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.fileAttach"/></th>
                            <td colspan="3">
                                <!-- 파일 첨부 시작 -->
                                <div class="infile_set">
                                    <input type="text"  readonly="readonly" title="File Route" id="file_route">
                                    <span class="btn_infile btype03 bstyle04">
                                        <input type="file" name="noticeFile" onchange="javascript:document.getElementById('file_route').value=this.value">
                                    </span>
                                    <c:if test="${!empty notice.logicalFileName}">
                                        <p class="before_file">
                                            <a href="${rootPath}/notice/download.html?noticeId=${notice.noticeId}" title="${notice.logicalFileName}">${notice.logicalFileName}</a>
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
                        <c:if test="${!empty notice.noticeId}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${notice.insertUserName}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${notice.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${notice.updateUserId}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${notice.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <%--<h4>테이블 타이틀</h4>--%>
                <div class="table_btn_set">
                    <c:if test="${empty notice.noticeId}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addNotice(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty notice.noticeId}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveNotice(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeNotice(); return false;"><spring:message code="common.button.remove"/> </button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<textarea id="comment" name="comment" style="display:none;">${notice.comment}</textarea>
<!-- END : contents -->

<script type="text/javascript">

    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#noticeForm');

    /*
     url defind
     @author dhj
     */
    var type = 'notice';
    var urlConfig = {
        addUrl      :   "${rootPath}/notice/add.json"
        ,saveUrl    :   "${rootPath}/notice/save.json"
        ,removeUrl  :   "${rootPath}/notice/remove.json"
        ,listUrl    :   "${rootPath}/notice/list.html"
    };

    /*
     message define
     @author kst
     */
    var messageConfig = {
        'addConfirm':'<spring:message code="notice.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="notice.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="notice.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="notice.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="notice.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="notice.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="notice.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="notice.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="notice.message.removeComplete"/>'
        ,'notEqualsPassword':'<spring:message code="user.message.notEqualPassword"/>'
        ,'requireTitle':'<spring:message code="notice.message.requireTitle"/>'
        ,'requireUserName':'<spring:message code="user.message.requireUserName"/>'
        ,'requirePassword':'<spring:message code="user.message.requirePassword"/>'
        ,'requireJabberId':'<spring:message code="user.message.requireJabberId"/>'
        ,'requireDomain':'<spring:message code="user.message.requireDomain"/>'
        ,'requirePhoneNumber':'<spring:message code="user.message.requirePhoneNumber"/>'
        ,'confirmStartDatetime':'<spring:message code="notice.message.confirmStartDatetime"/>'
        ,'confirmEndDatetime':'<spring:message code="notice.message.confirmEndDatetime"/>'
    };

    /**
     * 날짜 비교
     * @author dhj
     */
    function dataDiffCheck() {
        var startDt = $("input[name=startDatetimeStr]").val();
        var endDt = $("input[name=endDatetimeStr]").val();

        var startHour = $("#selectMMstart").val();
        var endHour = $("#selectMMend").val();

        var startDatetime = startDt + " " + startHour + ":00:00";
        var endDatetime = endDt + " " + endHour + ":59:59";

        if(startDatetime.length != 0 && !startDatetime.checkDatetimePattern(" ","-",":")){
            alertMessage('confirmStartDatetime');
            return false;
        }
        if(endDatetime.length != 0 && !endDatetime.checkDatetimePattern(" ","-",":")){
            alertMessage('confirmEndDatetime');
            return false;
        }

        var sDate = new Date(startDt);
        var eDate = new Date(endDt);

        if (sDate > eDate) {
            alert('시작일이 종료일보다 클 수 없습니다.');
            return false;
        }else if(startDt == endDt && startHour > endHour){
            alert('시작시간이 종료시간보다 클 수 없습니다.');
            return false;
        }

        $("input[name=startDatetime]").val(startDatetime);
        $("input[name=endDatetime]").val(endDatetime);
        return true;

    }

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

        if (dataDiffCheck()) {
            return true;
        } else {
            return false;
        }

    }

    /*
     add method
     @author kst
     */
    function addNotice(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            $("input[name='headerCode']").val($("#selectHeaderCode").val());
            $("input[name='pinYn']").val($("#pinYn").val());
            $("input[name='popYn']").val($("#popYn").val());
            $("input[name='comment']").val(editorFrame.Editor.getContent());
            callAjaxWithFile('add', form);
        }
    }

    /*
     save method
     @author kst
     */
    function saveNotice(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(2)){
            $("input[name='headerCode']").val($("#selectHeaderCode").val());
            $("input[name='pinYn']").val($("#pinYn").val());
            $("input[name='popYn']").val($("#popYn").val());
            $("input[name='comment']").val(editorFrame.Editor.getContent());
            callAjaxWithFile('save', form);
        }
    }
    /*
     remove method
     @author kst
     */
    function removeNotice(){
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
    };

    $(document).ready(function(){

        $("input[name='noticeFile']").change(function(e) {
            var fileName = e.target.files[0].name;
            $("input[name='logicalFileName']").val(fileName);
        });

        var startTime = '<fmt:formatDate pattern="HH" value="${notice.startDatetime}" />';
        var endTime = '<fmt:formatDate pattern="HH" value="${notice.endDatetime}" />';

        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));

        setHourDataToSelect($("#selectMMstart"), startTime, false);
        setHourDataToSelect($("#selectMMend"), endTime, true);
    });
</script>