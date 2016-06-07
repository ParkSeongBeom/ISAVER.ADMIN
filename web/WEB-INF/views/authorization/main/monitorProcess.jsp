<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<div class="table_title_area">
    <h4><spring:message code="main.title.process"/></h4>
    <div class="table_btn_set">
        <button class="btn main_btn fa more" onclick="javascript:moveView('setting','tabId','monitorProcess'); return false;"></button>
        <button class="btn main_btn fa refresh" onclick="javascript:reloadMenu('monitorProcess'); return false;"></button>
    </div>
</div>

<div class="table_contents">
    <!-- 조회 테이블 Start -->
    <table class="t_defalut t_type01 t_style02 ">
        <colgroup>
            <col style="width:90px">
            <col style="width:*">
            <col style="width:75px">
            <col style="width:75px">
            <col style="width:75px">
            <col style="width:50px">
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="monitorprocess.column.monitorName"/></th>
                <th><spring:message code="monitorprocess.column.processName"/></th>
                <th><spring:message code="monitor.column.cpu"/></th>
                <th><spring:message code="monitor.column.memory"/></th>
                <th><spring:message code="monitorprocess.column.reachable"/></th>
                <th></th>
            </tr>
        </thead>
    </table>

    <div id="monitorProcess" class="t_scroll t_height01" data-mcs-theme="minimal-dark">
        <table class="t_defalut t_type01 t_style02 cursor_no">
            <colgroup>
                <col style="width:90px">
                <col style="width:*">
                <col style="width:75px">
                <col style="width:75px">
                <col style="width:75px">
                <col style="width:50px">
            </colgroup>
            <tbody>
                <c:choose>
                    <c:when test="${monitorProcesses != null and fn:length(monitorProcesses) > 0}">
                        <c:forEach var="monitorProcess" items="${monitorProcesses}">
                            <tr id="${monitorProcess.processId}" monitorId="${monitorProcess.monitorId}">
                                <td>${monitorProcess.monitorName}</td>
                                <td>${monitorProcess.processCode}</td>
                                <td class="cpu tc loading"></td>
                                <td class="memory tc loading"></td>
                                <td class="reachable tc loading"></td>
                                <td><button class="btn main_btn fa refresh" onclick="javascript:reloadMonitorProcess('${monitorProcess.processId}','${monitorProcess.monitorId}'); return false;"></button></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6"><spring:message code="common.message.emptyData"/></td>
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
        loadMonitorProcessAll();
    });

    function loadMonitorProcessAll(){
        $.each($("#monitorProcess").find("tr"),function(e){
            var processId = $(this).attr("id");
            var monitorId = $(this).attr("monitorId");

            if(processId!=null && monitorId!=null){
                loadImage('loading', 'monitorProcess', processId);
                callAjax('loadProcessData',{'processId':processId , 'monitorId':monitorId});
            }
        });
    }

    function reloadMonitorProcess(processId,monitorId){
        loadImage('loading', 'monitorProcess', processId);
        callAjax('loadProcessData',{'processId':processId , 'monitorId':monitorId});
    }

    function setMonitorProcess(data){
        if(data.hasOwnProperty("resultMap")){
            var resultMap = data['resultMap'];

            for(var type in resultMap){
                if(type=="reachable"){
                    $("#"+data['processId']).find("."+type).html(
                        $("<span/>").addClass("stion_btn "+"con_"+resultMap[type]).text(messageConfig[resultMap[type]])
                    );
                }else{
                    $("#"+data['processId']).find("."+type).empty().text(resultMap[type]);
                }
            }
        }else{
            console.error("[setMonitorProcess] has not resultMap");
        }

        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
        loadImage('complete', 'monitorProcess', data['processId']);
    }
</script>