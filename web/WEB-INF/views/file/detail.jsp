<!-- 라이센스 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00061" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.file"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <div class="popupbase admin_popup use_device_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="file.column.useList"/></h2>
                    <button onclick="javascript:closePopup();"></button>
                </header>
                <article>
                    <input type="hidden" name="pageNumber">
                    <div class="search_area">
                        <div class="search_contents">
                            <!-- 일반 input 폼 공통 -->
                            <p class="itype_01">
                                <span><spring:message code="file.column.deviceId"/></span>
                                <span>
                                    <input type="text" id="searchDeviceId" />
                                </span>
                            </p>
                        </div>
                        <div class="search_btn">
                            <button onclick="javascript:loadUseDevice(); return false;" class="btn"><spring:message code="common.button.search"/></button>
                        </div>
                    </div>
                    <div class="table_area">
                        <div class="table_contents">
                            <!-- 입력 테이블 Start -->
                            <table id="actionList" class="t_defalut t_type01 t_style02">
                                <colgroup>
                                    <col style="width: 5%;">
                                    <col style="width: 20%;">
                                    <col style="width: *%;">
                                    <col style="width: 20%;">
                                    <col style="width: 10%;">
                                    <col style="width: 20%;">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="t_center"></th>
                                    <th><spring:message code="file.column.deviceId"/></th>
                                    <th><spring:message code="file.column.deviceName"/></th>
                                    <th><spring:message code="file.column.areaName"/></th>
                                    <th><spring:message code="file.column.insertUserName"/></th>
                                    <th><spring:message code="file.column.insertDatetime"/></th>
                                </tr>
                                </thead>
                                <tbody id="deviceList">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </article>
                <footer>
                    <button class="btn" onclick="javascript:closePopup(); return false;"><spring:message code="common.button.cancel"/></button>
                </footer>
            </div>
        </div>
        <div class="bg ipop_close" onclick="closePopup();"></div>
    </div>

    <form id="fileForm" method="POST">
        <input type="hidden" name="fileId" value="${file.fileId}" />
        <input type="hidden" name="selDevices" />
        <input type="hidden" name="addDevices" />
        <input type="hidden" name="removeDevices" />
        <input type="hidden" name="addDeviceSyncRequests" />
        <input type="hidden" name="physicalFileName" value="${file.physicalFileName}" />
        <input type="hidden" name="logicalFileName" value="${file.logicalFileName}" />

        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 t_style03">
                    <colgroup>
                        <col style="width:16%">  <!-- 01 -->
                        <col style="width:40%">  <!-- 02 -->
                        <col style="width:16%">  <!-- 03 -->
                        <col style="width:*">    <!-- 04 -->
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="point"><spring:message code="file.column.title"/></th>
                        <td colspan="3" class="point">
                            <input type="text" name="title" value="${file.title}"/>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="file.column.description"/></th>
                        <td colspan="3">
                            <textarea name="description">${file.description}</textarea>
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="file.column.fileName"/></th>
                        <td colspan="3" class="point">
                            <!-- 파일 첨부 시작 -->
                            <div class="infile_set">
                                <input type="text" readonly="readonly" title="File Route" id="file_route">
                                    <span class="btn_infile btype03 bstyle04">
                                        <input type="file" name="file" onchange="javascript:document.getElementById('file_route').value=this.value" />
                                    </span>
                                <c:if test="${!empty file.logicalFileName}">
                                    <p class="before_file">
                                        <a href="${rootPath}/file/download.html?fileId=${file.fileId}" title="${file.logicalFileName}">${file.logicalFileName}</a>
                                    </p>
                                </c:if>
                            </div>
                            <!-- 파일 첨부 끝  -->
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="file.column.useYn"/></th>
                        <td colspan="3" class="point">
                            <span><input type="radio" name="useYn" value="Y" ${empty file || file.useYn == 'Y' ? 'checked' : ''}/><spring:message code="common.column.useYes" /></span>
                            <span><input type="radio" name="useYn" value="N" ${file.useYn == 'N' ? 'checked' : ''}/><spring:message code="common.column.useNo" /></span>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="file.column.useList"/></th>
                        <td colspan="3">
                            <div class="code_list">
                                <button onclick="javascript:openPopup(); return false;"></button>
                            </div>
                        </td>
                    </tr>
                    <c:if test="${!empty file}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${file.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${file.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${file.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${file.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty file.fileId}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addFile(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty file.fileId}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveFile(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeFile(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#fileForm');
    var deviceInfo = {
        "selDeviceList" : []
        ,"addDeviceList" : []
        ,"removeDeviceList" : []
    };

    var urlConfig = {
        'addUrl':'${rootPath}/file/add.json'
        ,'saveUrl':'${rootPath}/file/save.json'
        ,'removeUrl':'${rootPath}/file/remove.json'
        ,'listUrl':'${rootPath}/file/list.html'
        ,'fileListUrl':'${rootPath}/device/fileList.json'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="file.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="file.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="file.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="file.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="file.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="file.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="file.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="file.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="file.message.removeComplete"/>'
        ,'titleEmpty':'<spring:message code="file.message.titleEmpty"/>'
        ,'fileEmpty':'<spring:message code="file.message.fileEmpty"/>'
    };

    var emptyListTag = $("<tr/>").append(
        $("<td/>", {colspan:"6"}).text('<spring:message code="common.message.emptyData"/>')
    );

    $(document).ready(function() {
        $("input[name='file']").change(function(e) {
            var fileName = "";
            if(e.target.files.length>0){
                fileName = e.target.files[0].name;
            }
            $("input[name='logicalFileName']").val(fileName);
        });

        loadUseDevice();
    });

    function loadUseDevice(){
        var data = {
            'fileId' : '${file.fileId}'
            ,'deviceId' : $("#searchDeviceId").val()
            ,'delYn' : "N"
        };

        callAjax('fileList', data);
    }

    function validate(){
        if(form.find('input[name=title]').val().length == 0){
            alertMessage('titleEmpty');
            return false;
        }

        if(form.find('input[name=physicalFileName]').val().length == 0 && form.find('input[name=logicalFileName]').val().length == 0){
            alertMessage('fileEmpty');
            return false;
        }
        return true;
    }

    function addFile(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            $("input[name='addDevices']").val(deviceInfo['addDeviceList'].toString());
            callAjaxWithFile('add', form);
        }
    }

    function saveFile(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(1)){
            $("input[name='selDevices']").val(deviceInfo['selDeviceList'].toString());
            $("input[name='addDevices']").val(deviceInfo['addDeviceList'].toString());
            $("input[name='removeDevices']").val(deviceInfo['removeDeviceList'].toString());
            $("input[name='addDeviceSyncRequests']").val(deviceInfo['addDeviceList'].concat(deviceInfo['removeDeviceList']).toString());

            callAjaxWithFile('save', form);
        }
    }

    function removeFile(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(2)){
            callAjax('remove', form.serialize());
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function callAjaxWithFile(actionType, form){
        sendAjaxFileRequest(urlConfig[actionType + 'Url'],form,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'fileList':
                fileListRender(data['deviceList']);
                break;
            case 'save':
            case 'add':
            case 'remove':
                alertMessage(actionType + 'Complete');
                cancel();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
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

    function openPopup(){
        $(".use_device_popup").fadeIn();
    }

    function closePopup(){
        $(".use_device_popup").fadeOut();
    }

    function fileListRender(list){
        $("#deviceList").empty();

        if(list!=null){
            for(var index in list){
                var device = list[index];
                var checkYn = false;

                if(device['useFileYn']=='Y' && deviceInfo['selDeviceList'].indexOf(device['deviceId']) == -1){
                    deviceInfo['selDeviceList'].push(device['deviceId']);
                    checkYn = true;
                }

                if(deviceInfo['addDeviceList'].indexOf(device['deviceId']) > -1){
                    checkYn = true;
                }

                if(deviceInfo['removeDeviceList'].indexOf(device['deviceId']) > -1){
                    checkYn = false;
                }

                $("#deviceList").append(
                    $("<tr/>").append(
                        $("<td/>", {class:'t_center'}).append(
                            $("<input/>", {type:'checkbox', class:'checkbox', deviceId:device['deviceId'], name:'deviceCheckbox', checked:checkYn}).on("click",function(){
                                if($(this).is(":checked")){
                                    if(deviceInfo['selDeviceList'].indexOf($(this).attr("deviceId")) == -1){
                                        deviceInfo['addDeviceList'].push($(this).attr("deviceId"));
                                    }

                                    if(deviceInfo['removeDeviceList'].indexOf($(this).attr("deviceId")) > -1){
                                        deviceInfo['removeDeviceList'].splice(deviceInfo['removeDeviceList'].indexOf($(this).attr("deviceId")),1);
                                    }
                                }else{
                                    if(deviceInfo['selDeviceList'].indexOf($(this).attr("deviceId")) > -1){
                                        deviceInfo['removeDeviceList'].push($(this).attr("deviceId"));
                                    }

                                    if(deviceInfo['addDeviceList'].indexOf($(this).attr("deviceId")) > -1){
                                        deviceInfo['addDeviceList'].splice(deviceInfo['addDeviceList'].indexOf($(this).attr("deviceId")),1);
                                    }
                                }
                            })
                        )
                    ).append(
                        $("<td/>").text(device['deviceId'])
                    ).append(
                        $("<td/>").text(device['deviceCodeName'])
                    ).append(
                        $("<td/>").text(device['areaName'])
                    ).append(
                        $("<td/>").text(device['insertUserName'])
                    ).append(
                        $("<td/>").text(new Date(device['insertDatetime']).format("yyyy-mm-dd HH:mm:ss"))
                    )
                );
            }
        }else{
            $("#deviceList").append(emptyListTag.clone());
        }
    }
</script>