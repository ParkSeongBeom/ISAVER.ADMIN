<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-H000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-E000-0000-0000-000000000001" var="menuId"/>

<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.broadcast"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="broadcastForm" method="POST">
        <c:if test="${!empty broadcast}">
            <input type="hidden" id="broadcastId" name="broadcastId" value="${broadcast.broadcastId}"/>
        </c:if>

        <article class="table_area">
            <div class="table_title_area">
                <h4><spring:message code="common.title.broadcast"/></h4>
            </div>

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
                            <th class="point"><spring:message code="broadcast.column.broadcastName"/></th>
                            <td class="point">
                                <input type="text" name="broadcastName" value="${broadcast.broadcastName}" />
                            </td>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${broadcast.useYn}" htmlTagName="useYn"/>
                            </td>
                        </tr>
                        <c:if test="${!empty broadcast}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${broadcast.insertUserId}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${broadcast.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${broadcast.updateUserId}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${broadcast.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <h4><spring:message code="broadcast.column.broadcastTarget"/></h4>
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:addTargetPopup(); return false;"><spring:message code="common.button.addTarget"/> </button>
                    <button class="btn btype01 bstyle03" onclick="javascript:removeTarget(); return false;"><spring:message code="common.button.removeTarget"/> </button>
                </div>
            </div>

            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table id="groupTb" class="t_defalut t_type01 t_style02">
                    <colgroup>
                        <col style="width: 5%;" />
                        <col style="width: 10%;" />
                        <col style="width: *%;" />
                        <col style="width: 15%;" />
                        <col style="width: 15%;" />
                        <col style="width: 15%;" />
                        <col style="width: 15%;" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="mainCheck" value=""></th>
                            <th><spring:message code="broadcast.column.gubn"/></th>
                            <th><spring:message code="user.column.userId"/></th>
                            <th><spring:message code="organization.column.orgName"/></th>
                            <th><spring:message code="user.column.userName"/></th>
                            <th><spring:message code="user.column.classification"/></th>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${broadcastGroups != null and fn:length(broadcastGroups) > 0}">
                                <c:forEach var="broadcastGroup" items="${broadcastGroups}">
                                    <tr>
                                        <td><input type="checkbox" name="subCheck"></td>
                                        <td>
                                            <input type="hidden" id="gubn" value="${broadcastGroup.gubn}">
                                            <c:choose>
                                                <c:when test="${broadcastGroup.gubn == 'O'}">
                                                    <spring:message code="broadcast.column.owner"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <spring:message code="broadcast.column.participant"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <input type="hidden" id="userId" value="${broadcastGroup.userId}">
                                                ${broadcastGroup.userId}
                                        </td>
                                        <td>${broadcastGroup.orgName}</td>
                                        <td>${broadcastGroup.userName}</td>
                                        <td>${broadcastGroup.classification}</td>
                                        <td>
                                                ${broadcastGroup.insertUserName != null ? broadcastGroup.insertUserName : broadcastGroup.insertUserId}
                                        </td>
                                        <td>
                                            <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${broadcastGroup.insertDatetime}" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr id="emptyTr">
                                    <td colspan="8"><spring:message code="common.message.emptyData"/></td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty broadcast}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addBroadcast(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty broadcast}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveBroadcast(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeBroadcast(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#broadcastForm');

    var urlConfig = {
        'addUrl':'${rootPath}/broadcast/add.json'
        ,'saveUrl':'${rootPath}/broadcast/save.json'
        ,'removeUrl':'${rootPath}/broadcast/remove.json'
        ,'listUrl':'${rootPath}/broadcast/list.html'
        ,'popupUrl':'${rootPath}/broadcast/popup.html'
    };

    var messageConfig = {
        'addFailure':'<spring:message code="broadcast.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="broadcast.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="broadcast.message.removeFailure"/>'
        ,'removeTargetEmpty':'<spring:message code="broadcast.message.removeTargetEmpty"/>'
        ,'requireBroadcastName':'<spring:message code="broadcast.message.requireBroadcastName"/>'
        ,'addConfirm':'<spring:message code="broadcast.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="broadcast.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="broadcast.message.removeConfirm"/>'
        ,'addComplete':'<spring:message code="broadcast.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="broadcast.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="broadcast.message.removeComplete"/>'
    };

    /*
     validate method
     @author psb
     */
    function validate(type){
        if(form.find('input[name=broadcastName]').val().trim().length == 0){
            alertMessage('requireBroadcastName');
            return false;
        }
        return true;
    }

    /*
     대상추가팝업
     @author psb
     */
    function addTargetPopup(){
        window.open(urlConfig['popupUrl'],'broadcastDetailUserPopup','scrollbars=no,width=700,height=550,left=50,top=50');
    }

    /*
     대상추가
     @author psb
     */
    function addTarget(gubn, userId, orgName, userName, classification){
        var groupTb = $("#groupTb tbody").find('tr');
        var flag = true;
        var gubnName;

        if (gubn == 'O'){
            gubnName = "<spring:message code="broadcast.column.owner"/>";
        }else{
            gubnName = "<spring:message code="broadcast.column.participant"/>";
        }

        for (var i = 0; i < groupTb.length; i++) {
            if ($.trim($(groupTb[i]).find('td:eq(1)').text())==gubnName
             && $.trim($(groupTb[i]).find('td:eq(2)').text())==userId){
                flag = false;
            }
        }

        if(flag){
            $("#groupTb").append(
                            "<tr><td><input type='checkbox' id='subCheck' value=''></td>"
                            +"<td><input type='hidden' id='gubn' value='"+gubn+"'>"+gubnName+"</td>"
                            +"<td><input type='hidden' id='userId' value='"+userId+"'>"+userId+"</td>"
                            +"<td>"+orgName+"</td>"
                            +"<td>"+userName+"</td>"
                            +"<td>"+classification+"</td><td></td><td></td></tr>"
            );
        }else{
            return "<spring:message code="broadcast.message.addTargetDup"/>";
        }

        return null;
    }

    /*
     대상삭제
     @author psb
     */
    function removeTarget(){
        var broadCheck = $("#groupTb input[name=subCheck]:checked");

        if(broadCheck.length>0){
            for (var i = 0; i < broadCheck.length; i++) {
                broadCheck[i].parentNode.parentNode.remove();

                if ($("#groupTb tr").size()==1){
                    $("#groupTb").append("<tr id='emptyTr'><td colspan='8'><spring:message code='common.message.emptyData'/></td></tr>");
                }
            }
        }else{
            alertMessage('removeTargetEmpty');
        }
    }

    /*
     동보방송 오너/대상자 parameter 셋팅
     @author psb
     */
    function setBroadcastGroup(){
        var groupTb = $("#groupTb tbody").find('tr');
        var broadcastGroup = "";

        for (var i = 0; i < groupTb.length; i++) {
            var gubn = $(groupTb[i]).children().find("#gubn").val();
            var userId = $(groupTb[i]).children().find("#userId").val();

            if(i > 0){
                broadcastGroup += "|";
            }
            broadcastGroup += gubn+","+userId;
        }

        form.append($('<INPUT>').attr('type','hidden').attr('name','broadcastGroup').attr('value',broadcastGroup));
    }

    /*
     동보방송 추가
     @author psb
     */
    function addBroadcast(){
        if(!confirm(messageConfig['addConfirm'])) {
            return false;
        }

        if(validate(1)){
            setBroadcastGroup();
            callAjax('add', form.serialize());
        }
    }

    /*
     동보방송 수정
     @author psb
     */
    function saveBroadcast(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        if(validate(2)){
            setBroadcastGroup();
            callAjax('save', form.serialize());
        }
    }
    /*
     동보방송 제거
     @author psb
     */
    function removeBroadcast(){
        if(!confirm(messageConfig['removeConfirm'])) {
            return false;
        }

        callAjax('remove', form.serialize());
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        alert(messageConfig[actionType + 'Complete']);
        switch(actionType){
            case 'save':
                break;
            case 'add':
            case 'remove':
                cancel();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(messageConfig[actionType + 'Failure']);
    }

    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    $(document).ready(function(){
        $('#mainCheck').click(function(){
            if($(this).is(':checked')){
                $("#groupTb input[name=subCheck]").prop("checked",true);
            }else{
                $("#groupTb input[name=subCheck]").prop("checked",false);
            }
        });
    });
</script>