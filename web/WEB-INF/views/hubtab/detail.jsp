<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000006" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.hubTab"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="hubTabForm" method="POST">
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
                            <th><spring:message code="hubtab.column.tabId"/></th>
                            <td>
                                <input type="text" name="tabId" value="${hubTab.tabId}" placeholder="<spring:message code="hubtab.message.requireHubTabId"/>" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="hubtab.column.tabName"/></th>
                            <td class="point">
                                <input type="text" name="tabName" value="${hubTab.tabName}"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="hubtab.column.tabType"/></th>
                            <td class="point">
                                <select id="tabLinkTypeSelect" name="tabLinkType">
                                    <option value=""><spring:message code="common.button.select"/></option>
                                    <option value="web" ${hubTab.tabLinkType == 'web' ? 'selected' : ''}><spring:message code="hubtab.common.tabTypeWeb"/></option>
                                    <option value="postPop" ${hubTab.tabLinkType == 'postPop' ? 'selected' : ''}><spring:message code="hubtab.common.tabTypeCs"/></option>
                                    <option value="file" ${hubTab.tabLinkType == 'file' ? 'selected' : ''}><spring:message code="hubtab.common.tabTypeFile"/></option>
                                    <option value="groupware" ${hubTab.tabLinkType == 'groupware' ? 'selected' : ''}><spring:message code="hubtab.common.tabTypeGroupware"/></option>
                                </select>
                            </td>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point">
                                <span><input type="radio" name="useYn" value="Y" ${!empty hubTab && hubTab.useYn == 'Y' ? 'checked' : ''}/><spring:message code="common.column.useYes" /></span>
                                <span><input type="radio" name="useYn" value="N" ${empty hubTab || hubTab.useYn == 'N' ? 'checked' : ''}/><spring:message code="common.column.useNo" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.sortOrder"/></th>
                            <td>
                                <input type="number" name="tabSort" value="${hubTab.tabSort}" onkeypress="isNumber(this)"/>
                            </td>
                            <th><spring:message code="hubtab.column.tabUrl"/></th>
                            <td>
                                <input type="text" name="tabUrl" value="${hubTab.tabUrl}"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="hubtab.column.popWidth"/></th>
                            <td>
                                <input type="text" name="popWidth" value="${hubTab.popWidth}" onkeypress="isNumber(this)"/>
                            </td>
                            <th><spring:message code="hubtab.column.popHeight"/></th>
                            <td>
                                <input type="text" name="popHeight" value="${hubTab.popHeight}" onkeypress="isNumber(this)"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="hubtab.column.showPostion"/></th>
                            <td>
                                <span><input type="radio" name="tabPosition" value="top" ${!empty hubTab && hubTab.tabPosition == 'top' ? 'checked' : ''}/><spring:message code="hubtab.column.showTop" /></span>
                                <span><input type="radio" name="tabPosition" value="bottom" ${empty hubTab || hubTab.tabPosition == 'bottom' ? 'checked' : ''}/><spring:message code="hubtab.column.showBottom" /></span>
                            </td>
                            <th><spring:message code="hubtab.column.iconUrl"/></th>
                            <td>
                                <input type="text" name="iconUrl" value="${hubTab.iconUrl}"/>
                            </td>
                        </tr>
                        <c:if test="${!empty hubTab}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${hubTab.insertUserId}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${hubTab.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${hubTab.updateUserId}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${hubTab.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty hubTab}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addHubTab(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty hubTab}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveHubTab(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeHubTab(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#hubTabForm');

    var urlConfig = {
        'iconUrl':'${rootPath}/assets/images/hubtab/'
        ,'addUrl':'${rootPath}/hubtab/add.json'
        ,'saveUrl':'${rootPath}/hubtab/save.json'
        ,'removeUrl':'${rootPath}/hubtab/remove.json'
        ,'listUrl':'${rootPath}/hubtab/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="hubtab.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="hubtab.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="hubtab.message.removeConfirm"/>'
        ,'addComplete':'<spring:message code="hubtab.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="hubtab.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="hubtab.message.removeComplete"/>'
        ,'addFailure':'<spring:message code="hubtab.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="hubtab.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="hubtab.message.removeFailure"/>'
        ,'requireHubTabName':'<spring:message code="hubtab.message.requireHubTabName"/>'
        ,'requireHubTabIcon':'<spring:message code="hubtab.message.requireHubTabIcon"/>'
        ,'requireHubTabPopup':'<spring:message code="hubtab.message.requireHubTabPopup"/>'
    };

    $(document).ready(function(){
        onSelectIcon($('#iconSelect'));
    });

    function onSelectIcon(element){
        form.find('img[id=iconImg]').attr('src',urlConfig['iconUrl'] + $(element).find('option:selected').attr('name'));
    }


    function validate(type){
        if(form.find('input[name=tabName]').val().length == 0 && type != 3){
            alertMessage('requireHubTabName');
            return false;
        }

        if ($('#iconSelect').length>0){
            if($('#iconSelect').val().length == 0 && type != 3){
                alertMessage('requireHubTabIcon');
                return false;
            }
        }

        if($('#tabLinkTypeSelect').val().length == 0 && type != 3){
            alertMessage('requireHubTabPopup');
            return false;
        }

        return true;
    }

    function addHubTab(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('add',form.serialize());
        }
    }

    function saveHubTab(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(2)){
            callAjax('save',form.serialize());
        }
    }

    function removeHubTab(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }
        if(validate(3)){
            callAjax('remove',form.serialize());
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestHubTab_successHandler,requestHubTab_errorHandler,actionType);
    }

    function requestHubTab_successHandler(data, dataType, actionType){
        alertMessage(actionType+'Complete');
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

    function requestHubTab_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType+'Failure');
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>