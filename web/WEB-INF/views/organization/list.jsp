<%--
  Created by IntelliJ IDEA.
  User: dhj
  Date: 2014. 6. 7.
  Time: 오후 10:09
  부서관리
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-B000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-B000-0000-0000-000000000002" var="menuId"/>

<jabber:pageRoleCheck menuId="${menuId}" />

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.department"/></h3>
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
                <button class="btn btype01 bstyle01" onclick="javascript:organizationCtrl.treeExpandAll(); return false;"><spring:message code='organization.button.viewTheFullOrganization'/></button>
                <button class="btn btype01 bstyle01" onclick="javascript:organizationCtrl.setAddBefore(); return false;" ><spring:message code='organization.button.addOrganization'/></button>
            </div>
        </div>
        <div class="table_contents">
            <div id="menuTreeArea" class="tree_box"></div>
        </div>
    </article>
    <!-- 트리 영역 End -->

    <form id="menuForm" method="POST">
        <input type="hidden" name="depth" />
        <input type="hidden" name="upOrgId" />
        <input type="hidden" name="roleIds" />
        <input type="hidden" name="pageNumber"/>

        <article class="table_area tr_table">
            <div class="table_title_area">
                <h4><spring:message code="organization.page.codeWritten"/></h4>
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
                            <th><spring:message code="organization.column.orgId"/></th>
                            <td>
                                <input type="text" name="orgId" value="" placeholder="<spring:message code="organization.message.requireOrganizationId"/>" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="organization.column.orgName"/></th>
                            <td class="point">
                                <input type="text" name="orgName" value="" placeholder="<spring:message code='organization.message.requiredOrgName'/>" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="organization.column.upOrgPath"/></th>
                            <td colspan="3">
                                <select id="selectUpOrgSeq">
                                    <option value="" depth="0">HOME</option>
                                    <c:forEach items="${organizationList }" var="org">
                                        <option value="${org.orgId }" depth="${org.depth}">${org.path }</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr name="orgSortTr">
                            <th class="point"><spring:message code="common.column.sortOrder"/></th>
                            <td class="point" colspan="3">
                                <input type="number" name="sortOrder" value="" title="<spring:message code="common.column.sortOrder"/>"/>
                            </td>
                        </tr>
                        <tr name="orgDateTr">
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td name="insertUserId"></td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td name="insertDatetime"></td>
                        </tr>
                        <tr name="orgDateTr">
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td name="updateUser"></td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td name="updateDatetime"></td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area" name="showHideTag">
                <h4><spring:message code="organization.column.orgUserSortOrder"/></h4>
            </div>

            <article class="search_area" name="showHideTag">
                <div class="search_contents">
                    <!-- 일반 input 폼 공통 -->
                    <p class="itype_01">
                        <span><spring:message code="user.column.userId" /></span>
                        <span>
                            <input type="text" name="userId" value=""/>
                        </span>
                    </p>
                    <p class="itype_01">
                        <span><spring:message code="user.column.userName" /></span>
                        <span>
                            <input type="text" name="userName" value=""/>
                        </span>
                    </p>
                </div>
                <div class="search_btn">
                    <button onclick="javascript:organizationCtrl.searchOrgUser(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
                </div>
            </article>

            <div class="table_title_area" name="showHideTag">
                <%--<h4></h4>--%>
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:organizationCtrl.openPopupUserPage(); return false;"><spring:message code="organization.button.addUser"/> </button>
                    <button class="btn btype01 bstyle03" onclick="javascript:organizationCtrl.removeOrgUsers()(); return false;"><spring:message code="organization.button.removeUser"/> </button>
                </div>
            </div>

            <div class="table_contents" id="roleListTable" name="showHideTag">
                <table name="roleListTable" class="t_defalut t_type01 t_style02">
                    <colgroup>
                        <col style="width: 10%;" />
                        <col style="width: 25%;" />
                        <col style="width: *;" />
                        <col style="width: 15%;" />
                        <col style="width: 10%;" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th><input id="selectAll" type="checkbox" class="checkbox" name="checkbox01" /></th>
                            <th><spring:message code="user.column.userId"/></th>
                            <th><spring:message code="user.column.userName"/></th>
                            <th><spring:message code="user.column.classification"/></th>
                            <th><spring:message code="common.column.sortOrder"/></th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>

                <!-- 테이블 공통 페이징 Start -->
                <div id="pageContainer" class="page" ></div>
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <button name="addBtn" class="btn btype01 bstyle03" onclick="javascript:organizationCtrl.addOrganizationVaild(); return false;"><spring:message code="common.button.add"/></button>
                    <button name="saveBtn" class="btn btype01 bstyle03" onclick="javascript:organizationCtrl.saveOrganizationVaild(); return false;"><spring:message code="common.button.save"/></button>
                    <button name="removeBtn" class="btn btype01 bstyle03" onclick="javascript:organizationCtrl.removeOrganizationVaild(); return false;"><spring:message code="common.button.remove"/></button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
        <!-- END : contents -->
    </form>
</section>

<!-- END : contents -->
<script src="${rootPath}/assets/js/common/dynatree/jquery.dynatree.js"     type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/util/ajax-util.js"                      type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/util/page-navigater.js"                 type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/organization/OrganizationModel.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/organization/OrganizationCtrl.js"  type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/organization/OrganizationView.js"  type="text/javascript" charset="UTF-8"></script>

<script type="application/javascript" charset="utf-8">

    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var messageConfig = {
        menuTreeFailure                 : '<spring:message code="organization.message.menuTreeFailure"/>'
        ,   detailFailure                   : '<spring:message code="organization.message.detailFailure"/>'
        ,   addFailure                      : '<spring:message code="organization.message.addFailure"/>'
        ,   saveFailure                     : '<spring:message code="organization.message.saveFailure"/>'
        ,   removeFailure                   : '<spring:message code="organization.message.removeFailure"/>'
        ,   orgUserRemoveFailure            : '<spring:message code="organization.message.removeFailure"/>'
        ,   addComplete                     : '<spring:message code="organization.message.addComplete"/>'
        ,   saveComplete                    : '<spring:message code="organization.message.saveComplete"/>'
        ,   removeComplete                  : '<spring:message code="organization.message.removeComplete"/>'
        ,   orgUserRemoveComplete           : '<spring:message code="organization.message.orgUserRemoveComplete"/>'
        ,   orgUserRemovesComplete           : '<spring:message code="organization.message.orgUserRemoveComplete"/>'
        ,   addConfirmMessage               : '<spring:message code="common.message.addConfirm"/>'
        ,   saveConfirmMessage              : '<spring:message code="common.message.saveConfirm"/>'
        ,   removeConfirmMessage            : '<spring:message code="organization.message.removeConfirm"/>'
        ,   removeUserConfirmMessage        : '<spring:message code="organization.message.removeUserConfirm"/>'
        ,   removeUserValidationErrorMessage: '<spring:message code="organization.message.removeUserValidationError"/>'
        ,   requiredOrgName                 : '<spring:message code="organization.message.requiredOrgName"/>'
        ,   requiredSortOrder               : '<spring:message code="organization.message.requiredSortOrder"/>'
        ,   regexpDigits                    : '<spring:message code="menu.message.regexpDigits"/>'
        ,   regexpUrl                       : '<spring:message code="menu.message.regexpUrl"/>'
        ,   pleaseChooseOrganization        : '<spring:message code="organization.message.pleaseChooseOrganization"/>'
        ,   organizationNotDeleted          : '<spring:message code="organization.message.organizationNotDeleted"/>'
        ,   requireChooseAnotherDepartment  : '<spring:message code="organization.message.requireChooseAnotherDepartment"/>'
    };

    var pageConfig = {
        pageSize : String('${paramBean.pageRowNumber}')
        , pageNumber : String('${paramBean.pageNumber}')
        , totalCount : String('${paramBean.totalCount}')
    };

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
        organizationModel.setPageIndex(pageNumber);
        organizationCtrl.searchOrgUser();
    }

    $(document).ready(function(){
        <%--$("#" + organizationModel.getFormName()).validate({--%>
        <%--rules: {--%>
        <%--orgName: { required: true },--%>
        <%--orgSort: { required: true, digits : true }--%>
        <%--},--%>
        <%--messages: {--%>
        <%--orgName: {--%>
        <%--required: messageConfig.requiredOrgName--%>
        <%--},--%>
        <%--orgSort: {--%>
        <%--required: messageConfig.requiredSortOrder,--%>
        <%--digits : messageConfig.regexpDigits--%>
        <%--}--%>

        <%--},--%>
        <%--submitHandler: function (frm) {--%>
        <%--var orgName = document.forms[organizationModel.getFormName()]['orgName'].value;--%>
        <%--switch(organizationModel.getViewStatus()) {--%>
        <%--case OrganizationModel().model.ACTION.ADD:--%>

        <%--var msgText = '<spring:message code="common.message.addConfirm"/>';--%>
        <%--if(!confirm(sprintf('[ %s ] %s', orgName, msgText))) return;--%>
        <%--organizationCtrl.addOrganization();--%>
        <%--break;--%>
        <%--case OrganizationModel().model.ACTION.SAVE:--%>
        <%--var msgText = '<spring:message code="common.message.saveConfirm"/>';--%>
        <%--if(!confirm(sprintf("[ %s ] %s", orgName, msgText))) return;--%>
        <%--organizationCtrl.saveOrganization();--%>
        <%--break;--%>
        <%--default:--%>
        <%--alert(organizationModel.getViewStatus());--%>
        <%--break;--%>
        <%--}--%>
        <%--}--%>
        <%--});--%>

        /**
         * 조직도 - 인원 검색
         */
        $("input[name='userId']").add("input[name='userName']").keyup(function(e) {
            if (e.keyCode == 13)  {
                organizationCtrl.searchOrgUser();
            }
        });

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

        $( "#selectUpOrgSeq" ).change(function() {
            $('input:hidden[name=upOrgId]').val($("select[id=selectUpOrgSeq]").val());

            var orgDepthTemp = 0;
            if (organizationCtrl._model.getViewStatus() == "detail") {
                orgDepthTemp = Number($("#selectUpOrgSeq option:selected").attr("depth"));
                orgDepthTemp++;
            }
            $('input:hidden[name=depth]').val(orgDepthTemp);
        });

        /* 숫자 입력만 허용 */
        $("input[name='sortOrder']").keypress(function(event) {
            return (/\d/.test(String.fromCharCode(event.which) ))
        });
    });

    var organizationModel = new OrganizationModel();
    organizationModel.setRootUrl(String('${rootPath}'));
    organizationModel.setPageRowNumber(10);
    organizationModel.setPageIndex(0);
    // 최상위 부서 제거로 주석 @author kst
    //organizationModel.setRootOrgId("ORG00000-0000-0000-0000-000000000000");
    $("#selectUpOrgSeq option:eq(0)").attr("value", organizationModel.getRootOrgId());
    var organizationCtrl = new OrganizationCtrl(organizationModel);

    /**
     * 조직도 트리 생성
     */
    organizationCtrl.findMenuTree();
    <%--alert(String('${organizationTreeList}'));--%>

</script>