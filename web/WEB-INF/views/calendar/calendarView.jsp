<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
        <button class="btn btype01 bstyle03" onclick="javascript:detail('mon',null); return false;"><spring:message code="calendar.button.add"/></button>
    </div>
</div>
<div class="table_contents">
    <div id='calendar'></div>
</div>

<script type="text/javascript">
    var weekday = ['일','월','화','수','목','금','토'];

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
            "startDatetimeStr" : $.fullCalendar.moment($('#calendar').fullCalendar('getView').intervalStart).format('YYYY-MM-DD')
            ,"endDatetimeStr" : $.fullCalendar.moment($('#calendar').fullCalendar('getView').intervalEnd).format('YYYY-MM-DD')
        };

        callAjax('listJson', data);
    }

    /*
     조회된 회의실예약 데이터를 랜더링
     @author psb
     */
    function reservationListRender(reservations){
        $('#calendar').fullCalendar('removeEvents');

        var events = [];
        for (var index in reservations){
            var reservation = reservations[index];
            events.push({
                reservationId: reservation['reservationId'],
                title: reservation['title'],
                start: $.fullCalendar.moment(reservation['startDate']).format('YYYY-MM-DD HH:mm'),
                end: $.fullCalendar.moment(reservation['endDate']).format('YYYY-MM-DD HH:mm'),
                assetsName : reservation['assetsName'],
                insertUserName : reservation['insertUserName'],
                description: reservation['description'],
                repeatYn : reservation['repeatYn'],
                repeatId : reservation['repeatId'],
                backgroundColor : reservation['colorCode'],
                borderColor : "#ffffff",
                allDay:false
            });
        }
        $('#calendar').fullCalendar('addEventSource', events);

//        $(".fc-event").hover(
//            function() {
//                $( this ).addClass("fchover");
//            }, function() {
//                $( this ).removeClass("fchover");
//            }
//        );
    }

    /*
     조회된 반복 데이터를 랜더링
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
                        $("<span/>").css("color", calendar['colorCode']).attr("onclick","javascript:detail('mon','"+calendar['calendarId']+"')").attr('title',calendar['title']).text(calendar['title'])
                    );
                }else{
                    $(calendarDay).addClass('holiday_color').css("color", calendar['colorCode']);
                    $(calendarDay).prepend(
                        $("<span/>").addClass("holiday_span").append(
                            $("<span/>").css("color", calendar['colorCode']).attr("onclick","javascript:detail('mon','"+calendar['calendarId']+"')").attr('title',calendar['title']).text(calendar['title'])
                        )
                    );
                }
            }
        }
    }

    function initialize(){
        $('#calendar').fullCalendar({
            header: { left: '', center: '', right: '' },
            dayNamesShort : ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
            timeFormat : 'HH:00',//'HH:00',
            editable: false,
            eventLimit: true,
            eventLimitText: "더보기",
            dayPopoverFormat: "YY.MM.DD",
            selectable: false, // select 다중 선택기능
            disableResizing: true,
            nextDayThreshold: "00:00:00",
            eventClick: function(calEvent, jsEvent, view) {
                detail('rev', calEvent['reservationId']);
            }
        });

        currentDateSet();
        search();
    }

    initialize();
</script>