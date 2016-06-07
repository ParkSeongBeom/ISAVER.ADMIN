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
        <h3 class="1depth_title"><spring:message code="common.title.function"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->


    <form id="functionForm" method="POST">
        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 t_style03">
                    <colgroup>
                        <col style="width: 15%;" />
                        <col style="width: 35%;" />
                        <col style="width: 15%;" />
                        <col style="width: 35%;" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><spring:message code="function.column.funcId"/></th>
                            <td>
                                <input type="text" name="funcId" value="${function.funcId}" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="function.column.funcName"/></th>
                            <td class="point">
                                <input type="text" name="funcName" value="${function.funcName}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="function.column.description"/></th>
                            <td>
                                <input type="text" name="description" value="${function.description}"/>
                            </td>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${function.useYn}" htmlTagName="useYn"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:saveFunction(); return false;"><spring:message code="common.button.save"/> </button>
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
    var form = $('#functionForm');

    var urlConfig = {
        'saveUrl':'${rootPath}/function/save.json'
        ,'listUrl':'${rootPath}/setting/list.html'
    };

    var messageConfig = {
        'saveConfirm'       :'<spring:message code="function.message.saveConfirm"/>'
        ,'saveFailure'      :'<spring:message code="function.message.saveFailure"/>'
        ,'saveComplete'     :'<spring:message code="function.message.saveComplete"/>'
        ,'emptyFuncName'    :'<spring:message code="function.message.emptyFuncName"/>'
    };

    /*
     validate method
     @author psb
     */
    function validate(){
        if(form.find('input[name=funcName]').val().trim().length == 0){
            alertMessage('emptyFuncName');
            return false;
        }
        return true;
    }

    /*
     기능제한 수정
     @author psb
     */
    function saveFunction(){
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
        listForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','function'));
        document.body.appendChild(listForm.get(0));
        listForm.submit();
    }
</script>