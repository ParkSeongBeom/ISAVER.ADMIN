<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-D000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-D000-0000-0000-000000000005" var="menuId"/>

<jabber:pageRoleCheck menuId="${menuId}" />
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.account"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <div class="tabs_area">
        <ul class="tabs">
            <li rel="#report" href="${rootPath}/account/reportList.html"><span><spring:message code="common.title.reportAccount"/></span></li>
            <li rel="#organization" href="${rootPath}/account/orgList.html"><span><spring:message code="common.title.orgAccount"/></span></li>
            <li rel="#user" href="${rootPath}/account/userList.html"><span><spring:message code="common.title.userAccount"/></span></li>
        </ul>

        <div class="tabs_contents_area">
            <div class="page_loading"></div>
            <article class="tabs_content table_area" id="report"></article>
            <article class="tabs_content table_area" id="organization"></article>
            <article class="tabs_content table_area" id="user"></article>
        </div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var tabId = String('${tabId}');

    var parameters = {
        'id' : "${paramBean.id}"
        ,'startDatetimeStr' : "${paramBean.startDatetimeStr}"
        ,'endDatetimeStr' : "${paramBean.endDatetimeStr}"
        ,'type' : "${paramBean.type}"
    };

    var urlConfig = {
        'listUrl':'${rootPath}/account/list.html'
    };

    var messageConfig = {
        'confirmStartDatetime':'<spring:message code="account.message.confirmStartDatetime"/>'
        ,'confirmEndDatetime':'<spring:message code="account.message.confirmEndDatetime"/>'
    };

    var parameters = {
        "id" : "${paramBean.id}",
        "startDatetimeStr" : "${paramBean.startDatetimeStr}",
        "endDatetimeStr" : "${paramBean.endDatetimeStr}",
        "type" : "${paramBean.type}",
        "reportDt" : "${paramBean.reportDt}"
    };

    $(document).ready(function(){
        $("ul.tabs li").click(function () {
            $("ul.tabs li").removeClass("tabs_on");
            $(this).addClass("tabs_on");
            $(".tabs_content").hide();
            var activeTab = $(this).attr("rel");

            $(".page_loading").show();
            $(activeTab).load($(this).attr("href"), parameters, function(){
                $(".page_loading").hide();
                $(activeTab).fadeIn();
            });
        });

        if(tabId!=""){
            $(".tabs > li[rel='#"+tabId+"']").trigger("click");
        }else{
            $(".tabs > li[rel='#report']").trigger("click");
        }

        <%--$("#tabs").tabs({--%>
            <%--active: "${tabIndex}",--%>
            <%--beforeLoad: function( event, ui ) {--%>
                <%--ui.ajaxSettings.type = 'POST';--%>
                <%--ui.ajaxSettings.hasContent = true;--%>
                <%--ui.jqXHR.setRequestHeader( "Content-Type", ui.ajaxSettings.contentType );--%>
                <%--ui.ajaxSettings.data = $.param( parameters, ui.ajaxSettings.traditional );--%>
                <%--$('#loadingBar').show();--%>
            <%--},--%>
            <%--load: function(event, ui) {--%>
                <%--$("#loadingBar").hide();--%>
            <%--}--%>
        <%--});--%>
    });

    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>