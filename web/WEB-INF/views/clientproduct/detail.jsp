<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-G000-0000-0000-000000000002" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.clientProduct"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->


    <form id="clientProductForm" method="POST">
        <input type="hidden" name="clientProductId" value="${clientProduct.clientProductId}"/>

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
                            <th class="point"><spring:message code="clientproduct.column.title"/></th>
                            <td class="point">
                                <input type="text" name="title" value="${clientProduct.title}" placeholder="<spring:message code="clientproduct.message.requireTitle"/>" />
                            </td>
                            <th class="point"><spring:message code="clientproduct.column.version"/></th>
                            <td class="point">
                                <input type="text" name="version" value="${clientProduct.version}" placeholder="<spring:message code="clientproduct.message.requireVersionPlaceHolder"/>" onkeypress="isNumberWithPoint(this);"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.description"/></th>
                            <td colspan="3">
                                <textarea name="description" class="textboard">${clientProduct.description}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="clientproduct.column.clientFile"/></th>
                            <td class="point" colspan="3">
                                <!-- 파일 첨부 시작 -->
                                <div class="infile_set">
                                    <input type="text"  readonly="readonly" title="File Route" id="file_route">
                                    <span class="btn_infile btype03 bstyle04">
                                        <input type="file" name="file" onchange="javascript:document.getElementById('file_route').value=this.value">
                                    </span>
                                    <c:if test="${!empty clientProduct.logicalFileName}">
                                        <p class="before_file">
                                            <a href="#" title="${clientProduct.logicalFileName}">${clientProduct.logicalFileName}</a>
                                        </p>
                                    </c:if>
                                </div>
                                <!-- 파일 첨부 끝  -->
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point" colspan="3">
                                <input type="radio" name="useYn" value="Y" ${!empty clientProduct && clientProduct.useYn == 'Y' ? 'checked' : ''}/><spring:message code="common.column.useYes" />
                                <input type="radio" name="useYn" value="N" ${empty clientProduct || clientProduct.useYn == 'N' ? 'checked' : ''}/><spring:message code="common.column.useNo" />
                            </td>
                        </tr>
                        <c:if test="${!empty clientProduct}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${clientProduct.insertUserName}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${clientProduct.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${clientProduct.updateUserName}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${clientProduct.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty clientProduct}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addClientProduct(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty clientProduct}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveClientProduct(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeClientProduct(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#clientProductForm');

    var urlConfig = {
        'addUrl':'${rootPath}/product/add.json'
        ,'saveUrl':'${rootPath}/product/save.json'
        ,'removeUrl':'${rootPath}/product/remove.json'
        ,'listUrl':'${rootPath}/product/list.html'
    };

    var messageConfig = {
        'requireTitle':'<spring:message code="clientproduct.message.requireTitle"/>'
        ,'requireVersion':'<spring:message code="clientproduct.message.requireVersion"/>'
        ,'requireFile':'<spring:message code="clientproduct.message.requireFile"/>'
        ,'addFailure':'<spring:message code="clientproduct.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="clientproduct.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="clientproduct.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="clientproduct.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="clientproduct.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="clientproduct.message.removeComplete"/>'
        ,'addConfirm':'<spring:message code="clientproduct.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="clientproduct.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="clientproduct.message.removeConfirm"/>'
    };

    /*
     수정전 validate
     @author kst
     */
    function validate(type){
        var validateFlag = true;

        if(form.find('input[name=title]').val().length == 0){
            alertMessage('requireTitle');
            return false;
        }

        if(form.find('input[name=version]').val().length == 0){
            alertMessage('requireVersion');
            return false;
        }

        if(type != 2 && form.find('input[name=file]').val().length == 0){
            alertMessage('requireFile');
            return false;
        }

        return true;
    }

    /*
        제품버젼 추가
        @author kst
     */
    function addClientProduct(){
        if(!confirm(messageConfig['addConfirm'])) {
            return false;
        }

        if(validate(1)){
            callAjax('add', form);
        }
    }

    /*
        제품버젼 수정
        @author kst
     */
    function saveClientProduct(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        if(validate(2)){
            callAjax('save', form);
        }
    }
    /*
        제품버젼 제거
        @author kst
     */
    function removeClientProduct(){
        if(!confirm(messageConfig['removeConfirm'])) {
            return false;
        }

        callAjax('remove', form);
    }

    function callAjax(actionType, form){
        sendAjaxFileRequest(urlConfig[actionType + 'Url'],form,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        alertMessage(actionType + 'Complete');
        switch(actionType){
            case 'save':
                break;
            case 'add':
            case 'remove':
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
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>