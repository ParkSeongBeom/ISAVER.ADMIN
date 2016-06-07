<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-C000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-C000-0000-0000-000000000009" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>

<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<!-- select2 -->
<link rel="stylesheet" href="${rootPath}/assets/library/select2/v3.5.2/select2.css?version=${version}">
<script type="text/javascript" src="${rootPath}/assets/library/select2/v3.5.2/select2.min.js?version=${version}"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/select2-helper.js?version=${version}" charset="UTF-8"></script>

<aside class="layer_popup">
    <section class="layer_wrap">
    </section>
    <div class="layer_popupbg ipop_close"></div>
</aside>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.bussinessboard"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <div class="tabs_area">
        <ul class="tabs">
            <li rel="calendarView"><span><spring:message code="bussinessboard.tab.calendarView"/></span></li>
            <li rel="listView"><span><spring:message code="bussinessboard.tab.listView"/></span></li>
        </ul>

        <div class="tabs_contents_area">
            <article class="tabs_content table_area" id="calendarView"></article>
            <article class="tabs_content table_area" id="listView"></article>
        </div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var tabId = String('${tabId}');
    var select2Helper;

    var parameters = {
        "viewType" : "${paramBean.viewType}"
        ,"pageNumber" : "${paramBean.pageNumber}"
        ,"title" : "${paramBean.title}"
        ,"type" : "${paramBean.type}"
        ,"startDatetimeStr" : "${paramBean.startDatetimeStr}"
        ,"endDatetimeStr" : "${paramBean.endDatetimeStr}"
    };

    /* 디폴트 알람 인원
     * 문원상 사장님 - 010701
     * 김주백 부사장님 - 050801
     * 김충일 전무님 - 051101
     * 류광식 상무님 - 140803
     * 김민철 이사님 - 010803
     */
    var defaultSelectList = ['010701','050801','051101','010803','140803'];

    var urlConfig = {
        'listUrl':'${rootPath}/bussinessboard/list.html'
        ,'listJsonUrl':'${rootPath}/bussinessboard/list.json'
        ,'detailUrl':'${rootPath}/bussinessboard/detail.json'
        ,'userListUrl':'${rootPath}/user/all.json'
        ,'addUrl':'${rootPath}/bussinessboard/add.json'
        ,'saveUrl':'${rootPath}/bussinessboard/save.json'
        ,'removeUrl':'${rootPath}/bussinessboard/remove.json'
    };

    var messageConfig = {
        listJsonFailure         : '<spring:message code="bussinessboard.message.listJsonFailure"/>'
        ,addConfirm             : '<spring:message code="common.message.addConfirm"/>'
        ,addFailure             : '<spring:message code="common.message.addFailure"/>'
        ,addComplete            : '<spring:message code="common.message.addComplete"/>'
        ,saveConfirm            : '<spring:message code="common.message.saveConfirm"/>'
        ,saveFailure            : '<spring:message code="common.message.saveFailure"/>'
        ,saveComplete           : '<spring:message code="common.message.saveComplete"/>'
        ,removeConfirm          : '<spring:message code="common.message.removeConfirm"/>'
        ,removeFailure          : '<spring:message code="common.message.removeFailure"/>'
        ,removeComplete         : '<spring:message code="common.message.removeComplete"/>'
        ,confirmStartDatetime   : '<spring:message code="bussinessboard.message.confirmStartDatetime"/>'
        ,confirmEndDatetime     : '<spring:message code="bussinessboard.message.confirmEndDatetime"/>'
        ,overflowDate           : '<spring:message code="bussinessboard.message.overflowDate"/>'
        ,overflowDatetime       : '<spring:message code="bussinessboard.message.overflowDatetime"/>'
        ,emptyTitle             : '<spring:message code="bussinessboard.message.emptyTitle"/>'
        ,emptyStartDate         : '<spring:message code="bussinessboard.message.emptyStartDate"/>'
        ,emptyEndDate           : '<spring:message code="bussinessboard.message.emptyEndDate"/>'
        ,copyConfirm            : '<spring:message code="bussinessboard.message.copyConfirm"/>'
    };

    var layerTag = $("<article/>").addClass("layer_area").append(
        $("<div/>").addClass("layer_header").text('<spring:message code="bussinessboard.title.add"/>').append(
            $("<button/>").addClass("ipop_x").attr("onclick","javascript:closeLayer(); return false;")
        )
    ).append(
        $("<div/>").addClass("layer_contents").append(
            $("<div/>").addClass("layer_sc lsc_style01").append(
                $("<div/>").addClass("itype_05").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.title"/>')
                ).append(
                    $("<div/>").addClass("color_set").append(
                        $("<input/>").attr("type","text").attr("id","title")
                    ).append(
                        $("<div/>").addClass("cs_color").append(
                            $("<div/>").addClass("cs_select").css("background-color","#3366cc").append(
                                $("<input/>").attr("type","hidden").attr("id","backgroundColor").addClass("infos").val("#3366cc")
                            )
                        ).append(
                            $("<div/>").addClass("cs_color_select").append(
                                $("<p/>").css("background-color","#3366cc").attr("bgcolor","#3366cc")
                            ).append(
                                $("<p/>").css("background-color","#22aa99").attr("bgcolor","#22aa99")
                            ).append(
                                $("<p/>").css("background-color","#b027b0").attr("bgcolor","#b027b0")
                            ).append(
                                $("<p/>").css("background-color","#76a72d").attr("bgcolor","#76a72d")
                            ).append(
                                $("<p/>").css("background-color","#e25091").attr("bgcolor","#e25091")
                            ).append(
                                $("<p/>").css("background-color","#f2812e").attr("bgcolor","#f2812e")
                            )
                        )
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.location"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","location")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.start"/>')
                ).append(
                    $("<span/>").addClass("plable05").append(
                        $("<input/>").attr("type","text").attr("id","startDatetime")
                    )
                ).append(
                    $("<span/>").addClass("plable05 subDate").append(
                        $("<select/>").attr("id","startDateHour")
                    ).append(
                        $("<em/>").text(":")
                    ).append(
                        $("<select/>").attr("id","startDateMinute").append(
                            $("<option/>").val("00").text("00")
                        ).append(
                            $("<option/>").val("30").text("30")
                        )
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.end"/>')
                ).append(
                    $("<span/>").addClass("plable05").append(
                        $("<input/>").attr("type","text").attr("id","endDatetime")
                    )
                ).append(
                    $("<span/>").addClass("plable05 subDate").append(
                        $("<select/>").attr("id","endDateHour")
                    ).append(
                        $("<em/>").text(":")
                    ).append(
                        $("<select/>").attr("id","endDateMinute").append(
                            $("<option/>").val("00").text("00")
                        ).append(
                            $("<option/>").val("30").text("30")
                        )
                    )
                )
            ).append(
                $("<p/>").addClass("itype_01").append(
                    $("<span/>")
                ).append(
                    $("<span/>").append(
                        $("<input/>").addClass("checkbox").attr("type","checkbox").attr("id","alldayYn").attr("onclick","javascript:if($(this).is(':checked')){ $('.subDate').hide(); }else{ $('.subDate').show(); }")
                    ).append(
                        $("<span/>").text('<spring:message code="bussinessboard.column.allday"/>').css("width","50px")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.order"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","order").addClass("infos")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.pm"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","pm").addClass("infos")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.pl"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","pl").addClass("infos")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.entry"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","entry").addClass("infos")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.team"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","team").addClass("infos")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.staff"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","staff").addClass("infos")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.description"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","description").addClass("infos")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text('<spring:message code="bussinessboard.column.alarm"/>')
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","alarm")
                    )
                )
            )
        )
    ).append(
        $("<div/>").addClass("layer_bottom")
    );

    $(document).ready(function(){
        $("ul.tabs li").click(function () {
            $("ul.tabs li").removeClass("tabs_on");
            $(this).addClass("tabs_on");
            $(".tabs_content").hide();
            var activeTab = $(this).attr("rel");
            parameters['viewType'] = activeTab;
            $("#"+activeTab).empty().load( urlConfig['listUrl'], parameters).fadeIn();
        });

        if(tabId!=""){
            $(".tabs > li[rel='"+tabId+"']").trigger("click");
        }else{
            $(".tabs > li[rel='calendarView']").trigger("click");
        }

        getUserList();
    });

    /*
     Select2를 위한 User 모델링
     @author psb
     */
    function getUserList(){
        callAjax('userList');
    }

    /*
     조회된 유저 리스트
     @author psb
     */
    function setUserList(_userList){
        select2Helper = new Select2Helper(_userList);
        select2Helper.setOption({
            'width':'100%'
            ,'placeholder':'<spring:message code='common.message.selectEntry'/>'
            ,'resultAddClass':'sr_set04'
        });
    }

    /*
     상세화면 이동
     @author psb
     */
    function detail(id){
        callAjax('detail',{'id':id});
    }

    function closeLayer(){
        $('.layer_popup').fadeOut(200);
        setTimeout(function () {
            $('.layer_popup').removeClass("ipop_type01");
            $('.layer_popup').removeClass("ipop_type02");
            $('.layer_popup').removeClass("ipop_type03");
            $('.layer_wrap').removeClass("i_type01");
            $('.layer_wrap').removeClass("i_type02");
            $('.layer_wrap').removeClass("i_type03");
            $('.layer_wrap').removeClass("it_style01");
        }, 300);
    }

    function bussinessDetailRender(_type, _bussiness){
        var _layerTag = layerTag.clone();

        /* 알람 */
        var params = [];

        /* 시작,종료 시간 selectbox */
        for(var i=0; i<24; i++){
            var _hour = i<10 ? "0"+i : i;
            _layerTag.find("#startDateHour").append( $("<option/>").val(_hour).text(_hour) );
            _layerTag.find("#endDateHour").append( $("<option/>").val(_hour).text(_hour) );
        }

        if(_type=='edit'){
            if(_bussiness['title']!=null){ _layerTag.find("#title").val(_bussiness['title']); }
            if(_bussiness['location']!=null){ _layerTag.find("#location").val(_bussiness['location']); }
            if(_bussiness['startDatetime']!=null){
                _layerTag.find("#startDatetime").val($.fullCalendar.moment(_bussiness['startDatetime']).format('YYYY-MM-DD'));
                _layerTag.find("#startDateHour").val($.fullCalendar.moment(_bussiness['startDatetime']).format('HH'));
                _layerTag.find("#startDateMinute").val($.fullCalendar.moment(_bussiness['startDatetime']).format('mm'));
            }
            if(_bussiness['endDatetime']!=null){
                _layerTag.find("#endDatetime").val($.fullCalendar.moment(_bussiness['endDatetime']).format('YYYY-MM-DD'));
                _layerTag.find("#endDateHour").val($.fullCalendar.moment(_bussiness['endDatetime']).format('HH'));
                if($.fullCalendar.moment(_bussiness['endDatetime']).format('mm')=='59'){
                    _layerTag.find("#endDateMinute").val('00');
                }else{
                    _layerTag.find("#endDateMinute").val($.fullCalendar.moment(_bussiness['endDatetime']).format('mm'));
                }
            }

            /* 데이터 */
            var _infos = {};
            for (var index in _bussiness['infos']){
                var info = _bussiness['infos'][index];

                if(info['key']!=null && info['value']!=null){
                    _infos[info['key']] = info['value'];
                }
            }

            if(_infos['alldayYn']!=null){
                if(_infos['alldayYn']=="Y"){
                    _layerTag.find("#alldayYn").prop("checked",true);
                    _layerTag.find(".subDate").hide();
                }
            }

            if(_infos['backgroundColor']!=null){
                _layerTag.find(".cs_select").css("background-color",_infos['backgroundColor']);
                _layerTag.find("#backgroundColor").val(_infos['backgroundColor']);
            }
            if(_infos['order']!=null){ _layerTag.find("#order").val(_infos['order']); }
            if(_infos['pm']!=null){ _layerTag.find("#pm").val(_infos['pm']); }
            if(_infos['pl']!=null){ _layerTag.find("#pl").val(_infos['pl']); }
            if(_infos['entry']!=null){ _layerTag.find("#entry").val(_infos['entry']); }
            if(_infos['team']!=null){ _layerTag.find("#team").val(_infos['team']); }
            if(_infos['staff']!=null){ _layerTag.find("#staff").val(_infos['staff']); }
            if(_infos['description']!=null){ _layerTag.find("#description").val(_infos['description']); }
            if(_infos['alarm']!=null){
                var alarmList = _infos['alarm'].split("|");
                for (var i=0 ; i<alarmList.length; i++){
                    params.push({id:alarmList[i]});
                }
            }

            /* 버튼 */
            _layerTag.find(".layer_bottom").append(
                $("<button/>").addClass("btn btype01 bstyle01").attr("onclick","javascript:copyBussiness(); return false;").text("일정복사")
            ).append(
                $("<button/>").addClass("btn btype01 bstyle03").attr("onclick","javascript:saveBussiness('"+_bussiness['bussinessId']+"'); return false;").text("수정")
            ).append(
                $("<button/>").addClass("btn btype01 bstyle03").attr("onclick","javascript:removeBussiness('"+_bussiness['bussinessId']+"'); return false;").text("삭제")
            )
        }else{
            var _now = new Date();

            if(_bussiness!=null && _bussiness['start'] && _bussiness['end']){
                _layerTag.find("#startDatetime").val($.fullCalendar.moment(_bussiness['start']).format('YYYY-MM-DD'));
                _layerTag.find("#endDatetime").val($.fullCalendar.moment(_bussiness['end']).subtract(1,'days').format('YYYY-MM-DD'));
            }else{
                _layerTag.find("#startDatetime").val($.fullCalendar.moment(_now).format('YYYY-MM-DD'));
                _layerTag.find("#endDatetime").val($.fullCalendar.moment(_now).subtract(-1,'hours').format('YYYY-MM-DD'));
            }

            _layerTag.find("#startDateHour").val($.fullCalendar.moment(_now).format('HH'));
            _layerTag.find("#endDateHour").val($.fullCalendar.moment(_now).subtract(-1,'hours').format('HH'));

            // default 알람 설정
            for (var i in defaultSelectList){
                params.push({id:defaultSelectList[i]});
            }

            /* 버튼 */
            _layerTag.find(".layer_bottom").append(
                $("<button/>").addClass("btn btype01 bstyle03").attr("onclick","javascript:addBussiness(); return false;").text("저장")
            )
        }

        _layerTag.find(".layer_bottom").append(
            $("<button/>").addClass("btn btype01 bstyle03 ipop_close").attr("onclick","javascript:closeLayer(); return false;").text("취소")
        );

        $('.layer_popup').addClass("ipop_type02");
        $('.layer_wrap').addClass("i_type02").addClass("it_style01").html(_layerTag);

        $(".cs_color_select > p").click(function(){
            var bgColor = $(this).attr("bgcolor")!=null ? $(this).attr("bgcolor") : '';
            $(".cs_select").css("background-color",bgColor);
            $("#backgroundColor").val(bgColor);
        });

        calendarHelper.load($('#startDatetime'));
        calendarHelper.load($('#endDatetime'));

        $('.ipop_type02').fadeIn(200);

        setTimeout(function(){
            select2Helper.setElement($('#alarm'));
            select2Helper.load();
            select2Helper.setSelectedList(params);
        },200);
    }

    /*
     validate method
     @author kst
     */
    function validate(){
        if($('#title').val().trim().length == 0){
            $('#title').focus();
            alertMessage('emptyTitle');
            return false;
        }

        var startDt = $('#startDatetime').val().trim();
        var endDt = $('#endDatetime').val().trim();

        if(startDt.length == 0){
            $('#startDatetime').focus();
            alertMessage('emptyStartDate');
            return false;
        }

        if(endDt.length == 0){
            $('#endDatetime').focus();
            alertMessage('emptyEndDate');
            return false;
        }

        var startDatetime = startDt + " " +  $("#startDateHour").val() + ":" + $("#startDateMinute").val() + ":00";
        var endDatetime = endDt + " " + $("#endDateHour").val() + ":" + $("#endDateMinute").val() + ":00";

        if(startDatetime.length != 0 && !startDatetime.checkDatetimePattern(" ","-",":")){
            alertMessage('confirmStartDatetime');
            return false;
        }
        if(endDatetime.length != 0 && !endDatetime.checkDatetimePattern(" ","-",":")){
            alertMessage('confirmEndDatetime');
            return false;
        }

        if (new Date(startDt) > new Date(endDt)) {
            alertMessage('overflowDate');
            return false;
        }else if(!$("#alldayYn").is(":checked") && new Date(startDatetime) >= new Date(endDatetime)){
            alertMessage('overflowDatetime');
            return false;
        }

        return true;
    }

    /*
     * 등록,수정 데이터 가공
     * @author psb
     */
    function setParamData(id){
        var data = {};
        var splitString = "/#s@p!l,i.t&/";

        if(id!=null){ data['bussinessId'] = id; }
        if($("#title").val().trim()!=""){ data['title'] = $("#title").val(); }
        if($("#location").val().trim()!=""){ data['location'] = $("#location").val(); }
        if ($("#alldayYn").is(":checked")){
            data['startDatetime'] = $("#startDatetime").val() + " 00:00:00";
            data['endDatetime'] = $("#endDatetime").val() + " 23:59:00";
            data['alldayYn'] = "Y";
        }else{
            data['startDatetime'] = $("#startDatetime").val() + " " +  $("#startDateHour").val() + ":" + $("#startDateMinute").val() + ":00";
            data['endDatetime'] = $("#endDatetime").val() + " " +  $("#endDateHour").val() + ":" + $("#endDateMinute").val() + ":00";
            data['alldayYn'] = "N";
        }

        var keys = "";
        var values = "";
        $.each($(".infos"),function(){
            if(this.value.trim()!=""){
                keys += this.id+splitString;
                values += this.value+splitString;
            }
        });

        var alarmList = select2Helper.getSelectedList();
        var alarmIds = "";
        for (var i=0; i<alarmList.length; i++){
            if (i>0){ alarmIds += "|"; }
            alarmIds += alarmList[i].id + "@" + alarmList[i].domain;
        }

        if(alarmIds!=""){
            keys += "alarm"+splitString;
            values += alarmIds+splitString;
        }

        data['keys'] = keys.substring(0,keys.lastIndexOf(splitString));
        data['values'] = values.substring(0,values.lastIndexOf(splitString));

        return data;
    }

    /*
     * 일정복사
     * @author psb
     */
    function copyBussiness(){
        if(!confirm(messageConfig['copyConfirm'])){
            return false;
        }

        var buttonHtml = "<button class='btn btype01 bstyle03' onclick='javascript:addBussiness(); return false;'>저장</button>"
                + "<button class='btn btype01 bstyle03 ipop_close' onclick='javascript:closeLayer(); return false;'>취소</button>";

        $(".layer_bottom").html(buttonHtml);
    }

    /*
     * 전락사업현황 등록
     * @author psb
     */
    function addBussiness(){
        if(validate()){
            if(!confirm(messageConfig['addConfirm'])){
                return false;
            }
            callAjax('add', setParamData());
        }
    }

    /*
     * 전락사업현황 수정
     * @author psb
     */
    function saveBussiness(id){
        if(validate()){
            if(!confirm(messageConfig['saveConfirm'])){
                return false;
            }
            callAjax('save', setParamData(id));
        }
    }

    /*
     * 전략사업현황 삭제
     * @author psb
     */
    function removeBussiness(id){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        callAjax('remove', { "bussinessId" : id });
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        if (actionType!='listJson' && actionType!='userList' && actionType!='detail'){
            alertMessage(actionType + 'Complete');
        }

        switch(actionType){
            case 'userList':
                setUserList(data.users);
                break;
            case 'listJson':
                if(data.bussinessBoardList!=null){
                    bussinessListRender(data.bussinessBoardList);
                }
                if(data.calendars!=null){
                    calendarListRender(data.calendars);
                }
                break;
            case 'detail':
                if(data.bussinessBoard!=null){
                    bussinessDetailRender('edit',data.bussinessBoard);
                }
                break;
            case 'add':
                search();
                break;
            case 'save':
                search();
                break;
            case 'remove':
                search();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>