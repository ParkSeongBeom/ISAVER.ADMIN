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
        var ALRAM_CONTENT_TEMPLATE = $("<li/>").append(
            $("<div/>", {class:"check_box_set"}).append(
                $("<input/>", {type:"checkbox" ,class:"check_input"})
            ).append(
                $("<label/>", {class:"lablebase lb_style01"})
            )
        ).append(
            $("<div/>", {class:"dbc_contents"}).append(
                $("<div/>").append(
                    $("<p/>", {id:"eventType"})
                ).append(
                    $("<p/>", {id:"eventName"})
                )
            ).append(
                $("<div/>").append(
                    $("<p/>", {id:"areaName"})
                ).append(
                    $("<span/>", {id:"eventDatetime"})
                )
            )
        ).append(
            $("<button/>", {href:"#", class:"infor_open"})
        );

        /********************************************************************************
         * marquee 리스트 template
         *********************************************************************************/
        var MARQUEE_CONTENT_TEMPLATE = $("<button/>");

        /**
         * get template (동적생성 Tag)
         * @author psb
         */
        this.getTemplate = function(target){
            var _returnTag = null;

            switch (target) {
                case "alram01":
                    _returnTag = ALRAM_CONTENT_TEMPLATE.clone();
                    break;
                case "marquee01":
                    _returnTag = MARQUEE_CONTENT_TEMPLATE.clone();
                    break;
            }

            if(_returnTag==null){
                console.error("[TemplateHelper][getTemplate] not found template id - " + target);
            }

            return _returnTag;
        };
    }
);