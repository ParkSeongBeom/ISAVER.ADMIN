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
            ,"DEV019" : "ico-qguard"
            ,"DEV020" : "ico-m8"
        };
        var _options = {
            "initFenceListShow" : true
        };
        // 라이다 메인장치 코드
        var _mainDeviceCode = ['DEV013','DEV020'];
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
            , 'text' : null
            , 'lineTextList' : []
            , 'mode' : 'normal'
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

            _element.on("click",function(event){
                if (!$(event.target).closest(".fence_cut, .btn-cut").length) {
                    $(".btn-cut").removeClass("on");
                    $(".fence_cut").removeClass("on");
                }
                if (!$(event.target).closest(".fence_tarea, .btn-tarea").length) {
                    $(".btn-tarea").removeClass("on");
                    $(".fence_tarea").removeClass("on");
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
         * set message config
         * @author psb
         */
        this.getImagePoint = function(width, height, cutX, cutY){
            _customMapMediator.getImagePoint(width, height, cutX, cutY);
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

            var fenceList = _customMapMediator.getMarkerList('fence');
            var fenceParamList = [];
            for(var index in fenceList){
                for(var i in fenceList[index]){
                    var fenceMap = $.extend({}, fenceList[index][i]['data']);
                    if(fenceMap['config']!=null && fenceMap['config']!=''){
                        try{
                            JSON.parse(fenceMap['config']);
                        }catch(e){
                            alert("[CustomMapPopup] save json parse error");
                            console.error("[CustomMapPopup] save json parse error string - " + fenceMap['config']);
                            return false;
                        }
                    }
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
                    'element' : {
                        'lastPositionSaveFlag' : true
                    }, 'custom' : {
                        'draggable': true
                        , 'rotatable': true
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
                                            _customMapMediator.targetRender({targetId: evt.data.targetId,deviceCode: evt.data.deviceCode});
                                        })
                                    ).append(
                                        $("<div/>").append(
                                            $("<input/>", {
                                                type: 'checkbox',
                                                name: 'useYn',
                                                checked: target['useYn'] == 'Y'
                                            }).click({targetId: target['targetId']}, function (evt) {
                                                _customMapMediator.setDisplayTarget(evt.data.targetId,$(this).is(":checked"));
                                            })
                                        ).append(
                                            $("<label/>")
                                        )
                                    )
                                ).append(
                                    $("<div/>", {class: "uplist"}).append(
                                        $("<button/>",{class:'ico-up'+(_options['initFenceListShow']?' on':'')}).click(function (evt) {
                                            $(this).toggleClass("on");
                                            $(this).parent().parent().find("section").toggleClass("on");
                                        })
                                    )
                                );
                                _element.find("#childList").append(targetElement);

                                console.log(target['deviceCode'], _mainDeviceCode.indexOf(target['deviceCode'])>-1, target['mainFlag'] == "Y");
                                if (_mainDeviceCode.indexOf(target['deviceCode'])>-1 && target['mainFlag'] == "Y" && targetElement.find("#addSection").length == 0) {
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
                                        deviceId: data['deviceId'],
                                        class:_options['initFenceListShow']?"on":""
                                    }).append(
                                        $("<div/>", {class: "fence_list"}).append(
                                            $("<div/>", {class: "fence_title"}).append(
                                                $("<p/>").text(data['fenceId'])
                                            ).append(
                                                $("<button/>", {class: "btn-tarea", title:"Configuration"}).click({
                                                    fenceId: data['fenceId'],
                                                    deviceId: data['deviceId']
                                                }, function (evt) {
                                                    $(this).toggleClass("on");
                                                    $("section[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'] .fence_tarea").toggleClass("on");
                                                })
                                            ).append(
                                                $("<button/>", {class: "btn-cut", title:"Cutting"}).click({
                                                    fenceId: data['fenceId'],
                                                    deviceId: data['deviceId']
                                                }, function (evt) {
                                                    $(this).toggleClass("on");
                                                    $("section[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'] .fence_cut").toggleClass("on");
                                                })
                                            ).append(
                                                $("<button/>", {class: "btn-edi", title:"Modify"}).click({
                                                    fenceId: data['fenceId'],
                                                    deviceId: data['deviceId']
                                                }, function (evt) {
                                                    _self.addFence(evt.data.fenceId, evt.data.deviceId);
                                                })
                                            ).append(
                                                $("<button/>", {class: "btn-del", title:"Delete"}).click({
                                                    fenceId: data['fenceId'],
                                                    deviceId: data['deviceId']
                                                }, function (evt) {
                                                    if (!validate()) {
                                                        return false;
                                                    }
                                                    _customMapMediator.removeMarker('fence', {
                                                        deviceId: evt.data.deviceId,
                                                        id: evt.data.fenceId
                                                    });
                                                })
                                            )
                                        ).append(
                                            $("<div/>", {class: "fence_tarea"}).append(
                                                $("<p/>").text("Fence Config")
                                            ).append(
                                                $("<textarea/>", {name:"config", class:"textboard"}).change({
                                                    deviceId: data['deviceId'],
                                                    fenceId: data['fenceId']
                                                }, function (evt) {
                                                    let paramData = {deviceId:evt.data.deviceId, fenceId:evt.data.fenceId, config:$(this).val()};
                                                    if(!_customMapMediator.computePolyPoints(paramData)){
                                                        _customMapMediator.saveFence(paramData);
                                                    }
                                                }).text((data['config']?data['config']:""))
                                            )
                                        ).append(
                                            $("<div/>", {class: "fence_cut"}).append(
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
                                                    var wCut = Number($("section[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'] input[name='column']").val());
                                                    var hCut = Number($("section[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'] input[name='row']").val());
                                                    if(wCut<=0 || hCut<=0){
                                                        _alertMessage("cutValueNotEnough");
                                                        return false;
                                                    }
                                                    _customMapMediator.fencePartition(evt.data.deviceId,evt.data.fenceId,{'w':wCut,'h':hCut});
                                                    $("section[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'] .btn-cut").removeClass("on");
                                                    $("section[deviceId='"+evt.data.deviceId+"'][fenceId='"+evt.data.fenceId+"'] .fence_cut").removeClass("on");
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
                                                    let paramData = {deviceId:evt.data.deviceId, fenceId:evt.data.fenceId, fenceName:$(this).val()};
                                                    if(!_customMapMediator.computePolyPoints(paramData)){
                                                        _customMapMediator.saveFence(paramData);
                                                    }
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
                                                    let paramData = {deviceId:evt.data.deviceId, fenceId:evt.data.fenceId, zMin:$(this).val()};
                                                    if(!_customMapMediator.computePolyPoints(paramData)){
                                                        _customMapMediator.saveFence(paramData);
                                                    }
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
                                                    let paramData = {deviceId:evt.data.deviceId, fenceId:evt.data.fenceId, fenceType:$(this).val()};
                                                    if(!_customMapMediator.computePolyPoints(paramData)){
                                                        _customMapMediator.saveFence(paramData);
                                                    }
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
                            _element.find("#childList div[name='custom'] button").removeClass("on");
                            _element.find("#childList li[targetId='"+data['targetId']+"'] div[name='custom'] button").addClass("on");
                            _customMapMediator.setSelectTarget(data['targetId']);
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
                                    if(data!=null){
                                        _element.find("#fileId option[physicalFileName='"+data+"']").prop("selected",true);
                                    }else{
                                        _element.find("#fileId").val("");
                                    }
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
            var ratio = _customMapMediator.getRatio();
            var uuid = null;
            if(fenceId==null){
                fenceId = uuid38();
            }
            var mouseOverUseFlag = false;

            _addFenceInfo['fenceMarker'] = _customMapMediator.getMarker('fence', {'deviceId':deviceId,'fenceId':fenceId});
            if(_addFenceInfo['fenceMarker']!=null){
                if(_addFenceInfo['fenceMarker']['element']!=null) _addFenceInfo['fenceMarker']['element'].hide();
                if(_addFenceInfo['fenceMarker']['textElement']!=null) _addFenceInfo['fenceMarker']['textElement'].hide();
                if(_addFenceInfo['fenceMarker']['circleElement']!=null) _addFenceInfo['fenceMarker']['circleElement'].hide();
                if(_addFenceInfo['fenceMarker']['polylineElement']!=null) _addFenceInfo['fenceMarker']['polylineElement'].hide();
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
                if(_addFenceInfo['mode']=='normal'){
                    const point = [event.offsetX,event.offsetY];
                    if(_addFenceInfo['points'].length>0){
                        if(mouseOverUseFlag){
                            _addFenceInfo['points'].push(point);
                            mouseOverUseFlag = false;
                        }else{
                            _addFenceInfo['points'][_addFenceInfo['points'].length-1] = point;
                        }
                        _addFenceInfo['fence'].attr("points",_addFenceInfo['points'].join(" "));

                        if(_addFenceInfo['points'].length>1){
                            var x = Math.abs(point[0]-_addFenceInfo['points'][_addFenceInfo['points'].length-2][0]);
                            var y = Math.abs(point[1]-_addFenceInfo['points'][_addFenceInfo['points'].length-2][1]);
                            var gap = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
                            if(_addFenceInfo['text']==null){
                                const svgText = _addFenceInfo['canvasSvg'].text(point[0], point[1], (gap/ratio).toFixed(1)+"m", {'text-anchor': "end", 'fill': "white", 'font-size': "5px"});
                                _addFenceInfo['text'] = $(svgText);
                            }else{
                                _addFenceInfo['text'].attr({"x":point[0],"y":point[1]}).text((gap/ratio).toFixed(1)+"m")
                            }
                        }
                    }
                }else{
                    _addFenceInfo['points'] = [];
                    var customWidth = Number($("#customFenceWidth").val());
                    var customHeight = Number($("#customFenceHeight").val());
                    _addFenceInfo['points'].push([event.offsetX,event.offsetY]);
                    _addFenceInfo['points'].push([event.offsetX,event.offsetY+(customHeight*ratio)]);
                    _addFenceInfo['points'].push([event.offsetX+(customWidth*ratio),event.offsetY+(customHeight*ratio)]);
                    _addFenceInfo['points'].push([event.offsetX+(customWidth*ratio),event.offsetY]);
                    _addFenceInfo['fence'].attr("points",_addFenceInfo['points'].join(" "));
                }
            }).on("mouseup", function(event){
                if (event.which==1 && _addFenceInfo['mode']=='normal') {
                    const point = [event.offsetX,event.offsetY];
                    if(_addFenceInfo['points'].length>0){
                        _addFenceInfo['points'][_addFenceInfo['points'].length-1] = point;
                    }else{
                        _addFenceInfo['points'].push(point);
                    }

                    if(_addFenceInfo['points'].length>1){
                        var x = Math.abs(point[0]-_addFenceInfo['points'][_addFenceInfo['points'].length-2][0]);
                        var y = Math.abs(point[1]-_addFenceInfo['points'][_addFenceInfo['points'].length-2][1]);
                        var gap = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
                        const svgText = _addFenceInfo['canvasSvg'].text(
                            (point[0]+_addFenceInfo['points'][_addFenceInfo['points'].length-2][0])/2
                            , (point[1]+_addFenceInfo['points'][_addFenceInfo['points'].length-2][1])/2
                            , (gap/ratio).toFixed(1)+"m"
                            , {'text-anchor': "middle", 'fill': "white", 'font-size': "5px"});
                        _addFenceInfo['lineTextList'].push($(svgText));
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

                if(_addFenceInfo['fenceMarker']!=null){
                    _customMapMediator.computePolyPoints({deviceId:deviceId, fenceId:fenceId});
                }
                _customMapMediator.addMarker('fence',{
                    "deviceId":deviceId
                    ,"uuid":uuid
                    ,"id":fenceId
                    ,"fenceType":_addFenceInfo['fenceMarker']!=null?_addFenceInfo['fenceMarker']['data']['fenceType']:'normal'
                    ,"location":_customMapMediator.convertFenceLocationOrigin(deviceId,uniqArrayList(_addFenceInfo['points']))
                });
                _self.resetAddFenceInfo(true);
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

        /**
         * 펜스 그리기 모드 설정 (normal/custom)
         * @author psb
         */
        this.changeFenceMode = function(){
            _self.resetAddFenceInfo(false);
            $(".fencebtn_set").toggleClass('custom-mode');
            _addFenceInfo['mode'] = $(".fencebtn_set").hasClass("custom-mode")?'custom':'normal';
        };

        /**
         * 펜스 그리기 마지막 포인트 제거
         * @author psb
         */
        this.removePointFence = function(){
            if(_addFenceInfo['points'][_addFenceInfo['points'].length-1]!=null){
                _addFenceInfo['points'].splice(-1,1);
                _addFenceInfo['fence'].attr("points",_addFenceInfo['points'].join(" "));
            }

            if(_addFenceInfo['circleList'][_addFenceInfo['circleList'].length-1]!=null){
                _addFenceInfo['circleList'][_addFenceInfo['circleList'].length-1].remove();
                _addFenceInfo['circleList'].splice(-1,1);
            }

            if(_addFenceInfo['lineTextList'][_addFenceInfo['lineTextList'].length-1]!=null){
                _addFenceInfo['lineTextList'][_addFenceInfo['lineTextList'].length-1].remove();
                _addFenceInfo['lineTextList'].splice(-1,1);
            }

            if(_addFenceInfo['circleList'].length==0 && _addFenceInfo['text']!=null){
                _addFenceInfo['text'].remove();
                _addFenceInfo['text'] = null;
            }
        };

        this.resetAddFenceInfo = function(closeFlag){
            for(var index in _addFenceInfo['circleList']){
                _addFenceInfo['circleList'][index].remove();
            }
            if(_addFenceInfo['text']!=null){
                _addFenceInfo['text'].remove();
            }
            for(var index in _addFenceInfo['lineTextList']){
                _addFenceInfo['lineTextList'][index].remove();
            }
            _addFenceInfo['text'] = null;
            _addFenceInfo['circleList'] = [];
            _addFenceInfo['lineTextList'] = [];
            _addFenceInfo['points'] = [];

            if(closeFlag){
                if(_addFenceInfo['mapCanvas']!=null){
                    _addFenceInfo['mapCanvas'].parent().removeClass("cursor_cros");
                    _addFenceInfo['mapCanvas'].find("svg").off("mousedown mousemove mouseup dblclick");
                }

                if(_addFenceInfo['fenceMarker']!=null){
                    if(_addFenceInfo['fenceMarker']['element']!=null) _addFenceInfo['fenceMarker']['element'].show();
                    if(_addFenceInfo['fenceMarker']['textElement']!=null) _addFenceInfo['fenceMarker']['textElement'].show();
                    if(_addFenceInfo['fenceMarker']['circleElement']!=null) _addFenceInfo['fenceMarker']['circleElement'].show();
                    if(_addFenceInfo['fenceMarker']['polylineElement']!=null) _addFenceInfo['fenceMarker']['polylineElement'].show();
                }
                if(_addFenceInfo['fence']!=null){
                    _addFenceInfo['fence'].remove();
                }
                _addFenceInfo['fence'] = null;
                $(".fenceset_popup").removeClass("on");
            }else{
                _addFenceInfo['fence'].attr("points","");
            }
        };

        /**
         * close popup
         * @author psb
         */
        this.closePopup = function(){
            _self.resetAddFenceInfo(true);
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