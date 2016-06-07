<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000017" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.notification"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="notificationForm" method="POST">
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
                            <th><spring:message code="notification.column.notiId"/></th>
                            <td>
                                <input type="text" name="notiId" value="${notification.notiId}" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="notification.column.notiName"/></th>
                            <td class="point">
                                <input type="text" name="notiName" value="${notification.notiName}" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="notification.column.type"/></th>
                            <td class="point">
                                <input type="text" name="type" value="${notification.type}" />
                            </td>
                            <th><spring:message code="notification.column.sortOrder"/></th>
                            <td>
                                <input type="text" name="sortOrder" value="${notification.sortOrder}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="notification.column.url"/></th>
                            <td>
                                <input type="text" name="url" value="${notification.url}" />
                            </td>
                            <th><spring:message code="notification.column.imageUrl"/></th>
                            <td>
                                <input type="text" name="imageUrl" value="${notification.imageUrl}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="notification.column.width"/></th>
                            <td>
                                <input type="text" name="width" value="${notification.width}" />
                            </td>
                            <th><spring:message code="notification.column.height"/></th>
                            <td>
                                <input type="text" name="height" value="${notification.height}" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point" colspan="3">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${notification.useYn}" htmlTagName="useYn"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:saveNotification(); return false;"><spring:message code="common.button.save"/> </button>
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
    var form = $('#notificationForm');

    var urlConfig = {
        'saveUrl':'${rootPath}/notification/save.json'
        ,'listUrl':'${rootPath}/setting/list.html'
    };

    var messageConfig = {
        'saveConfirm'       :'<spring:message code="notification.message.saveConfirm"/>'
        ,'saveFailure'      :'<spring:message code="notification.message.saveFailure"/>'
        ,'saveComplete'     :'<spring:message code="notification.message.saveComplete"/>'
        ,'emptyNotiName'    :'<spring:message code="notification.message.emptyNotiName"/>'
        ,'emptyType'    :'<spring:message code="notification.message.emptyType"/>'
    };

    /*
     validate method
     @author psb
     */
    function validate(){
        if(form.find('input[name=notiName]').val().trim().length == 0){
            alertMessage('emptyNotiName');
            return false;
        }

        if(form.find('input[name=type]').val().trim().length == 0){
            alertMessage('emptyType');
            return false;
        }
        return true;
    }

    /*
     기능제한 수정
     @author psb
     */
    function saveNotification(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        if(validate()){
            callAjax('save', form.serialize());
        }
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
        listForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','notification'));
        document.body.appendChild(listForm.get(0));
        listForm.submit();
    }
</script>