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
        <input type="hidden" name="mode" value="search"/>
        <article class="search_area">
            <div class="search_contents">
                <spring:message code="common.selectbox.select" var="allSelectText"/>
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="videoHistory.column.areaName" /></span>
                    <span><isaver:areaSelectBox htmlTagName="areaId" allModel="true" areaId="${paramBean.areaId}" allText="${allSelectText}"/></span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="videoHistory.column.deviceName" /></span>
                    <span>
                        <select name="deviceId">
                            <option value="" ><spring:message code="common.selectbox.all"/></option>
                            <c:forEach var="device" items="${deviceList}">
                                <option value="${device.deviceId}" <c:if test="${device.deviceId == paramBean.deviceId}">selected="selected"</c:if>>${device.deviceName}</option>
                            </c:forEach>
                        </select>
                    </span>
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
                <p class="itype_01">
                    <span><spring:message code="videoHistory.column.videoType" /></span>
                    <span>
                        <select name="videoType">
                            <option value="" ><spring:message code="common.selectbox.all"/></option>
                            <option value="event" <c:if test="${paramBean.videoType == 'event'}">selected="selected"</c:if>><spring:message code="videoHistory.selectbox.event"/></option>
                            <option value="normal" <c:if test="${paramBean.videoType == 'normal'}">selected="selected"</c:if>><spring:message code="videoHistory.selectbox.normal"/></option>
                        </select>
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
                    <button class="x1 on" speed="1"></button>
                    <button class="x2" speed="2"></button>
                    <button class="x4" speed="4"></button>
                    <button class="x8" speed="8"></button>
                </div>
            </div>
        </section>

        <section>
            <div class="table_btn_set">
                <p><span><spring:message code="common.message.total"/><em id="totalCount"></em><spring:message code="common.message.number01"/></span></p>
            </div>
            <ul class="video_list" id="videoList"></ul>
            <button id="videoHistoryMoreBtn" onclick="javascript:listRender();"></button>
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
        ,'listFailure':'<spring:message code="videoHistory.message.listFailure"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/videoHistory/list.json'
    };

    var searchConfig = {
        'startDatetimeHour':'${paramBean.startDatetimeHour}'
        ,'endDatetimeHour':'${paramBean.endDatetimeHour}'
    };

    var videoElementTag = $("<li/>").append(
        $("<div/>").append(
            $("<img/>",{id:'thumbnail'})
        )
    ).append(
        $("<div/>").append(
            $("<span/>",{id:'areaName'})
        ).append(
            $("<span/>",{id:'deviceName'})
        ).append(
            $("<p/>",{id:'eventName'})
        ).append(
            $("<span/>",{id:'videoDatetime'})
        )
    );

    var videoHistoryList;
    var pageConfig = {
        viewMaxCnt : 20
        ,elementIndex : 0
        ,totalCount : 0
    };

    $(document).ready(function(){
        $(".speed > button").on("click",function(){
            $(".speed > button").removeClass("on");
            $(this).addClass("on");
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

        search();
    });

    function openVideo(_this, videoFileName){
        $(".video_list li").removeClass("on");
        $(_this).addClass("on");

        $("#videoSource").attr("src",videoUrl+videoFileName);
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
     @author psb
     */
    function search(){
        if(validate()){
            callAjax('list', form.serialize());
        }
    }

    function listRender(){
        var index = 0;

        while (index<=pageConfig['viewMaxCnt']){
            if(pageConfig['elementIndex']<videoHistoryList.length){
                var videoHistory = videoHistoryList[pageConfig['elementIndex']];
                addVideoHistory(videoHistory);
            }else{
                break;
            }
            pageConfig['elementIndex']++;
            index++;
        }

        if(pageConfig['elementIndex']<videoHistoryList.length){
            $("#videoHistoryMoreBtn").show();
        }else{
            $("#videoHistoryMoreBtn").hide();
        }
    }

    function addVideoHistory(videoHistory){
        var videoTag = videoElementTag.clone();
        var fenceName = '';
        if(videoHistory['fenceName']!=null){
            fenceName = "("+videoHistory['fenceName']+")";
        }
        videoTag.attr("onclick","openVideo(this,'"+videoHistory['videoType']+"/"+videoHistory['videoFileName']+"');");
        videoTag.find("#thumbnail").attr("src","${videoUrl}"+videoHistory['videoType']+"/"+videoHistory['thumbnailFileName']);
        videoTag.find("#areaName").text(videoHistory['areaName']?videoHistory['areaName']:'');
        videoTag.find("#deviceName").text(videoHistory['deviceName']?videoHistory['deviceName']:'');
        videoTag.find("#eventName").text((videoHistory['eventName']?videoHistory['eventName']:'')+fenceName);
        videoTag.find("#videoDatetime").text(new Date(videoHistory['videoDatetime']).format("MM/dd HH:mm:ss"));
        $("#videoList").append(videoTag);
    }

    /*
     ajax call
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,videoHistory_successHandler,videoHistory_errorHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function videoHistory_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'list':
                videoHistoryList = data['videoHistoryList'];
                pageConfig['elementIndex'] = 0;
                pageConfig['totalCount'] = Number(data['totalCount']);
                $("#videoList").empty();
                $("#totalCount").text(pageConfig['totalCount']);
                listRender();
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function videoHistory_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>