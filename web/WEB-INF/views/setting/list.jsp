<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000011" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />

<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.setting"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <div class="tabs_area">
        <ul class="tabs">
            <li rel="#server" href="${rootPath}/server/list.html"><span><spring:message code="common.title.server"/></span></li>
            <%--<li rel="#targetSynchronize" href="${rootPath}/targetSynchronize/list.html"><span><spring:message code="common.title.targetSynchronize"/></span></li>--%>
            <li rel="#target" href="${rootPath}/target/list.html"><span><spring:message code="common.title.target"/></span></li>
            <li rel="#function" href="${rootPath}/function/list.html"><span><spring:message code="common.title.function"/></span></li>
            <li rel="#notification" href="${rootPath}/notification/list.html"><span><spring:message code="common.title.notification"/></span></li>
            <li rel="#mail" href="${rootPath}/mail/list.html"><span><spring:message code="common.title.mail"/></span></li>
            <li rel="#monitor" href="${rootPath}/monitor/list.html"><span><spring:message code="common.title.monitor"/></span></li>
            <li rel="#monitorProcess" href="${rootPath}/monitorProcess/list.html"><span><spring:message code="common.title.monitorProcess"/></span></li>
        </ul>

        <div class="tabs_contents_area">
            <article class="tabs_content table_area" id="server"></article>
            <%--<article class="tabs_content table_area" id="targetSynchronize"></article>--%>
            <article class="tabs_content table_area" id="target"></article>
            <article class="tabs_content table_area" id="function"></article>
            <article class="tabs_content table_area" id="notification"></article>
            <article class="tabs_content table_area" id="mail"></article>
            <article class="tabs_content table_area" id="monitor"></article>
            <article class="tabs_content table_area" id="monitorProcess"></article>
        </div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var tabId = String('${tabId}');

    $(document).ready(function(){
        $("ul.tabs li").click(function () {
            $("ul.tabs li").removeClass("tabs_on");
            $(this).addClass("tabs_on");
            $(".tabs_content").hide();
            var activeTab = $(this).attr("rel");
            $(activeTab).load($(this).attr("href")).fadeIn();
        });

        if(tabId!=""){
            $(".tabs > li[rel='#"+tabId+"']").trigger("click");
        }else{
            $(".tabs > li[rel='#server']").trigger("click");
        }
        <%--$("#tabs").tabs({ active: "${tabIndex}" });--%>
    });
</script>