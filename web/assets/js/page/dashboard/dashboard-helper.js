/**
 * Dashboard Helper
 *
 * @author psb
 * @type {Function}
 */
var DashboardHelper = (
    function(){
        var _this = this;

        // append area target
        var _target;

        // area data model
        var _model;

        // template resource
        var _resource;

        // config
        var _config = {
            'sensorIcon' : {
                'safeeye' : ['DEV001','DEV002','DEV003','DEV004']
                , 'nhr' : ['DEV900','DEV901','DEV902','DEV903','DEV904','DEV905','DEV906']
                , 'blinker' : ['DEV009']
            }
            ,'retryExternalCount':50
            ,'retryExternalDeley':500
        };

        /**
         * Dashboard Helper initialize
         */
        this.initialize = function(target, model, resource){
            if(!target || typeof target.length == 0){
                console.warn('[DashboardHelper] initialize warnning - target is null or not found');
            }else{
                _target = target;
            }

            if(!model || typeof model != 'object'){
                console.warn('[DashboardHelper] initialize warnning - model is null or typeerror');
            }else{
                _model = model;
            }

            if(!resource || !resource instanceof DashboardResource){
                console.warn('[DashboardHelper] initialize warnning - resource typeerror');
            }else{
                _resource = resource;
            }
            console.log('[DashboardHelper] initialize complete');
        };

        /**
         * setting template
         */
        this.setTrefficTemplate = function(template){
            if(!_resource || !_resource instanceof DashboardResource){
                console.warn('[DashboardHelper] setTrefficTemplate warnning - resource typeerror');
            }

            if(!template || typeof template != 'object'){
                console.warn('[DashboardHelper] setTrefficTemplate warnning - template is null or typeerror');
            }else{
                _resource.setTrefficTemplate(template);
            }
        };


        /**
         * draw area
         */
        this.areaRender = function(){
            _target.empty();
            _target.attr('class','watch_area');

            var modelLen = Object.keys(_model).length;
            if(modelLen==1){
                _target.addClass('area01');
            }else if(modelLen<=4){
                _target.addClass('area04');
            }else if(modelLen>=5 && modelLen<=6){
                _target.addClass('area06');
            }else if(modelLen>=7 && modelLen<=8){
                _target.addClass('area08');
            }else if(modelLen==9){
                _target.addClass('area09');
            }else if(modelLen>=10 && modelLen<=12){
                _target.addClass('area00');
            }else if(modelLen>=13){
                _target.addClass('area16');
            }

            for(var areaId in _model){
                var areaModel = _model[areaId];
                var baseTmp = _resource.getTemplate('base');
                baseTmp.attr("areaId",areaId);
                baseTmp.find("h3").text(areaModel['areaName']);

                switch (areaModel['templateCode']){
                    /**
                     * 신호등
                     */
                    case "TMP001":
                        if(areaModel['devices'] != null){
                            var sensorTmp = _resource.getTemplate('SENSOR');
                            var sensorYn = false;
                            for(var i in areaModel['devices']){
                                var device = areaModel['devices'][i];
                                for(var k in _config['sensorIcon']){
                                    if(_config['sensorIcon'][k].indexOf(device['deviceCode'])>-1 && sensorTmp.find(".ico-"+device['deviceCode']).length == 0){
                                        sensorTmp.find("> div").append(
                                            $("<span/>",{class:"ico-"+device['deviceCode']})
                                        );
                                        sensorYn = true;
                                    }
                                }
                            }

                            if(sensorYn){
                                baseTmp.find("header").append(sensorTmp);
                            }
                        }
                        baseTmp.find("article").append(_resource.getTemplate('TREFFIC_SECTION'));
                        break;
                    /**
                     * 감시구역 침입
                     */
                    case "TMP002":
                        baseTmp.addClass("type-list");
                        baseTmp.find("article").append(_resource.getTemplate('TREFFIC_SECTION').css("display","none"));
                        baseTmp.find("article").append(_resource.getTemplate('SAFEEYE_SECTION'));
                        break;
                    /**
                     * 전시물 보호
                     */
                    case "TMP003":
                        baseTmp.addClass("type-list");
                        baseTmp.find("article").append(_resource.getTemplate('TREFFIC_SECTION').css("display","none"));
                        baseTmp.find("article").append(_resource.getTemplate('EXHIBIT_SECTION'));
                        break;
                    /**
                     * 진출입
                     */
                    case "TMP004":
                        baseTmp.addClass("type-list");
                        var inoutSetBtnTmp = _resource.getTemplate('INOUT_SET_BUTTON');
                        inoutSetBtnTmp.attr("onclick","javascript:openInoutConfigListPopup('"+areaId+"','"+areaModel['areaName']+"'); return false;");
                        baseTmp.find("header").append(inoutSetBtnTmp);

                        var inoutSectionTmp = _resource.getTemplate('INOUT_SECTION');
                        inoutSectionTmp.find("div[areaId]").attr("areaId",areaId).attr("templateCode",areaModel['templateCode']);
                        var areaYn = false;
                        for(var i in areaModel['areas']){
                            var area = areaModel['areas'][i];
                            if(area['templateCode']=="TMP004"){
                                var inoutLiTmp = _resource.getTemplate('INOUT_LI');
                                inoutLiTmp.find("h3").text(area['areaName']);
                                inoutLiTmp.find(">div").attr("areaId",area['areaId']).attr("templateCode",area['templateCode']);
                                inoutSectionTmp.find(".s_rbox ul").append(inoutLiTmp);
                                areaYn = true;
                            }
                        }
                        if(!areaYn){
                            inoutSectionTmp.find(".s_rbox").remove();
                        }
                        baseTmp.find("article").append(inoutSectionTmp);
                        baseTmp.find("article").append(_resource.getTemplate('TREFFIC_SECTION').css("display","none"));
                        break;
                    /**
                     * NHR
                     */
                    case "TMP005":
                        baseTmp.addClass("type-list");

                        var nhrSectionTmp = _resource.getTemplate('NHR_SECTION');
                        nhrSectionTmp.find("div[dateSelType] button").attr("onclick","javascript:dateSelTypeClick('"+areaId+"', this); return false;");
                        nhrSectionTmp.find("div[chartAreaId]").attr("chartAreaId", areaId);
                        var deviceYn = false;
                        for(var i in areaModel['devices']){
                            var device = areaModel['devices'][i];
                            var nhrLiTmp = _resource.getTemplate('NHR_LI');
                            nhrLiTmp.attr("deviceId",device['deviceId']);
                            nhrLiTmp.append(_resource.getTemplate('TREFFIC_SECTION').css("display","none"));
                            nhrLiTmp.find("span:eq(0)").text(device['deviceCodeName']);
                            nhrLiTmp.on("click",function(){
                                if(!$(this).hasClass("on")){
                                    $(this).parent().find("li").removeClass("on");
                                    $(this).addClass("on");
                                    updateChart(areaId, $(this).attr("deviceId"));
                                }
                            });
                            nhrSectionTmp.find("ul").append(nhrLiTmp);
                            deviceYn = true;
                        }
                        if(!deviceYn){
                            nhrSectionTmp.find(".s_rbox").remove();
                        }

                        baseTmp.find("article").append(nhrSectionTmp);
                        break;
                }

                if(areaModel['childAreaIds'].length > 0){
                    var areaBtnTmp = _resource.getTemplate('AREA_BUTTON');
                    areaBtnTmp.attr("childAreaIds",areaModel['childAreaIds']);
                    areaBtnTmp.attr("onclick","javascript:moveDashboard('"+areaId+"'); return false;");
                    baseTmp.find("header").append(areaBtnTmp);
                }

                baseTmp.find("article").append(_resource.getTemplate('MARQUEE_BOX'));
                _target.append(baseTmp);
            }
            console.log('[DashboardHelper] areaRender complete');
        };

        this._externalEventRecursion = function (id, type, data, count) {
            //if (this._externalEventHandler && typeof this._externalEventHandler == 'function') {
            //    this._externalEventHandler(this.id, type, data);
            //} else {
            //    if (count > 0) {
            //        var _this = this;
            //        console.log('[ChatMediator] _externalEventRecursion retry - ' + count);
            //        setTimeout(
            //            function () {
            //                _this._externalEventRecursion(id, type, data, count - 1);
            //            }
            //            , _config['retryExternalDeley']
            //        );
            //    } else {
            //        console.error('[ChatMediator] _externalEventRecursion failure - event handler is null');
            //    }
            //}
        };
    }
);