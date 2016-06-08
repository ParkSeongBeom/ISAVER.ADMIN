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
    <title>iSaver Admin</title>
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
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
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
<body class="admin_mode adaptive_min">
<!-- wrap Start -->
<div class="wrap">
    <!-- hearder Start 고통부분 -->
    <header id="header">
        <div class="header_area">
            <h1><button>i-Saver</button></h1>
            <div class="ha_right_set">
                <div class="hrs_date">
                    <span>05.20 FRI 10:31 AM</span>
                    <span>${sessionScope.authAdminInfo.userName}</span>
                </div>
                <div class="hrs_btn_set">
                    <button></button>
                    <button href="#" onclick="javascript:logout();"></button>
                </div>
            </div>
        </div>
    </header>
    <!-- hearder End -->

    <nav id="nav" class="nav"><!-- 관리자용  -->

    </nav>

    <nav id="nav" class="nav"><!-- 관리자용  -->
        <div class="gnb_area"></div>

        <!-- 메인, 대시보드, 이력, 통계용 -->
        <div class="nav_area">
            <ul class="lnb">
                <li class="on" name="">
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
<script type="application/javascript">

</script>
</body>
</html>