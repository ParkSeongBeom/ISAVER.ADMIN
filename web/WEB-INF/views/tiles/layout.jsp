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
<body class="admin_mode">
    <!-- wrap Start -->
    <div class="wrap">
        <!-- 사이트 맵 Start -->
        <%--<aside class="site_map">--%>
            <%--<div class="site_map_area"></div>--%>
        <%--</aside>--%>
        <!-- 사이트 맵 End -->

        <!-- hearder Start 고통부분 -->
        <header>
            <div class="header_area">
                <div class="top_logo_area">
                    <h1><button href="#" onclick="javascript:goHome();">i-Saver</button>
                    <%--<span id="log"></span>--%>
                    </h1>
                </div>
                <div class="ha_right_set">
                    <div class="hrs_date">
                        <span>05.20 FRI 10:31 AM</span>
                        <span>홍길동 과장</span>
                    </div>
                    <div class="hrs_btn_set">
                        <button class="on"></button>
                        <button></button>
                    </div>
                </div>
            </div>
        </header>
        <%--<header>--%>
    <%--<div class="header_area">--%>
    <%--<div class="top_logo_area">--%>
    <%--<h1><button href="#" onclick="javascript:goHome();">i-Saver</button>--%>
    <%--&lt;%&ndash;<span id="log"></span>&ndash;%&gt;--%>
    <%--</h1>--%>
    <%--</div>--%>


    <%--<div class="top_gnb_area">--%>
    <%--<div class="gnb_box">--%>
    <%--<div id="fx01" class="gnb_area">--%>
    <%--</div>--%>
    <%--<div class="lr_btn_set00">--%>
    <%--<button class="pre_btn prebt01">〈 </button>--%>
    <%--<button class="nex_btn nexbt01"> 〉</button>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div class="gnb_right_area">--%>
    <%--<!-- 사이트 맵 오픈 버튼 -->--%>
    <%--<button class="btn_sitemap"></button>--%>
    <%--<!-- 관리자 정보 / 로그 아웃 버튼 -->--%>
    <%--<a href="javascript:logout()" class="btn_logout fa">--%>
    <%--<span title="${sessionScope.authAdminInfo.name}(${sessionScope.authAdminInfo.adminId})">--%>
    <%--${sessionScope.authAdminInfo.name}(${sessionScope.authAdminInfo.adminId})--%>
    <%--</span>--%>
    <%--<span>님</span>--%>
    <%--</a>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--</header>--%>
        <!-- hearder End -->

        <nav class="nav">
            <!-- 관리자용  -->
            <div class="gnb_area"><!--id="fx01"-->
                <ul class="gnb">
                    <li name="" class="depth01">
                        <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/user/list.html'";>사용자관리</button>
                    </li>
                    <li name="" class="depth01">
                        <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/systemMenu/list.html'";>시스템관리</button>
                        <ul>
                            <li name="">
                                <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/systemMenu/list.html'";>메뉴관리</button>
                            </li>
                            <li name="">
                                <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/systemCode/list.html'";>코드관리</button>
                            </li>
                            <li name="">
                                <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/systemEvent/list.html'";>이벤트관리</button>
                            </li>
                            <li name="">
                                <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/systemMenuAuthority/list.html'";>메뉴권한관리</button>
                            </li>
                            <li name="">
                                <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/systemAuthority/list.html'";>권한관리</button>
                            </li>
                        </ul>
                    </li>

                    <li name="" class="depth01">
                        <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/eventManagement/list.html'";>이벤트조치관리</button>
                        <ul>
                            <li name="">
                                <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/eventManagement/list.html'";>이벤트관리</button>
                            </li>
                            <li name="">
                                <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/eventMeasure/list.html'";>조치관리</button>
                            </li>
                        </ul>
                    </li>

                    <li name="" class="depth01">
                        <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/areaMangement/list.html'";>감시구역관리</button>
                    </li>

                    <li name="" class="depth01">
                        <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/deviceMangement/list.html'";>장치관리</button>
                    </li>

                    <li name="" class="depth01">
                        <button onclick="location.href='http://172.16.120.215/safe/WEB-INF/views/licenseMangement/list.html'";>License 관리</button>
                    </li>
                </ul>
            </div>

            <!-- 메인, 대시보드, 이력, 통계용 -->
            <div class="nav_area">
                <ul class="lnb">
                    <li class="nl_dash on" name="" title="DashBoard">
                    <button>Dashboard</button>
                        <ul>
                        <li><button>All</button></li>
                        <li><button>A-Area</button></li>
                        <li><button>B-Area</button></li>
                        <li><button>C-Area</button></li>
                        <li><button>D-Area</button></li>
                        <li><button>E-Area</button></li>
                        <li><button>F-Area</button></li>
                        </ul>
                    </li>
                    <li class="nl_record" name="">
                        <button>이력</button>
                    </li>
                    <li class="nl_stat" name="">
                        <button>통계</button>
                    </li>
                </ul>
            </div>
        </nav>
        <tiles:insertAttribute name="body" />
    </div>
    <script type="application/javascript"></script>
</body>
</html>