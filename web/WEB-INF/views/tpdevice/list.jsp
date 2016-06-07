<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-H000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-F000-0000-0000-000000000001" var="menuId"/>

<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.tpdevice"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="tpDeviceForm" method="POST">
        <input type="hidden" name="pageNumber"/>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/> </button>
                <button class="btn btype01 bstyle03" onclick="javascript:removeTpDevice(); return false;"><spring:message code="common.button.remove"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 5%;" />
                    <col style="width: *%;" />
                    <col style="width: 20%;" />
                    <col style="width: 20%;" />
                    <col style="width: 20%;" />
                    <col style="width: 8%;" />
                    <col style="width: 8%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><input type="checkbox" id="mainCheck" value=""></th>
                        <th><spring:message code="tpdevice.column.deviceName"/></th>
                        <th><spring:message code="tpdevice.column.ipAddress"/></th>
                        <th><spring:message code="tpdevice.column.sipUrl"/></th>
                        <th><spring:message code="tpdevice.column.h323Id"/></th>
                        <th><spring:message code="tpdevice.column.type"/></th>
                        <th><spring:message code="common.column.useYn"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${tpDevices != null and fn:length(tpDevices) > 0}">
                            <c:forEach var="tpDevice" items="${tpDevices}">
                                <tr id="${tpDevice.deviceId}">
                                    <td><input type="checkbox" name="subCheck" value="${tpDevice.deviceId}"></td>
                                    <td>${tpDevice.deviceName}</td>
                                    <td>${tpDevice.ipAddress}</td>
                                    <td>${tpDevice.sipUrl}</td>
                                    <td>${tpDevice.h323Id}</td>
                                    <td>${tpDevice.type}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tpDevice.useYn == 'Y'}">
                                                <spring:message code="common.column.useYes"/>
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code="common.column.useNo"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
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

            <!-- 테이블 공통 페이징 Start -->
            <div id="pageContainer" class="page" />
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#tpDeviceForm');

    var urlConfig = {
        'listUrl':'${rootPath}/tpdevice/list.html'
        ,'detailUrl':'${rootPath}/tpdevice/detail.html'
        ,'removeUrl':'${rootPath}/tpdevice/remove.json'

    };

    var pageConfig = {
        'pageSize':${paramBean.pageRowNumber}
        ,'pageNumber':${paramBean.pageNumber}
        ,'totalCount':${paramBean.totalCount}
    };

    var messageConfig = {
        'removeComplete':'<spring:message code="tpdevice.message.removeComplete"/>'
        ,'removeConfirm':'<spring:message code="tpdevice.message.removeConfirm"/>'
        ,'removeEmpty':'<spring:message code="tpdevice.message.removeEmpty"/>'
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        $('tbody tr').each(function(){
            $(this).find('td').not(':first-child').on('click',function(){
                if($(this).parent().attr('id') != null && $(this).parent().attr('id').length > 0){
                    moveDetail($(this).parent().attr('id'));
                }
            });
        });
    });

    /*
     페이지 네이게이터를 그린다.
     @author psb
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
     @author psb
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }

    /*
     조회
     @author psb
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     TP장비 제거
     @author psb
     */
    function removeTpDevice(){
        var tpCheck = $("input[name=subCheck]:checked");
        var deviceId = "";

        if(tpCheck.length>0){
            if(!confirm(messageConfig['removeConfirm'])) {
                return false;
            }

            for (var i = 0; i < tpCheck.length; i++) {
                if (i>0){
                    deviceId += ",";
                }
                deviceId += tpCheck[i].value;
            }

            var data = {
                "deviceId" : deviceId
            };

            callAjax('remove', data);
        }else{
            alert(messageConfig['removeEmpty']);
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        alert(messageConfig[actionType + 'Complete']);
        switch(actionType){
            case 'remove':
                search();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(messageConfig[actionType + 'Failure']);
    }

    /*
     상세화면 이동
     @author psb
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','deviceId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }

    $(document).ready(function(){
        $('#mainCheck').click(function(){
            if($(this).is(':checked')){
                $("input[name=subCheck]").prop("checked",true);
            }else{
                $("input[name=subCheck]").prop("checked",false);
            }
        });
    });
</script>