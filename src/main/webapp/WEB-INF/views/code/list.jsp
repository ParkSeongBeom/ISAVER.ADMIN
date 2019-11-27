<!-- 코드 관리 목록 -->
<!-- @author psb -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00020" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>
<script src="${rootPath}/assets/js/page/code/code-helper.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.code"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 트리 영역 Start -->
    <article class="table_area tree_table">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <button class="btn" onclick="javascript:codeHelper.getGroupCodeDetail(); return false;"><spring:message code='groupcode.button.addGroupCode'/></button>
                <button class="btn" onclick="javascript:codeHelper.getCodeDetail(); return false;"><spring:message code='code.button.addCode'/></button>
            </div>
        </div>
        <div class="table_contents">
            <div class="tree_tab_set">
                <ul class="area_tree_set on">
                    <li>
                        <button class="all_see_btn" onclick="javascript:allView(this); return false;" title="<spring:message code='resource.title.allView'/>"></button>
                        <ul id="codeList"></ul>
                    </li>
                </ul>
            </div>
        </div>
    </article>
    <!-- 트리 영역 End -->

    <!-- 테이블 입력 / 조회 영역 Start -->
    <article class="table_area tr_table type01">
        <div class="table_title_area">
            <h4><spring:message code='code.title.detail'/></h4>
        </div>

        <!-- 아무 선택이 없을 경우 코멘트 영역 Start-->
        <div detail class="ment on">
            <div>Click the after-view button</div>
        </div>
        <!-- 아무 선택이 없을 경우 코멘트 영역 End -->

        <!-- 그룹코드 상세 Start-->
        <div detail class="area_table groupCode_table">
            <form id="groupCodeForm" method="POST" onsubmit="return false;" class="form_type01">
                <div class="table_contents">
                    <!-- 입력 테이블 Start -->
                    <table class="t_defalut t_type02 groupcodedetail_col">
                        <colgroup>
                            <col>  <!-- 01 -->
                            <col>  <!-- 02 -->
                            <col>  <!-- 03 -->
                            <col>    <!-- 04 -->
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="point"><spring:message code="groupcode.column.groupCodeId"/></th>
                                <td class="point">
                                    <input type="text" name="groupCodeId" maxlength="3" placeholder="<spring:message code="groupcode.message.requireGroupCodeId"/>" />
                                </td>
                                <th class="point"><spring:message code="groupcode.column.groupName"/></th>
                                <td class="point">
                                    <input type="text" name="groupName" placeholder="<spring:message code="groupcode.message.requireGroupName"/>" />
                                </td>
                            </tr>
                            <tr modifyTag>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td name="insertUserName"></td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td name="insertDatetime"></td>
                            </tr>
                            <tr modifyTag>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td name="updateUserName"></td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td name="updateDatetime"></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- 입력 테이블 End -->
                </div>

                <div class="table_btn_set">
                    <button class="btn" name="addBtn" onclick="javascript:codeHelper.submit('groupCode','add'); return false;"><spring:message code="common.button.add"/></button>
                    <button class="btn" name="saveBtn" onclick="javascript:codeHelper.submit('groupCode','save'); return false;"><spring:message code="common.button.save"/></button>
                    <button class="btn" name="removeBtn" onclick="javascript:codeHelper.submit('groupCode','remove'); return false;"><spring:message code="common.button.remove"/></button>
                </div>
            </form>
        </div>
        <!-- 그룹코드 상세 End-->

        <!-- 코드 상세 Start-->
        <div detail class="area_table code_table">
            <form id="codeForm" method="POST" onsubmit="return false;" class="form_type01">
                <div class="table_contents">
                    <!-- 입력 테이블 Start -->
                    <table class="t_defalut t_type02 codedetail_col">
                        <colgroup>
                            <col>  <!-- 01 -->
                            <col>  <!-- 02 -->
                            <col>  <!-- 03 -->
                            <col>  <!-- 04 -->
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="point"><spring:message code="groupcode.column.groupCodeId"/></th>
                                <td class="point">
                                    <select name="groupCodeId"></select>
                                </td>
                                <th class="point"><spring:message code="code.column.codeName"/></th>
                                <td class="point">
                                    <input type="text" name="codeName" placeholder="<spring:message code="code.message.requireCodeName"/>" />
                                </td>
                            </tr>
                            <tr>
                                <th class="point"><spring:message code="code.column.codeId"/></th>
                                <td class="point">
                                    <input type="text" name="codeId" maxlength="6" placeholder="<spring:message code="code.message.requireCodeId"/>"/>
                                </td>
                                <th><spring:message code="common.column.codeDesc"/></th>
                                <td>
                                    <input type="text" name="codeDesc" />
                                </td>
                            </tr>
                            <tr>
                                <th class="point"><spring:message code="common.column.useYn"/></th>
                                <td class="point">
                                    <div class="checkbox_set csl_style03">
                                        <input type="hidden" name="useYn" value="N"/>
                                        <input type="checkbox" id="useYnCB"  onchange="setCheckBoxYn(this,'useYn')"/>
                                        <label></label>
                                    </div>
                                </td>
                                <th class="point"><spring:message code="common.column.sortOrder"/></th>
                                <td class="point">
                                    <input type="number" name="sortOrder" onkeypress="isNumber(this)"/>
                                </td>
                            </tr>
                            <tr modifyTag>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td name="insertUserName"></td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td name="insertDatetime"></td>
                            </tr>
                            <tr modifyTag>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td name="updateUserName"></td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td name="updateDatetime"></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- 입력 테이블 End -->
                </div>

                <div class="table_btn_set">
                    <button class="btn" name="addBtn" onclick="javascript:codeHelper.submit('code','add'); return false;"><spring:message code="common.button.add"/></button>
                    <button class="btn" name="saveBtn" onclick="javascript:codeHelper.submit('code','save'); return false;"><spring:message code="common.button.save"/></button>
                    <button class="btn" name="removeBtn" onclick="javascript:codeHelper.submit('code','remove'); return false;"><spring:message code="common.button.remove"/></button>
                </div>
            </form>
        </div>
        <!-- 코드 상세 End-->
    </article>
    <!-- 테이블 입력 / 조회 영역 End -->
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var codeHelper = new CodeHelper(String('${rootPath}'));

    var messageConfig = {
        // 공통
        addConfirmMessage:'<spring:message code="common.message.addConfirm"/>'
        ,saveConfirmMessage:'<spring:message code="common.message.saveConfirm"/>'
        ,removeConfirmMessage:'<spring:message code="common.message.removeConfirm"/>'
        // 그룹코드
        ,'addGroupCodeFailure':'<spring:message code="groupcode.message.addFailure"/>'
        ,'saveGroupCodeFailure':'<spring:message code="groupcode.message.saveFailure"/>'
        ,'removeGroupCodeFailure':'<spring:message code="groupcode.message.removeFailure"/>'
        ,'addGroupCodeComplete':'<spring:message code="groupcode.message.addComplete"/>'
        ,'saveGroupCodeComplete':'<spring:message code="groupcode.message.saveComplete"/>'
        ,'removeGroupCodeComplete':'<spring:message code="groupcode.message.removeComplete"/>'
        ,'groupCodeDetailFailure':'<spring:message code="groupcode.message.detailFailure"/>'
        ,'requireGroupCodeId':'<spring:message code="groupcode.message.requireGroupCodeId"/>'
        ,'lengthFailGroupCodeId':'<spring:message code="groupcode.message.lengthFailGroupCodeId"/>'
        ,'requireGroupName':'<spring:message code="groupcode.message.requireGroupName"/>'
        // 코드
        ,'addCodeFailure':'<spring:message code="code.message.addFailure"/>'
        ,'saveCodeFailure':'<spring:message code="code.message.saveFailure"/>'
        ,'removeCodeFailure':'<spring:message code="code.message.removeFailure"/>'
        ,'addCodeComplete':'<spring:message code="code.message.addComplete"/>'
        ,'saveCodeComplete':'<spring:message code="code.message.saveComplete"/>'
        ,'removeCodeComplete':'<spring:message code="code.message.removeComplete"/>'
        ,'codeDetailFailure':'<spring:message code="code.message.detailFailure"/>'
        ,'requireCodeId':'<spring:message code="code.message.requireCodeId"/>'
        ,'lengthFailCodeId':'<spring:message code="code.message.lengthFailCodeId"/>'
        ,'requireCodeName':'<spring:message code="code.message.requireCodeName"/>'
        ,'requireSortOrder':'<spring:message code="code.message.requireSortOrder"/>'
    };

    $(document).ready(function(){
        codeHelper.setMessageConfig(messageConfig);
        codeHelper.refreshList();
    });

    function allView(_this){
        $(_this).toggleClass("on");

        if($(_this).hasClass("on")){
            $(_this).parent().find("input[type='checkbox']").prop('checked', true);
        }else{
            $(_this).parent().find("input[type='checkbox']").prop('checked', false);
        }
    }
</script>