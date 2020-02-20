<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00060" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.target"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <form id="targetForm" method="POST">
        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 userdetail_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>  <!-- 04 -->
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="point"><spring:message code="target.column.targetId"/></th>
                            <td class="point">
                                <select name="targetId">
                                    <option value="icent" ${target.targetId=="icent"?'selected':''}>iCent</option>
                                    <option value="posco" ${target.targetId=="posco"?'selected':''}>포스코</option>
                                    <option value="taekwon" ${target.targetId=="taekwon"?'selected':''}>태권도원</option>
                                    <option value="nonsan" ${target.targetId=="nonsan"?'selected':''}>논산교도소</option>
                                    <option value="pnit" ${target.targetId=="pnit"?'selected':''}>PNIT</option>
                                    <option value="nowon" ${target.targetId=="nowon"?'selected':''}>노원구청</option>
                                </select>
                            </td>
                            <th class="point"><spring:message code="target.column.targetName"/></th>
                            <td class="point">
                                <input type="text" name="targetName" value="${target.targetName}" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:saveTarget(); return false;"><spring:message code="common.button.save"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#targetForm');

    /*
     url defind
     @author kst
     */
    var urlConfig = {
        'listUrl':'${rootPath}/target/detail.html'
        ,'saveUrl':"${rootPath}/target/save.json"
    };

    /*
     message define
     @author kst
     */
    var messageConfig = {
        'saveConfirm':'<spring:message code="target.message.saveConfirm"/>'
        ,'saveFailure':'<spring:message code="target.message.saveFailure"/>'
        ,'saveComplete':'<spring:message code="target.message.saveComplete"/>'
        ,'requireTargetName':'<spring:message code="target.message.requireTargetName"/>'
    };

    /*
     validate method
     @author kst
     */
    function validate(){
        if(form.find('input[name=targetName]').val().trim().length == 0){
            alertMessage('requireTargetName');
            return false;
        }
        return true;
    }

    /*
     save method
     @author kst
     */
    function saveTarget(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('save', form.serialize());
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
     ajax success handler
     @author kst
     */
    function requestCode_successHandler(data, dataType, actionType){
        alertMessage(actionType + 'Complete');
        cancel();
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
     @author kst
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>