<!-- 구역 관리 목록 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000001" var="menuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.area"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <!-- 트리 영역 Start -->
    <article class="table_area tree_table">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle01" onclick="javascript:menuCtrl.treeExpandAll(); return false;"><spring:message code='area.button.viewTheFullArea'/></button>
                <button class="btn btype01 bstyle01" onclick="javascript:menuCtrl.setAddBefore(); return false;" ><spring:message code='area.button.addArea'/></button>
            </div>
        </div>
        <div class="table_contents">
            <div id="menuTreeArea" class="tree_box">
                <ul class="dynatree-container dynatree-no-connector">
                    <li class="dynatree-lastsib">
                            <span class="dynatree-node dynatree-folder dynatree-expanded dynatree-has-children dynatree-lastsib dynatree-exp-el dynatree-ico-ef">
                                <span class="dynatree-icon"></span>
                                <a href="#" class="dynatree-title">Area01</a>
                            </span>
                        <ul>
                            <li class="">
                                    <span class="dynatree-node dynatree-has-children dynatree-exp-c dynatree-ico-c">
                                        <span class="dynatree-expander"></span>
                                        <span class="dynatree-icon"></span>
                                        <a href="#" class="dynatree-title">Area01 001-23</a>
                                    </span>
                            </li>
                            <li class="">
                                    <span class="dynatree-node dynatree-has-children dynatree-exp-c dynatree-ico-c">
                                        <span class="dynatree-expander"></span>
                                        <span class="dynatree-icon"></span>
                                        <a href="#" class="dynatree-title">Area02 002-56</a>
                                    </span>
                            </li>
                            <li class="">
                                    <span class="dynatree-node dynatree-has-children dynatree-exp-c dynatree-ico-c">
                                        <span class="dynatree-expander"></span>
                                        <span class="dynatree-icon"></span>
                                        <a href="#" class="dynatree-title">Area03 003-52</a>
                                    </span>
                            </li>
                            <li class="">
                                    <span class="dynatree-node dynatree-has-children dynatree-exp-c dynatree-ico-c">
                                        <span class="dynatree-expander"></span>
                                        <span class="dynatree-icon"></span>
                                        <a href="#" class="dynatree-title">Area04 004-85</a>
                                    </span>
                            </li>

                        </ul>
                    </li>

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

    <form id="deviceForm" method="POST">
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
                            <input type="text" name="" value="" placeholder="<spring:message code="area.message.requiredAreaId"/>">
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
                <div class="table_title_area">
                    <div class="table_btn_set">
                        <button class="btn btype01 bstyle03" name="addBtn" onclick="javascript:menuCtrl.addMenuVaild(); return false;"><spring:message code="common.button.add"/></button>
                        <button class="btn btype01 bstyle03" name="saveBtn" onclick="javascript:menuCtrl.saveMenuVaild(); return false;"><spring:message code="common.button.save"/></button>
                        <button class="btn btype01 bstyle03" name="removeBtn" onclick="javascript:menuCtrl.removeMenuVaild(); return false;"><spring:message code="common.button.remove"/></button>
                    </div>
                </div>
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
                        <th><spring:message code="area.column.areaId"/></th>
                        <td>
                            <input type="text" name="areaId" placeholder="<spring:message code="area.message.requiredAreaId"/>" readonly="true">
                        </td>
                        <th class="point"><spring:message code="area.column.areaName"/></th>
                        <td class="point">
                            <input type="text" name="areaName" placeholder="<spring:message code="area.message.requiredAreaName"/>">
                        </td>
                    </tr>
                    <tr>
                        <!--<th>부모구역 명</th>
                        <td>
                            <select id="selectParentMenuId">
                                <option value="">Area01</option>
                                <option value="">Area01 〉 Area01_01</option>
                            </select>
                        </td>-->
                        <th><spring:message code="area.column.areaName"/></th>
                        <td colspan="3">
                            <input type="number" name="sortOrder" value="" placeholder="<spring:message code="area.message.requiredAreaName"/>">
                        </td>
                    </tr>

                    <tr>
                        <th><spring:message code="area.column.areaDesc"/></th>
                        <td class="point" colspan="3">
                            <textarea name="" class="textboard"></textarea>
                        </td>
                    </tr>

                    <tr>
                        <th><spring:message code="common.column.insertUser"/></th>
                        <td name=""></td>
                        <th><spring:message code="common.column.insertDatetime"/></th>
                        <td name=""></td>
                    </tr>
                    <tr>
                        <th><spring:message code="common.column.updateUser"/></th>
                        <td name=""></td>
                        <th><spring:message code="common.column.updateDatetime"/></th>
                        <td name=""></td>
                    </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>
            <div class="table_title_area">
                <h4><spring:message code="device.column.deviceList"/></h4>
            </div>
            <article class="search_area" name="showHideTag" style="display: table;">
                <div class="search_contents">
                    <!-- 일반 input 폼 공통 -->
                    <p class="itype_01">
                        <span><spring:message code="device.column.deviceId"/></span>
                        <span>
                            <input type="text" name="deviceId" value="">
                        </span>
                    </p>
                    <p class="itype_01">
                        <span><spring:message code="device.column.serialNo"/></span>
                        <span>
                            <input type="text" name="serialNo" value="">
                        </span>
                    </p>
                    <p class="itype_01">
                        <span><spring:message code="device.column.deviceCode"/></span>
                        <span>
                            <select>
                                <option value="">장치 코드 01</option>
                                <option value="">장치 코드 02</option>
                                <option value="">장치 코드 03</option>
                            </select>
                        </span>
                    </p>
                    <p class="itype_01">
                        <span><spring:message code="device.column.deviceType"/></span>
                        <span>
                            <select>
                                <option value="">장치 유형 01</option>
                                <option value="">장치 유형 02</option>
                                <option value="">장치 유형 03</option>
                            </select>
                        </span>
                    </p>
                </div>
                <div class="search_btn">
                    <button onclick="javascript:organizationCtrl.searchOrgUser(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.find"/></button>
                </div>
            </article>

            <div class="table_contents">
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
                        <th><spring:message code="device.column.deviceCode"/></th>
                        <th><spring:message code="device.column.deviceType"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>CN-JSVJRGB</td>
                        <td>Area01 001-23</td>
                        <td></td>
                        <td></td>
                    </tr>
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
                    <button class="btn btype01 bstyle03" name="addBtn" onclick="javascript:menuCtrl.addMenuVaild(); return false;"><spring:message code="common.button.add"/> </button>
                    <button class="btn btype01 bstyle03" name="saveBtn" onclick="javascript:menuCtrl.saveMenuVaild(); return false;"><spring:message code="common.button.save"/> </button>
                    <button class="btn btype01 bstyle03" name="removeBtn" onclick="javascript:menuCtrl.removeMenuVaild(); return false;"><spring:message code="common.button.remove"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
        <!-- END : contents -->
    </form>

</section>

<script src="${rootPath}/assets/js/common/dynatree/jquery.dynatree.js"type="text/javascript" ></script>
<script src="${rootPath}/assets/js/util/ajax-util.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/area/AreaModel.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/area/AreaCtrl.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/area/AreaView.js" type="text/javascript" charset="UTF-8"></script>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var messageConfig = {
            menuBarFailure            :'<spring:message code="menu.message.menuTreeFailure"/>'
        ,   menuTreeFailure           :'<spring:message code="menu.message.menuBarFailure"/>'
        ,   addFailure                :'<spring:message code="menu.message.addFailure"/>'
        ,   saveFailure               :'<spring:message code="menu.message.saveFailure"/>'
        ,   removeFailure             :'<spring:message code="menu.message.removeFailure"/>'
        ,   addComplete               :'<spring:message code="menu.message.addComplete"/>'
        ,   saveComplete              :'<spring:message code="menu.message.saveComplete"/>'
        ,   removeComplete            :'<spring:message code="menu.message.removeComplete"/>'
        ,   addConfirmMessage         :'<spring:message code="common.message.addConfirm"/>'
        ,   saveConfirmMessage        :'<spring:message code="common.message.saveConfirm"/>'
        ,   removeConfirmMessage      :'<spring:message code="common.message.removeConfirm"/>'
        ,   requiredMenuId            :"<spring:message code='menu.message.requiredMenuId'/>"
        ,   requiredMenuName          :"<spring:message code='menu.message.requiredMenuName'/>"
        ,   requiredMenuUrl           :"<spring:message code='menu.message.requiredMenuUrl'/>"
        ,   requiredSortOrder         :"<spring:message code='menu.message.requiredSortOrder'/>"
        ,   regexpDigits              :"<spring:message code='menu.message.regexpDigits'/>"
        ,   regexpUrl                 :"<spring:message code='menu.message.regexpUrl'/>"
        ,   pleaseChooseMenu          :"<spring:message code='menu.message.pleaseChooseMenu'/>"
        ,   menuNotDeleted            :"<spring:message code='menu.message.menuNotDeleted'/>"
    };

    $(document).ready(function(){

        $('#selectAll').click(function(event) {
            if(this.checked) {
                $('input[type=checkbox]').each(function() {
                    this.checked = true;
                });
            }else{
                $('input[type=checkbox]').each(function() {
                    this.checked = false;
                });
            }
        });

        $( "#selectParentMenuId" ).change(function() {
            var formName = menuModel.getFormName();
            $('input:hidden[name=parentMenuId]').val($("select[id=selectParentMenuId]").val());
        });



    });

    var areaModel = new AreaModel();
    areaModel.setRootUrl(String('${rootPath}'));
    areaModel.setPageRowNumber(10);
    areaModel.setPageIndex(0);
    // 최상위 부서 제거로 주석 @author kst
    //organizationModel.setRootOrgId("ORG00000-0000-0000-0000-000000000000");
//    $("#selectUpOrgSeq option:eq(0)").attr("value", organizationModel.getRootOrgId());
    var areaCtrl = new AreaCtrl(areaModel);

    /**
     * 구역 트리 생성
     */
    areaCtrl.findMenuTree();
    <%--alert(String('${organizationTreeList}'));--%>
</script>