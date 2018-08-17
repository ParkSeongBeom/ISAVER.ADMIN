<!-- 영상이력, @author psb -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="2B0020" var="menuId"/>
<c:set value="2B0000" var="subMenuId"/>

<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.videoHistory"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="videoHistoryForm" method="POST">
        <article class="search_area">
            <div class="search_contents">
                <spring:message code="common.selectbox.select" var="allSelectText"/>
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="videoHistory.column.areaName" /></span>
                    <span><isaver:areaSelectBox htmlTagName="areaId" allModel="true" areaId="${paramBean.areaId}" allText="${allSelectText}"/></span>
                </p>
                <p class="itype_04">
                    <span><spring:message code="videoHistory.column.eventDatetime" /></span>
                    <span class="plable04">
                        <input type="text" name="startDatetimeStr" class="datepicker dpk_normal_type" value="${paramBean.startDatetimeStr}" />
                        <select id="startDatetimeHourSelect" name="startDatetimeHour"></select>
                        <em>~</em>
                        <input type="text" name="endDatetimeStr" class="datepicker dpk_normal_type" value="${paramBean.endDatetimeStr}" />
                        <select id="endDatetimeHourSelect" name="endDatetimeHour"></select>
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="video_area">
        <section>
            <!-- 입력 테이블 Start -->
            <div>
                <video id="videoElement" class="videobox" poster="" controls="ture" style="width:100%;">
                    <source id="videoSource" type="video/mp4">
                </video>
                <div class="speed">
                    <button class="x1" speed="1"></button>
                    <button class="x2" speed="2"></button>
                    <button class="x4" speed="4"></button>
                    <button class="x8" speed="8"></button>
                </div>
            </div>
        </section>

        <section>
            <div class="table_btn_set">
                <p><span><spring:message code="common.message.total"/><em>${totalCount}</em><spring:message code="common.message.number01"/></span></p>
            </div>
            <ul class="video_list">
                <c:choose>
                    <c:when test="${videoHistoryList != null and fn:length(videoHistoryList) > 0}">
                        <c:forEach var="videoHistory" items="${videoHistoryList}">
                            <li onclick="javascript:openVideo(this,'${videoHistory.notificationId}','${videoHistory.deviceId}');">
                                <div>
                                    <img src="${videoUrl}${videoHistory.notificationId}${videoHistory.deviceId}.jpg"/>
                                </div>
                                <div>
                                    <span>${videoHistory.areaName}</span>
                                    <span>${videoHistory.deviceName}</span>
                                    <p>${videoHistory.eventName}</p>
                                    <span><fmt:formatDate value="${videoHistory.eventDatetime}" pattern="MM/dd HH:mm:ss"/></span>
                                </div>
                            </li>
                        </c:forEach>
                    </c:when>
                </c:choose>
            </ul>
        </section>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var videoUrl = String('${videoUrl}');
    var form = $('#videoHistoryForm');

    var messageConfig = {
        'earlyDatetime':'<spring:message code="videoHistory.message.earlyDatetime"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/videoHistory/list.html'
    };


    var searchConfig = {
        'startDatetimeHour':'${paramBean.startDatetimeHour}'
        ,'endDatetimeHour':'${paramBean.endDatetimeHour}'
    };

    $(document).ready(function(){
        $(".speed > button").on("click",function(){
            $("#videoElement")[0].playbackRate = Number($(this).attr("speed"));
            $("#videoElement")[0].play();
        });

        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));

        setHourDataToSelect($('#startDatetimeHourSelect'),searchConfig['startDatetimeHour'],false);
        setHourDataToSelect($('#endDatetimeHourSelect'),searchConfig['endDatetimeHour'],true);

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
    });

    function openVideo(_this, notificationId,deviceId){
        $(".video_list li").removeClass("on");
        $(_this).addClass("on");

        $("#videoSource").attr("src",videoUrl+notificationId+deviceId+".mp4");
        $("#videoElement")[0].load();
    }

    function validate(){
        var start = new Date($("input[name='startDatetimeStr']").val() + " " + $("#startDatetimeHourSelect").val() + ":00:00");
        var end = new Date($("input[name='endDatetimeStr']").val() + " " + $("#endDatetimeHourSelect").val() + ":00:00");

        if(start>end){
            alertMessage("earlyDatetime");
            return false;
        }
        return true;
    }

    /*
     조회
     @author kst
     */
    function search(){
        if(validate()){
            form.attr('action',urlConfig['listUrl']);
            form.submit();
        }
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>