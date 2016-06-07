<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>

<!-- fullcalendar -->
<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/fullcalendar/fullcalendar.css" >
<script type="text/javascript" src="${rootPath}/assets/library/fullcalendar/lib/moment.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/library/fullcalendar/fullcalendar.js"></script>

<div class="table_title_area">
    <div class="month_btn_set">
        <button class="mon_allow ma_left fa" onclick="javascript:moveCalendar('prev'); return false;"></button>
        <p id="viewDate"></p>
        <button class="mon_allow ma_right fa" onclick="javascript:moveCalendar('next'); return false;"></button>
    </div>
    <div class="table_btn_set">
        <button class="btn btype01 bstyle03" onclick="javascript:bussinessDetailRender('new'); return false;"><spring:message code="bussinessboard.button.add"/></button>
    </div>
</div>
<div class="table_contents">
    <div id='calendar'></div>
</div>

<script type="text/javascript">
    $(document).ready(function(){
        $('#calendar').fullCalendar({
            header: { left: '', center: '', right: '' },
            dayNamesShort : ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
            timeFormat : 'HH:00',//'HH:00',
            editable: false,
            eventLimit: true,
            eventLimitText: "더보기",
            dayPopoverFormat: "YY.MM.DD",
            selectable: true, // select 다중 선택기능
            disableResizing: true,
            displayEventTime:false,
            nextDayThreshold: "00:00:00",
            select: function(start, end, jsEvent, view, resource) {
                bussinessDetailRender('new',{'start':start,'end':end});
            },
            eventClick: function(calEvent, jsEvent, view) {
                detail(calEvent['bussinessId']);
            }
        });

        currentDateSet();
        search();
    });

    /*
     날짜 이동
     @author psb
     */
    function moveCalendar(buttonName){
        $('#calendar').fullCalendar(buttonName);
        currentDateSet();
        search();
    }

    /*
     날짜
     @author psb
     */
    function currentDateSet(){
        var viewDate = $.fullCalendar.moment($('#calendar').fullCalendar('getDate')).format("YYYY.MM");
        $("#viewDate").text(viewDate);
    }

    /*
     조회
     @author psb
     */
    function search(){
        closeLayer();

        var data = {
            "viewType" : "calendarView"
            ,"startDatetimeStr" : $.fullCalendar.moment($('#calendar').fullCalendar('getView').intervalStart).format('YYYY-MM-DD')
            ,"endDatetimeStr" : $.fullCalendar.moment($('#calendar').fullCalendar('getView').intervalEnd).format('YYYY-MM-DD')
        };

        callAjax('listJson', data);
    }

    /*
     조회된 현황 데이터를 랜더링
     @author psb
     */
    function bussinessListRender(bussinessList){
        $('#calendar').fullCalendar('removeEvents');

        var events = [];
        for (var index in bussinessList){
            var bussiness = bussinessList[index];

            events[index] = {
                bussinessId: bussiness['bussinessId'],
                title: bussiness['title'],
                location : bussiness['location'],
                start: $.fullCalendar.moment(bussiness['startDatetime']).format('YYYY-MM-DD HH:mm'),
                end: $.fullCalendar.moment(bussiness['endDatetime']).format('YYYY-MM-DD HH:mm'),
                insertUserName : bussiness['insertUserName'],
                borderColor : "#ffffff",
                alldayYn:bussiness['alldayYn'],
                backgroundColor:bussiness['backgroundColor']
            };
        }

        $('#calendar').fullCalendar('addEventSource', events);
    }

    /*
     일정 데이터를 랜더링
     @author psb
     */
    function calendarListRender(calendars){
        $('.holiday_color').css("color", "").removeClass('holiday_color');
        $('.holiday_span').remove();

        if (calendars!=null){
            for (var index in calendars){
                var calendar = calendars[index];
                var calendarDay = $("td.fc-day-number[data-date='"+$.fullCalendar.moment(calendar['date']).format('YYYY-MM-DD')+"']");

                if ($(calendarDay).find('.holiday_span').length!=0){
                    $(calendarDay).find('.holiday_span').append(
                        $("<em/>").text(",")
                    ).append(
                        $("<span/>").css("color", calendar['colorCode']).attr('title',calendar['title']).text(calendar['title'])
                    );
                }else{
                    $(calendarDay).addClass('holiday_color').css("color", calendar['colorCode']);
                    $(calendarDay).prepend(
                        $("<span/>").addClass("holiday_span").append(
                            $("<span/>").css("color", calendar['colorCode']).attr('title',calendar['title']).text(calendar['title'])
                        )
                    );
                }
            }
        }
    }
</script>