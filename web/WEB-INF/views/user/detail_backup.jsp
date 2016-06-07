<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-B000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-B000-0000-0000-000000000001" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.user"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="userForm" method="POST">
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
                            <th class="point"><spring:message code="user.column.userId"/></th>
                            <td class="point">
                                <input type="text" name="userId" value="${user.userId}" <c:if test="${!empty user}">readonly="true"</c:if> />
                            </td>
                            <th rowspan="3"><spring:message code="user.column.photoFilePath"/></th>
                            <td rowspan="3">
                                <!-- 파일 첨부 시작 -->
                                <div class="infile_set">
                                    <input type="text" readonly="readonly" title="File Route" id="file_route">
                                    <span class="btn_infile btype03 bstyle04">
                                        <input type="file" name="profile_photo" onchange="javascript:document.getElementById('file_route').value=this.value">
                                    </span>
                                    <c:if test="${!empty user.photoFilePath}">
                                        <p class="before_file preview">
                                            <a href="${rootPath}/user/download.html?userId=${user.userId}" title="${user.photoFilePath}">${user.photoFilePath}</a>
                                        </p>
                                    </c:if>
                                </div>
                                <!-- 파일 첨부 끝  -->
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="user.column.userName"/></th>
                            <td class="point">
                                <input type="text" name="userName" value="${user.userName}" class="syncType" beforeText="${user.userName}"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="user.column.nickName"/></th>
                            <td>
                                <input type="text" name="nickName" value="${user.nickName}" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="admin.column.password"/></th>
                            <td class="point">
                                <input type="password" name="japplePassword" class="syncType" beforeText="${user.japplePassword}" value="" placeholder="<spring:message code="common.message.passwordEdit"/>" />
                            </td>
                            <th class="point"><spring:message code="admin.column.passwordConfirm"/></th>
                            <td class="point">
                                <input type="password" name="password_confirm" value="" placeholder="<spring:message code="common.message.passwordEdit"/>" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="user.column.domain"/></th>
                            <td>
                                <input type="text" name="domain" value="${!empty user ? user.domain : domain}" <c:if test="${empty user}">readonly="true"</c:if> />
                            </td>
                            <th><spring:message code="user.column.email"/></th>
                            <td>
                                <input type="text" name="email" value="${user.email}" class="syncType" beforeText="${user.email}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="organization.column.orgInformation"/></th>
                            <td>
                                <c:choose>
                                    <c:when test="${empty user}">
                                        <input type="hidden"  name="orgId"/>
                                        <select id="selectOrgSeq">
                                            <option value="-1"><spring:message code="user.column.none"/></option>
                                            <c:forEach items="${organizationList}" var="orgList">
                                                <option value="${orgList.orgId}">${orgList.path}</option>
                                            </c:forEach>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${fn:length(orgUsers)<=1 and fn:length(organizations) > 0}">
                                            <input type="hidden"  name="orgId"/>
                                            <select id="selectOrgSeq">
                                                <option value="-1"><spring:message code="user.column.none"/></option>
                                                <c:forEach items="${organizations}" var="orgList">
                                                    <option value="${orgList.orgId}" <c:if test="${orgList.orgId == orgUsers[0].orgId}">selected</c:if>>${orgList.path}</option>
                                                </c:forEach>
                                            </select>
                                        </c:if>
                                        <c:if test="${fn:length(orgUsers)>1 and fn:length(organizations) > 0}">
                                            <select>
                                                <c:forEach items="${organizations}" var="orgList">
                                                    <c:forEach items="${orgUsers}" var="org">
                                                        <c:if test="${orgList.orgId == org.orgId}">
                                                            <option value="${orgList.orgId}">${orgList.path}</option>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:forEach>
                                            </select>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <th><spring:message code="user.column.classification"/></th>
                            <td>
                                <input type="text" name="classification" value="${user.classification}" class="syncType" beforeText="${user.classification}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="user.column.phone"/></th>
                            <td>
                                <input type="text" name="phone" value="${user.phone}" onkeypress="javascript:return onlyNumberPress(event);" onkeyup="javascript:onlyNumberDown(this);" />
                            </td>
                            <th><spring:message code="user.column.mobile"/></th>
                            <td>
                                <input type="text" name="mobile" value="${user.mobile}" class="syncType" beforeText="${user.mobile}" onkeypress="javascript:return onlyNumberPress(event);" onkeyup="javascript:onlyNumberDown(this);" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="user.column.profileNm"/></th>
                            <td>
                                <textarea name="profile" class="textboard">${user.profile}</textarea>
                            </td>
                            <th><spring:message code="user.column.specialNm"/></th>
                            <td>
                                <textarea name="special" class="textboard">${user.special}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="user.column.jappleYn"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="Y" htmlTagName="jappleYn" allText="" />
                            </td>
                            <th></th>
                            <td></td>
                        </tr>
                        <c:if test="${!empty user}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${user.insertUserName}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${user.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${user.updateUserName}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${user.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <h4>
                    <spring:message code="user.title.syncSetting"/>
                    <c:if test="${user.synchronizeYn=='Y'}">
                        <spring:message code="user.title.synchronize"/>
                    </c:if>
                </h4>
            </div>
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 t_style03">
                    <colgroup>
                        <col style="width:10%;">  <!-- 01 -->
                        <col style="width:20%;">  <!-- 02 -->
                        <col style="width:15%;">  <!-- 03 -->
                        <col style="width:15%;">  <!-- 04 -->
                        <col style="width:*;">    <!-- 05 -->
                        <col style="width:80px;">  <!-- 06 -->
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="2"><spring:message code="user.header.sync"/></th>
                            <th colspan="2"><spring:message code="user.header.useStatus"/></th>
                            <th colspan="2"><spring:message code="user.header.useHistory"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th colspan="2"><spring:message code="user.column.adLdapYn"/></th>
                            <td colspan="2">
                                <c:choose>
                                    <c:when test="${user == 'UPD'}">
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty userSettings.adLdapUseYn ? userSettings.adLdapUseYn : ''}" htmlTagName="adLdapUseYn" htmlTagClass="syncYn"/>
                                    </c:when>
                                    <c:otherwise>
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty syncSettings.adLdapUseYn ? syncSettings.adLdapUseYn : ''}" htmlTagName="adLdapUseYn" htmlTagClass="syncYn"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td id="adLdapResultText"></td>
                            <td>
                                <c:if test="${!empty user}">
                                    <button class="btn btype02 bstyle02 adLdapYn" onclick="javascript:requestDevice('adLdap'); return false;" <c:if test="${user.synchronizeYn=='Y'}">disabled="true"</c:if>><spring:message code="user.button.request"/></button>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="8"><spring:message code="user.column.cucm"/></th>
                            <th><spring:message code="user.column.cucmYn"/></th>
                            <td colspan="2">
                                <c:choose>
                                    <c:when test="${user == 'UPD'}">
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty userSettings.cucmUseYn ? userSettings.cucmUseYn : ''}" htmlTagName="cucmUseYn" htmlTagClass="syncYn"/>
                                    </c:when>
                                    <c:otherwise>
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty syncSettings.cucmUseYn ? syncSettings.cucmUseYn : ''}" htmlTagName="cucmUseYn" htmlTagClass="syncYn"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td id="cucmResultText"></td>
                            <td>
                                <c:if test="${!empty user}">
                                    <button class="btn btype02 bstyle02 cucmYn" onclick="javascript:requestDevice('cucm'); return false;" <c:if test="${user.synchronizeYn=='Y'}">disabled="true"</c:if>><spring:message code="user.button.request"/></button>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="2"><spring:message code="user.column.cucmExtension"/></th>
                            <th>JAPPLE</th>
                            <td>
                                <input type="text" name="extension" value="${user.extension}" onkeypress="javascript:return onlyNumberPress(event);" onkeyup="javascript:onlyNumberDown(this);" />
                            </td>
                            <td rowspan="2" id="extensionResultText"></td>
                            <td rowspan="2">
                                <c:if test="${!empty user}">
                                    <button class="btn btype02 bstyle02" onclick="javascript:requestDevice('extension'); return false;" <c:if test="${user.synchronizeYn=='Y'}">disabled="true"</c:if>><spring:message code="user.button.request"/></button>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>CUCM</th>
                            <td>
                                <input type="text" name="cucmExtension" readonly="true"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <spring:message code="user.column.cucmDevice"/>
                                <button class="btn btype02 bstyle03" onclick="javascript:cucmDevicePopup(); return false;"><spring:message code="user.button.device"/></button>
                            </th>
                            <td colspan="2">
                                <ul class="deviceUl"></ul>
                            </td>
                            <td id="deviceResultText"></td>
                            <td>
                                <c:if test="${!empty user}">
                                    <button class="btn btype02 bstyle02" onclick="javascript:requestDevice('device'); return false;" <c:if test="${user.synchronizeYn=='Y'}">disabled="true"</c:if>><spring:message code="user.button.request"/></button>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="user.column.cucmChatYn"/></th>
                            <td colspan="2">
                                <c:choose>
                                    <c:when test="${user == 'UPD'}">
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty userSettings.cupUseYn ? userSettings.cupUseYn : ''}" htmlTagName="cupUseYn" htmlTagClass="syncYn"/>
                                    </c:when>
                                    <c:otherwise>
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty syncSettings.cupUseYn ? syncSettings.cupUseYn : ''}" htmlTagName="cupUseYn" htmlTagClass="syncYn"/>
                                    </c:otherwise>
                                </c:choose>

                            </td>
                            <td id="cupResultText"></td>
                            <td>
                                <c:if test="${!empty user}">
                                    <button class="btn btype02 bstyle02" onclick="javascript:requestDevice('cup'); return false;" <c:if test="${user.synchronizeYn=='Y'}">disabled="true"</c:if>><spring:message code="user.button.request"/></button>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="3"><spring:message code="user.column.voiceMail"/></th>
                            <th><spring:message code="user.column.voiceMailYn"/></th>
                            <td>
                                <c:choose>
                                    <c:when test="${user == 'UPD'}">
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty userSettings.cucUseYn ? userSettings.cucUseYn : ''}" htmlTagName="cucUseYn" htmlTagClass="syncYn"/>
                                    </c:when>
                                    <c:otherwise>
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty syncSettings.cucUseYn ? syncSettings.cucUseYn : ''}" htmlTagName="cucUseYn" htmlTagClass="syncYn"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td rowspan="3" id="cucResultText"></td>
                            <td rowspan="3">
                                <c:if test="${!empty user}">
                                    <button class="btn btype02 bstyle02" onclick="javascript:requestDevice('cuc'); return false;" <c:if test="${user.synchronizeYn=='Y'}">disabled="true"</c:if>><spring:message code="user.button.request"/></button>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="user.column.voiceMailTime"/></th>
                            <td>
                                <input type="text" name="voiceMailTime" value="${!empty syncSettings.cucTime ? syncSettings.cucTime : ''}" onkeypress="javascript:return onlyNumberPress(event);" onkeyup="javascript:onlyNumberDown(this);" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="user.column.voiceMailPassword"/></th>
                            <td>
                                <input type="text" name="voiceMailPassword" value="${!empty syncSettings.cucPassword ? syncSettings.cucPassword : ''}" />
                            </td>
                        </tr>
                        <tr>
                            <th colspan="2"><spring:message code="user.column.webexYn"/></th>
                            <td colspan="2">
                                <c:choose>
                                    <c:when test="${user == 'UPD'}">
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty userSettings.webexUseYn ? userSettings.webexUseYn : ''}" htmlTagName="webexUseYn" htmlTagClass="syncYn"/>
                                    </c:when>
                                    <c:otherwise>
                                        <jabber:codeSelectBox groupCodeId="C008" codeId="${!empty syncSettings.webexUseYn ? syncSettings.webexUseYn : ''}" htmlTagName="webexUseYn" htmlTagClass="syncYn"/>
                                    </c:otherwise>
                                </c:choose>

                            </td>
                            <td id="webexResultText"></td>
                            <td>
                                <c:if test="${!empty user}">
                                    <button class="btn btype02 bstyle02" onclick="javascript:requestDevice('webex'); return false;" <c:if test="${user.synchronizeYn=='Y'}">disabled="true"</c:if>><spring:message code="user.button.request"/></button>
                                </c:if>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <c:if test="${!empty user}">
                    <div class="table_btn_set leftBtn">
                        <button class="btn btype01 <c:choose><c:when test="${ucSyncYn == 'Y'}">bstyle03</c:when><c:otherwise>bstyle06</c:otherwise></c:choose>"
                                onclick="javascript:synchronizeUser(); return false;" <c:if test="${user.synchronizeYn=='Y' || ucSyncYn!='Y'}">disabled="true"</c:if>><spring:message code="user.button.synchronize"/> </button>
                    </div>
                </c:if>
                <div class="table_btn_set">
                    <c:if test="${empty user}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addUser(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty user}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveUser(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeUser(); return false;" <c:if test="${user.synchronizeYn=='Y'}">disabled="true"</c:if>><spring:message code="common.button.remove"/> </button>
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
    var form = $('#userForm');
    var mode = '${empty user ? 'INS':'UPD'}';

    /*
        url defind
        @author kst
     */
    var urlConfig = {
        addUrl      :   "${rootPath}/user/add.json"
        ,saveUrl    :   "${rootPath}/user/save.json"
        ,removeUrl  :   "${rootPath}/user/remove.json"
        ,listUrl    :   "${rootPath}/user/list.html"
        ,existUrl   :   "${rootPath}/user/exist.html"
        ,'cucmDeviceListUrl' :   '${rootPath}/cucm/list.json'
        ,'cucmDevicePopupUrl':   '${rootPath}/cucm/popup.html'
        ,'requestAdLdapUrl'  :   '${rootPath}/directory/request.json'
        ,'requestCucmUrl'    :   '${rootPath}/cucm/request.json'
        ,'requestWebexUrl'   :   '${rootPath}/webex/request.json'
        ,'requestCucUrl'     :   '${rootPath}/cuc/request.json'
        ,'synchronizeUserUrl':   '${rootPath}/synchronize/addUser.json'
    };

    /*
        message define
        @author kst
     */
    var messageConfig = {
        'addConfirm':'<spring:message code="user.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="user.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="user.message.removeConfirm"/>'
        ,'synchronizeUserConfirm':'<spring:message code="user.message.synchronizeUserConfirm"/>'
        ,'addFailure':'<spring:message code="user.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="user.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="user.message.removeFailure"/>'
        ,'synchronizeUserFailure':'<spring:message code="user.message.synchronizeUserFailure"/>'
        ,'addComplete':'<spring:message code="user.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="user.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="user.message.removeComplete"/>'
        ,'synchronizeUserComplete':'<spring:message code="user.message.synchronizeUserComplete"/>'
        ,'notEqualsPassword':'<spring:message code="user.message.notEqualPassword"/>'
        ,'requireUserId':'<spring:message code="user.message.requireUserId"/>'
        ,'requireUserName':'<spring:message code="user.message.requireUserName"/>'
        ,'requirePassword':'<spring:message code="user.message.requirePassword"/>'
        ,'requireJabberId':'<spring:message code="user.message.requireJabberId"/>'
        ,'requireDomain':'<spring:message code="user.message.requireDomain"/>'
        ,'requirePhoneNumber':'<spring:message code="user.message.requirePhoneNumber"/>'
        ,'requireExtensionNumber':'<spring:message code="user.message.requireExtensionNumber"/>'
        ,'existUserId':'<spring:message code="user.message.existUserId"/>'
        ,'emptyEmail':'<spring:message code="user.message.emptyEmail"/>'
        ,'emptyJapplePassword':'<spring:message code="user.message.emptyJapplePassword"/>'
    };

    var cucmDeviceTag = $("<li/>").append(
        $("<span/>").addClass("cucmDevice")
    ).append(
        $("<button/>").attr("onclick","javascript:removeDevice(this); return false;").addClass("btn btype02 bstyle03").text('<spring:message code="common.column.delYes"/>')
    );

    $(document).ready(function(){
        findCucmDeviceList();
    });

    /*
        validate method
        @author kst
     */
    function validate(type){
        if(form.find('input[name=userId]').val().trim().length == 0){
            alertMessage('requireUserId');
            return false;
        }

        if(form.find('input[name=userName]').val().trim().length == 0 && type != 3){
            alertMessage('requireUserName');
            return false;
        }

        if(form.find('input[name=japplePassword]').val().trim().length == 0 && type == 1){
            alertMessage('requirePassword');
            return false;
        }

        if(form.find('input[name=japplePassword]').val().trim().length > 0
                && form.find('input[name=japplePassword]').val() != form.find('input[name=password_confirm]').val() && type != 3){
            alertMessage('notEqualsPassword');
            return false;
        }

        if(form.find('input[name=domain]').val().trim().length == 0 && type != 3){
            alertMessage('requireDomain');
            return false;
        }

        if(form.find('input[name=extension]').val().trim().length == 0 && type != 3){
            alertMessage('requireExtensionNumber');
            return false;
        }

        $('input:hidden[name=orgId]').val($("#userForm select[id=upOrgSeqSelect]").val());
        return true;
    }

    /*
        add method
        @author kst
     */
    function addUser(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            $('input:hidden[name=orgId]').val($("form select[id=selectOrgSeq]").val());
            setSynchronizeUserParam('INS');
            checkUserId();
        }
    }

    /*
        save method
        @author kst
     */
    function saveUser(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(2)){
            $('input:hidden[name=orgId]').val($("form select[id=selectOrgSeq]").val());
            setSynchronizeUserParam('UPD');
            callAjaxWithFile('save', form);
        }
    }

    /*
        remove method
        @author kst
     */
    function removeUser(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(3)){
            setSynchronizeUserParam('DEL');
            callAjax('remove', form.serialize());
        }
    }

    /*
     remove method
     @author kst
     */
    function synchronizeUser(){
        if(!confirm(messageConfig['synchronizeUserConfirm'])){
            return false;
        }

        var synchronizeUserList = [{
            'userId' : $("input[name='userId']").val()
        }];
        callAjax('synchronizeUser', {"synchronizeUserList":JSON.stringify(synchronizeUserList)});
    }

    /*
     cucm device List param
     @author psb
     */
    function setSynchronizeUserParam(modeType){
        var synchronizeUserList = [{
            'userId' : $("input[name='userId']").val()
        }];

        var synchronizeInfoList = [];
        var synchronizeDetailList = [];

        /**
         * 요청계정정보 맵핑
         */
        // 사용자정보
        $('.syncType').each(function(){
            var beforeText = $(this).attr("beforeText")!=null ? $(this).attr("beforeText") : "";
            if(beforeText!=$(this).val()){
                synchronizeInfoList.push({
                    'key' : $(this).attr("name")
                    ,'value' : $(this).val()
                });
            }
        });
        // 전화장비
        var deviceName = "";
        $.each($(".deviceUl").find(".cucmDevice"), function(){
            if(deviceName!=""){ deviceName += "|"; }
            deviceName += $(this).attr("title");
        });
        if(deviceName!=""){
            synchronizeInfoList.push({
                'key' : 'cucmDeviceName'
                ,'value' : deviceName
            });
        }

        // 내선번호
        if($("input[name='cucmExtension']").val()!=$("input[name='extension']").val()){
            synchronizeInfoList.push({
                'key' : 'extension'
                ,'value' : $("input[name='extension']").val()
            });
        }

        /**
         * 요청작업 맵핑
         */
        switch(modeType){
            case 'INS':
                $('.syncYn').each(function(){
                    if($(this).val()=="Y"){
                        synchronizeDetailList.push({
                            'target' : $(this).attr("name")
                            ,'type' : modeType
                        });
                    }
                });
                break;
            case 'UPD':
                $('.syncYn').each(function(){
                    var beforeSelect = $(this).attr("beforeSelect")!=null ? $(this).attr("beforeSelect") : "";
                    if(beforeSelect!=$(this).val()){
                        synchronizeDetailList.push({
                            'target' : $(this).attr("name")
                            ,'type' : $(this).val()=="Y" ? "UPD" : "DEL"
                        });
                    }
                });
                break;
            case 'DEL':
                $('.syncYn').each(function(){
                    if($(this).attr("beforeSelect")=="Y"){
                        synchronizeDetailList.push({
                            'target' : $(this).attr("name")
                            ,'type' : modeType
                        });
                    }
                });
                break;
        }

        synchronizeUserList[0]['infoBeans'] = synchronizeInfoList;
        synchronizeUserList[0]['detailBeans'] = synchronizeDetailList;

        form.append($('<INPUT>').attr('name','synchronizeUserList').attr('value',JSON.stringify(synchronizeUserList)));
    }

    /*
     remove cucm device List
     @author psb
     */
    function removeDevice(_this){
        if(mode=='INS'){
            $(_this).parent("li").remove();
        }
    }

    /*
     user id useable check
     */
    function findCucmDeviceList(){
        if($("input[name='userId']").val()==""){
            return false;
        }else{
            sendAjaxPostRequest(urlConfig['cucmDeviceListUrl'],{'userId':$("input[name='userId']").val()},cucmDevice_successHandler,cucmDevice_errorHandler);
        }
    }

    function cucmDevice_successHandler(data, dataType) {
        var resultCucmBean = data['resultCucmBean'];

        if (resultCucmBean != null) {
            /* cucm */
            if (resultCucmBean['resultFlag']) {
                /* CUCM 내선번호 */
                var telephoneNumber = resultCucmBean['resultUserBean']['telephoneNumber'];
                if(telephoneNumber!=null){
                    $("input[name='cucmExtension']").val(telephoneNumber);
                }
                /* 전화장비 */
                makeHtmlTagCucm(resultCucmBean['deviceBeanList']);
            } else {
                $("#deviceResultText").text(resultCucmBean['resultText']);
            }

            /* 음성사서함 */
            var lineBean = resultCucmBean['lineBean'];
            if (lineBean != null && lineBean['forwardToVoiceMail']=="true") {
                $("input[name='voiceMailTime']").val(lineBean['duration']);
            }
        } else {
            $("#extensionResultText").text("[cucmDevice_successHandler][failure] resultCucmBean is null");
        }
    }

    function cucmDevice_errorHandler(XMLHttpRequest, textStatus, errorThrown){
        console.log(XMLHttpRequest, textStatus, errorThrown);
    }

    /*
     전화장비 make html tag
     */
    function makeHtmlTagCucm(deviceBeanList){
        /* 초기화 */
        $(".deviceUl").empty();

        if(deviceBeanList!=null){
            for (var index in deviceBeanList) {
                var deviceHtml = cucmDeviceTag.clone();
                deviceHtml.find("span")
                    .attr("title", deviceBeanList[index]['devtype'])
                    .text(deviceBeanList[index]['devicename']);
                $(".deviceUl").append(deviceHtml);
            }
        }else{
            $("#deviceResultText").text("[makeHtmlTagCucm][failure] deviceBeanList is null");
        }
    }

    /*
     user id useable check
     */
    function checkUserId(){
        sendAjaxPostRequest(urlConfig['existUrl'],form.serialize(),checkUserId_successHandler,checkUserId_errorHandler);
    }

    function checkUserId_successHandler(data, dataType){
        if(data != null && data.hasOwnProperty('exist') && data['exist'] == 'N'){
            callAjaxWithFile('add', form);
        }else{
            alertMessage('existUserId');
        }
    }

    function checkUserId_errorHandler(XMLHttpRequest, textStatus, errorThrown){
        alertMessage('addFailure');
    }

    /*
     ajax call
     @author kst
     */
    function requestDevice(type){
        var actionType = "";
        var data = {
            "type" : type
        };

        switch(type) {
            case "adLdap" :
                data["param"] = $("input[name='userId']").val();
                actionType = "requestAdLdap";
                break;
            case "cucm" :
            case "extension" :
            case "cup" :
                data["param"] = $("input[name='userId']").val();
                actionType = "requestCucm";
                break;
            case "device" :
                data["param"] = $("input[name='userId']").val();
                actionType = "requestCucm";
                break;
            case "cuc" :
                data["userId"] = $("input[name='userId']").val();
                actionType = "requestCuc";
                break;
            case "webex" :
                var email = $("input[name='email']").val();
                var japplePassword = $("input[name='japplePassword']").val()!="" ? $("input[name='japplePassword']").val() : $("input[name='japplePassword']").attr("beforetext");

                if(email==null || email==""){
                    alertMessage('emptyEmail');
                }else if(japplePassword==null || japplePassword==""){
                    alertMessage('emptyJapplePassword');
                }else{
                    data["userName"] = email;
                    data["japplePassword"] = japplePassword;
                    actionType = "requestWebex";
                }
                break;
        }

        if(actionType!=""){
            callAjax(actionType, data);
        }
    }

    /*
        ajax call
        @author kst
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,errorHandler,actionType);
    }

    /*
        ajax with file call
        @author kst
     */
    function callAjaxWithFile(actionType, form){
        sendAjaxFileRequest(urlConfig[actionType + 'Url'],form,successHandler,errorHandler,actionType);
    }

    /*
        ajax success handler
        @author kst
     */
    function successHandler(data, dataType, actionType){
        switch(actionType){
            case 'save' :
            case 'synchronizeUser':
                alertMessage(actionType + 'Complete');
                break;
            case 'add':
            case 'remove':
                alertMessage(actionType + 'Complete');
                cancel();
                break;
            case 'requestAdLdap':
            case 'requestCucm':
            case 'requestWebex':
            case 'requestCuc':
                requestHandler(data);
                break;
        }
    }

    /*
        ajax error handler
        @author kst
     */
    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function requestHandler(data){
        if(data['resultFlag']){
            $("#"+data['type']+"ResultText").attr("title","인증성공").text("인증성공");
            switch(data['type']) {
                case "adLdap" :
                case "cup" :
                case "cucm" :
                case "webex" :
                case "cuc" :
                    break;
                case "extension" :
                    $("input[name='cucmExtension']").val(data['phone']);
                    break;
                case "device" :
                    makeHtmlTagCucm(data['deviceBeanList']);
                    break;
            }
        }else{
            $("#"+data['type']+"ResultText").attr("title",data['resultText']).text(data['resultText']);
        }
    }

    /*
        alert message method
        @author kst
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    /*
        cancel method
        @author kst
     */
    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }

    function cucmDevicePopup(){
        window.open(urlConfig['cucmDevicePopupUrl']+"?userId="+form.find('input[name=userId]').val(),'cucmDevicePopup','scrollbars=no,width=850,height=570,left=50,top=50');
    }

    function imagePreview(){
        /* CONFIG */
        var xOffset = 0;
        var yOffset = 0;

        /* END CONFIG */
        $("p.preview").hover(function(e){
            var photoFilePath = $(this).text().trim();
            if(photoFilePath!=""){
                $("body").append("<p id='preview'><img src='${photoPath}"+ photoFilePath +"'/></p>");
                $("#preview").css("position","absolute").css("top",(e.pageY - xOffset) + "px").css("left",(e.pageX + yOffset) + "px").fadeIn("fast");
            }
        },
        function(){
            $("#preview").remove();
        });
    };

    window.onload = function() {
        $( "#upOrgSeqSelect" ).change(function() {
            var formName = "#userForm";
            if ($("#userForm select[id=upOrgSeqSelect]").val() != $('input[name=orgSeq]').val()) {
                $('input:hidden[name=orgSeq]').val($("#userForm select[id=upOrgSeqSelect]").val());
            }
        });

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

        if (mode == "INS") {
            $("input[name='email']").focus(function(){
                if ($("input[name='email']").val().trim().length ==0 ) {
                    var _userId = $("input[name='userId']").val();
                    var _domain = $("input[name='domain']").val();

                    if (_userId.trim().length != 0 && _domain.trim().length != 0) {
                        $("input[name='email']").val(_userId + "@" + _domain);
                    }
                }

            });
        }

    }
</script>