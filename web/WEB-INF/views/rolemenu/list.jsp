<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00004" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="rolemenu.title.top"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <article class="tableplus">
        <article class="search_area" style="padding:10px 0">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <select id="roleId" class="w200" onchange="javascript:search(this);">
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.roleId}" ${paramBean.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                        </c:forEach>
                    </select>
                </p>
            </div>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle03" href="#" onclick="javascript:saveRoleMenu();">저장</button>
            </div>
        </article>

        <div>
            <!-- 미등록 메뉴 영역 Start -->
            <div>
                <div class="table_title_area"><h4><spring:message code="rolemenu.title.unregi"/></h4></div>
                <div id="unregiList" class="ul_t_defalut">
                    <c:choose>
                        <c:when test="${unregiMenuList != null and fn:length(unregiMenuList) > 0}">
                            <c:forEach var="unregiMenu" items="${unregiMenuList}">
                                <button menuId="${unregiMenu.menuId}" type="unregi" href="#" onclick="javascript:moveList(this);">${unregiMenu.menuName}</button>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <!-- 미등록 메뉴 영역 End -->

            <!-- 권한등록 메뉴 영역 Start -->
            <div class="">
                <div class="table_title_area"><h4><spring:message code="rolemenu.title.regi"/></h4></div>
                <div id="regiList" class="ul_t_defalut">
                    <c:choose>
                        <c:when test="${regiMenuList != null and fn:length(regiMenuList) > 0}">
                            <c:forEach var="regiMenu" items="${regiMenuList}">
                                <button menuId="${regiMenu.menuId}" type="regi" href="#" onclick="javascript:moveList(this);">${regiMenu.menuName}</button>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <!-- 권한등록 메뉴 영역 End -->
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var messageConfig = {
        saveConfirm  :'<spring:message code="common.message.saveConfirm"/>'
        ,saveFailure :'<spring:message code="rolemenu.message.saveFailure"/>'
        ,saveComplete:'<spring:message code="rolemenu.message.saveComplete"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/roleMenu/list.html'
        ,'saveUrl':"${rootPath}/roleMenu/save.json"
    };

    $(document).ready(function(){
    });

    function search(_this){
        var searchForm = $('<FORM>').attr('action',urlConfig['listUrl']).attr('method','POST');
        searchForm.append($('<INPUT>').attr('type','hidden').attr('name','roleId').attr('value',$(_this).find("option:selected").val()));
        document.body.appendChild(searchForm.get(0));
        searchForm.submit();
    }

    function moveList(_this){
        var _type = $(_this).attr("type");

        if(_type=="unregi"){
            $(_this).attr("type","regi");
            $("#regiList").append(_this);
        }else{
            $(_this).attr("type","unregi");
            $("#unregiList").append(_this);
        }
    }

    function saveRoleMenu(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        var menuIds = [];

        $.each($("#regiList button"),function(){
            menuIds.push($(this).attr("menuId"));
        });

        var _data = {
            'roleId' : $("#roleId option:selected").val()
            ,'menuIds' : menuIds.join(",")
        };

        callAjax('save', _data);
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
        alertMessage(actionType + 'Complete');
        switch(actionType){
            case 'save':
                break;
        }
    }

    /*
     ajax error handler
     @author kst
     */
    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author kst
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>