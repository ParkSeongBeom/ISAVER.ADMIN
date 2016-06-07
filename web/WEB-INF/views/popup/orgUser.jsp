<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-B000-0000-0000-000000000002" var="menuId"/>

<jabber:pageRoleCheck menuId="${menuId}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${pageContext.servletContext.contextPath}/assets/css/base.css" rel="stylesheet" type="text/css" />
    <!--[if lt IE 9] -->
    <script src="${pageContext.servletContext.contextPath}/assets/js/util/html5.js"></script>
    <!--[endif] -->
    <title>Jabber Admin</title>
    <%-- dynatree, dhj --%>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.autosize.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.event.drag-1.5.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.touchSlider.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/calendar-helper.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui.custom.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.mCustomScrollbar.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/design.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/default.js"></script>
    <%-- dynatree, dhj --%>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.cookie.js"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';
    </script>

    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
</head>
<body>

<div class="window_wrap">
    <section class="container sub_area">
        <!-- 2depth 타이틀 영역 Start -->
        <article class="sub_title_area">
            <!-- 2depth 타이틀 Start-->
            <h3 class="1depth_title"><spring:message code="organization.title.addUser"/></h3>
            <!-- 2depth 타이틀 End -->
            <div class="navigation">
                <span><jabber:menu menuId="${menuId}" /></span>
            </div>
        </article>
        <!-- 2depth 타이틀 영역 End -->

        <form id="userForm" method="POST">
            <input type="hidden" name="pageNumber"/>
            <input type="hidden" name="id" value="${paramBean.id}" />
            <input type="hidden" name="upOrgId" />
            <input type="hidden" name="roleIds" />

            <article class="search_area">
                <div class="search_contents">
                    <!-- 일반 input 폼 공통 -->
                    <p class="itype_01">
                        <span><spring:message code="organization.title.orgPath" /></span>
                        <span>
                            <select id="selectUpOrgSeq">
                                <c:forEach items="${organizationList }" var="org">
                                    <option value="${org.orgId }">${org.path }</option>
                                </c:forEach>
                            </select>
                        </span>
                    </p>
                    <p class="itype_01">
                        <span><spring:message code="user.column.userId" /></span>
                        <span>
                            <input type="text" name="userId" value="${paramBean.userId}"/>
                        </span>
                    </p>
                    <p class="itype_01">
                        <span><spring:message code="user.column.userName" /></span>
                        <span>
                            <input type="text" name="name" value="${paramBean.name}"/>
                        </span>
                    </p>
                </div>
                <div class="search_btn">
                    <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
                </div>
            </article>
        </form>

        <article class="table_area">
            <div class="table_title_area">
                <h4></h4>
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:addOrgUser(); return false;"><spring:message code="common.button.add"/> </button>
                </div>
            </div>

            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table name="roleListTable" class="t_defalut t_type01 t_style02">
                    <colgroup>
                        <col style="width: 7%;" />
                        <col style="width: 15%;" />
                        <col style="width: 15%;" />
                        <col style="width: *%;" />
                        <col style="width: 15%;" />
                        <col style="width: 15%;" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th><input id="selectAll" type="checkbox" class="checkbox" name="checkbox01" /></th>
                            <th><spring:message code="user.column.userId"/></th>
                            <th><spring:message code="user.column.classification"/></th>
                            <th><spring:message code="user.column.userName"/></th>
                            <th><spring:message code="user.column.extension"/></th>
                            <th><spring:message code="user.column.mobile"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${users != null and fn:length(users) > 0}">
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>
                                            <c:if test="${user.orguserexist == '-1'}">
                                                <input type="checkbox" />
                                                <input type="hidden" name="userId" value="${user.userid}" />
                                                <input type="hidden" name="classification" value="${user.classification}" />
                                            </c:if>
                                        </td>
                                        <td>${user.userid}</td>
                                        <td>${user.classification}</td>
                                        <td>${user.username}</td>
                                        <td>${user.extension}</td>
                                        <td>${user.mobile}</td>
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

                <!-- 테이블 공통 페이징 Start -->
                <div id="pageContainer" class="page" />
            </div>
        </article>
    </section>
    <!-- section End -->
</div>

</body>

<script type="text/javascript">

    var rootPath = '${rootPath}';
    var targetMenuId = String('${menuId}');
    var form = $('#userForm');

    var urlConfig = {
        listUrl : '${rootPath}/organization/detailUserPopup.html',
        addUrl : '${rootPath}/orgUser/add.json'
    };

    var pageConfig = {
        'pageSize':${paramBean.pageRowNumber}
        ,'pageNumber':${paramBean.pageNumber}
        ,'totalCount':${paramBean.totalCount}
    };

    /*
     message define
     @author dhj
     */
    var messageConfig = {
        'addConfirm'            :'<spring:message code="user.message.addConfirm"/>'
        ,'saveConfirm'          :'<spring:message code="user.message.saveConfirm"/>'
        ,'removeConfirm'        :'<spring:message code="user.message.removeConfirm"/>'
        ,'addFailure'           :'<spring:message code="user.message.addFailure"/>'
        ,'saveFailure'          :'<spring:message code="user.message.saveFailure"/>'
        ,'removeFailure'        :'<spring:message code="user.message.removeFailure"/>'
        ,'addComplete'          :'<spring:message code="user.message.addComplete"/>'
        ,'saveComplete'         :'<spring:message code="user.message.saveComplete"/>'
        ,'removeComplete'       :'<spring:message code="user.message.removeComplete"/>'
    };

    /**
     * 부모 페이지 새로 고침
     */
    function refreshParent() {
        window.onunload = refreshParent;
        var loc = window.opener.location;
        window.opener.location = loc;
//        window.opener.location.reload();
    }

    /*
     페이지 네이게이터를 그린다.
     @author dhj
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
     @author dhj
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }

    /*
     조회
     @author dhj
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     add method
     @author dhj
     */
    function addOrgUser(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }
        var roleIds = new Array();

        var orgUserLists = [];
        $("input[name='roleIds']").val("");
        var orgId = $("select[id=selectUpOrgSeq]").val();
        $("table[name='roleListTable'] tbody tr").each(function () {
            if ($(this).find('input:checkbox').is(':checked')) {
                this.orgUser = {
                    orgId  : orgId,
                    userId : $(this).find("input[name='userId']").val()
                    ,classification : $(this).find("input[name='classification']").val()
                };

                orgUserLists.push(this.orgUser);
            }

        });

        if (orgUserLists.length > 0 ){
            $("input[name='roleIds']").val(JSON.stringify(orgUserLists));
        }

        callAjax('add', form);
    }

    /*
     ajax call
     @author dhj
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'], $(form).serialize(), requestOrgUser_successHandler,requestOrgUser_errorHandler,actionType);
    }

    /*
     ajax success handler
     @author dhj
     */
    function requestOrgUser_successHandler(data, dataType, actionType){
        alertMessage(actionType + 'Complete');
        switch(actionType){
            case 'save':
                break;
            case 'add':
            case 'remove':
                refreshParent();
                search();
                break;
        }
    }

    /*
     ajax error handler
     @author dhj
     */
    function requestOrgUser_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    $(document).ready(function(){
        $( "#selectUpOrgSeq" ).change(function() {
            $('input:hidden[name=id]').val($("select[id=selectUpOrgSeq]").val());
            search();
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
        $( "#selectUpOrgSeq").val("${paramBean.id}");
        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);
    });

</script>
</html>