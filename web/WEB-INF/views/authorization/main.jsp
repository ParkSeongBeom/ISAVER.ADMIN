<%--
  Created by IntelliJ IDEA.
  User: sungtae
  Date: 2014. 6. 2.
  Time: 오후 3:43
  메인 메뉴
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-0000-0000-0000-000000000000" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />

<script src="${rootPath}/assets/js/common/dynatree/jquery.dynatree.js" type="text/javascript" ></script>
<script src="${rootPath}/assets/js/util/ajax-util.js" type="text/javascript" charset="UTF-8"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container main_area">
    <!-- section End -->
    <c:if test="${!empty roleId and roleId=='ROLE00000'}">
        <ul class="view" style="display:none;">
            <li rel="#monitorServer" href="${rootPath}/monitor/serverList.html"></li>
            <li rel="#monitorProcess" href="${rootPath}/monitorProcess/processList.html"></li>
            <li rel="#logBatch" href="${rootPath}/logbatch/mainList.html"></li>
            <li rel="#logAuthAdminUser" href="${rootPath}/logauthadmin/mainList.html"></li>
            <li rel="#maintenance" href="${rootPath}/maintenance/mainList.html"></li>
            <li rel="#user" href="${rootPath}/logauthuser/userList.html"></li>
            <li rel="#logUser" href="${rootPath}/logauthuser/logUserList.html"></li>
        </ul>

        <article class="table_area main_type03" id="monitorServer"></article>
        <article class="table_area main_type01" id="monitorProcess"></article>
        <article class="table_area main_type02" id="logBatch"></article>
        <article class="table_area main_type00" id="logAuthAdminUser"></article>
        <article class="table_area main_type04" id="maintenance"></article>
        <article class="table_area main_type05" id="user"></article>
        <article class="table_area main_type03" id="logUser"></article>
    </c:if>
</section>

<script type="application/javascript" charset="utf-8">
    var targetMenuId = String('${menuId}');
    /*
     url defind
     @author psb
     */
    var urlConfig = {
        'settingUrl'            : '${rootPath}/setting/list.html'
        ,'logBatchUrl'          : '${rootPath}/logbatch/list.html'
        ,'userUrl'              : '${rootPath}/user/list.html'
        ,'logUserUrl'           : '${rootPath}/logauthuser/list.html'
        ,'maintenanceUrl'       : '${rootPath}/maintenance/list.html'
        ,'maintenanceDetailUrl' : '${rootPath}/maintenance/detail.html'
        ,'logAuthAdminUserUrl'  : '${rootPath}/logauthadmin/list.html'
        ,'loadMonitorDataUrl'   : '${rootPath}/monitor/serverDetail.json'
        ,'loadProcessDataUrl'   : '${rootPath}/monitorProcess/processDetail.json'
    };

    /*
     message define
     @author psb
     */
    var messageConfig = {
        'on':'<spring:message code="main.column.on"/>'
        ,'off':'<spring:message code="main.column.off"/>'
        ,'failure':'<spring:message code="main.column.failure"/>'
    };

    $(document).ready(function() {
        <c:if test="${!empty roleId and roleId=='ROLE00000'}">
            $.each($(".view").find("li"), function(){
                var activeTab = $(this).attr("rel");
                $(activeTab).load($(this).attr("href"),function(){
                    $(".t_scroll").mCustomScrollbar({
                        axis:"y"
                    });
                });
            });
        </c:if>
    });

    function reloadMenu(id){
        var activeLi = $("li[rel='#"+id+"']");
        var activeTab = $(activeLi).attr("rel");
        $(activeTab).load($(activeLi).attr("href"),function(){
            $(".t_scroll").mCustomScrollbar({
                axis:"y"
            });
        });
    }

    /*
     move view method
     @author dhj
     */
    function moveView(actionType, paramName, paramData){
        var listForm = $('<FORM>').attr('action',urlConfig[actionType+'Url']).attr('method','POST');

        if(paramName!=null && paramName!=""){
            listForm.append($('<INPUT>').attr('type','hidden').attr('name',paramName).attr('value',paramData));
        }

        document.body.appendChild(listForm.get(0));
        listForm.submit();
    }

    function loadImage(flag, tbId, id){
        switch(flag){
            case 'loading':
                $("#"+id).find(".loading").html(
                    $("<span/>").addClass("con_loading")
                );
                break;
            case 'complete':
                $("#"+id).find(".con_loading").parent("td").html(
                    $("<span/>").addClass("stion_btn con_failure").text(messageConfig['failure'])
                );
                break;
            case 'failure':
                $(".con_loading").parent("td").html(
                    $("<span/>").addClass("stion_btn con_failure").text(messageConfig['failure'])
                );
                break;
        };
    }

    /*
     ajax call
     @author kst
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    /*
     ajax success handler
     @author kst
     */
    function requestCode_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'loadMonitorData':
                setMonitorServer(data);
                break;
            case 'loadProcessData':
                setMonitorProcess(data);
                break;
        };
    }

    /*
     ajax error handler
     @author kst
     */
    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        loadImage('failure');
    }
</script>