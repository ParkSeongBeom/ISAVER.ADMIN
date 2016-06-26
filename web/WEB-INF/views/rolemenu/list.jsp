<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00040" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />

<section class="container">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title">메뉴 권한 관리</h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span>Dashboard 〉 시스템 관리 〉메뉴 권한 관리</span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <article class="table_area">
        <form id="userForm" method="POST">
            <input type="hidden" name="pageNumber">
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
        </form>
        <ul class="menu_tree_set">
            <li style="display: none;">
                <button>All</button>
                <ul>
                    <li><button>DashBoard</button></li> <!-- 01 depth  -->
                    <li>
                        <button>통계현황</button>
                        <ul> <!-- 02 depth  -->
                            <li><button>이벤트 이력관리</button></li>
                            <li>
                                <button>로그인 이력관리</button>
                                <ul> <!-- 03 depth  -->
                                    <li><button>ex 03</button></li>
                                    <li>
                                        <button>ex 03</button>
                                        <ul> <!-- 04 depth  -->
                                            <li>
                                                <button>ex 04</button>
                                                <ul> <!-- 05 depth  -->
                                                    <li><button>ex 05</button></li>
                                                    <li><button>ex 05</button></li>
                                                    <li><button>ex 05</button></li>
                                                </ul>
                                            </li>
                                            <li><button>ex 04</button></li>
                                            <li><button>ex 04</button></li>
                                        </ul>
                                    </li>
                                    <li><button>ex 03</button></li>
                                </ul>
                            </li>
                            <li><button>ex 02</button></li>
                        </ul>
                    </li>
                    <li>
                        <button>시스템 관리</button>
                        <ul> <!-- 02 depth  -->
                            <li><button>코드 관리</button></li>
                            <li><button>메뉴 관리</button></li>
                            <li><button>권한 관리</button></li>
                            <li><button>메뉴권한 관리</button></li>
                            <li><button>이벤트 관리</button></li>
                        </ul>
                    </li><!-- 01 depth  -->
                    <li><button>사용자 관리</button></li><!-- 01 depth  -->
                    <li><button>조치 관리</button></li><!-- 01 depth  -->
                    <li><button>구역 관리</button></li><!-- 01 depth  -->
                    <li><button>장치 관리</button></li><!-- 01 depth  -->
                    <li><button>라이센스 관리</button></li><!-- 01 depth  -->
                </ul>
            </li> <!-- 01 depth  -->
        </ul>
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

        menuLoadFunc();
    });

    /**
     * 메뉴 권한 리스트 호출
     */
    function menuLoadFunc() {
        var data = {
            roleId : $("#roleId option:selected").val()
        };

        var actionType = "list";

        sendAjaxPostRequest(urlConfig[actionType + 'Url'], data, requestRoleMenu_successHandler, requestRoleMenu_errorHandler,actionType);
    }

    /**
     * 메뉴 권한 그리기
     */
    function drawMenuFunc(data) {

        var menuTreeTag = $(".table_area .menu_tree_set");
        menuTreeTag.empty();

        if (data['menuTreeList'] == null && data['menuTreeList'].length == 0) {
            return;
        }

        for (var i=0; i < data['menuTreeList'].length; i++) {
            var menu =  data['menuTreeList'][i];

            var menuDepth = menu['menuDepth'];
            var menuName = menu['menuName'];
            var menuId = menu['menuId'];
            var parentMenuId = menu['parentMenuId'];
            switch(Number(menuDepth)) {
                case 0:
                    menuTreeTag.append($("<li depth='0'><button id='allButton'>All</button></li>"));
                    break;
                case 1:
                    menuDepth --;

                    var searchTag = menuTreeTag.find("li[depth="+menuDepth+"] > ul");
                    if (searchTag.length == 0) {
                        var _tag = $("<ul></ul>").append($("<li menu_id="+menuId+"><button menu_id="+menuId+">" + menuName + "</button></li>"));
                        menuTreeTag.find("li[depth="+menuDepth+"]").append(_tag);
                    } else {
                        var _tag = $("<li menu_id='"+menuId+"'><button menu_id="+menuId+">" +  menuName +"</button></li>");
                        menuTreeTag.find("li[depth="+menuDepth+"] > ul ").append(_tag);
                    }
                    break;
                default :

                    var searchTag = menuTreeTag.find("li[menu_id="+parentMenuId+"] > ul");

                    if (searchTag.length == 0) {
                        var _tag = $("<ul></ul>").append($("<li menu_id="+menuId+"><button menu_id="+menuId+">" + menuName + "</button></li>"));
                        menuTreeTag.find("li[menu_id="+parentMenuId+"]").append(_tag);
                    } else {
                        var _tag = $("<li menu_id='"+menuId+"'><button menu_id="+menuId+">" +  menuName +"</button></li>");
                        menuTreeTag.find("li[menu_id="+parentMenuId+"] > ul ").append(_tag);
                    }
                    break;

            }

        }

        var treeBtn = $(".menu_tree_set > li button");
        var treeBtnAll = $(".menu_tree_set > li > button");

//        treeBtn.on('click', function () {
//            $(this).toggleClass("on");

//            var treeBtnAll_on = $(".menu_tree_set > li > button").hasClass("on");
//            if(treeBtnAll_on) {
//                treeBtnAll.on('click', function () {
//                    treeBtn.removeClass("on");
//                });
//            } else {
//                treeBtnAll.on('click', function () {
//                    treeBtn.addClass("on");
//                });
//            }
//        });

        var treeBtnAll = $(".menu_tree_set #allButton");

        /* All button */
        treeBtnAll.on("click", function() {
            if (treeBtnAll.hasClass("on")) {
                $(".menu_tree_set button").removeAttr("class")
            } else {
                $(".menu_tree_set button").removeAttr("class").attr("class", "on");
            }
        });

        /* All button를 제외한 나머지 버튼  */
        $(".menu_tree_set Button").not("#allButton").on("click", function() {

            if ($(this).hasClass("on")) {
                $(this).parent().find("ul button").removeAttr("class");
                $(this).removeAttr("class");
            } else {
                $(this).parent().find("ul button").removeAttr("class").attr("class", "on");
                $(this).attr("class", "on");
            }

            var menuId = $(this).attr("menu_id");
            $(this).parents("li").children("button").not("#allButton").not("button[menu_id=" +menuId + "]").attr("class", "on");

        });

        drawRoleMenu(data);
    }

    /**
     * 메뉴 권한 체크 하기
     */
    function drawRoleMenu(data) {

        if (data['regiMenuList'] == null && data['regiMenuList'].length == 0) {
            return;
        }

        var menuTreeTag = $(".table_area .menu_tree_set");

        for (var i =0;i < data['regiMenuList'].length; i++) {
            var menu =  data['regiMenuList'][i];

            var menuId = menu['menuId'];
            menuTreeTag.find("li[menu_id="+menuId+"] > button ").addClass("on");
        }

        if (data['regiMenuList'].length > menuTreeTag.find("li[menu_id]").length) {
            menuTreeTag.find("button[id='allButton']").addClass("on");
        }

    }
    /*
     ajax success handler
     @author kst
     */
    function requestRoleMenu_successHandler(data, dataType, actionType){

        switch(actionType){
            case 'list':
                drawMenuFunc(data);
                break;
        }
    }

    /*
     ajax error handler
     @author kst
     */
    function requestRoleMenu_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }



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

    /**
     * 메뉴 권한 저장
     */
    function saveRoleMenu(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        var menuIds = [];

        $.each($("li[menu_id] > button[class=on]"), function() {

            var menuId = $(this).attr("menu_id")
            menuIds.push(menuId);
        });

        var _data = {
            'roleId' : $("#roleId option:selected").val()
            ,'menuIds' : menuIds.join(",")
        };

        callAjax('save', _data);
    }


    function saveRoleMenu_backup(){
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