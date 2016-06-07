<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000015" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.target"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="targetForm" method="POST">
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
                            <th><spring:message code="target.column.targetId"/></th>
                            <td>${target.targetId}</td>
                            <th><spring:message code="target.column.licenseCount"/></th>
                            <td>${target.licenseCount}</td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="target.column.name"/></th>
                            <td class="point">
                                <input type="text" name="name" value="${target.name}" />
                            </td>
                            <th class="point"><spring:message code="target.column.code"/></th>
                            <td class="point">
                                <input type="text" name="code" value="${target.code}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="target.column.logoUrl"/></th>
                            <td colspan="3">
                                <input type="text" name="logoUrl" value="${target.logoUrl}" />
                            </td>
                            <!--
                            <th class="point"><spring:message code="target.column.domain"/></th>
                            <td class="point">
                                <input type="text" name="domain" value="${target.domain}" />
                            </td>
                            -->
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
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
    var form = $('#targetForm');

    var urlConfig = {
        'saveUrl':'${rootPath}/target/save.json'
        ,'listUrl':'${rootPath}/setting/list.html'
    };

    var messageConfig = {
        'saveConfirm'            :'<spring:message code="target.message.saveConfirm"/>'
        ,'saveFailure'           :'<spring:message code="target.message.saveFailure"/>'
        ,'saveComplete'          :'<spring:message code="target.message.saveComplete"/>'
        ,'emptyName'             :'<spring:message code="target.message.emptyName"/>'
        ,'emptyCode'             :'<spring:message code="target.message.emptyCode"/>'
        ,'emptyDomain'           :'<spring:message code="target.message.emptyDomain"/>'
    };

    /*
     validate method
     @author psb
     */
    function validate(){
        if(form.find('input[name=name]').val().trim().length == 0){
            alertMessage('emptyName');
            return false;
        }

        if(form.find('input[name=code]').val().trim().length == 0){
            alertMessage('emptyCode');
            return false;
        }
        /*
        if(form.find('input[name=domain]').val().trim().length == 0){
            alertMessage('emptyDomain');
            return false;
        }
        */
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
        var listForm = $('<FORM>').attr('action',urlConfig['listUrl']).attr('method','POST');
        listForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','target'));
        document.body.appendChild(listForm.get(0));
        listForm.submit();
    }
</script>