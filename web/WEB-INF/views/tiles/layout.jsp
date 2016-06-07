<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="rootPath" value="${pageContext.servletContext.contextPath}" scope="application"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${pageContext.servletContext.contextPath}/assets/css/base.css" rel="stylesheet" type="text/css" />
    <!--[endif] -->
    <title>Japple Admin</title>
    <%-- dynatree, dhj --%>
    <link rel="stylesheet" type="text/css" href="${rootPath}/assets/css/dynatree/skin-vista/ui.dynatree.css" >
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

    <%-- dynatree, dhj --%>
    <script src="${rootPath}/assets/js/page/menu/MenuModel.js" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuCtrl.js" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuView.js" type="text/javascript" charset="UTF-8"></script>

    <!-- util -->
    <script type="text/javascript" src="${rootPath}/assets/js/util/consolelog-helper.js"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';

        var calendarHelper;
        var menuModel = new MenuModel();
        var menuCtrl = null;
        var targetMenuId = '';
        var subMenuId = '';

        function logout(){
            location.href = rootPath + '/logout.html';
        }

        function goHome(){
            location.href = rootPath + '/main.html';
        }

        $(document).ready(function(){
            calendarHelper = new CalendarHelper(rootPath);

            menuModel.setRootUrl(rootPath);
            menuModel.setViewStatus('detail');
            menuModel.setParentMenuId(subMenuId);

            menuCtrl = new MenuCtrl(menuModel);
            try {
                menuCtrl.findMenuTopBar(targetMenuId);
            } catch(e) {
                console.error(e);
            }

            $.each($("table.t_type01 > tbody > tr > td"),function(){
                $(this).attr("title",$(this).text().trim());
            });
        });


    </script>
</head>
<body>
    <!-- wrap Start -->
    <div class="wrap">
        <!-- 사이트 맵 Start -->
        <aside class="site_map">
            <div class="site_map_area"></div>
        </aside>
        <!-- 사이트 맵 End -->

        <!-- hearder Start 고통부분 -->
        <header>
            <div class="header_area">
                <div class="top_logo_area">
                    <h1><a href="#" onclick="javascript:goHome();">JAPPLE ADMIN</a>
                    <span id="log"></span></h1>
                </div>
                <div class="top_gnb_area">
                    <div class="gnb_box">
                        <div id="fx01" class="gnb_area">
                        </div>
                        <div class="lr_btn_set00">
                            <button class="pre_btn prebt01">〈 </button>
                            <button class="nex_btn nexbt01"> 〉</button>
                        </div>
                    </div>
                    <div class="gnb_right_area">
                        <!-- 사이트 맵 오픈 버튼 -->
                        <button class="btn_sitemap"></button>
                        <!-- 관리자 정보 / 로그 아웃 버튼 -->
                        <a href="javascript:logout()" class="btn_logout fa">
                            <span title="${sessionScope.authAdminInfo.name}(${sessionScope.authAdminInfo.adminId})">
                                ${sessionScope.authAdminInfo.name}(${sessionScope.authAdminInfo.adminId})
                            </span>
                            <span>님</span>
                        </a>
                    </div>
                </div>
            </div>
        </header>
        <!-- hearder End -->

        <nav class="nav"></nav>
        <tiles:insertAttribute name="body" />
    </div>
    <script type="application/javascript">

    </script>
</body>
</html>