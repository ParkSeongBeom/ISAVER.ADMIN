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
            fileListUrl : "/file/list.json"
            ,saveUrl : "/customMapLocation/save.json"
            ,fenceDeviceListUrl : "/fenceDevice/list.json"
        };
        var _markerClass = {
            'area' : "ico-area"
            ,"DEV002" : "ico-ptz"
            ,"DEV006" : "ico-led"
            ,"DEV007" : "ico-speaker"
            ,"DEV008" : "ico-wlight"
            ,"DEV013" : "ico-m8"
            ,"DEV015" : "ico-qguard"
        };
        var _areaId = null;
        var _mouseDownInterval = 0;
        var _customMapMediator;
        var _messageConfig;
        var _cameraSelectTag;
        var _element;
        var _self = this;

        var _addFenceInfo = {
            'fence' : null
            , 'circleList' : []
            , 'points' : []
            , 'mapCanvas' : null
            , 'canvasSvg' : null
        };

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
            _ajaxCall('fileList', {'fileType':'FTA002','useYn':'Y'});

            _element.find("#angleClass").on("change",function(){
                if(_customMapMediator!=null){
                    _customMapMediator.setAngleXClass($(this).find("option:selected").val(),false);
                }
            });
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
         * 펜스 설정중 체크
         * @author psb
         */
        var validate = function(){
            if(_addFenceInfo['fence']!=null){
                _alertMessage("settingsInUsed");
                return false;
            }
            return true;
        };

        /**
         * save setting
         * @author psb
         */
        this.save = function(){
            if(!validate()){ return false; }

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

            var fenceList = _customMapMediator.getMarker('fence');
            var fenceParamList = [];
            for(var index in fenceList){
                for(var i in fenceList[index]){
                    var fenceMap = $.extend({}, fenceList[index][i]['data']);
                    fenceMap['areaId'] = _areaId;
                    fenceParamList.push(fenceMap);
                }
            }

            var fenceDeviceParamList = [];
            $.each(_element.find("button[name='fenceDevice']"),function(){
                fenceDeviceParamList.push({uuid:$(this).attr("uuid"),deviceId:$(this).attr("deviceId")})
            });

            if(confirm(_messageConfig['saveConfirmMessage'])){
                _ajaxCall('save', {
                    areaId:_areaId
                    , rotate:_element.find("#rotate").val()
                    , skewX:_element.find("#skewX").val()
                    , skewY:_element.find("#skewY").val()
                    , fileId:_element.find("#fileId").val()
                    , angleClass:_element.find("#angleClass").val()
                    , customList:JSON.stringify(customParamList)
                    , fenceList:JSON.stringify(fenceParamList)
                    , fenceDeviceList:JSON.stringify(fenceDeviceParamList)
                });
            }
        };

        /**
         * open popup
         * @author psb
         */
        this.openPopup = function(areaId,areaName){
            if(templateSettingPopup.getSettingValue('safeGuardMapView')!="offline"){
                _alertMessage("customMapSupport");
                return false;
            }

            if(areaId==null || areaId==""){
                console.error("[CustomMapPopup][openPopup] areaId is null");
                return false;
            }
            _element.find("#areaName").text(areaName);
            _element.find("#childList section").remove();
            _element.fadeIn();

            _areaId = areaId;
            _customMapMediator = new CustomMapMediator(_rootPath,_version);
            try{
                _customMapMediator.setElement(_element, _element.find("#mapElement"));
                _customMapMediator.setMessageConfig(_messageConfig);
                _customMapMediator.init(areaId,{
                    'custom' : {
                        'draggable': true
                        , 'resizable': true
                        , 'fenceView': true
                        , 'openLinkFlag': false
                        , 'lidarHideFlag' : true
                        , 'childListLoad': function (data) {
                            _element.find("#childList").empty();
                            _cameraSelectTag = $("<select/>", {name: "selCamera"}).append(
                                $("<option/>", {value: ""}).text("Choice Camera")
                            );

                            for (var index in data) {
                                var target = data[index];
                                if (target['deviceCode'] == "DEV002") {
                                    _cameraSelectTag.append(
                                        $("<option/>", {value: target['targetId']}).text(target['targetName'])
                                    );
                                }

                                var targetElement = $("<li/>", {
                                    targetId: target['targetId'],
                                    deviceCode: target['deviceCode']
                                }).append(
                                    $("<div/>", {name: "custom"}).append(
                                        $("<button/>").text(target['targetName']).addClass(_markerClass[target['deviceCode']]).click({
                                            targetId: target['targetId'],
                                            deviceCode: target['deviceCode']
                                        }, function (evt) {
                                            _customMapMediator.targetRender({
                                                targetId: evt.data.targetId,
                                                deviceCode: evt.data.deviceCode
                                            });
                                        })
                                    ).append(
                                        $("<div/>").append(
                                            $("<input/>", {
                                                type: 'checkbox',
                                                name: 'useYn',
                                                checked: target['useYn'] == 'Y'
                                            }).click({targetId: target['targetId']}, function (evt) {
                                                _checkChildTarget(evt.data.targetId, $(this).is(":checked"));
                                            })
                                        ).append(
                                            $("<label/>")
                                        )
                                    )
                                );
                                _element.find("#childList").append(targetElement);

                                if (target['deviceCode'] == "DEV013" && target['mainFlag'] == "Y" && targetElement.find("#addSection").length == 0) {
                                    targetElement.append(
                                        $("<section/>", {id: "addSection"}).append(
                                            $("<button/>", {class: "btn-add"}).click({deviceId: target['targetId']}, function (evt) {
                                                _self.addFence(null, evt.data.deviceId);
                                            })
                                        )
                                    );
                                }
                            }
                        }
                        , 'changeFence': function (actionType, data) {
                            switch (actionType) {
                                case 'add' :
                                    var targetTag = _element.find("#childList > li[targetId='" + data['deviceId'] + "']");
                                    var cameraSelectTag = _cameraSelectTag.clone();
                                    cameraSelectTag.attr("uuid", data['uuid']).on("change", function () {
                                        var selectedOption = $(this).find("option:selected");
                                        if (selectedOption.val() != "") {
                                            $(this).after(
                                                $("<div/>").append(
                                                    $("<button/>", {class: "btn-cam"}).text(selectedOption.text())
                                                ).append(
                                                    $("<button/>", {
                                                        class: "btn-del",
                                                        name: "fenceDevice",
                                                        uuid: $(this).attr("uuid"),
                                                        deviceId: selectedOption.val()
                                                    }).on("click", function () {
                                                        $(this).parent().parent().find("select option[value='" + $(this).attr("deviceId") + "']").prop("disabled", false);
                                                        $(this).parent().remove();
                                                    })
                                                )
                                            );
                                            selectedOption.prop("disabled", true);
                                        }
                                        $(this).val("");
                                    });

                                    var fenceElement = $("<section/>", {
                                        fenceId: data['fenceId'],
                                        deviceId: data['deviceId']
                                    }).append(
                                        $("<div/>", {class: "fence_list"}).append(
                                            $("<div/>", {class: "fence_title"}).append(
                                                $("<p/>").text(data['fenceId'])
                                            ).append(
                                                $("<button/>", {class: "btn-cut", fenceId:data['fenceId'], deviceId: data['deviceId']}).click({
                                                    fenceId: data['fenceId'],
                                                    deviceId: data['deviceId']
                                                }, function (evt) {
                                                    $(this).toggleClass("on");
                                                    $("div[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'].fence_cut").toggleClass("on");
                                                })
                                            ).append(
                                                $("<button/>", {class: "btn-edi"}).click({
                                                    fenceId: data['fenceId'],
                                                    deviceId: data['deviceId']
                                                }, function (evt) {
                                                    _self.addFence(evt.data.fenceId, evt.data.deviceId);
                                                })
                                            ).append(
                                                $("<button/>", {class: "btn-del"}).click({
                                                    fenceId: data['fenceId'],
                                                    deviceId: data['deviceId']
                                                }, function (evt) {
                                                    if (!validate()) {
                                                        return false;
                                                    }
                                                    _self.resetAddFenceInfo();
                                                    _customMapMediator.removeMarker('fence', {
                                                        deviceId: evt.data.deviceId,
                                                        id: evt.data.fenceId
                                                    });
                                                })
                                            )
                                        ).append(
                                            $("<div/>", {class: "fence_cut", fenceId:data['fenceId'], deviceId: data['deviceId']}).append(
                                                $("<div/>", {class:"tit_guide"}).append(
                                                    $("<span/>").text("Column")
                                                ).append(
                                                    $("<span/>").text("row")
                                                )
                                            ).append(
                                                $("<input/>", {
                                                    type: "text",
                                                    placeholder:"column",
                                                    name:"column",
                                                    value:"1",
                                                    maxLength:"3"}
                                                ).on("keypress",function(){isNumber(this);})
                                            ).append(
                                                $("<input/>", {
                                                    type: "text",
                                                    placeholder:"row",
                                                    name:"row",
                                                    value:"1",
                                                    maxLength:"3"}
                                                ).on("keypress",function(){isNumber(this);})
                                            ).append(
                                                $("<button/>", {class:"btn"}).click({
                                                    fenceId: data['fenceId'],
                                                    deviceId: data['deviceId']
                                                }, function (evt) {
                                                    var wCut = Number($("div[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'] input[name='column']").val());
                                                    var hCut = Number($("div[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'] input[name='row']").val());
                                                    if(wCut<=0 || hCut<=0){
                                                        _alertMessage("cutValueNotEnough");
                                                        return false;
                                                    }
                                                    _customMapMediator.fencePartition(evt.data.deviceId,evt.data.fenceId,{'w':wCut,'h':hCut});
                                                    $(".btn-cut[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"']").removeClass("on");
                                                    $("div[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'].fence_cut").removeClass("on");
                                                }).text("CUT")
                                            )
                                        ).append(
                                            $("<div/>", {class: "fence_name"}).append(
                                                $("<input/>", {
                                                    type: 'text',
                                                    name: 'fenceName',
                                                    value: data['fenceName'],
                                                    maxlength: "50"
                                                }).change({
                                                    deviceId: data['deviceId'],
                                                    fenceId: data['fenceId']
                                                }, function (evt) {
                                                    _customMapMediator.saveFence({deviceId:evt.data.deviceId, fenceId:evt.data.fenceId, fenceName:$(this).val()});
                                                })
                                            ).append(
                                                $("<input/>", {
                                                    type: 'text',
                                                    name: 'zMin',
                                                    value: (data['zMin']?data['zMin']:0),
                                                    maxLength:"10"
                                                }).on("keypress",function(){
                                                    isNumberWithPoint(this);
                                                }).change({
                                                    deviceId: data['deviceId'],
                                                    fenceId: data['fenceId']
                                                }, function (evt) {
                                                    _customMapMediator.saveFence({deviceId:evt.data.deviceId, fenceId:evt.data.fenceId, zMin:$(this).val()});
                                                })
                                            ).append(
                                                $("<select/>", {name: 'fenceType'}).append(
                                                    $("<option/>", {
                                                        value: 'normal',
                                                        selected: data['fenceType'] == 'normal'
                                                    }).text("normal")
                                                ).append(
                                                    $("<option/>", {
                                                        value: 'ignore',
                                                        selected: data['fenceType'] == 'ignore'
                                                    }).text("ignore")
                                                ).change({
                                                    deviceId: data['deviceId'],
                                                    fenceId: data['fenceId']
                                                }, function (evt) {
                                                    _customMapMediator.saveFence({deviceId:evt.data.deviceId, fenceId:evt.data.fenceId, fenceType:$(this).val()});
                                                })
                                            )
                                        )
                                    ).append(
                                        $("<div/>", {class: "camera_list"}).append(cameraSelectTag)
                                    );
                                    fenceElement.insertBefore(targetTag.find("#addSection"));
                                    _ajaxCall("fenceDeviceList", {areaId: _areaId, uuid: data['uuid']});
                                    break;
                                case 'remove' :
                                    _element.find("#childList > li[targetId='" + data['deviceId'] + "'] section[fenceId='" + data['fenceId'] + "']").remove();
                                    break;
                            }
                        }
                        , 'change': function (data) {
                            _checkChildTarget(data['targetId'], data['useYn'] == 'Y');
                            _updateTargetValue(data);
                        }
                        , 'changeConfig': function (configName, data) {
                            switch (configName) {
                                case "skewX":
                                case "skewY":
                                case "rotate":
                                    _element.find("input[name='"+configName+"']").val(data);
                                    break;
                                case "fileId":
                                    _element.find("#fileId option[physicalFileName='"+data+"']").prop("selected",true);
                                    break;
                                case "angleClass":
                                    _element.find("#angleClass").val(data).prop("selected",true);
                                    break;
                            }
                        }
                    }
                });
            }catch(e){
                console.error("[CustomMapPopup][openPopup] custom map mediator init error - "+ e.message);
            }
        };

        /**
         * add fence
         * @author psb
         */
        this.addFence = function(fenceId, deviceId){
            if(!validate()){ return false; }
            if(_addFenceInfo['mapCanvas']==null){
                _addFenceInfo['mapCanvas'] = _customMapMediator.getMapCanvas();
            }
            if(_addFenceInfo['canvasSvg']==null){
                _addFenceInfo['canvasSvg'] = _customMapMediator.getCanvasSvg();
            }
            var uuid = null;
            if(fenceId==null){
                fenceId = uuid38();
            }
            var mouseOverUseFlag = false;

            _addFenceInfo['fenceMarker'] = _customMapMediator.getMarker('fence', {'deviceId':deviceId,'fenceId':fenceId});
            if(_addFenceInfo['fenceMarker']!=null){
                if(_addFenceInfo['fenceMarker']['element']!=null) _addFenceInfo['fenceMarker']['element'].hide();
                if(_addFenceInfo['fenceMarker']['textElement']!=null) _addFenceInfo['fenceMarker']['textElement'].hide();
                uuid = _addFenceInfo['fenceMarker']['data']['uuid'];
                deviceId = _addFenceInfo['fenceMarker']['data']['deviceId'];
            }else{
                uuid = uuid32();
            }

            var fence = _addFenceInfo['canvasSvg'].polygon([],{"fenceId":fenceId});
            _addFenceInfo['fence'] = $(fence);
            _addFenceInfo['mapCanvas'].parent().addClass("cursor_cros");
            $(".fenceset_popup").addClass("on");

            _addFenceInfo['mapCanvas'].find("svg").on("mousemove", function(event){
                const point = [event.offsetX,event.offsetY];
                if(_addFenceInfo['points'].length>0){
                    if(mouseOverUseFlag){
                        _addFenceInfo['points'].push(point);
                        mouseOverUseFlag = false;
                    }else{
                        _addFenceInfo['points'][_addFenceInfo['points'].length-1] = point;
                    }
                    _addFenceInfo['fence'].attr("points",_addFenceInfo['points'].join(" "));
                }
            }).on("mouseup", function(event){
                if (event.which==1) {
                    const point = [event.offsetX,event.offsetY];
                    if(_addFenceInfo['points'].length>0){
                        _addFenceInfo['points'][_addFenceInfo['points'].length-1] = point;
                    }else{
                        _addFenceInfo['points'].push(point);
                    }
                    var circle = _addFenceInfo['canvasSvg'].circle(event.offsetX,event.offsetY,2);
                    _addFenceInfo['circleList'].push($(circle));
                    _addFenceInfo['fence'].attr("points",_addFenceInfo['points'].join(" "));
                    mouseOverUseFlag = true;
                }
            }).on("dblclick", function(event){
                if(_addFenceInfo['points'].length<3){
                    _alertMessage("fenceNotEnough");
                    return false;
                }
                _customMapMediator.addMarker('fence',{
                    "deviceId":deviceId
                    ,"uuid":uuid
                    ,"id":fenceId
                    ,"fenceType":_addFenceInfo['fenceMarker']!=null?_addFenceInfo['fenceMarker']['data']['fenceType']:'normal'
                    ,"location":_customMapMediator.convertFenceLocationOrigin(deviceId,_addFenceInfo['points'])
                });
                _self.resetAddFenceInfo();
                event.stopPropagation();
            });
        };

        /**
         * 구역 환경 설정 (이미지 회전/기울기)
         * @author psb
         */
        this.setImageConfig = function(settingType, actionType, deg, continueFlag){
            _customMapMediator.setImageConfig(settingType, actionType, deg);
            if(continueFlag!=null && continueFlag){
                _mouseDownInterval = setInterval(function(){
                    _self.setImageConfig(settingType, actionType);
                }, 100);
            }
        };

        this.stopMouseDownInterval = function(){
            clearInterval(_mouseDownInterval);
        };

        this.removePointFence = function(){
            if(_addFenceInfo['points'][_addFenceInfo['points'].length-1]!=null){
                _addFenceInfo['points'].splice(-1,1);
                _addFenceInfo['fence'].attr("points",_addFenceInfo['points'].join(" "));
            }

            if(_addFenceInfo['circleList'][_addFenceInfo['circleList'].length-1]!=null){
                _addFenceInfo['circleList'][_addFenceInfo['circleList'].length-1].remove();
                _addFenceInfo['circleList'].splice(-1,1);
            }
        };

        this.resetAddFenceInfo = function(){
            if(_addFenceInfo['mapCanvas']!=null){
                _addFenceInfo['mapCanvas'].parent().removeClass("cursor_cros");
                _addFenceInfo['mapCanvas'].find("svg").off("mousedown mousemove mouseup dblclick");
            }
            for(var index in _addFenceInfo['circleList']){
                _addFenceInfo['circleList'][index].remove();
            }
            if(_addFenceInfo['fence']!=null){
                _addFenceInfo['fence'].remove();
            }
            if(_addFenceInfo['fenceMarker']!=null){
                if(_addFenceInfo['fenceMarker']['element']!=null) _addFenceInfo['fenceMarker']['element'].show();
                if(_addFenceInfo['fenceMarker']['textElement']!=null) _addFenceInfo['fenceMarker']['textElement'].show();
            }
            $(".fenceset_popup").removeClass("on");
            _addFenceInfo['fence'] = null;
            _addFenceInfo['circleList'] = [];
            _addFenceInfo['points'] = [];
        };

        /**
         * close popup
         * @author psb
         */
        this.closePopup = function(){
            _self.resetAddFenceInfo();
            if(_addFenceInfo['mapCanvas']!=null){
                _addFenceInfo['mapCanvas'] = null;
            }
            if(_addFenceInfo['canvasSvg']!=null){
                _addFenceInfo['canvasSvg'] = null;
            }
            _element.fadeOut();
        };

        /**
         * File List Render
         * @author psb
         */
        var fileListRender = function(data){
            _element.find("#fileId option").not(":eq(0)").remove();
            for(var index in data){
                _element.find("#fileId").append(
                    $("<option/>",{value:data[index]['fileId'], physicalFileName:data[index]['physicalFileName']}).text(data[index]['title'])
                )
            }
            _element.find("#fileId").on("change",function(){
                if(_customMapMediator!=null){
                    _customMapMediator.setBackgroundImage($(this).find("option:selected").attr("physicalFileName"),false);
                }
            });
        };

        /**
         * set Target Value
         * @author psb
         */
        this.setTargetValue = function(_this){
            var targetId = _element.find("#childList button.on").parent().parent().attr("targetId");
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
                _element.find("#childList li[targetId='"+targetId+"'] div[name='custom'] button").removeClass("on");
                _element.find("#childList li[targetId='"+targetId+"'] div[name='custom'] input[name='useYn']").prop("checked",false);
            }else{
                _element.find("#childList button").removeClass("on");
                _element.find("#childList li[targetId='"+targetId+"'] div[name='custom'] button").addClass("on");
                _element.find("#childList li[targetId='"+targetId+"'] div[name='custom'] input[name='useYn']").prop("checked",true);
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
                    fileListRender(data['files']);
                    break;
                case 'save':
                    _alertMessage(actionType + 'Complete');
                    if(resourceHelper && resourceHelper instanceof ResourceHelper){
                        resourceHelper.refreshList();
                    }
                    _self.closePopup();
                    break;
                case 'fenceDeviceList':
                    for(var index in data['fenceDeviceList']){
                        var fenceDevice = data['fenceDeviceList'][index];
                        _element.find("section[fenceId='"+fenceDevice['fenceId']+"']").find("select[name='selCamera']").val(fenceDevice['deviceId']).trigger("change");
                    }
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