<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="G00030" var="menuId"/>
<c:set value="G00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />

<!-- section Start -->
<section class="container">
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.eventStatistics"/></h3>
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <!-- 탭 컨테이너 시작 -->
    <article class="tabs_area">
        <ul class="tabs">
            <li rel="#area" href="${rootPath}/eventStatistics/area.html"><button><spring:message code="statistics.tab.area"/></button></li>
            <li rel="#worker" href="${rootPath}/eventStatistics/worker.html"><button><spring:message code="statistics.tab.worker"/></button></li>
            <li rel="#crane" href="${rootPath}/eventStatistics/crane.html"><button><spring:message code="statistics.tab.crane"/></button></li>
            <li rel="#gas" href="${rootPath}/eventStatistics/gas.html"><button><spring:message code="statistics.tab.gas"/></button></li>
            <li rel="#inout" href="${rootPath}/eventStatistics/inout.html"><button><spring:message code="statistics.tab.inout"/></button></li>
        </ul>

        <div class="tabs_contents_area">
            <div class="tabs_content" id="area" title="<spring:message code="statistics.tab.area"/>"></div>
            <div class="tabs_content" id="worker" title="<spring:message code="statistics.tab.worker"/>"></div>
            <div class="tabs_content" id="crane" title="<spring:message code="statistics.tab.crane"/>"></div>
            <div class="tabs_content" id="gas" title="<spring:message code="statistics.tab.gas"/>"></div>
            <div class="tabs_content" id="inout" title="<spring:message code="statistics.tab.inout"/>"></div>
        </div>
    </article>
    <!-- 탭 컨테이너 끝   -->
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var tabId = String('${tabId}');

    $(document).ready(function(){
        $("ul.tabs li").click(function () {
            if(!$(this).hasClass("tabs_on")){
                $("ul.tabs li").removeClass("tabs_on");
                $(this).addClass("tabs_on");
                $(".tabs_content").hide();
                var activeTabId = $(this).attr("rel");

                if($(activeTabId).is(":empty")){
                    $(activeTabId).load($(this).attr("href")).fadeIn();
                }else{
                    $(activeTabId).fadeIn();
                }
            }
        });

        if(tabId!=""){
            $("ul.tabs li[rel='#"+tabId+"']").trigger("click");
        }else{
            $("ul.tabs li[rel='#area']").trigger("click");
        }
    });
</script>