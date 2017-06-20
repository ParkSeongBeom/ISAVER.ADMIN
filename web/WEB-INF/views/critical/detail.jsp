<!-- 임계치 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000005" var="menuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.critical"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->
    <form id="criticalForm" method="POST">
        <c:if test="${!empty critical}">
            <input type="hidden" name="eventId" value="${critical.eventId}" />
        </c:if>
        <input type="hidden" name="criticalInfo" value="${criticalInfo}" />
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
                        <th class="point"><spring:message code="critical.column.eventId"/></th>
                        <td class="point">
                            <select name="eventId" <c:if test="${!empty critical}">disabled</c:if>>
                                <c:choose>
                                    <c:when test="${events != null and fn:length(events) > 0}">
                                        <c:forEach var="event" items="${events}">
                                            <option value="${event.eventId}" <c:if test="${critical.eventId == event.eventId}">selected</c:if>>${event.eventName}(${event.eventId})</option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <option>없음</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </td>
                        <th class="point"><spring:message code="critical.column.criticalName"/></th>
                        <td class="point">
                            <input type="text" name="criticalName" value="${critical.criticalName}" placeholder="<spring:message code="critical.message.requireCriticalName"/>" />
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="common.column.useYn"/></th>
                        <td class="point" colspan="3">
                            <select name="useYn">
                                <option value="Y" <c:if test="${critical.useYn == 'Y'}">selected</c:if>><spring:message code="common.column.useYes"/></option>
                                <option value="N" <c:if test="${critical.useYn == 'N'}">selected</c:if>><spring:message code="common.column.useNo"/></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="critical.column.criticalDesc"/></th>
                        <td colspan="3">
                            <textarea name="description" class="textboard">${critical.description}</textarea>
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="critical.column.criticalRangeUseYn"/></th>
                        <td class="point" colspan="3">
                            <select name="rangeYn">
                                <option value="Y" <c:if test="${critical.rangeYn == 'Y'}">selected</c:if>><spring:message code="common.column.useYes"/></option>
                                <option value="N" <c:if test="${critical.rangeYn == 'N'}">selected</c:if>><spring:message code="common.column.useNo"/></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="critical.column.criticalRangeSetup"/></th>
                        <td colspan="3">
                            <table class="t_defalut t_type02 t_style03" id="range_tb">
                                <tr id="first_range_tr">
                                    <td><input type="text" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" value="${criticalInfos[0].startValue}" /></td>
                                    <td>~</td>
                                    <td><input type="text" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" value="${criticalInfos[0].endValue}" /></td>
                                    <c:if test="${critical.rangeYn == 'Y'}">
                                        <td><isaver:codeSelectBox groupCodeId="LEV" htmlTagName="levFlag" codeId="${criticalInfos[0].criticalLevel}" /></td>
                                    </c:if>
                                    <c:if test="${critical.rangeYn == 'N'}">
                                        <td><isaver:codeSelectBox groupCodeId="LEV" htmlTagName="levFlag" codeId="${range_lv}" /></td>
                                    </c:if>
                                    <c:if test="${empty critical}">
                                        <td><isaver:codeSelectBox groupCodeId="LEV" htmlTagName="levFlag" /></td>
                                    </c:if>
                                    <td></td>
                                </tr>
                                <c:if test="${critical.rangeYn == 'Y'}">
                                    <c:forEach var="criticalInfo" items="${criticalInfos}" varStatus="status">
                                        <c:if test="${status.count >= 2}">
                                            <tr type="range_tr">
                                                <td><input type="text" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" value="${criticalInfo.startValue}" /></td>
                                                <td>~</td>
                                                <td><input type="text" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" value="${criticalInfo.endValue}" /></td>
                                                <td><isaver:codeSelectBox groupCodeId="LEV" htmlTagName="levFlag" codeId="${criticalInfo.criticalLevel}" /></td>
                                                <td><button class='btn btype01 bstyle03' onclick='javascript:removeRangeLayer(this); return false;'>X</button></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <tr id="addBtn">
                                    <td class="point" colspan="5">
                                        <button class="btn btype01 bstyle03" onclick="javascript:addRangeLayer(); return false;">추가</button>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <c:if test="${!empty critical}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${critical.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${critical.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${critical.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${critical.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty critical}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addEvent(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty critical}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveEvent(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeEvent(); return false;"><spring:message code="common.button.remove"/> </button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>
<div style="display: none">
    <isaver:codeSelectBox groupCodeId="LEV" htmlTagId="selectLevFlag" htmlTagName="levFlag"/>
</div>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#criticalForm');

    var urlConfig = {
        'addUrl':'${rootPath}/critical/add.json'
        ,'saveUrl':'${rootPath}/critical/save.json'
        ,'removeUrl':'${rootPath}/critical/remove.json'
        ,'listUrl':'${rootPath}/critical/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="critical.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="critical.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="critical.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="critical.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="critical.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="critical.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="critical.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="critical.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="critical.message.removeComplete"/>'
        ,'requireCriticalName':'<spring:message code="critical.message.requireCriticalName"/>'
    };

    function validate(type){
//        if(form.find('input[name=eventId]').val().length == 0){
//            alertMessage('requireCodeId');
//            return false;
//        }

        switch(type){
            case 1:
                if(form.find('input[name=criticalName]').val().length == 0){
                    alertMessage('requireCriticalName');
                    return false;
                }
                if ($("select[name=rangeYn]").val() == "Y") {
                    var criticalInfo = addCriticalInfo();

                    if (criticalInfo.length == 0) {
                        return false;
                    } else {
                        $("input[name=criticalInfo]").val(criticalInfo.join());
                    }

                } else {
                    $("input[name=criticalInfo]").val($("#first_range_tr").find("select").val());
                }
                break;
            case 2:
                break;
        }

        return true;
    }

    function addEvent(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    function saveEvent(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }
        if(validate(1)){

            callAjax('save', form.serialize());
        }
    }

    function removeEvent(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(2)){
            callAjax('remove', form.serialize());
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestEvent_successHandler,requestEvent_errorHandler,actionType);
    }

    function requestEvent_successHandler(data, dataType, actionType){

        switch(actionType){
            case 'save':
                alertMessage(actionType + 'Complete');
                break;
            case 'add':
                if (data['existFlag'] == "true") {
                    alertMessage('eventAddExistFail');
                } else {
                    alertMessage(actionType + 'Complete');
                }
                break;
            case 'remove':
                alertMessage(actionType + 'Complete');
                break;
        }
        cancel();
    }

    function requestEvent_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
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

    function requestAction_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'actionList':
                makeActionListFunc(data['actions']);
                break;
        }
    }

    function makeCriticalListFunc(ranges) {
        if (ranges == null && ranges.length == 0) {
            return;
        }

    }


    function requestAction_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(actionType + 'Failure');
    }

    var html_item_btn = "<tr id='addBtn'>" +
            "<td class='point' colspan='5'>" +
            "<button class='btn btype01 bstyle03' onclick='javascript:addRangeLayer(); return false;'>추가</button>" +
            "</td>" +
            "</tr>";

    /**
     * range 레이어 추가
     */
    function addRangeLayer() {
        var html_item= "<tr type='range_tr'>"+
                "<td><input type='text' oninput=\"this.value=this.value.replace(/[^-\.0-9]/g);\" /></td>" +
                "<td>~</td>" +
                "<td><input type='text' oninput=\"this.value=this.value.replace(/[^-\.0-9]/g);\" /></td>" +
                "<td><select>"+ $("#selectLevFlag").html() +"</select></td>" +
                "<td><button class='btn btype01 bstyle03' onclick='javascript:removeRangeLayer(this); return false;'>X</button></td>" +
        "</tr>";

        $("#addBtn").remove();
        $("#range_tb").append(html_item).append(html_item_btn);
    }

    function removeRangeLayer(_this) {
        $(_this).parent().parent().remove();
    }

    /**
     *
     */
    function useNoRangeTr() {
        $("#first_range_tr").find("input").val("");
        $("#addBtn").remove();
        $("#first_range_tr input").attr('disabled', true);
        $("tr[type=range_tr]").remove();
    }

    function useYesRangeTr() {
        $("#first_range_tr input").attr('disabled', false);
        $("#range_tb").append(html_item_btn);
    }

    function addCriticalInfo() {

        var criticalInfoDatas = [];
        var checkDatas = [];

        var alertFlag = false;

        if ($.trim($("#first_range_tr").find("input:eq(0)").val()).length == 0 || $.trim($("#first_range_tr").find("input:eq(1)").val()).length == 0) {
            alertFlag = true;
        } else {
            var range_max = $.trim($("#first_range_tr").find("input:eq(1)").val());
            var range_min = $.trim($("#first_range_tr").find("input:eq(0)").val());

            if (range_max < range_min) {
                alertFlag = true;
            }

            criticalInfoDatas.push(
                    $("#first_range_tr").find("input:eq(0)").val() + "|" +
                    $("#first_range_tr").find("input:eq(1)").val() +  "|" +
                    $("#first_range_tr").find("select").val()
            );

            checkDatas.push({max : Number(range_max),min : Number(range_min) });
        }

        $("tr[type=range_tr]").each(function( index ) {
            var range_min = $(this).find("input:eq(0)").val();
            var range_max = $(this).find("input:eq(1)").val();
            var range_level = $(this).find("select").val();

            if (range_max < range_min) {
                alertFlag = true;
            }

            if ($.trim($(this).find("input:eq(0)").val()).length == 0 || $.trim($(this).find("input:eq(1)").val()).length == 0) {
                alertFlag = true;
            }

            if (alertFlag == false) {
                criticalInfoDatas.push(range_min + "|" + range_max +  "|" + range_level);
                checkDatas.push({max : Number(range_max),min : Number(range_min) });
            }

        });


//        function removeFunc(from, to) {
//            var rest = this.slice((to || from) + 1 || this.length);
//            this.length = from < 0 ? this.length + from : from;
//            return this.push.apply(this, rest);
//        };

        function _checkFunc(value, _copyArray) {
            var result = false;

            if (value == 100) {
//                debugger;
            }

            for (var ii = 0; ii < _copyArray.length; ii ++) {

                var item = _copyArray[ii];

                if (item != undefined) {
                    var _min = Number(item.min);
                    var _max = Number(item.max);

                    if (_max >= value && value >= _min) {
                        result = true;
                        break;
                    }
                }

            }
            return result;
        }

        for (var i = 0; i < checkDatas.length; i ++) {
            var item = checkDatas[i];
            var _min = Number(item.min);

            var _copyArray = checkDatas.slice(0);

            delete _copyArray[i];

            if (i > 0) {

                alertFlag = _checkFunc(_min, _copyArray);
                break;
//                console.log(i + "[" + _min + "]" + " _min=> " + _checkFunc(_min, _copyArray));
            }

        }

        if (alertFlag) {
            criticalInfoDatas = [];
            alert("임계치 범위 설정을 다시 한번 확인해 주세요.");
        }

        return criticalInfoDatas;

    }

    $(document).ready(function() {

        <c:if test="${critical.rangeYn == 'N'}"> useNoRangeTr();</c:if>

        $("select[name=rangeYn]").change(function() {
            if($(this).val() == "Y") {
                useYesRangeTr();
            }

            if($(this).val() == "N") {
                useNoRangeTr();
            }
        });

    })
    Array.prototype.remove = function(from, to) {
        var rest = this.slice((to || from) + 1 || this.length);
        this.length = from < 0 ? this.length + from : from;
        return this.push.apply(this, rest);
    };
</script>