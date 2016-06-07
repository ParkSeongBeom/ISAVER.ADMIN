<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000013" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

    <!-- section Start / 메인 "main_area", 서브 "sub_area"-->
    <section class="container sub_area">
        <!-- 2depth 타이틀 영역 Start -->
        <article class="sub_title_area">
            <!-- 2depth 타이틀 Start-->
            <h3 class="1depth_title"><spring:message code="common.title.server"/></h3>
            <!-- 2depth 타이틀 End -->
            <div class="navigation">
                <span><jabber:menu menuId="${menuId}" /></span>
            </div>
        </article>
        <!-- 2depth 타이틀 영역 End -->

    <form id="serverForm" method="POST">
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
                            <th><spring:message code="server.column.serverId"/></th>
                            <td>
                                <input type="text" name="serverId" value="${server.serverId}" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="server.column.type"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="S001" codeId="${server.type}" htmlTagName="type"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="server.column.protocol"/></th>
                            <td>
                                <input type="text" name="protocol" value="${server.protocol}" />
                            </td>
                            <th><spring:message code="server.column.ip"/></th>
                            <td>
                                <input type="text" name="ip" value="${server.ip}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="server.column.port"/></th>
                            <td>
                                <input type="text" name="port" value="${server.port}" />
                            </td>
                            <th><spring:message code="server.column.url"/></th>
                            <td>
                                <input type="text" name="url" value="${server.url}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="server.column.conference"/></th>
                            <td>
                                <input type="text" name="conference" value="${server.conference}" />
                            </td>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${server.useYn}" htmlTagName="useYn"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="server.column.id"/></th>
                            <td>
                                <input type="text" name="id" value="${server.id}" />
                            </td>
                            <th><spring:message code="server.column.password"/></th>
                            <td>
                                <input type="text" name="password" value="${server.password}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="server.column.description"/></th>
                            <td>
                                <input type="text" name="description" value="${server.description}" />
                            </td>
                            <th><spring:message code="server.column.version"/></th>
                            <td>
                                <input type="text" name="version" value="${server.version}" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="server.column.name"/></th>
                            <td class="point">
                                <input type="text" name="name" value="${server.name}" />
                            </td>
                            <th><spring:message code="server.column.extendPort"/></th>
                            <td>
                                <input type="text" name="extendPort" value="${server.extendPort}" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty server}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addServer(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty server}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveServer(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeServer(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#serverForm');

    var urlConfig = {
        'addUrl':'${rootPath}/server/add.json'
        ,'saveUrl':'${rootPath}/server/save.json'
        ,'removeUrl':'${rootPath}/server/remove.json'
        ,'listUrl':'${rootPath}/setting/list.html'
        ,'directoryUrl':'${rootPath}/directory/popup.html'
        ,'connectUrl':'${rootPath}/server/connect.json'
    };

    var messageConfig = {
        'addConfirm'       :'<spring:message code="server.message.addConfirm"/>'
        ,'addFailure'      :'<spring:message code="server.message.addFailure"/>'
        ,'addComplete'     :'<spring:message code="server.message.addComplete"/>'
        ,'saveConfirm'     :'<spring:message code="server.message.saveConfirm"/>'
        ,'saveFailure'     :'<spring:message code="server.message.saveFailure"/>'
        ,'saveComplete'    :'<spring:message code="server.message.saveComplete"/>'
        ,'removeConfirm'   :'<spring:message code="server.message.removeConfirm"/>'
        ,'removeFailure'   :'<spring:message code="server.message.removeFailure"/>'
        ,'removeComplete'  :'<spring:message code="server.message.removeComplete"/>'
        ,'connectFailure'  :'<spring:message code="server.message.connectFailure"/>'
        ,'connectComplete' :'<spring:message code="server.message.connectComplete"/>'
        ,'pingFailure'     :'<spring:message code="server.message.pingFailure"/>'
        ,'autorizeFailure' :'<spring:message code="server.message.autorizeFailure"/>'
        ,'emptyName'       :'<spring:message code="server.message.emptyName"/>'
        ,'emptyType'       :'<spring:message code="server.message.emptyType"/>'
        ,'emptyIp'         :'<spring:message code="server.message.emptyIp"/>'
        ,'emptyPort'       :'<spring:message code="server.message.emptyPort"/>'
        ,'emptyId'         :'<spring:message code="server.message.emptyId"/>'
        ,'emptyPassword'   :'<spring:message code="server.message.emptyPassword"/>'
        ,'passwordFailure' :'<spring:message code="server.message.passwordFailure"/>'
    };

    $(document).ready(function(){
        $("select[name='type']").on("change",function(){
            directoryViewShowHide();
        });
        directoryViewShowHide();
    });

    /*
     AD/LDAP Version view
     @author psb
     */
    function directoryViewShowHide(){
        var typeCode = $("select[name='type'] option:selected").val();

        if(typeCode=='4000' || typeCode=='7000'){
            $("#directoryView").show();
        }else{
            $("#directoryView").hide();
        }

        if(typeCode=='0001' || typeCode=='1000' || typeCode=='2000' || typeCode=='3000' || typeCode=='4000' || typeCode=='7000'){
            $("#connectBtn").show();
        }else{
            $("#connectBtn").hide();
        }
    }

    function directoryPopup(){
        if(validate(2)){
            window.open(urlConfig['directoryUrl']+"?"+form.serialize(),'directoryPopup','scrollbars=no,width=600,height=480,left=50,top=50');
        }
    }

    function connect(){
        switch($("select[name='type'] option:selected").val()){
            case '0001': //WAS
            case '1000': //CUP
            case '2000': //CUCM
            case '3000': //CUC
                if(validate(2)){
                    callAjax('connect', form.serialize());
                }
                break;
            case '4000': //AD
            case '7000': //LDAP
                if(validate(3)){
                    callAjax('connect', form.serialize());
                }
                break;
        }
    }

    /*
     validate method
     @author psb
     */

    function validate(type){
        if(type==1){
            if(form.find('input[name=name]').val().trim().length == 0){
                alertMessage('emptyName');
                return false;
            }

            if(form.find('select[name=type]').val().trim().length == 0){
                alertMessage('emptyType');
                return false;
            }
        }else if(type==2){
            if(form.find('input[name=ip]').val().trim().length == 0){
                alertMessage('emptyIp');
                return false;
            }
        }else if(type==3){
            if(form.find('input[name=ip]').val().trim().length == 0){
                alertMessage('emptyIp');
                return false;
            }

            if(form.find('input[name=port]').val().trim().length == 0){
                alertMessage('emptyPort');
                return false;
            }

            if(form.find('input[name=id]').val().trim().length == 0){
                alertMessage('emptyId');
                return false;
            }

            if(form.find('input[name=password]').val().trim().length == 0){
                alertMessage('emptyPassword');
                return false;
            }

            if(form.find('input[name=id]').val().trim()=="anonymous" && form.find('input[name=id]').val().trim()!=form.find('input[name=password]').val().trim()){
                alertMessage('passwordFailure');
                return false;
            }
        }
        return true;
    }

    /*
     add method
     @author kst
     */
    function addServer(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    /*
     고객사 수정
     @author psb
     */
    function saveServer(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        if(validate(1)){
            callAjax('save', form.serialize());
        }
    }

    /*
     remove method
     @author kst
     */
    function removeServer(){
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
            case 'save':
            case 'add':
            case 'remove':
                alert(messageConfig[actionType + 'Complete']);
                cancel();
                break;
            case 'connect':
                if(data['returnValue']!=null){
                    if(data['returnValue']==200){
                        alert(messageConfig['connectComplete']);
                    }else if(data['returnValue']==100){
                        alert(messageConfig['pingFailure']);
                    }else if(data['returnValue']==105){
                        alert(messageConfig['autorizeFailure']);
                    }
                }else{
                    alert(messageConfig['connectFailure']);
                }
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
        listForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','server'));
        document.body.appendChild(listForm.get(0));
        listForm.submit();
    }
</script>