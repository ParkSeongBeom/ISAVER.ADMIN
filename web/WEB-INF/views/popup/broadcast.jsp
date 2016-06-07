<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
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
            <h3 class="1depth_title"><spring:message code="common.title.broadcastUserList"/></h3>
            <!-- 2depth 타이틀 End -->
            <%--<div class="navigation">--%>
            <%--<span><jabber:menu menuId="${menuId}" /></span>--%>
            <%--</div>--%>
        </article>
        <!-- 2depth 타이틀 영역 End -->

        <form id="userForm" method="POST">
            <input type="hidden" name="pageNumber"/>

            <article class="search_area">
                <div class="search_contents">
                    <!-- 일반 input 폼 공통 -->
                    <p class="itype_01">
                        <span><spring:message code="user.column.userId" /></span>
                        <span>
                            <input type="text" name="id" value="${paramBean.id}"/>
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
                    <jabber:codeSelectBox groupCodeId="C009" htmlTagId="gubn"/>
                    <button class="btn btype01 bstyle03" onclick="javascript:addTarget(); return false;"><spring:message code="common.button.add"/> </button>
                </div>
            </div>

            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table id="groupTb" class="t_defalut t_type01 t_style02">
                    <colgroup>
                        <col style="width: 10%;" />
                        <col style="width: 25%;" />
                        <col style="width: 30%;" />
                        <col style="width: 20%;" />
                        <col style="width: 15%;" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="mainCheck"></th>
                            <th><spring:message code="user.column.userId"/></th>
                            <th><spring:message code="organization.column.orgName"/></th>
                            <th><spring:message code="user.column.userName"/></th>
                            <th><spring:message code="user.column.classification"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${users != null and fn:length(users) > 0}">
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td><input type="checkbox" name="subCheck"></td>
                                        <td>${user.userId}</td>
                                        <td>${user.orgName}</td>
                                        <td>${user.userName}</td>
                                        <td>${user.classification}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5"><spring:message code="common.message.emptyData"/></td>
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
    var form = $('#userForm');

    var urlConfig = {
        'listUrl':'${rootPath}/broadcast/popup.html'
    };

    var pageConfig = {
        'pageSize':${paramBean.pageRowNumber}
        ,'pageNumber':${paramBean.pageNumber}
        ,'totalCount':${paramBean.totalCount}
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);
    });

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

    /*
     조회
     @author kst
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     대상추가
     @author psb
     */
    function addTarget(){
        var broadCheck = $("#groupTb input[name=subCheck]:checked");
        var gubn = $("#gubn option:selected").val();

        opener.$("#emptyTr").remove();

        for (var i = 0; i < broadCheck.length; i++) {
            var data = broadCheck[i].parentNode.parentNode;

            var userId = $(data).find('td:eq(1)').text();
            var orgName = $(data).find('td:eq(2)').text();
            var userName = $(data).find('td:eq(3)').text();
            var classification = $(data).find('td:eq(4)').text();

            var result = opener.addTarget(gubn, userId, orgName, userName, classification);

            if(result!=null){
                alert(result);
                break;
            }
        }
    }

    $(document).ready(function(){
        $('#mainCheck').click(function(){
            if($(this).is(':checked')){
                $("#groupTb input[name=subCheck]").prop("checked",true);
            }else{
                $("#groupTb input[name=subCheck]").prop("checked",false);
            }
        });
    });
</script>
</html>