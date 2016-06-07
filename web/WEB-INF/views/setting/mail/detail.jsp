<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000013" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.mail"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="mailForm" method="POST">
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
                            <th><spring:message code="mail.column.mailType"/></th>
                            <td>
                                <input type="text" name="mailType" value="${mail.mailType}" readonly="true" />
                            </td>
                            <th><spring:message code="mail.column.name"/></th>
                            <td>
                                <input type="text" name="name" value="${mail.name}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="mail.column.sendType"/></th>
                            <td>
                                <jabber:codeSelectBox groupCodeId="M001" codeId="${mail.sendType}" htmlTagName="sendType"/>
                            </td>
                            <th><spring:message code="mail.column.sendValue"/></th>
                            <td>
                                <input type="text" name="sendValue" value="${mail.sendValue}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="mail.column.receiveType"/></th>
                            <td>
                                <jabber:codeSelectBox groupCodeId="M001" codeId="${mail.receiveType}" htmlTagName="receiveType"/>
                            </td>
                            <th><spring:message code="mail.column.receiveValue"/></th>
                            <td>
                                <input type="text" name="receiveValue" value="${mail.receiveValue}" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point" colspan="3">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${mail.useYn}" htmlTagName="useYn"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty mail}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveServer(); return false;"><spring:message code="common.button.save"/> </button>
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
    var form = $('#mailForm');

    var urlConfig = {
        'saveUrl':'${rootPath}/mail/save.json'
        ,'listUrl':'${rootPath}/setting/list.html'
    };

    var messageConfig = {
        'saveConfirm'       :'<spring:message code="mail.message.saveConfirm"/>'
        ,'saveFailure'      :'<spring:message code="mail.message.saveFailure"/>'
        ,'saveComplete'     :'<spring:message code="mail.message.saveComplete"/>'
    };

    /*
     메일 정보 수정
     @author psb
     */
    function saveServer(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        callAjax('save', form.serialize());
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
        listForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','mail'));
        document.body.appendChild(listForm.get(0));
        listForm.submit();
    }
</script>