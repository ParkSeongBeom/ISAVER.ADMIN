<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<div class="table_title_area">
    <h4><spring:message code="main.title.system"/></h4>
    <div class="table_btn_set">
        <button class="btn main_btn fa more" onclick="javascript:moveView('setting','tabId','monitor'); return false;"></button>
        <button class="btn main_btn fa refresh" onclick="javascript:reloadMenu('monitorServer'); return false;"></button>
    </div>
</div>

<div class="table_contents">
    <!-- 조회 테이블 Start -->
    <table class="t_defalut t_type01 t_style02 ">
        <colgroup>
            <col style="width:*">  <!-- 01 -->
            <col style="width:15%">  <!-- 02 -->
            <col style="width:15%">  <!-- 03 -->
            <col style="width:15%">  <!-- 04 -->
            <col style="width:15%">  <!-- 05 -->
            <col style="width:100px">    <!-- 06 -->
            <col style="width:70px">    <!-- 06 -->
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="monitor.column.name"/></th>
                <th><spring:message code="monitor.column.ip"/></th>
                <th><spring:message code="monitor.column.cpu"/></th>
                <th><spring:message code="monitor.column.memory"/></th>
                <th><spring:message code="monitor.column.storage"/></th>
                <th><spring:message code="monitorprocess.column.reachable"/></th>
                <th></th>
            </tr>
        </thead>
    </table>

    <div id="monitors" class="t_scroll t_height01" data-mcs-theme="minimal-dark">
        <table class="t_defalut t_type01 t_style02 cursor_no">
            <colgroup>
                <col style="width:*">  <!-- 01 -->
                <col style="width:15%">  <!-- 02 -->
                <col style="width:15%">  <!-- 03 -->
                <col style="width:15%">  <!-- 04 -->
                <col style="width:15%">  <!-- 05 -->
                <col style="width:100px">    <!-- 06 -->
                <col style="width:70px">    <!-- 07 -->
            </colgroup>
            <tbody>
                <c:choose>
                    <c:when test="${monitors != null and fn:length(monitors) > 0}">
                        <c:forEach var="monitor" items="${monitors}">
                            <tr id="${monitor.monitorId}">
                                <td>${monitor.name}</td>
                                <td>${monitor.ip}</td>
                                <td class="cpu loading"></td>
                                <td class="memory loading"></td>
                                <td class="storage loading"></td>
                                <td class="reachable loading"></td>
                                <td><button class="btn main_btn fa refresh" onclick="javascript:reloadMonitorServer('${monitor.monitorId}'); return false;"></button></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7"><spring:message code="common.message.emptyData"/></td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        <!-- 조회 테이블 End -->
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function(){
        loadMonitorServerAll();
    });

    function loadMonitorServerAll(){
        $.each($("#monitors").find("tr"),function(e){
            var monitorId = $(this).attr("id");
            if(monitorId!=null) {
                loadImage('loading',monitorId);
                callAjax('loadMonitorData',{monitorId:monitorId});
            }
        });
    }

    function reloadMonitorServer(id){
        loadImage('loading', 'monitors', id);
        callAjax('loadMonitorData',{monitorId:id});
    }

    function setMonitorServer(data){
        if(data.hasOwnProperty("resultMap")){
            var resultMap = data['resultMap'];

            for(var type in resultMap){
                if(type=="reachable"){
                    $("#"+data['monitorId']).find("."+type).html(
                        $("<span/>").addClass("stion_btn "+"con_"+resultMap[type]).text(messageConfig[resultMap[type]])
                    );
                }else{
                    $("#"+data['monitorId']).find("."+type).empty().text(resultMap[type]);
                }
            }
        }else{
            console.error("[setMonitorServer] has not resultMap");
        }

        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
        loadImage('complete', 'monitors',data['monitorId']);
    }
</script>