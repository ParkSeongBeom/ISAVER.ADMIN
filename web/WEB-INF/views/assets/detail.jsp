<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-H000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-H000-0000-0000-000000000002" var="menuId"/>

<jabber:pageRoleCheck menuId="${menuId}" />

<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.assets"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="assetsForm" method="POST">
        <c:if test="${!empty assets}">
            <input type="hidden" id="assetsId" name="assetsId" value="${assets.assetsId}"/>
        </c:if>

        <article class="table_area">
            <div class="table_title_area">
                <h4><spring:message code="common.title.assets"/></h4>
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
                            <th class="point"><spring:message code="assets.column.assetsName"/></th>
                            <td class="point">
                                <input type="text" name="assetsName" value="${assets.assetsName}" />
                            </td>
                            <th class="point"><spring:message code="assets.column.codeId"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="A001" codeId="${assets.codeId}" htmlTagName="codeId"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${assets.useYn}" htmlTagName="useYn"/>
                            </td>
                            <th class="point"><spring:message code="assets.column.limitYn"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${assets.limitYn}" htmlTagName="limitYn"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="assets.column.description"/></th>
                            <td>
                                <input type="text" name="description" value="${assets.description}" />
                            </td>
                            <th><spring:message code="assets.column.colorCode"/></th>
                            <td>
                                <input type="text" name="colorCode" value="${assets.colorCode}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="assets.column.sortOrder"/></th>
                            <td colspan="3">
                                <input type="number" name="sortOrder" value="${assets.sortOrder}" />
                            </td>
                        </tr>
                        <c:if test="${!empty assets}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${assets.insertUserName}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${assets.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${assets.updateUserName}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${assets.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <h4><spring:message code="assets.column.assetsTarget"/></h4>
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
                        <col style="width: *%;" />
                        <col style="width: 20%;" />
                        <col style="width: 20%;" />
                        <col style="width: 20%;" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="mainCheck" value=""></th>
                            <th><spring:message code="user.column.userId"/></th>
                            <th><spring:message code="organization.column.orgName"/></th>
                            <th><spring:message code="user.column.userName"/></th>
                            <th><spring:message code="user.column.classification"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${userAssetses != null and fn:length(userAssetses) > 0}">
                                <c:forEach var="userAssets" items="${userAssetses}">
                                    <tr>
                                        <td><input type="checkbox" name="subCheck"></td>
                                        <td>
                                            <input type="hidden" id="userId" value="${userAssets.userId}">
                                                ${userAssets.userId}
                                        </td>
                                        <td>${userAssets.orgName}</td>
                                        <td>${userAssets.userName}</td>
                                        <td>${userAssets.classification}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr id="emptyTr">
                                    <td colspan="5"><spring:message code="common.message.emptyData"/></td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty assets}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addAssets(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty assets}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveAssets(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeAssets(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#assetsForm');

    var urlConfig = {
        'addUrl':'${rootPath}/assets/add.json'
        ,'saveUrl':'${rootPath}/assets/save.json'
        ,'removeUrl':'${rootPath}/assets/remove.json'
        ,'listUrl':'${rootPath}/assets/list.html'
        ,'popupUrl':'${rootPath}/assets/popup.html'
    };

    var messageConfig = {
        'addFailure':'<spring:message code="assets.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="assets.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="assets.message.removeFailure"/>'
        ,'removeTargetEmpty':'<spring:message code="assets.message.removeTargetEmpty"/>'
        ,'emptyAssetsName':'<spring:message code="assets.message.emptyAssetsName"/>'
        ,'addConfirm':'<spring:message code="assets.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="assets.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="assets.message.removeConfirm"/>'
        ,'addComplete':'<spring:message code="assets.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="assets.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="assets.message.removeComplete"/>'
    };

    /*
     validate method
     @author psb
     */
    function validate(type){
        if(form.find('input[name=assetsName]').val().trim().length == 0){
            alertMessage('emptyAssetsName');
            return false;
        }
        return true;
    }

    /*
     대상추가팝업
     @author psb
     */
    function addTargetPopup(){
        window.open(urlConfig['popupUrl'],'assetsDetailUserPopup','scrollbars=no,width=700,height=680,left=50,top=50');
    }

    /*
     대상추가
     @author psb
     */
    function addTarget(userId, orgName, userName, classification){
        var groupTb = $("#groupTb tbody").find('tr');
        var flag = true;

        for (var i = 0; i < groupTb.length; i++) {
            if ($.trim($(groupTb[i]).find('td:eq(1)').text())==userId){
                flag = false;
            }
        }

        if(flag){
            $("#groupTb").append(
                            "<tr><td><input type='checkbox' id='subCheck' value=''></td>"
                            +"<td><input type='hidden' id='userId' value='"+userId+"'>"+userId+"</td>"
                            +"<td>"+orgName+"</td>"
                            +"<td>"+userName+"</td>"
                            +"<td>"+classification+"</td></tr>"
            );
        }else{
            return "<spring:message code="assets.message.addTargetDup"/>";
        }

        return null;
    }

    /*
     대상삭제
     @author psb
     */
    function removeTarget(){
        var assetsCheck = $("#groupTb input[name=subCheck]:checked");

        if(assetsCheck.length>0){
            for (var i = 0; i < assetsCheck.length; i++) {
                assetsCheck[i].parentNode.parentNode.remove();

                if ($("#groupTb tr").size()==1){
                    $("#groupTb").append("<tr id='emptyTr'><td colspan='5'><spring:message code='common.message.emptyData'/></td></tr>");
                }
            }
        }else{
            alertMessage('removeTargetEmpty');
        }
    }

    /*
     관리자 parameter 셋팅
     @author psb
     */
    function setAssetsUser(){
        var groupTb = $("#groupTb tbody").find('tr').not("#emptyTr");
        var groupUserId = "";

        for (var i = 0; i < groupTb.length; i++) {
            if(i > 0){
                groupUserId += ",";
            }
            groupUserId += $(groupTb[i]).children().find("#userId").val();
        }

        form.append($('<INPUT>').attr('type','hidden').attr('name','groupUserId').attr('value',groupUserId));
    }

    /*
     자원 추가
     @author psb
     */
    function addAssets(){
        if(!confirm(messageConfig['addConfirm'])) {
            return false;
        }

        if(validate(1)){
            setAssetsUser();
            callAjax('add', form.serialize());
        }
    }

    /*
     자원 수정
     @author psb
     */
    function saveAssets(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        if(validate(2)){
            setAssetsUser();
            callAjax('save', form.serialize());
        }
    }
    /*
     자원 제거
     @author psb
     */
    function removeAssets(){
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