<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00020" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.code"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <article class="table_area left_table">
        <div class="table_title_area">
            <h4><spring:message code="groupcode.common.groupCodeList" /></h4>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle03" onclick="javascript:moveGroupCodeDetail('',''); return false;"><spring:message code="common.button.add"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table groupTb class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 18%;" />
                    <col style="width: *%;" />
                    <col style="width: 16%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="groupcode.column.groupCodeId"/></th>
                        <th><spring:message code="groupcode.column.groupName"/></th>
                        <th><spring:message code="code.column.codeId"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${groupCodes != null and fn:length(groupCodes) > 0}">
                            <c:forEach var="groupCode" items="${groupCodes}">
                                <tr groupCodeId="${groupCode.groupCodeId}">
                                    <td><a href="javascript:moveGroupCodeDetail('${groupCode.groupCodeId}')">${groupCode.groupCodeId}</a></td>
                                    <td>${groupCode.groupName}</td>
                                    <td><a href="javascript:findListCode('${groupCode.groupCodeId}')"><spring:message code="code.column.codeId"/></a></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4"><spring:message code="common.message.emptyData"/></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </article>

    <article class="table_area right_table">
        <div class="table_title_area">
            <h4><spring:message code="code.common.codeList"/></h4>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle03" onclick="javascript:moveCodeDetail('',''); return false;"><spring:message code="common.button.add"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table id="codeTable" class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 18%;" />
                    <col style="width: *%;" />
                    <col style="width: 20%;" />
                    <col style="width: 20%;" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="code.column.codeId"/></th>
                    <th><spring:message code="code.column.codeName"/></th>
                    <th><spring:message code="common.column.useYn"/></th>
                    <th><spring:message code="common.column.sortOrder"/></th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td colspan="4"><spring:message code="groupcode.message.selectCodeGroup"/></td>
                </tr>
                </tbody>
            </table>
        </div>
    </article>
</section>

<!-- END : contents -->
<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var textConfig = {
        'Y':'<spring:message code="common.column.useYes"/>'
        ,'N':'<spring:message code="common.column.useNo"/>'
    };

    var urlConfig = {
        'findListCodeUrl':'${rootPath}/code/list.json'
        ,'detailGroupCodeUrl':'${rootPath}/groupcode/detail.html'
        ,'detailCodeUrl':'${rootPath}/code/detail.html'
    };

    var messageConfig = {
        "emptyList":'<spring:message code="common.message.emptyData"/>'
        ,'failureFindListCode':'<spring:message code="code.message.findFailure"/>'
        ,'requireSelectGroupCode':'<spring:message code="groupcode.message.selectCodeGroup"/>'
    }

    var selectGroupCode = null;

    function findListCode(groupCodeId){
        $("table[groupTb] tr").removeClass("on");
        $("table[groupTb] tr[groupCodeId='"+groupCodeId+"']").addClass("on");
        selectGroupCode = groupCodeId;
        sendAjaxPostRequest(urlConfig['findListCodeUrl'],{"groupCodeId":groupCodeId},findListCode_successHandler,findListCode_errorHandler);
    }

    function findListCode_successHandler(data, dataType, actionType){
        if(data != null && data.hasOwnProperty('codes')){
            var codes = data['codes'];
            drawCodeList(codes);
        }else{
            alertMessage('failureFindListCode');
            clearGroupCode();
        }
    }

    function findListCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage('failureFindListCode');
        clearGroupCode();
    }

    function drawCodeList(codes){
        if(codes == null){
            alertMessage('failureFindListCode');
            clearGroupCode();
            return false;
        }

        $('#codeTable tbody').empty();


        if(codes.length < 1){
            var tr = $('<TR>');
            tr.append(
                $('<TD>').attr('colspan','4').text(messageConfig['emptyList'])
            );
            $('#codeTable tbody').append(tr);
            return false;
        }

        for(var index in codes){
            var code = codes[index];

            var tr = document.createElement("tr");
            tr.setAttribute("onClick", "moveCodeDetail('"+code['codeId']+"','"+code['groupCodeId']+"')");

            var tdCodeId = document.createElement("td");
            var tdCodeName = document.createElement("td");
            var tdCodeUseYn = document.createElement("td");
            var tdCodeSort = document.createElement("td");

            tdCodeId.textContent = code['codeId'];
            tdCodeName.textContent = code['codeName'];
            var useYn = textConfig[code['useYn']] == null ? textConfig['N'] : textConfig[code['useYn']];
            tdCodeUseYn.textContent = useYn;
            tdCodeSort.textContent = code['sortOrder'];

            tr.appendChild(tdCodeId);
            tr.appendChild(tdCodeName);
            tr.appendChild(tdCodeUseYn);
            tr.appendChild(tdCodeSort);

            $('#codeTable tbody').append(tr);

        }
    }

    function clearGroupCode(){
        selectGroupCode = null;
    }

    function moveGroupCodeDetail(groupCodeId){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailGroupCodeUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','groupCodeId').attr('value',groupCodeId));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }

    function moveCodeDetail(codeId,groupCodeId){
        if(selectGroupCode == null && (groupCodeId == null || groupCodeId == '' )){
            alertMessage('requireSelectGroupCode');
        }else{
            selectGroupCode = groupCodeId != null && groupCodeId != '' ? groupCodeId : selectGroupCode;

            var detailForm = $('<FORM>').attr('action',urlConfig['detailCodeUrl']).attr('method','POST');
            detailForm.append($('<INPUT>').attr('type','hidden').attr('name','codeId').attr('value',codeId));
            detailForm.append($('<INPUT>').attr('type','hidden').attr('name','groupCodeId').attr('value',selectGroupCode));
            document.body.appendChild(detailForm.get(0));
            detailForm.submit();
        }
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>