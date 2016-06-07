<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-J000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-U000-0000-0000-000000000001" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.file"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="fileForm" action="#none" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="file.column.category" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="V001" codeId="${paramBean.type}" htmlTagName="type" allModel="true"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="file.column.state" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="U001" codeId="${paramBean.status}" htmlTagName="status" allModel="true"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="file.column.fileName" /></span>
                    <span>
                        <input type="text" name="name" value="${paramBean.name}" />
                    </span>
                </p>
                <p class="itype_03">
                    <span><spring:message code="account.column.selDatetime" /></span>
                    <span>
                        <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                            <em>~</em>
                        <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="common.column.insertUser" /></span>
                    <span>
                        <input type="text" name="insertUserName" value="${paramBean.insertUserName}" />
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle03" onclick="javascript:deleteFile(); return false;"><spring:message code="common.button.remove"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 50px;" />
                    <col style="width: 100px;" />
                    <col style="width: 100px;" />
                    <col style="width: *%;" />
                    <col style="width: 100px;" />
                    <col style="width: 100px;" />
                    <col style="width: 160px;" />
                    <col style="width: 100px;" />
                    <col style="width: 160px;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><input type="checkbox" name="allCheckbox" onchange="checkAllControl(this)"></th>
                        <th><spring:message code="file.column.category"/></th>
                        <th><spring:message code="file.column.state"/></th>
                        <th><spring:message code="file.column.fileName"/></th>
                        <th><spring:message code="file.column.fileSize"/></th>
                        <th><spring:message code="common.column.insertUser"/></th>
                        <th><spring:message code="common.column.insertDatetime"/></th>
                        <th><spring:message code="common.column.updateUser"/></th>
                        <th><spring:message code="common.column.updateDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${files != null and fn:length(files) > 0}">
                            <c:forEach var="file" items="${files}">
                                <tr>
                                    <td>
                                        <input type="checkbox" name="target" value="${file.fileId}" ${'4' eq file.state or '5' eq file.state ? '' : 'disabled'}>
                                    </td>
                                    <td onclick="selectFile('${file.fileId}');">
                                        <c:choose>
                                            <c:when test="${!empty file.categoryName}">
                                                ${file.categoryName}
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code="file.category.unknown"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <c:choose>
                                        <c:when test="${file.state == 6}">
                                            <td onclick="selectFile('${file.fileId}');"><span class="delete_text">${file.stateName}</span></td>
                                        </c:when>
                                        <c:otherwise>
                                            <td onclick="selectFile('${file.fileId}');">${file.stateName}</td>
                                        </c:otherwise>
                                    </c:choose>
                                    <td onclick="selectFile('${file.fileId}');">${file.logicalFileName}</td>
                                    <td onclick="selectFile('${file.fileId}');"><jabber:fileSize value="${file.fileSize}" point="1"/></td>
                                    <td onclick="selectFile('${file.fileId}');">${file.insertUserName}</td>
                                    <td onclick="selectFile('${file.fileId}');">
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${file.insertDatetime}" />
                                    </td>
                                    <td onclick="selectFile('${file.fileId}');">${file.updateUserId}</td>
                                    <td onclick="selectFile('${file.fileId}');">
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${file.updateDatetime}" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9"><spring:message code="common.message.emptyData"/></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <!-- 테이블 공통 페이징 Start -->
            <div id="pageContainer" class="page" />
        </div>
    </article>
</section>

<script type="text/javascript">

    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#fileForm');

    var urlConfig = {
        'listUrl':'${rootPath}/file/list.html'
        ,'detailUrl':'${rootPath}/file/detail.html'
        ,'deleteUrl':'${rootPath}/file/delete.html'
    };

    var messageConfig = {
        'requireSelectFile':'삭제할 파일을 선택해 주세요.'
        ,'deleteFileSuccess':'선택된 파일이 삭제되었습니다.'
        ,'deleteFileFailure':'선택된 파일삭제를 실패하였습니다.'
        ,'deleteFileConfirm':'선택된 파일을 삭제하시겠습니까?'
        ,'deleteFileFailurePart':'파일을 찾을 수 없거나, 삭제에 실패한 내역이 있습니다.'
        ,'failedDatetime':'<spring:message code="common.message.failedDatetime"/>'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));
    });

    /*
     페이지 네이게이터를 그린다.
     @author kst
     */
    function drawPageNavigater(pageSize,pageNumber,totalCount){
        var pageNavigater = new PageNavigator(pageSize,pageNumber,totalCount);
        pageNavigater.setClass('paging','p_arrow pll','p_arrow pl','','page_select','');
        pageNavigater.setGroupTag('《','〈','〉','》');
        pageNavigater.showInfo(false);
        $('#pageContainer').append(pageNavigater.getHtml());
    }

    /*
     페이지 이동
     @author kst
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }

    /*
     조회조건 validate
     @author kst
     */
    function validateSearch(){
        var startDatetiemStr = form.find('input[name=startDatetimeStr]').val();
        if(startDatetiemStr.length != 0 && !startDatetiemStr.checkDatePattern('-')){
            alertMessage('failedDatetime');
            return false;
        }

        var endDatetimeStr = form.find('input[name=endDatetimeStr]').val();
        if(endDatetimeStr.length != 0 && !endDatetimeStr.checkDatePattern('-')){
            alertMessage('failedDatetime');
            return false;
        }

        return true;
    }

    /*
     조회
     @author kst
     */
    function search(){
        if(validateSearch()){
            form.attr('action',urlConfig['listUrl']);
            form.submit();
        }
    }

    /*
     alert message method
     @author kst
     */
    function alertMessage(type, prefix, subfix){
        var message = messageConfig[type];

        if(prefix){
            message = prefix + message;
        }

        if(subfix){
            message = message + subfix;
        }

        alert(message);
    }

    /*
     상세화면 이동
     @author kst
     */
    function moveDetail(id){
//        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
//        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','userId').attr('value',id));
//        document.body.appendChild(detailForm.get(0));
//        detailForm.submit();
    }

    function checkAllControl(target){
        var checkFlag = $(target).is(':checked');
        $('input:checkbox[name=target]').each(function(){
            selectFile($(this).val(), checkFlag, this);
        });
    }

    function selectFile(id, flag, element){
        if(!element){
            $('input:checkbox[name=target]').each(function(){
                if($(this).val() == id){
                    element = this;
                }
            });
        }

        if($(element).attr('disabled') != null && ($(element).attr('disabled') == true || $(element).attr('disabled') == 'disabled')){
            return false;
        }

        if(flag == null){
            flag = !$(element).is(':checked');
            $('input:checkbox[name=allCheckbox]').prop('checked',false);
        }

        $(element).prop('checked',flag);
    }

    function deleteFile(){
        var flag = false;

        var ids = '';
        $('input:checkbox[name=target]').each(function(){
            if($(this).is(':checked')){
                ids += $(this).val() + ',';
            }
        });

        if(!ids || ids.length == 0){
            alertMessage('requireSelectFile');
            return false;
        }

        if(confirm(messageConfig['deleteFileConfirm'])){
            requestDeleteFile({'id':ids});
        }
    }

    function requestDeleteFile(data){
        sendAjaxPostRequest(urlConfig['deleteUrl'],data,deleteFile_successHandler, deleteFile_failureHandler);
    }

    function deleteFile_successHandler(data, dataType, actionType){
        if(!data){
            alertMessage('deleteFileFailure');
            return false;
        }

        if(data.hasOwnProperty('notDeleteFiles') && data['notDeleteFiles'].length > 0){
            var list = data['notDeleteFiles'];
            var failureDeleteFile = '';
            for(var index = 0; index < list.length; index++){
                failureDeleteFile += '\n-' + list[index];
            }

            alertMessage('deleteFileFailurePart',null,failureDeleteFile);
        }else{
            alertMessage('deleteFileSuccess');
        }

        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }

    function deleteFile_failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        console.error(textStatus);
        alertMessage('deleteFileFailure');
    }
</script>