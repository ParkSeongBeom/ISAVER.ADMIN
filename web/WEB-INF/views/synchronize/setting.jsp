<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-B000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-B000-0000-0000-000000000008" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.settingSynchronize"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="settingServerSynchronizeForm" method="POST">
        <article class="table_area">
            <div class="table_title_area">
                <h4><spring:message code="synchronize.title.synchronizeSetting" /></h4>
            </div>

            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 t_style03">
                    <colgroup>
                        <col style="width:12%;">  <!-- 01 -->
                        <col style="width:15%;">  <!-- 02 -->
                        <col style="width:20%;">  <!-- 03 -->
                        <col style="width:20%;">  <!-- 04 -->
                        <col style="width:33%;">  <!-- 05 -->
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="2"><spring:message code="synchronize.header.sync"/></th>
                            <th colspan="2"><spring:message code="synchronize.header.useStatus"/></th>
                            <th><spring:message code="synchronize.header.server"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th colspan="2"><spring:message code="synchronize.column.adLdapUseYn"/></th>
                            <td colspan="2">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${adLdapUseYn}" htmlTagName="adLdapUseYn" htmlTagClass="descUseYn"/>
                            </td>
                            <td>
                                <select name="adLdapServerId" class="descServerId">
                                    <option value=""><spring:message code="common.column.emptySelectBox"/></option>
                                    <c:forEach var="adServer" items="${adServers}">
                                        <option value="${adServer.serverId}" <c:if test="${adLdapServerId==adServer.serverId}">selected="selected"</c:if>>${adServer.name}</option>
                                    </c:forEach>
                                    <c:forEach var="ldapServer" items="${ldapServers}">
                                        <option value="${ldapServer.serverId}" <c:if test="${adLdapServerId==ldapServer.serverId}">selected="selected"</c:if>>${ldapServer.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="5"><spring:message code="synchronize.column.cucm"/></th>
                            <th><spring:message code="synchronize.column.cucmUseYn"/></th>
                            <td colspan="2">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${cucmUseYn}" htmlTagName="cucmUseYn" htmlTagClass="descUseYn"/>
                            </td>
                            <td>
                                <select name="cucmServerId" class="descServerId">
                                    <option value=""><spring:message code="common.column.emptySelectBox"/></option>
                                    <c:forEach var="cucmServer" items="${cucmServers}">
                                        <option value="${cucmServer.serverId}" <c:if test="${cucmServerId==cucmServer.serverId}">selected="selected"</c:if>>${cucmServer.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="synchronize.column.cupUseYn"/></th>
                            <td colspan="2">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${cupUseYn}" htmlTagName="cupUseYn" htmlTagClass="descUseYn"/>
                            </td>
                            <td>
                                <select name="cupServerId" class="descServerId">
                                    <option value=""><spring:message code="common.column.emptySelectBox"/></option>
                                    <c:forEach var="cupServer" items="${cupServers}">
                                        <option value="${cupServer.serverId}" <c:if test="${cupServerId==cupServer.serverId}">selected="selected"</c:if>>${cupServer.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="3"><spring:message code="synchronize.column.voiceMail"/></th>
                            <th><spring:message code="synchronize.column.cucUseYn"/></th>
                            <td>
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${cucUseYn}" htmlTagName="cucUseYn" htmlTagClass="descUseYn"/>
                            </td>
                            <td rowspan="3">
                                <select name="cucServerId" class="descServerId">
                                    <option value=""><spring:message code="common.column.emptySelectBox"/></option>
                                    <c:forEach var="cucServer" items="${cucServers}">
                                        <option value="${cucServer.serverId}" <c:if test="${cucServerId==cucServer.serverId}" >selected="selected"</c:if>>${cucServer.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="synchronize.column.cucTime"/></th>
                            <td>
                                <input type="text" name="cucTime" value="${cucTime}" class="descTime" onkeypress="javascript:return onlyNumberPress(event);" onkeyup="javascript:onlyNumberDown(this);" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="synchronize.column.cucPassword"/></th>
                            <td>
                                <input type="text" name="cucPassword" value="${cucPassword}" class="descPassword"/>
                            </td>
                        </tr>
                        <tr>
                            <th colspan="2"><spring:message code="synchronize.column.webexUseYn"/></th>
                            <td colspan="2">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${webexUseYn}" htmlTagName="webexUseYn" htmlTagClass="descUseYn"/>
                            </td>
                            <td>
                                <select name="webexServerId" class="descServerId">
                                    <option value=""><spring:message code="common.column.emptySelectBox"/></option>
                                    <c:forEach var="webexServer" items="${webexServers}">
                                        <option value="${webexServer.serverId}" <c:if test="${webexServerId==webexServer.serverId}" >selected="selected"</c:if>>${webexServer.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <h4><spring:message code="synchronize.title.requestSynchronizeSetting" /></h4>
            </div>

            <div class="table_contents" style="width:50%;">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 t_style03">
                    <colgroup>
                        <col style="width:50%;">  <!-- 01 -->
                        <col style="width:50%;">  <!-- 02 -->
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><spring:message code="synchronize.column.syncTime"/></th>
                            <td>
                                <input type="text" name="syncTime" value="${syncTime}" class="descSyncTime" onkeypress="javascript:return onlyNumberPress(event);" onkeyup="javascript:onlyNumberDown(this);" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:saveSetting(); return false;"><spring:message code="common.button.save"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>
<!-- END : contents -->

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $("#settingServerSynchronizeForm");

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        saveUrl : "${rootPath}/synchronize/upsertSetting.json"
    };

    /*
     description define
     @author psb
     */
    var descriptionConfig = {
        'descUseYn'     :'<spring:message code="synchronize.description.descUseYn"/>'
        ,'descServerId' :'<spring:message code="synchronize.description.descServerId"/>'
        ,'descTime'     :'<spring:message code="synchronize.description.descTime"/>'
        ,'descPassword' :'<spring:message code="synchronize.description.descPassword"/>'
        ,'descSyncTime' :'<spring:message code="synchronize.description.descSyncTime"/>'
        ,'undefined'    :'<spring:message code="synchronize.description.undefined"/>'
    };

    /*
     message define
     @author kst
     */
    var messageConfig = {
        'saveConfirm':'<spring:message code="common.message.saveConfirm"/>'
        ,'saveComplete':'<spring:message code="common.message.saveComplete"/>'
        ,'saveFailure':'<spring:message code="common.message.saveFailure"/>'
    };

    /*
     add method
     @author psb
     */
    function saveSetting(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        var settingList = [];

        form.find('input:text').each(function(){
            settingList.push({
               'settingId' : $(this).attr("name")
               ,'value' : $(this).val()
               ,'description' : descriptionConfig[this.className]!=null ? descriptionConfig[this.className] : descriptionConfig['undefined']
            });
        });

        form.find('select').each(function(){
            settingList.push({
                'settingId' : $(this).attr("name")
                ,'value' : $(this).val()
                ,'description' : descriptionConfig[this.className]!=null ? descriptionConfig[this.className] : descriptionConfig['undefined']
            });
        });

        callAjax('save', {'settingList':JSON.stringify(settingList)});
    }

    /*
     ajax call
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,errorHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function successHandler(data, dataType, actionType){
        alertMessage(actionType + 'Complete');

        switch(actionType){
            case 'save':
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    window.onload = function() {

        $("select[name='cucmUseYn']").change(function() {
            if (this.value == "N") {
                $("select[name='cupUseYn'] option[value='N']").attr('selected', 'selected');
            }

        });

        $("select[name='cupUseYn']").change(function() {
            if (this.value == "Y") {
                $("select[name='cucmUseYn'] option[value='Y']").attr('selected', 'selected');
            }
        });
    }
</script>