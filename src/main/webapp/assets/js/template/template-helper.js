/**
 * Template helper
 *
 * @author psb
 * @type {Function}
 */
var TemplateHelper = (
    function(){
        /********************************************************************************
         * 알림 리스트 template
         *********************************************************************************/
        var NOTIFICATION_CONTENT_TEMPLATE = $("<li/>").append(
            $("<div/>", {class:"checkbox_set csl_style01"}).append(
                $("<input/>", {type:"checkbox" ,class:"check_input"})
            ).append(
                $("<label/>")
            )
        ).append(
            $("<div/>", {class:"infor_set issue01"}).append(
                $("<p/>", {id:"areaName"})
            ).append(
                $("<p/>", {id:"eventName"})
            ).append(
                $("<p/>", {id:"eventDatetime"})
            )
        ).append(
            $("<button/>", {href:"#", class:"infor_btn"}).append(
                $("<span/>")
            ).append(
                $("<span/>")
            )
        );

        /********************************************************************************
         * 토스트 팝업 template
         *********************************************************************************/
        var TOAST_POPUP_TEMPLATE = $("<div/>").append(
            $("<button/>", {href:"#", class:"tp_contents"}).append(
                $("<span/>", {id:"toastAreaName"})
            ).append(
                $("<span/>", {id:"toastEventDesc"})
            )
        ).append(
            $("<button/>", {href:"#", class:"btn_x", onclick:"javascript:$(this).parent().remove();"})
        );

        /********************************************************************************
         * 진출입 조회 template
         *********************************************************************************/
        var INOUT_TEMPLATE = $("<div/>").append(
            $("<p/>", {id:"gap"})
        ).append(
            $("<p/>", {id:"in"})
        ).append(
            $("<p/>", {id:"out"})
        ).append(
            $("<p/>", {id:"datetime"}).append(
                $("<em/>", {id:"dt"})
            ).append(
                $("<span/>", {id:"hms"})
            )
        );

        /********************************************************************************
         * 이벤트 통계 이벤트 추가 template
         *********************************************************************************/
        var STATISTICS_EVENT_TEMPLATE = $("<span/>").append(
            $("<input/>", {type:"text", name:"eventId", disabled:"disabled"})
        ).append(
            $("<button/>", {href:"#", class:"btn del"})
        );

        /********************************************************************************
         * 자원 모니터링 장치 template
         *********************************************************************************/
        var RESOURCE_DEVICE_TEMPLATE = $("<li/>").append(
            $("<p/>", {name:"resourceDeviceName"})
        ).append(
            $("<select/>", {name:"resourceEventId"}).append(
                $("<option/>",{value:''}).text("선택")
            )
        );

        /**
         * get template (동적생성 Tag)
         * @author psb
         */
        this.getTemplate = function(target){
            var _returnTag = null;

            switch (target) {
                case "notification":
                    _returnTag = NOTIFICATION_CONTENT_TEMPLATE.clone();
                    break;
                case "toast":
                    _returnTag = TOAST_POPUP_TEMPLATE.clone();
                    break;
                case "inout":
                    _returnTag = INOUT_TEMPLATE.clone();
                    break;
                case "statisticsEvent":
                    _returnTag = STATISTICS_EVENT_TEMPLATE.clone();
                    break;
                case "resourceDevice":
                    _returnTag = RESOURCE_DEVICE_TEMPLATE.clone();
                    break;
            }

            if(_returnTag==null){
                console.error("[TemplateHelper][getTemplate] not found template id - " + target);
            }

            return _returnTag;
        };
    }
);