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
            $("<div/>").addClass("check_box_set").append(
                $("<input/>").addClass("check_input").attr("type","checkbox")
            ).append(
                $("<label/>").addClass("lablebase lb_style01")
            )
        ).append(
            $("<div/>").addClass("dbc_contents issue01").append(
                $("<div/>").append(
                    $("<p/>").attr("id","eventName")
                ).append(
                    $("<p/>").attr("id","eventDesc")
                )
            ).append(
                $("<div/>").append(
                    $("<p/>").attr("id","areaName")
                ).append(
                    $("<span/>").attr("id","eventDesc")
                ).append(
                    $("<span/>").attr("id","eventDatetime")
                )
            )
        ).append(
            $("<button/>").addClass("infor_open").attr("href","#")
        );

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
            }

            if(_returnTag==null){
                console.error("[TemplateHelper][getTemplate] not found template id - " + target);
            }

            return _returnTag;
        };
    }
);