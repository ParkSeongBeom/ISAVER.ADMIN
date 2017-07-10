<!-- 구역 관리 목록 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="C00000" var="menuId"/>
<c:set value="C00000" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.area"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <!-- 트리 영역 Start -->
    <article class="table_area tree_table">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle01" onclick="javascript:areaCtrl.treeExpandAll(); return false;"><spring:message code='area.button.viewTheFullArea'/></button>
                <button class="btn btype01 bstyle01" onclick="javascript:areaCtrl.setAddBefore(); return false;" ><spring:message code='area.button.addArea'/></button>
            </div>
        </div>
        <div class="table_contents">
            <div id="menuTreeArea" class="tree_box">
                <ul class="dynatree-container dynatree-no-connector">
                </ul>
            </div>
        </div>
    </article>
    <%--<article class="table_area tree_table">--%>
    <%--<div class="table_title_area">--%>
    <%--<h4></h4>--%>
    <%--<div class="table_btn_set">--%>
    <%--<button class="btn btype01 bstyle01" onclick="javascript:menuCtrl.treeExpandAll(); return false;"><spring:message code='menu.button.viewTheFullMenu'/></button>--%>
    <%--<button class="btn btype01 bstyle01" onclick="javascript:menuCtrl.setAddBefore(); return false;" ><spring:message code='menu.button.addMenu'/></button>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div class="table_contents">--%>
    <%--<div id="menuTreeArea" class="tree_box"></div>--%>
    <%--</div>--%>
    <%--</article>--%>
    <!-- 트리 영역 End -->

    <form id="areaForm" method="POST" onsubmit="return false;" class="form_type01">
        <input type="hidden" name="parentAreaId" />
        <article class="table_area tr_table">
            <div class="table_title_area">
                <h4><spring:message code="area.column.areaInformation"/></h4>
            </div>

            <div class="table_contents area_enrolment">
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
                        <th><spring:message code="area.column.areaId"/></th>
                        <td>
                            <input type="text" name="" value="" placeholder="<spring:message code="area.message.requiredAreaId"/>" readonly="readonly">
                        </td>
                        <th class="point"><spring:message code="area.column.areaName"/></th>
                        <td class="point">
                            <input type="text" name="" value="" placeholder="<spring:message code="area.message.requiredAreaName"/>">
                        </td>
                    </tr>
                    <%--<tr>--%>
                    <%--<th>부모구역 명</th>--%>
                    <%--<td colspan="3">--%>
                    <%--<select id="selectParentMenuId">--%>
                    <%--<option value="">Area01</option>--%>
                    <%--<option value="">Area01 〉 Area01_01</option>--%>
                    <%--</select>--%>
                    <%--</td>--%>
                    <%--</tr>--%>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
                <%--<div class="table_title_area">--%>
                <%--<div class="table_btn_set">--%>
                <%--<button class="btn btype01 bstyle03" name="addBtn" onclick="javascript:areaCtrl.addMenuVaild(); return false;"><spring:message code="common.button.add"/></button>--%>
                <%--<button class="btn btype01 bstyle03" name="saveBtn" onclick="javascript:areaCtrl.saveMenuVaild(); return false;"><spring:message code="common.button.save"/></button>--%>
                <%--<button class="btn btype01 bstyle03" name="removeBtn" onclick="javascript:areaCtrl.removeMenuVaild(); return false;"><spring:message code="common.button.remove"/></button>--%>
                <%--</div>--%>
                <%--</div>--%>
            </div>

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
                        <th class="point"><spring:message code="area.column.areaId"/></th>
                        <td class="point">
                            <input type="text" name="areaId" placeholder="<spring:message code="area.message.requiredAreaId"/>" disabled>
                        </td>
                        <th class="point"><spring:message code="area.column.areaName"/></th>
                        <td class="point">
                            <input type="text" name="areaName" placeholder="<spring:message code="area.message.requiredAreaName"/>" maxlength="50">
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='area.column.parentareaName'/></th>
                        <td colspan="3">
                            <select id="selectParentAreaId">
                                <option value=""><spring:message code="device.message.emptyData"/></option>
                                <c:forEach items="${areas}" var="areas">
                                    <c:if test="${areas.delYn == 'N'}">
                                        <option value="${areas.areaId}">${areas.path}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="area.column.sortOrder"/></th>
                        <td class="point" colspan="3">
                            <input type="number" name="sortOrder" placeholder="<spring:message code="area.message.requiredSortOrder"/>" >
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="area.column.areaDesc"/></th>
                        <td class="point" colspan="3">
                            <textarea name="areaDesc" class="textboard"></textarea>
                        </td>
                    </tr>

                    <tr name="showHideTag" >
                        <th><spring:message code="common.column.insertUser"/></th>
                        <td name="insertUserName"></td>
                        <th><spring:message code="common.column.insertDatetime"/></th>
                        <td name="insertDatetime"></td>
                    </tr>
                    <tr name="showHideTag" >
                        <th><spring:message code="common.column.updateUser"/></th>
                        <td name="updateUserName"></td>
                        <th><spring:message code="common.column.updateDatetime"/></th>
                        <td name="updateDatetime"></td>
                    </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>
            <div class="table_title_area" name="showHideTag" >
                <h4><spring:message code="device.column.deviceList"/></h4>
            </div>

            <div class="table_contents" name="showHideTag" >
                <table name="roleListTable" class="t_defalut t_type01 t_style02">
                    <colgroup>
                        <col style="width: 20%;">
                        <col style="width: 20%;">
                        <col style="width: 20%;">
                        <col style="width: *;">
                    </colgroup>
                    <thead>
                    <tr>
                        <th><spring:message code="device.column.deviceId"/></th>
                        <th><spring:message code="device.column.serialNo"/></th>
                        <th><spring:message code="device.column.deviceType"/></th>
                        <th><spring:message code="device.column.deviceCode"/></th>
                    </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
                <!-- 테이블 공통 페이징 Start -->
                <div id="pageContainer" class="page">
                    <p class="paging">
                        <button class="p_arrow pll" onclick="alert(&quot;현재 첫번째 페이지 입니다.&quot;); return false;">《</button>
                        <button class="p_arrow pl" onclick="javascript:alert(&quot;현재 첫번째 페이지 입니다.&quot;); return false;">〈</button>
                        <button class="page_select ">1</button><button class="" onclick="javascript:goPage(2); return false;">2</button>
                        <button class="" onclick="javascript:goPage(3); return false;">3</button>
                        <button class="p_arrow pl" onclick="javascript:goPage(11); return false;">〉</button><button class="p_arrow pll" onclick="javascript:goPage(1006); return false;">》</button>
                    </p>
                </div>
            </div>
            <div class="table_title_area">
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" name="addBtn" onclick="javascript:areaCtrl.addAreaVaild(); return false;"><spring:message code="common.button.add"/> </button>
                    <button class="btn btype01 bstyle03" name="saveBtn" onclick="javascript:areaCtrl.saveAreaVaild(); return false;"><spring:message code="common.button.save"/> </button>
                    <button class="btn btype01 bstyle03" name="removeBtn" onclick="javascript:areaCtrl.removeAreaVaild(); return false;"><spring:message code="common.button.remove"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
        <!-- END : contents -->
    </form>

</section>

<script src="${rootPath}/assets/library/tree/jquery.dynatree.js"type="text/javascript" ></script>
<script src="${rootPath}/assets/js/page/area/AreaModel.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/area/AreaCtrl.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/area/AreaView.js" type="text/javascript" charset="UTF-8"></script>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var urlConfig = {
        'deviceListUrl':'${rootPath}/device/list.html'
    };

    var messageConfig = {
        menuBarFailure            :'<spring:message code="menu.message.menuTreeFailure"/>'
        ,   menuTreeFailure           :'<spring:message code="menu.message.menuBarFailure"/>'
        ,   addFailure                :'<spring:message code="area.message.addFailure"/>'
        ,   saveFailure               :'<spring:message code="area.message.saveFailure"/>'
        ,   removeFailure             :'<spring:message code="area.message.removeFailure"/>'
        ,   addComplete               :'<spring:message code="area.message.addComplete"/>'
        ,   saveComplete              :'<spring:message code="area.message.saveComplete"/>'
        ,   removeComplete            :'<spring:message code="area.message.removeComplete"/>'
        ,   addConfirmMessage         :'<spring:message code="common.message.addConfirm"/>'
        ,   saveConfirmMessage        :'<spring:message code="common.message.saveConfirm"/>'
        ,   removeConfirmMessage      :'<spring:message code="common.message.removeConfirm"/>'
        ,   requiredAreaId            :"<spring:message code='area.message.requiredAreaId'/>"
        ,   requiredAreaName          :"<spring:message code='area.message.requiredAreaName'/>"
        ,   requiredSortOrder          :"<spring:message code='area.message.requiredSortOrder'/>"
        ,   requiredMenuUrl           :"<spring:message code='menu.message.requiredMenuUrl'/>"
        ,   regexpDigits              :"<spring:message code='menu.message.regexpDigits'/>"
        ,   regexpUrl                 :"<spring:message code='menu.message.regexpUrl'/>"
        ,   pleaseChooseMenu          :"<spring:message code='menu.message.pleaseChooseMenu'/>"
        ,   menuNotDeleted            :"<spring:message code='menu.message.menuNotDeleted'/>"
        ,   existsAreaId            :"<spring:message code='area.message.existsAreaId'/>"
    };

    var areaModel = new AreaModel();
    areaModel.setRootUrl(String('${rootPath}'));
    areaModel.setPageRowNumber(10);
    areaModel.setPageIndex(0);

    var areaCtrl = new AreaCtrl(areaModel);


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


    $(document).ready(function(){

        $("select[id=selectParentAreaId]").change(function() {
            var id  = $(event.currentTarget).val();
            $("input[name=parentAreaId]").val(id);
            areaModel.setParentAreaId(id);
        });

        /**
         * 구역 트리 생성
         */
        areaCtrl.findMenuTree();
    });

</script>