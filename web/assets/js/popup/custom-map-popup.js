/**
 * Custom Map Popup
 * 오프라인 맵 팝업제어
 *
 * @author psb
 * @type {Function}
 */
var CustomMapPopup = (
    function(rootPath, version){
        var _rootPath;
        var _version;
        var _urlConfig = {
            fileListUrl : "/file/mapList.json"
            ,saveUrl : "/customMapLocation/save.json"
        };
        var _markerClass = {
            'area' : "area"
            ,"DEV013" : "m8"
            ,"DEV002" : "camera"
        };
        var _areaId = null;
        var _customMapMediator;
        var _messageConfig;
        var _element;
        var _self = this;

        /**
         * initialize
         */
        var initialize = function(rootPath, version){
            _rootPath = rootPath;
            _version = version;
            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
            console.log('[CustomMapPopup] initialize complete');
        };

        /**
         * init file list
         * @author psb
         */
        this.initFileList = function(){
            _ajaxCall('fileList', {useYn:'Y'});
        };

        /**
         * set target
         * @author psb
         */
        this.setElement = function(element){
            _element = element;
        };

        /**
         * set message config
         * @author psb
         */
        this.setMessageConfig = function(messageConfig){
            _messageConfig = messageConfig;
        };

        /**
         * save setting
         * @author psb
         */
        this.save = function(){
            if(!_customMapMediator || !_customMapMediator instanceof CustomMapMediator){
                console.error("[CustomMapPopup] save failure - customMapMediator is null or typeerror");
                return false;
            }

            var customList = _customMapMediator.getMarkerList('custom');
            var customParamList = [];

            for(var index in customList){
                var customMap = $.extend({}, customList[index]['data']);
                customMap['areaId'] = _areaId;
                customParamList.push(customMap);
            }

            var fenceList = _customMapMediator.getMarkerList('fence');
            var fenceParamList = [];
            for(var index in fenceList){
                fenceParamList.push($.extend({}, fenceList[index]['data']));
            }
            if(confirm(_messageConfig['saveConfirmMessage'])){
                _ajaxCall('save', {areaId:_areaId, fileId:_element.find("#fileId").val(), customParamList:JSON.stringify(customParamList), fenceParamList:JSON.stringify(fenceParamList)});
            }
        };

        /**
         * open popup
         * @author psb
         */
        this.openPopup = function(areaId,areaName,fileId){
            if(templateSettingPopup.getSettingValue('safeGuardMapView')!="offline"){
                alert("Map 설정은 Offline Map만 지원 가능합니다.");
                return false;
            }

            if(areaId==null || areaId==""){
                console.error("[CustomMapPopup][openPopup] areaId is null");
                return false;
            }
            _element.find("#areaName").text(areaName);
            _element.fadeIn();

            if(_areaId!=areaId){
                _areaId = areaId;
                _customMapMediator = new CustomMapMediator(_rootPath,_version);
                try{
                    _customMapMediator.setElement(_element.find("#mapElement"));
                    _customMapMediator.setMessageConfig(_messageConfig);
                    _customMapMediator.init(areaId,{
                        'draggable' : true
                        ,'resizable' : true
                        ,'fenceView':true
                        ,'onLoad' : function(actionType,data){
                            switch (actionType){
                                case 'childList' :
                                    _element.find("#childList").empty();
                                    for(var index in data){
                                        var target = data[index];
                                        _element.find("#childList").append(
                                            $("<li/>",{targetId:target['targetId'],deviceCode:target['deviceCode']}).append(
                                                $("<button/>").text(target['targetName']).addClass(_markerClass[target['deviceCode']]).on("click",function(){
                                                    _customMapMediator.targetRender({targetId:$(this).parent().attr("targetId"), deviceCode:$(this).parent().attr("deviceCode")});
                                                })
                                            ).append(
                                                $("<div/>").append(
                                                    $("<input/>",{type:'checkbox',name:'useYn',checked:target['useYn']=='Y'?true:false}).on("click",function(){
                                                        var targetId = $(this).parent().parent().attr("targetId");
                                                        _checkChildTarget(targetId, $(this).is(":checked"));
                                                    })
                                                ).append(
                                                    $("<label/>")
                                                )
                                            )
                                        );
                                        _customMapMediator.targetRender(target);
                                    }
                                    break;
                                case 'fenceList' :
                                    _element.find("#fenceList").empty();
                                    for(var index in data){
                                        var fence = data[index];
                                        var fenceName = fence['fenceName']!=null?fence['fenceName']:fence['fenceId'];
                                        _element.find("#fenceList").append(
                                            $("<li/>",{fenceId:fence['fenceId']}).append(
                                                $("<input/>",{type:'text',name:'fenceName',value:fenceName}).on("change",function(){
                                                    _customMapMediator.saveFence($(this).parent().attr("fenceId"), $(this).val());
                                                })
                                            ).append(
                                                $("<div/>").text(fence['fenceId'])
                                            )
                                        );
                                        _customMapMediator.saveMarker('fence', fence['fenceId'], fence['locations'], {uuid:fence['uuid'], 'fenceName':fenceName});
                                    }
                                    break;
                            }
                        }
                        ,'change' : function(data){
                            _checkChildTarget(data['targetId'], data['useYn']=='Y'?true:false);
                            _updateTargetValue(data);
                        }
                    });
                }catch(e){
                    console.error("[CustomMapPopup][openPopup] custom map mediator init error - "+ e.message);
                }
            }
            _element.find("#fileId").val(fileId).prop("selected",true);
        };

        /**
         * close popup
         * @author psb
         */
        this.getCustomMapMediator = function(){
            return _customMapMediator;
        };

        /**
         * close popup
         * @author psb
         */
        this.closePopup = function(){
            _element.fadeOut();
        };

        /**
         * File List Render
         * @author psb
         */
        var fileListRender = function(data,fileUploadPath){
            _element.find("#fileId option").not(":eq(0)").remove();
            for(var index in data){
                _element.find("#fileId").append(
                    $("<option/>",{value:data[index]['fileId'], physicalFileName:data[index]['physicalFileName']}).text(data[index]['title'])
                )
            }
            _element.find("#fileId").on("change",function(){
                if(_customMapMediator!=null){
                    _customMapMediator.setBackgroundImage($(this).find("option:selected").attr("physicalFileName"));
                }
            });
        };

        /**
         * set Target Value
         * @author psb
         */
        this.setTargetValue = function(_this){
            var targetId = _element.find("#childList button.on").parent().attr("targetId");
            if(targetId==null){
                return false;
            }

            var param = {
                'x1' : Number(_element.find("input[name='x1']").val())
                ,'x2' : Number(_element.find("input[name='x2']").val())
                ,'y1' : Number(_element.find("input[name='y1']").val())
                ,'y2' : Number(_element.find("input[name='y2']").val())
            };
            _customMapMediator.setTargetData(targetId, param);
        };

        /**
         * chlid list click event
         * @author psb
         */
        var _updateTargetValue = function(data){
            _element.find("input[name='x1']").val(data['x1']);
            _element.find("input[name='x2']").val(data['x2']);
            _element.find("input[name='y1']").val(data['y1']);
            _element.find("input[name='y2']").val(data['y2']);
        };

        /**
         * chlid list click event
         * @author psb
         */
        var _checkChildTarget = function(targetId, flag){
            var resultFlag = _customMapMediator.setDisplayTarget(targetId,flag);
            if(!resultFlag){
                _element.find("#childList li[targetId='"+targetId+"'] button").removeClass("on");
                _element.find("#childList li[targetId='"+targetId+"'] input[name='useYn']").prop("checked",false);
            }else{
                _element.find("#childList button").removeClass("on");
                _element.find("#childList li[targetId='"+targetId+"'] button").addClass("on");
                _element.find("#childList li[targetId='"+targetId+"'] input[name='useYn']").prop("checked",true);
            }
        };

        /**
         * ajax call
         * @author psb
         */
        var _ajaxCall = function(actionType, data){
            sendAjaxPostRequest(_urlConfig[actionType+'Url'],data,_successHandler,_failureHandler,actionType);
        };

        /**
         * success handler
         * @author psb
         */
        var _successHandler = function(data, dataType, actionType){
            switch(actionType){
                case 'fileList':
                    fileListRender(data['files'],data['fileUploadPath']);
                    break;
                case 'save':
                    _alertMessage(actionType + 'Complete');
                    if(resourceHelper && resourceHelper instanceof ResourceHelper){
                        resourceHelper.refreshList();
                    }
                    _self.closePopup();
                    break;
                default :
            }
        };

        /**
         * failure handler
         * @author psb
         */
        var _failureHandler = function(XMLHttpRequest, textStatus, errorThrown, actionType){
            if(XMLHttpRequest['status']!="0"){
                _alertMessage(actionType + 'Failure');
            }
        };

        /**
         * alert message method
         * @author psb
         */
        var _alertMessage = function(type){
            alert(_messageConfig[type]);
        };

        initialize(rootPath,version);
    }
);