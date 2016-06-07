<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-J000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-U000-0000-0000-000000000003" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.setting"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="fileSettingForm" method="POST">
        <input type="hidden" name="targetId" value="${target.targetId}"/>

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
                            <th><spring:message code="target.column.limitFileSize"/></th>
                            <td>
                                <input type="text" name="limitFileSize" value="${target.limitFileSize}" />
                            </td>
                            <th><spring:message code="target.column.limitFileExtension"/></th>
                            <td>
                                <input type="text" name="limitFileExtension" value="${target.limitFileExtension}" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="target.column.limitFileKeeptime"/></th>
                            <td class="point" colspan="3">
                                <input type="text" name="limitFileKeeptime" value="${target.limitFileKeeptime}" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <%--<h4>테이블 타이틀</h4>--%>
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:saveTarget(); return false;"><spring:message code="common.button.save"/> </button>
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
    var form = $('#fileSettingForm');

    var urlConfig = {
        'saveUrl':'${rootPath}/file/settingSave.json'
        ,'listUrl':'${rootPath}/file/setting.html'
    };

    var messageConfig = {
        'saveConfirm'            :'<spring:message code="common.message.saveConfirm"/>'
        ,'saveFailure'           :'<spring:message code="common.message.saveFailure"/>'
        ,'saveComplete'          :'<spring:message code="common.message.saveComplete"/>'
        ,'emptyLimitFileKeeptime':'<spring:message code="target.messege.emptyLimitFileKeeptime"/>'
    };

    /*
     validate method
     @author psb
     */
    function validate(){
        if(form.find('input[name=limitFileKeeptime]').val().trim().length == 0){
            alertMessage('emptyLimitFileKeeptime');
            return false;
        }
        return true;
    }

    /*
     고객사 수정
     @author psb
     */
    function saveTarget(){
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
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
//        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>