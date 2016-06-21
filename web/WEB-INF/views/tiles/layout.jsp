<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
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
    <script type="text/javascript" src="${rootPath}/assets/js/util/jquery.nanoscroller.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/dashboard/dashBoard-helper.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/template/template-helper.js"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';
        var calendarHelper = new CalendarHelper(rootPath);
        var menuModel = new MenuModel();
        var menuCtrl = null;
        var dashBoardHelper = new DashBoardHelper();
        var templateHelper = new TemplateHelper();

        var dashBoardUrlConfig = {
            'listUrl':'${rootPath}/eventLog/alram.html'
            ,'detailUrl':'${rootPath}/dashboard/detail.html'
        };

        $(document).ready(function(){
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

            bodyAddClass();
            printTime();

            dashBoardHelper.addRequestData('alram', dashBoardUrlConfig['listUrl'], null, alramSuccessHandler, alramFailureHandler);
            dashBoardHelper.startInterval();
            aliveSend(900000);
        });

        /**
         * [인터벌] alive send
         * @author psb
         */
        function aliveSend(_time) {
            setInterval(function() {
                $.get('${rootPath}/alive.json', function() {
                }).done(function() {
                }).fail(function() {
                    console.log("[aliveSend][error]");
                }).always(function() {
                });
            }, _time);
        }
    </script>
</head>
<body>
<!-- wrap Start -->
<div class="wrap">
    <!-- hearder Start 고통부분 -->
    <header id="header">
        <div class="header_area">
            <h1><button></button></h1>
            <div class="ha_right_set">
                <div class="hrs_date">
                    <span id="nowTime"></span>
                    <span>${sessionScope.authAdminInfo.userName}</span>
                </div>
                <div class="hrs_btn_set">
                    <button class="db_btn issue_btn" onclick="javascript:alramShowHide('list', 'show');"></button>
                    <button class="db_btn loginout_btn" href="#" onclick="javascript:logout();"></button>
                </div>
            </div>
        </div>
        <button class="db_btn zoom_btn change_btn" href="#" onclick="javascript:allView(this);"></button>
    </header>
    <!-- hearder End -->

    <!-- navigation 영역 Start -->
    <nav id="nav" class="nav">
        <div class="nav_area nano"></div>
    </nav>
    <!-- navigation 영역 End -->

    <!-- 알림목록 영역 Start -->
    <aside class="db_area">
        <div class="db_header">
            <div>
                <h3><spring:message code="dashboard.title.alramCenter"/></h3>
                <button class="btn btype03 bstyle07" href="#" onclick=""><spring:message code="dashboard.title.alramCancel"/></button>
            </div>
            <div>
                <div class="check_box_set">
                    <input type="checkbox"  name="" class="check_input" />
                    <label class="lablebase lb_style01"></label>
                </div>
                <select id="eventType">
                    <option value="">전체</option>
                    <option value="crane"><spring:message code="dashboard.selectbox.crane"/></option>
                    <option value="worker"><spring:message code="dashboard.selectbox.worker"/></option>
                    <option value="inout"><spring:message code="dashboard.selectbox.inout"/></option>
                </select>
                <isaver:areaSelectBox htmlTagId="areaType" allModel="true"/>
            </div>
        </div>
        <div class="db_contents nano">
            <ul class="nano-content" id="alramList"></ul>
        </div>
        <div class="db_bottom">
            <button href="#" onclick="alramShowHide('list', 'hide');"><spring:message code="common.button.close"/></button>
        </div>
    </aside>
    <!-- 알림목록 영역 End -->

    <!-- 알림상세 영역 Start -->
    <aside class="dbs_area">
        <div class="db_header">
            <div><h3><spring:message code="dashboard.title.action"/></h3></div>
            <div><p id="alramEvent"></p></div>
        </div>
        <div class="db_contents nano">
            <div class="nano-content text_area" id="alramActionDesc"></div>
        </div>
        <div class="db_bottom">
            <button href="#" onclick="alramShowHide('detail', 'hide');"><spring:message code="common.button.close"/></button>
        </div>
    </aside>
    <!-- 알림상세 영역 End -->

    <tiles:insertAttribute name="body" />
</div>
<script type="application/javascript">
    var marqueeList = {};

    /**
     * alram success handler
     * @author psb
     * @private
     */
    function alramSuccessHandler(data, dataType, actionType){
        if(data!=null && data['eventLogs']!=null){
            var marqueeFlag = false;

            for(var index in data['eventLogs']){
                var eventLog = data['eventLogs'][index];

                if(eventLog['eventType']!=null && eventLog['eventType']!=""){
                    var eventTypeName = null;
                    marqueeFlag = true;

                    switch (eventLog['eventType']){
                        case "crane" :
                            eventTypeName = "크래인";
                            break;
                        case "worker" :
                            eventTypeName = "쓰러짐";
                            break;
                    }

                    if(eventLog['eventCancelUserId']!="" && eventLog['eventCancelUserId']!=null){
                        $("#alramList li[eventLogId='"+eventLog['eventLogId']+"']").remove();
                        delete marqueeList[eventLog['eventLogId']];
                    }else{
                        // 알림센터
                        var alramTag = templateHelper.getTemplate("alram01");
                        alramTag.attr("eventLogId",eventLog['eventLogId']).attr("areaId",eventLog['areaId']);
                        alramTag.find("#eventType").text(eventTypeName);
                        alramTag.find("#eventName").text(eventLog['eventName']);
                        alramTag.find("#areaName").text(eventLog['areaName']);
                        alramTag.find("#eventDatetime").text(new Date(eventLog['eventDatetime']).format("MM/dd HH:mm:ss"));
                        $("#alramList").prepend(alramTag);

                        marqueeList[eventLog['eventLogId']] = eventLog['eventName'];

                        // 토스트팝업
                        var toastTag = templateHelper.getTemplate("toast");
                        toastTag.attr("eventLogId",eventLog['eventLogId']);
                        toastTag.find("#toastEventName").text(eventTypeName);
                        toastTag.find("#toastEventDesc").text(eventLog['eventName']);
                        $(".wrap").append(toastTag);

                        removeToastTag(toastTag);
                        function removeToastTag(_tag){
                            setTimeout(function(){
                                _tag.remove();
                            },2000);
                        }
                    }
                }
            }

            if(marqueeFlag && Object.keys(marqueeList).length>0 && $("#marqueeList").length>0){
                $('.marquee').marquee('destroy');

                for(var index in marqueeList){
                    // marquee
                    var marqueeTag = templateHelper.getTemplate("marquee01");
                    marqueeTag.attr("eventLogId",index).text(marqueeList[index]);
                    $("#marqueeList").prepend(marqueeTag);
                }

                //마키 플러그인 호출
                $('.marquee').marquee({
                    duration: 20000,
                    direction: 'left',
                    gap: 20,
                    duplicated: true,
                    pauseOnHover: true,
                    startVisible: true
                });
            }
        }

        dashBoardHelper.saveRequestData('alram', {datetime:new Date().format("yyyy-MM-dd HH:mm:ss")});
    }

    /**
     * alram failure handler
     * @author psb
     * @private
     */
    function alramFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        console.log(XMLHttpRequest, textStatus, errorThrown, actionType);
    }

    function printTime() {
        $("#nowTime").text(new Date().format("MM.dd E hh:mm A/P"));

        setTimeout(function(){
            printTime();
        },1000);
    }

    function bodyAddClass(){
        switch (subMenuId){
            case "H00000": // 대쉬보드
                $("body").addClass("dashboard_mode");
                break;
            default :
                $("body").addClass("admin_mode");
                break;
        }
    }

    /**
     * 알람 show / hide
     */
    function alramShowHide(_type, _action){
        switch (_type){
            case "list":
                if(_action == 'show'){
                    $(".db_area").addClass("on");
                }else if(_action == 'hide'){
                    $(".dbs_area").removeClass("on");
                    $(".db_area").removeClass("on");
                    $(".nano-content > li").removeClass("infor");
                }
                break;
            case "detail":
                if(_action == 'show'){
                    $(".dbs_area").addClass("on");
                }else if(_action == 'hide'){
                    $(".dbs_area").removeClass("on");
                    $(".nano-content > li").removeClass("infor");
                }
                break;
        }
    }

    /**
     * 전체화면
     */
    function allView(_this){
        if($(_this).hasClass("on")){
            $("body").removeClass("on");
            $(_this).removeClass("on");
        }else{
            $("body").addClass("on");
            $(_this).addClass("on");
        }
    }

    function logout(){
        location.href = rootPath + '/logout.html';
    }

    function goHome(){
        location.href = rootPath + '/main.html';
    }

    function moveDashBoardDetail(id,name){
        var detailForm = $('<FORM>').attr('action',dashBoardUrlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','areaId').attr('value',id));
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','areaName').attr('value',name));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>
</body>
</html>