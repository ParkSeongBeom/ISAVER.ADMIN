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
        var ALARM_CONTENT_TEMPLATE = $("<li/>").append(
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
         * marquee 리스트 template
         *********************************************************************************/
        var MARQUEE_CONTENT_TEMPLATE = $("<button/>");

        /********************************************************************************
         * 토스트 팝업 template
         *********************************************************************************/
        var TOAST_POPUP_TEMPLATE = $("<div/>").append(
            $("<button/>", {href:"#", class:"btn_x", onclick:"javascript:$(this).parent().remove();"})
        ).append(
            $("<button/>", {href:"#", class:"tp_contents"}).append(
                $("<span/>", {id:"toastEventName"})
            ).append(
                $("<span/>", {id:"toastEventDesc"})
            )
        );

        /********************************************************************************
         * 작업자 상태, 크레인 상태 리스트 template
         *********************************************************************************/
        var EVENT_LIST_TEMPLATE = $("<li/>").append(
            $("<span/>", {id:"status"})
        ).append(
            $("<span/>", {id:"eventName"})
        ).append(
            $("<span/>", {id:"eventDatetime"})
        );

        /********************************************************************************
         * 진출입 조회 주기 설정 template
         *********************************************************************************/
        var INOUT_SETTING_TEMPLATE = $("<li/>").append(
            $("<span/>")
        ).append(
            $("<button/>", {href:"#"})
        );

        /**
         * get template (동적생성 Tag)
         * @author psb
         */
        this.getTemplate = function(target){
            var _returnTag = null;

            switch (target) {
                case "alarm01":
                    _returnTag = ALARM_CONTENT_TEMPLATE.clone();
                    break;
                case "marquee01":
                    _returnTag = MARQUEE_CONTENT_TEMPLATE.clone();
                    break;
                case "toast":
                    _returnTag = TOAST_POPUP_TEMPLATE.clone();
                    break;
                case "eventList":
                    _returnTag = EVENT_LIST_TEMPLATE.clone();
                    break;
                case "inoutSetting":
                    _returnTag = INOUT_SETTING_TEMPLATE.clone();
                    break;
            }

            if(_returnTag==null){
                console.error("[TemplateHelper][getTemplate] not found template id - " + target);
            }

            return _returnTag;
        };
    }
);