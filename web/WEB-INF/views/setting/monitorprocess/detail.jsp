<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000025" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.monitorProcess"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="monitorProcessForm" method="POST">
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
                            <th><spring:message code="monitorprocess.column.processId"/></th>
                            <td>
                                <input type="text" name="processId" value="${monitorProcess.processId}" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="monitorprocess.column.monitorName"/></th>
                            <td class="point">
                                <select name="monitorId">
                                    <c:choose>
                                        <c:when test="${monitoringList != null and fn:length(monitoringList) > 0}">
                                            <c:forEach var="monitor" items="${monitoringList}">
                                                <option value="${monitor.monitorId}" <c:if test="${monitor.monitorId==monitorProcess.monitorId}">selected</c:if>>${monitor.name}</option>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <option value=""><spring:message code="common.message.emptyData"/></option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="monitorprocess.column.processName"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="W001" codeId="${monitorProcess.processCode}" htmlTagName="processCode"/>
                            </td>
                            <th class="point"><spring:message code="monitorprocess.column.serviceName"/></th>
                            <td class="point">
                                <input type="text" name="serviceName" value="${monitorProcess.serviceName}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="monitorprocess.column.description"/></th>
                            <td colspan="3">
                                <input type="text" name="description" value="${monitorProcess.description}" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty monitorProcess}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addMonitorProcess(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty monitorProcess}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveMonitorProcess(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeMonitorProcess(); return false;"><spring:message code="common.button.remove"/> </button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#monitorProcessForm');

    var urlConfig = {
        'addUrl':'${rootPath}/monitorProcess/add.json'
        ,'saveUrl':'${rootPath}/monitorProcess/save.json'
        ,'removeUrl':'${rootPath}/monitorProcess/remove.json'
        ,'listUrl':'${rootPath}/setting/list.html'
    };

    var messageConfig = {
        'addConfirm'      :'<spring:message code="common.message.addConfirm"/>'
        ,'addFailure'     :'<spring:message code="common.message.addFailure"/>'
        ,'addComplete'    :'<spring:message code="common.message.addComplete"/>'
        ,'saveConfirm'    :'<spring:message code="common.message.saveConfirm"/>'
        ,'saveFailure'    :'<spring:message code="common.message.saveFailure"/>'
        ,'saveComplete'   :'<spring:message code="common.message.saveComplete"/>'
        ,'removeConfirm'  :'<spring:message code="common.message.removeConfirm"/>'
        ,'removeFailure'  :'<spring:message code="common.message.removeFailure"/>'
        ,'removeComplete' :'<spring:message code="common.message.removeComplete"/>'
        ,'emptyServiceName' :'<spring:message code="monitorprocess.message.emptyServiceName"/>'
        ,'emptyMonitorId' :'<spring:message code="monitorprocess.message.emptyMonitorId"/>'
    };

    /*
     validate method
     @author psb
     */
    function validate(){
        if(form.find('input[name=serviceName]').val().trim().length == 0){
            alertMessage('emptyServiceName');
            return false;
        }

        if(form.find('select[name=monitorId]').val().trim().length == 0){
            alertMessage('emptyMonitorId');
            return false;
        }

        return true;
    }

    /*
     add method
     @author kst
     */
    function addMonitorProcess(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('add', form.serialize());
        }
    }

    /*
     모니터링 수정
     @author psb
     */
    function saveMonitorProcess(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        if(validate()){
            callAjax('save', form.serialize());
        }
    }

    /*
     remove method
     @author kst
     */
    function removeMonitorProcess(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }
        callAjax('remove', form.serialize());
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,errorHandler,actionType);
    }

    function successHandler(data, dataType, actionType){
        alert(messageConfig[actionType + 'Complete']);
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

    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(messageConfig[actionType + 'Failure']);
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function cancel(){
        var listForm = $('<FORM>').attr('action',urlConfig['listUrl']).attr('method','POST');
        listForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','monitorProcess'));
        document.body.appendChild(listForm.get(0));
        listForm.submit();
    }
</script>