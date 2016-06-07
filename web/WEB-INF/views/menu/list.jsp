<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000001" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.menu"/></h3>
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
                <button class="btn btype01 bstyle01" onclick="javascript:menuCtrl.treeExpandAll(); return false;"><spring:message code='menu.button.viewTheFullMenu'/></button>
                <button class="btn btype01 bstyle01" onclick="javascript:menuCtrl.setAddBefore(); return false;" ><spring:message code='menu.button.addMenu'/></button>
            </div>
        </div>
        <div class="table_contents">
            <div id="menuTreeArea" class="tree_box"></div>
        </div>
    </article>
    <!-- 트리 영역 End -->

    <form id="menuForm" method="POST">
        <input type="hidden" name="parentMenuId" />
        <input type="hidden" name="roleIds" />

        <article class="table_area tr_table">
            <div class="table_title_area">
                <h4><spring:message code="menu.page.menuWritten"/></h4>
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
                            <th><spring:message code="menu.column.menuId"/></th>
                            <td>
                                <input type="text" name="menuId" value="" placeholder="<spring:message code="menu.message.requireMenuId"/>" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="menu.column.menuName"/></th>
                            <td class="point">
                                <input type="text" name="menuName" value="" placeholder="<spring:message code='menu.message.requiredMenuName'/>"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="menu.column.parentMenuName"/></th>
                            <td colspan="3">
                                <select id="selectParentMenuId">
                                    <c:forEach items="${menuTreeList }" var="menu">
                                        <option value="${menu.menuId }">${menu.description }</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="menu.column.linkUrl"/></th>
                            <td class="point" colspan="3">
                                <input type="text" name="menuUrl" value="" placeholder="<spring:message code="menu.message.requiredMenuUrl"/>"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="common.column.sortOrder"/></th>
                            <td class="point" colspan="3">
                                <input type="number" name="sortOrder" value="" placeholder="<spring:message code="menu.message.requiredSortOrder"/>"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="menu.column.useFlag"/></th>
                            <td class="point" colspan="3">
                                <span><input type="radio" name="useFlag" value="Y" /><spring:message code="common.column.useYes" /></span>
                                <span><input type="radio" name="useFlag" value="N" /><spring:message code="common.column.useNo" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="menu.column.menuType"/></th>
                            <td class="point" colspan="3">
                                <span><input type="radio" name="menuType" value="M" />M</span>
                                <span><input type="radio" name="menuType" value="P" />P</span>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td name="insertUserId"></td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td name="insertDatetime"></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td name="updateUser"></td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td name="updateDatetime"></td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <h4><spring:message code="menu.page.roleModifyPermissions"/></h4>
            </div>

            <div class="table_contents">
                <table name="roleListTable" class="t_defalut t_type01 t_style02">
                    <colgroup>
                        <col style="width: 10%;" />
                        <col style="width: 20%;" />
                        <col style="width: *;" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th><input id="selectAll" type="checkbox" class="checkbox" name="checkbox01" /></th>
                            <th><spring:message code="role.column.roleId"/></th>
                            <th><spring:message code="role.column.roleName"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${roles}" var="role">
                            <tr onclick="this.td">
                                <td><input type="checkbox" id="${role.roleId}" name="role_ids" class="checkbox" value="${role.roleId}"/></td>
                                <td><c:out value="${role.roleId }" /></td>
                                <td><c:out value="${role.roleName }" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
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
<%--<script src="${rootPath}/assets/js/page/menu/MenuModel.js" type="text/javascript" charset="UTF-8"></script>--%>
<%--<script src="${rootPath}/assets/js/page/menu/MenuCtrl.js" type="text/javascript" charset="UTF-8"></script>--%>
<%--<script src="${rootPath}/assets/js/page/menu/MenuView.js" type="text/javascript" charset="UTF-8"></script>--%>
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

        menuCtrl.findMenuTree();

    });
</script>