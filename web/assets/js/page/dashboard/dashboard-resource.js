/**
 * Dashboard Resource
 *
 * @author psb
 * @type {Function}
 */
var DashboardResource = (
    function(){
        /********************************************************************************
         * base template
         *********************************************************************************/
        var BASE_TEMPLATE = $("<div/>").append(
            $("<header/>").append(
                $("<h3/>")
            )
        ).append(
            $("<article/>")
        );

        /********************************************************************************
         * header template
         *********************************************************************************/
        var HEADER_TEMPLATE = {
            'SENSOR' : $("<div/>", {class:"in_sensor"}).append($("<div/>"))
            ,'AREA_BUTTON' : $("<button/>", {class:"area", title:"AREA VIEW"})
            ,'INOUT_SET_BUTTON' : $("<button/>", {class:"ioset", title:"진출입 설정"})
            ,'DATE_SELECT' : $("<button/>", {class:'date_select'}).append(
                    $("<select/>", {name:"dateSelType"}).append(
                        $("<option/>",{value:'day', selected:'selected'}).text("일")
                    ).append(
                        $("<option/>",{value:'week'}).text("주")
                    ).append(
                        $("<option/>",{value:'month'}).text("월")
                    ).append(
                        $("<option/>",{value:'year'}).text("년")
                    )
                )
        };

        /********************************************************************************
         * article template
         *********************************************************************************/
        var ARTICLE_TEMPLATE = {
            'TREFFIC_SECTION' : null
            ,'SAFEEYE_SECTION' : $("<section/>", {class:"safeeye_set"}).append(
                    $("<div/>", {class:"s_lbox ico-invasion"})
                ).append(
                    $("<div/>", {class:"s_rbox"}).append(
                        $("<ul/>").append(
                            $("<li/>", {class:"ico-speaker"})
                        ).append(
                            $("<li/>", {class:"ico-wlight"})
                        ).append(
                            $("<li/>", {class:"ico-mobile"})
                        )
                    )
                )
            ,'EXHIBIT_SECTION' : $("<section/>", {class:"safeeye_set"}).append(
                    $("<div/>", {class:"s_lbox ico-exhibit fittext"})
                ).append(
                    $("<div/>", {class:"s_rbox"}).append(
                        $("<ul/>").append(
                            $("<li/>", {class:"ico-speaker"})
                        ).append(
                            $("<li/>", {class:"ico-wlight"})
                        ).append(
                            $("<li/>", {class:"ico-mobile"})
                        )
                    )
                )
            ,'INOUT_SECTION' : $("<section/>", {class:"personnel_set"}).append(
                    $("<div/>", {class:"s_lbox blinker_set"}).append(
                        $("<h3/>", {class:"s_lbox"})
                    ).append(
                        $("<div/>", {areaId:'', inoutArea:''}).append(
                            $("<p/>",{gap:''}).text('0')
                        ).append(
                            $("<div/>").append(
                                $("<p/>",{in:''}).text('0')
                            ).append(
                                $("<p/>",{out:''}).text('0')
                            )
                        )
                    )
                ).append(
                    $("<div/>", {class:"s_rbox"}).append(
                        $("<ul/>", {'data-duplicated':'true', 'data-direction':'up'})
                    )
                )
            ,'NHR_SECTION' : $("<section/>", {class:"nhr_set"}).append(
                    $("<div/>", {class:"s_lbox"}).append(
                        $("<div/>", {class:'chart_select_set', dateSelType:''}).append(
                            $("<button/>",{value:'day', class:'on', href:"#"}).text("일")
                        ).append(
                            $("<button/>",{value:'week', href:"#"}).text("주")
                        ).append(
                            $("<button/>",{value:'month', href:"#"}).text("월")
                        ).append(
                            $("<button/>",{value:'year', href:"#"}).text("년")
                        )
                    ).append(
                        $("<div/>", {class:"chart_box chart01", chartAreaId:''})
                    )
                ).append(
                    $("<div/>", {class:"s_rbox"}).append(
                        $("<ul/>", {'nhrDeviceList':'', 'data-duplicated':'true', 'data-direction':'up'})
                    )
                )
            ,'MARQUEE_BOX' : $("<div/>", {class:"m_marqueebox"}).append(
                    $("<p/>", {messageBox:''})
                )
        };

        /********************************************************************************
         * article template
         *********************************************************************************/
        var APPEND_TEMPLATE = {
            'INOUT_LI' : $("<li/>", {class:"blinker_set", inoutArea:''}).append(
                    $("<h3/>", {class:"s_lbox"})
                ).append(
                    $("<div/>").append(
                        $("<p/>",{gap:''}).text('0')
                    ).append(
                        $("<div/>").append(
                            $("<p/>",{in:''}).text('0')
                        ).append(
                            $("<p/>",{out:''}).text('0')
                        )
                    )
                )
            ,'NHR_LI' : $("<li/>").append(
                    $("<span/>")
                ).append(
                    $("<span/>", {evtValue:''})
                )
        };

        /**
         * get template (동적생성 Tag)
         * @author psb
         */
        this.getTemplate = function(code){
            var _returnTag = null;

            if(code=='base'){
                _returnTag = BASE_TEMPLATE.clone();
            }else if(HEADER_TEMPLATE[code]!=null){
                _returnTag = HEADER_TEMPLATE[code].clone();
            }else if (ARTICLE_TEMPLATE[code]!=null){
                _returnTag = ARTICLE_TEMPLATE[code].clone();
            }else if (APPEND_TEMPLATE[code]!=null){
                _returnTag = APPEND_TEMPLATE[code].clone();
            }

            if(_returnTag==null){
                console.error("[DashboardView][getTemplate] not found code - "+code);
            }

            return _returnTag;
        };


        /**
         * set model
         */
        this.setTrefficTemplate = function(template){
            ARTICLE_TEMPLATE['TREFFIC_SECTION'] = template;
        };
    }
);