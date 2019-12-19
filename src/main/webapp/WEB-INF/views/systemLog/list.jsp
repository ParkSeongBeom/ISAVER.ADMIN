<!-- 알림파일관리 목록, @author psb -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00070" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.systemLog"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <article class="flex-area-w">
        <section>
            <div class="set-btn type-01 style-01">
                <button class="ico-plus" onclick="javascript:excuteScript(); return false;">
                    <span><spring:message code="systemLog.button.saveLog"/></span>
                </button>
            </div>
            <div class="set-item">
                <div id="logDatetime" class="dpk_select_type"></div>
            </div>
        </section>
        <section>
            <form id="systemLogForm" method="POST">
                <input type="hidden" name="pageNumber"/>

                <article class="search_area">
                    <div class="search_contents">
                        <p class="itype_04">
                            <span><spring:message code="systemLog.column.logDatetime" /></span>
                            <span class="plable04">
                                <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                                <select id="startDatetimeHourSelect" name="startDatetimeHour"></select>
                                <em>~</em>
                                <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
                                <select id="endDatetimeHourSelect" name="endDatetimeHour"></select>
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
                    <div class="table_btn_set">
                        <p><span>총<em>${paramBean.totalCount}</em>건</span></p>
                    </div>
                </div>

                <div class="table_contents">
                    <!-- 입력 테이블 Start -->
                    <table class="t_defalut t_type01 t_style02">
                        <colgroup>
                            <col style="width: *;" />
                            <col style="width: 30%;" />
                            <col style="width: 30%;" />
                        </colgroup>
                        <thead>
                        <tr>
                            <th><spring:message code="systemLog.column.systemLogId"/></th>
                            <th><spring:message code="systemLog.column.fileName"/></th>
                            <th><spring:message code="systemLog.column.logDatetime"/></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${systemLogList != null and fn:length(systemLogList) > 0}">
                                <c:forEach var="systemLog" items="${systemLogList}">
                                    <tr onclick="downloadFile(String('${systemLog.systemLogId}'));">
                                        <td>${systemLog.systemLogId}</td>
                                        <td>${systemLog.fileName}</td>
                                        <td>
                                            <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${systemLog.logDatetime}" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="3"><spring:message code="common.message.emptyData"/></td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>

                    <!-- 테이블 공통 페이징 Start -->
                    <div id="pageContainer" class="page" ></div>
                </div>
            </article>
        </section>
    </article>
</section>
<!-- END : contents -->

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#systemLogForm');

    var messageConfig = {
        'requiredDatetime':'<spring:message code="systemLog.message.requiredDatetime"/>'
        ,'regexpDatetime':'<spring:message code="systemLog.message.regexpDatetime"/>'
        ,'saveLogConfirm':'<spring:message code="systemLog.message.saveLogConfirm"/>'
        ,'saveLogComplete':'<spring:message code="systemLog.message.saveLogComplete"/>'
        ,'saveLogFailure':'<spring:message code="systemLog.message.saveLogFailure"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/systemLog/list.html'
        ,'downloadUrl':'${rootPath}/systemLog/download.html'
        ,'saveLogUrl':'${rootPath}/systemLog/excute.json'
    };

    var searchConfig = {
        'startDatetimeHour':'${paramBean.startDatetimeHour}'
        ,'endDatetimeHour':'${paramBean.endDatetimeHour}'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

    $(document).ready(function(){
        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));
        calendarHelper.load($('#logDatetime'));

        setHourDataToSelect($('#startDatetimeHourSelect'),searchConfig['startDatetimeHour'],false);
        setHourDataToSelect($('#endDatetimeHourSelect'),searchConfig['endDatetimeHour'],true);

        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
    });

    /*
     조회
     @author psb
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     페이지 네이게이터를 그린다.
     @author psb
     */
    function drawPageNavigater(pageSize,pageNumber,totalCount){
        var pageNavigater = new PageNavigator(pageSize,pageNumber,totalCount);
        pageNavigater.setClass('paging','pll','pl','','on','');
        pageNavigater.setGroupTag('《','〈','〉','》');
        pageNavigater.showInfo(false);
        $('#pageContainer').append(pageNavigater.getHtml());
    }

    /*
     페이지 이동
     @author psb
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }

    function validate(logDatetime){
        if(logDatetime==null || logDatetime==""){
            alertMessage('requiredDatetime');
            return false;
        }

        if(!logDatetime.checkDatePattern("-")){
            alertMessage('regexpDatetime');
            return false;
        }
        return true;
    }

    /*
     스크립트 실행
     @author psb
     */
    function excuteScript(){
        if(!confirm(messageConfig['saveLogConfirm'])){
            return false;
        }

        var logDatetime = $("#logDatetime").val();
        if(!validate(logDatetime)){
            $("#logDatetime").focus();
            return false;
        }
        callAjax('saveLog', {"logDatetime":logDatetime});
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestSystemLog_successHandler,requestSystemLog_errorHandler,actionType);
    }

    function requestSystemLog_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'saveLog':
                if(data['status']=='commandSuccess'){
                    alertMessage(actionType + 'Complete');
                }else{
                    alert(actionType + 'Failure - ' + data['status']);
                }
                break;
        }
    }

    function requestSystemLog_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }


    /*
     파일 다운로드
     @author psb
     */
    function downloadFile(id){
        var downloadForm = $('<FORM>').attr('action',urlConfig['downloadUrl']).attr('method','POST');
        downloadForm.append($('<INPUT>').attr('type','hidden').attr('name','systemLogId').attr('value',id));
        document.body.appendChild(downloadForm.get(0));
        downloadForm.submit();
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>