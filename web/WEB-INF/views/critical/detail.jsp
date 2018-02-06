<!-- 임계치 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="J00011" var="menuId"/>
<c:set value="J00010" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />

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
        <input type="hidden" name="criticalInfo" />
        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 criticaldetail_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>  <!-- 04 -->
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
                            <div class="checkbox_set csl_style03">
                                <input type="hidden" name="useYn" value="${!empty critical && critical.useYn == 'Y' ? 'Y' : 'N'}"/>
                                <input type="checkbox" ${!empty critical && critical.useYn == 'Y' ? 'checked' : ''} onchange="setCheckBoxYn(this,'useYn')"/>
                                <label></label>
                            </div>
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
                            <div class="checkbox_set csl_style03">
                                <input type="hidden" name="rangeYn" value="${!empty critical && critical.rangeYn == 'Y' ? 'Y' : 'N'}"/>
                                <input type="checkbox" id="rangeYn" ${!empty critical && critical.rangeYn == 'Y' ? 'checked' : ''}/>
                                <label></label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="critical.column.criticalRangeSetup"/></th>
                        <td colspan="3" class="intd" id="rangeTb">
                            <!-- 타이틀 영역 -->
                            <div class="except01">
                                <p>최소범위 수치 입력</p>
                                <span>~</span>
                                <p>최대범위 수치 입력</p>
                                <p>임계치 선택</p>
                                <p>알림파일 선택</p>
                                <div>삭제ㆍ추가</div>
                            </div>

                            <c:choose>
                                <c:when test="${criticalInfos != null and fn:length(criticalInfos) > 0}">
                                    <c:forEach var="criticalInfo" items="${criticalInfos}" varStatus="status">
                                        <!-- 임계치 범위 설정 사용 추가 항목 -->
                                        <div>
                                            <input type="text" name="startValue" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" value="${criticalInfo.startValue}" placeholder="최소범위 수치 입력" />
                                            <span>~</span>
                                            <input type="text" name="endValue" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" value="${criticalInfo.endValue}" placeholder="최대범위 수치 입력" />
                                            <isaver:codeSelectBox groupCodeId="LEV" htmlTagName="criticalLevel" codeId="${criticalInfo.criticalLevel}" />
                                            <select name="alarmId">
                                                <option value=""><spring:message code="common.column.selectNo"/></option>
                                                <c:forEach var="alarm" items="${alarmList}">
                                                    <option value="${alarm.alarmId}" <c:if test="${alarm.alarmId==criticalInfo.alarmId}">selected="selected"</c:if>>${alarm.alarmName}</option>
                                                </c:forEach>
                                            </select>
                                            <!-- 임계치 범위 미사용 시 버튼 삭제 -->
                                            <div>
                                                <c:if test="${status.count > 1}">
                                                    <button class='btn ico-minus' onclick='javascript:removeRangeLayer(this); return false;'></button>
                                                </c:if>
                                                <button class='btn ico-plus' onclick="javascript:addRangeLayer(this); return false;"></button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- 임계치 범위 설정 사용 추가 항목 -->
                                    <div>
                                        <input type="text" name="startValue" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" placeholder="최소범위 수치 입력" />
                                        <span>~</span>
                                        <input type="text" name="endValue" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" placeholder="최대범위 수치 입력" />
                                        <isaver:codeSelectBox groupCodeId="LEV" htmlTagName="criticalLevel" />
                                        <select name="alarmId">
                                            <option value=""><spring:message code="common.column.selectNo"/></option>
                                            <c:forEach var="alarm" items="${alarmList}">
                                                <option value="${alarm.alarmId}">${alarm.alarmName}</option>
                                            </c:forEach>
                                        </select>
                                        <!-- 임계치 범위 미사용 시 버튼 삭제 -->
                                        <div>
                                            <button class='btn ico-plus' onclick="javascript:addRangeLayer(this); return false;"></button>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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
                        <button class="btn btype01 bstyle03" onclick="javascript:addCritical(); return false;"><spring:message code="common.button.add"/></button>
                    </c:if>
                    <c:if test="${!empty critical}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveCritical(); return false;"><spring:message code="common.button.save"/></button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeCritical(); return false;"><spring:message code="common.button.remove"/></button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.list"/></button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>
<div style="display: none">
    <!-- 임계치 범위 설정 사용 추가 항목 -->
    <div id="rangeTbTag">
        <div>
            <input type="text" name="startValue" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" placeholder="최소범위 수치 입력" />
            <span>~</span>
            <input type="text" name="endValue" oninput="this.value=this.value.replace(/[^-\.0-9]/g,'');" placeholder="최대범위 수치 입력" />
            <isaver:codeSelectBox groupCodeId="LEV" htmlTagName="criticalLevel" />
            <select name="alarmId">
                <option value=""><spring:message code="common.column.selectNo"/></option>
                <c:forEach var="alarm" items="${alarmList}">
                    <option value="${alarm.alarmId}">${alarm.alarmName}</option>
                </c:forEach>
            </select>
            <!-- 임계치 범위 미사용 시 버튼 삭제 -->
            <div>
                <button class='btn ico-minus' onclick='javascript:removeRangeLayer(this); return false;'></button>
                <button class='btn ico-plus' onclick="javascript:addRangeLayer(this); return false;"></button>
            </div>
        </div>
    </div>
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
        ,'requireCriticalRange':'<spring:message code="critical.message.requireCriticalRange"/>'
    };

    $(document).ready(function() {
        $("#rangeYn").on("change", function(){
            setCheckBoxYn(this,'rangeYn');
            changeRangeYn();
        });
        changeRangeYn();
    });

    function changeRangeYn(){
        if($("input[name=rangeYn]").val()=="Y"){
            $(".ico-plus").show();
            $("#rangeTb div input").attr('disabled', false);
        }else if($("input[name=rangeYn]").val()=="N"){
            $("#rangeTb > div").not(".except01, :eq(1)").remove();
            $(".ico-plus").hide();
            $("#rangeTb div input").attr('disabled', true).val(0);
        }
    }

    /**
     * 임계치범위 설정 레이어 추가
     */
    function addRangeLayer(_this) {
        $(_this).parent().parent().after($("#rangeTbTag > div").clone());
    }

    /**
     * 임계치범위 설정 레이어 제거
     */
    function removeRangeLayer(_this) {
        $(_this).parent().parent().remove();
    }

    function validate(){
        if(form.find('input[name=criticalName]').val().length == 0){
            alertMessage('requireCriticalName');
            return false;
        }

        var criticalInfo = addCriticalInfo();
        if(criticalInfo.length==0){
            alertMessage('requireCriticalRange');
            return false;
        }else{
            $("input[name=criticalInfo]").val(criticalInfo.join());
        }
        return true;
    }

    function addCriticalInfo(){
        var criticalInfo = [];
        var checkDatas = [];
        var alertFlag = false;

        $.each($("#rangeTb > div").not(".except01"),function(){
            var startValue = $.trim($(this).find("input[name='startValue']").val());
            var endValue = $.trim($(this).find("input[name='endValue']").val());
            var criticalLevel = $(this).find("select[name='criticalLevel']").val();
            var alarmId = $(this).find("select[name='alarmId']").val();

            if (Number(endValue) < Number(startValue)) {
                alertFlag = true;
            }

            if (startValue == "" || endValue == "") {
                alertFlag = true;
            }

            if (alertFlag == false) {
                criticalInfo.push(startValue + "|" + endValue + "|" + criticalLevel + "|" + alarmId);
                checkDatas.push({start : Number(startValue),end : Number(endValue) });
            }
        });

        checkDatas.sort(function (a, b) {
            return a.start < b.start ? -1 : a.start > b.start ? 1 : 0;
        });

        for(var index in checkDatas){
            if(index>0){
                if(checkDatas[index]['start'] <= checkDatas[index-1]['end']){
                    alertFlag = true;
                }
            }
        }

        if (alertFlag) {
            criticalInfo = [];
        }
        return criticalInfo;
    }

    function addCritical(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('add', form.serialize());
        }
    }

    function saveCritical(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('save', form.serialize());
        }
    }

    function removeCritical(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        callAjax('remove', form.serialize());
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,errorHandler,actionType);
    }

    function successHandler(data, dataType, actionType){
        switch(actionType){
            case 'add':
            case 'save':
            case 'remove':
                alertMessage(actionType + 'Complete');
                break;
        }
        cancel();
    }

    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
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
</script>