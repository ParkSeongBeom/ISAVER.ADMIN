/**
 * Resource Helper
 *
 * @author psb
 * @type {Function}
 */
var ResourceHelper = (
    function(rootPath){
        var _rootPath;
        var _urlConfig = {
            areaListUrl : "/area/list.json"
            ,addAreaUrl : "/area/add.json"
            ,saveAreaUrl : "/area/save.json"
            ,removeAreaUrl : "/area/remove.json"
            ,deviceListUrl : "/device/list.json"
            ,addDeviceUrl : "/device/add.json"
            ,saveDeviceUrl : "/device/save.json"
            ,removeDeviceUrl : "/device/remove.json"
        };
        var _messageConfig;
        var _areaList = {};
        var _deviceList = {};
        var _parentDeviceCode = ['DEV001','DEV003','DEV900','DEV015'];
        var _self = this;

        /**
         * initialize
         */
        var initialize = function(rootPath){
            _rootPath = rootPath;
            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
            eventHandlerBind();
            console.log('[ResourceHelper] initialize complete');
        };

        /**
         * Event Binding
         * @author psb
         */
        var eventHandlerBind = function(){
            $("select[name='templateCode']").on("change",function(){
                // 템플릿이 guard이고 수정모드에서만 Map설정 팝업 버튼 활성화
                if($(this).val()=='TMP005' && $("input[name='areaId']").val()!=""){
                    $(".map_sett_btn").show();
                }else{
                    $(".map_sett_btn").hide();
                }
            });

            $("select[name='deviceCode']").on("change",function(){
                // 장치구분이 IP카메라이고 수정모드에서만 PTZ 설정 팝업 버튼 활성화
                if($(this).val()=='DEV002' && $("input[name='deviceId']").val()!=""){
                    $(".onvif_sett_btn").show();
                }else{
                    $(".onvif_sett_btn").hide();
                }

                var form = $("#deviceForm");
                // 장치구분이 M8일경우에만 메인여부 활성화
                if($(this).val()=='DEV013'){
                    form.find("#mainFlagCB").prop("disabled",false);
                }else{
                    form.find("#mainFlagCB").prop("disabled",true).prop("checked",false).trigger("change");
                }
            });
        };

        /**
         * set message config
         * @author psb
         */
        this.setMessageConfig = function(messageConfig){
            _messageConfig = messageConfig;
        };

        /**
         * refresh List Data
         */
        this.refreshList = function(){
            // 구역 및 장치 목록 초기화
            $("#areaList").empty();
            $("#deviceList").empty();
            _areaList = {};
            _deviceList = {};

            // 구역 목록 요청
            _ajaxCall('areaList');
        };

        /**
         * area validate
         * actionType : add / save / remove
         */
        var areaVaild = function(actionType){
            var form = $("#areaForm");
            if(form.find("input[name=areaName]").val().trim().length==0){
                _alertMessage('requiredAreaName');
                return false;
            }

            switch (actionType){
                case "add" :
                    break;
                case "save" :
                    //if(confirm(_messageConfig['saveAllTemplate'])){
                    //    form.find("input[name='allTemplate']").val("Y");
                    //}
                    break;
                case "remove" :
                    break;
            }
            return true;
        };

        /**
         * device validate
         * actionType : add / save / remove
         */
        var deviceVaild = function(actionType){
            var form = $("#deviceForm");
            var deviceId = form.find("input[name=deviceId]").val().trim();
            var deviceName = form.find("input[name=deviceName]").val().trim();
            var deviceCode = form.find("select[name=deviceCode]").val().trim();
            var parentDeviceId = form.find("select[name=parentDeviceId]").val().trim();
            var serialNo = form.find("input[name=serialNo]").val().trim();

            if(deviceName==null && deviceName.length==0){
                _alertMessage('requiredDeviceName');
                return false;
            }

            if(actionType=='add'){
                if(serialNo==null && serialNo.length==0){
                    _alertMessage('requiredSerialNo');
                    return false;
                }

                for(var index in _deviceList){
                    var _data = _deviceList[index]['data'];
                    if(_data['serialNo']==serialNo && _data['deviceCode']==deviceCode){
                        _alertMessage('existsSerialNo');
                        return false;
                    }
                }
            }

            if(deviceCode=='DEV013'){
                if(parentDeviceId==null || parentDeviceId=='' || _deviceList[parentDeviceId]['data']['deviceCode']!='DEV015'){
                    _alertMessage('requiredM8');
                    return false;
                }
            }

            if(deviceCode=='DEV015'){
                if(parentDeviceId!=''){
                    var parentData = _deviceList[parentDeviceId]['data'];
                    if(parentData['deviceCode']!="DEV003"){
                        _alertMessage('requiredQnServer');
                        return false;
                    }

                    for(var index in _deviceList){
                        var _data = _deviceList[index]['data'];
                        if(_data['parentDeviceId']==parentDeviceId && _data['deviceCode']==deviceCode && _data['deviceId']!=deviceId){
                            _alertMessage('onlyOneServer');
                            return false;
                        }
                    }
                }
            }
            return true;
        };

        /**
         * Area / Device submit (add,save,remove
         */
        this.submit = function(mode, actionType){
            switch (mode){
                case "area" :
                    if(areaVaild(actionType)){
                        if(confirm(_messageConfig[actionType+'ConfirmMessage'])){
                            _ajaxCall(actionType+'Area',$("#areaForm").serialize());
                        }
                    }
                    break;
                case "device" :
                    if(deviceVaild(actionType)){
                        if(confirm(_messageConfig[actionType+'ConfirmMessage'])){
                            _ajaxCall(actionType+'Device',$("#deviceForm").serialize());
                        }
                    }
                    break;
            }
        };

        this.openCustomMapPopup = function(areaId){
            var data = _areaList[areaId]['data'];
            if(!customMapPopup && !customMapPopup instanceof CustomMapPopup){
                console.error("[ResourceHelper][openCustomMapPopup] customMapPopup is null or typeerror");
                return false;
            }
            customMapPopup.openPopup(areaId,data['areaName'],data['fileId']?data['fileId']:'');
        };

        this.openPtzControlPopup = function(deviceId){
            var data = _deviceList[deviceId]['data'];
            if(!ptzControlPopup && !ptzControlPopup instanceof PtzControlPopup){
                console.error("[ResourceHelper][openPtzControlPopup] customMapPopup is null or typeerror");
                return false;
            }
            ptzControlPopup.openPopup(data);
        };

        /**
         * 구역 상세
         * @author psb
         */
        this.getAreaDetail = function(areaId){
            var form = $("#areaForm");
            // 구역 정보 초기화
            form[0].reset();
            form.find(".table_btn_set button").show();
            $("div[detail]").removeClass("on");
            $(".area_table").addClass("on");

            // 부모구역명 셀렉트박스 리로드
            form.find("select[name='parentAreaId'] option").not(":eq(0)").remove();
            for(var index in _areaList){
                if(index!=areaId){
                    form.find("select[name='parentAreaId']").append(
                        $("<option/>",{value:index}).text(_areaList[index]['data']['path'])
                    );
                }
            }

            if(areaId!=null){ // 기존 등록된 구역 선택시
                if(_areaList[areaId]==null){
                    _alertMessage("areaDetailFailure");
                    return false;
                }
                var data = _areaList[areaId]['data'];
                form.find("input[name='areaId']").val(areaId);
                form.find("input[name='areaName']").val(data['areaName']);
                form.find("select[name='parentAreaId']").val(data['parentAreaId']).prop("selected", true);
                form.find("input[name='sortOrder']").val(data['sortOrder']!=null?data['sortOrder']:'');
                form.find("select[name='templateCode']").val(data['templateCode']).prop("selected", true).trigger("change");
                form.find(".map_sett_btn").attr("onclick","javascript:resourceHelper.openCustomMapPopup('"+areaId+"'); return false;");
                form.find("textarea[name='areaDesc']").val(data['areaDesc']!=null?data['areaDesc']:'');
                form.find("td[name='insertUserName']").text(data['insertUserName']);
                form.find("td[name='insertDatetime']").text(new Date(data['insertDatetime']).format("yyyy-MM-dd HH:mm:ss"));
                form.find("td[name='updateUserName']").text(data['updateUserName']?data['updateUserName']:'');
                form.find("td[name='updateDatetime']").text(new Date(data['updateDatetime']).format("yyyy-MM-dd HH:mm:ss"));
                form.find("tr[modifyTag]").show();
                form.find("button[name='addBtn']").hide();
            }else{ // 등록버튼 클릭시
                // 현재 선택된 구역을 부모구역으로 자동맵핑
                var selAreaId = $(".area_tree_set .on").find("button.on").attr("areaId");
                if(selAreaId!=null){
                    form.find("select[name='parentAreaId']").val(selAreaId).prop("selected", true);
                }
                form.find("select[name='templateCode']").trigger("change");
                form.find("tr[modifyTag]").hide();
                form.find("button[name='saveBtn']").hide();
                form.find("button[name='removeBtn']").hide();
                form.find(".onvif_sett_btn").hide();
            }
        };

        /**
         * 장치 상세
         * @author psb
         */
        this.getDeviceDetail = function(deviceId){
            var form = $("#deviceForm");
            // 구역 정보 초기화
            form[0].reset();
            form.find(".table_btn_set button").show();
            $("div[detail]").removeClass("on");
            $(".device_table").addClass("on");

            // 구역명 셀렉트박스 리로드
            form.find("select[name='areaId']").empty();
            for(var index in _areaList){
                form.find("select[name='areaId']").append(
                    $("<option/>",{value:index}).text(_areaList[index]['data']['path'])
                );
            }

            // 부모장치명 셀렉트박스 리로드
            form.find("select[name='parentDeviceId'] option").not(":eq(0)").remove();
            for(var index in _deviceList){
                if(index!=deviceId && _parentDeviceCode.indexOf(_deviceList[index]['data']['deviceCode'])>-1){
                    form.find("select[name='parentDeviceId']").append(
                        $("<option/>",{value:index}).text(_deviceList[index]['data']['path'])
                    );
                }
            }

            if(deviceId!=null){ // 기존 등록된 장치 선택시
                if(_deviceList[deviceId]==null){
                    _alertMessage("deviceDetailFailure");
                    return false;
                }
                var data = _deviceList[deviceId]['data'];
                form.find("input[name='deviceId']").val(deviceId);
                form.find("input[name='deviceName']").val(data['deviceName']);
                form.find("select[name='deviceTypeCode']").val(data['deviceTypeCode']).prop("selected", true);
                form.find("select[name='parentDeviceId']").val(data['parentDeviceId']).prop("selected", true);
                form.find("select[name='vendorCode']").val(data['vendorCode']).prop("selected", true);
                form.find("select[name='areaId']").val(data['areaId']).prop("selected", true);
                form.find("select[name='deviceCode']").val(data['deviceCode']).prop("selected", true).trigger("change");
                form.find("input[name='serialNo']").val(data['serialNo']).prop("readonly",true);
                form.find("input[name='ipAddress']").val(data['ipAddress']!=null?data['ipAddress']:'');
                form.find("input[name='port']").val(data['port']!=null?data['port']:'');
                form.find("input[name='deviceUserId']").val(data['deviceUserId']!=null?data['deviceUserId']:'');
                form.find("input[name='subUrl']").val(data['subUrl']!=null?data['subUrl']:'');
                form.find("input[name='etcConfig']").val(data['etcConfig']!=null?data['etcConfig']:'');
                form.find("input[name='streamServerUrl']").val(data['streamServerUrl']!=null?data['streamServerUrl']:'');
                form.find("input[name='linkUrl']").val(data['linkUrl']!=null?data['linkUrl']:'');
                form.find("#mainFlagCB").prop("checked",data['mainFlag']=='Y'?true:false).trigger("change");
                form.find("textarea[name='deviceDesc']").val(data['deviceDesc']!=null?data['deviceDesc']:'');
                form.find("td[name='insertUserName']").text(data['insertUserName']);
                form.find("td[name='insertDatetime']").text(new Date(data['insertDatetime']).format("yyyy-MM-dd HH:mm:ss"));
                form.find("td[name='updateUserName']").text(data['updateUserName']?data['updateUserName']:'');
                form.find("td[name='updateDatetime']").text(new Date(data['updateDatetime']).format("yyyy-MM-dd HH:mm:ss"));
                form.find("tr[modifyTag]").show();
                form.find("button[name='addBtn']").hide();
                form.find(".onvif_sett_btn").attr("onclick","javascript:resourceHelper.openPtzControlPopup('"+deviceId+"'); return false;");
            }else{ // 등록버튼 클릭시
                // 현재 선택된 장치를 부모장치로 자동맵핑
                var selDeviceId = $(".area_tree_set .on").find("button.on").attr("deviceId");
                if(selDeviceId!=null){
                    form.find("select[name='parentDeviceId']").val(selDeviceId).prop("selected", true);
                }

                // 현재 선택된 구역을 구역명에 자동맵핑
                var selAreaId = $(".area_tree_set .on").find("button.on").attr("areaId");
                if(selAreaId!=null){
                    form.find("select[name='areaId']").val(selAreaId).prop("selected", true);
                }
                form.find("input[name='serialNo']").prop("readonly",false);
                form.find("#mainFlagCB").prop("checked",false).trigger("change");
                form.find("select[name='deviceCode']").trigger("change");
                form.find("tr[modifyTag]").hide();
                form.find("button[name='saveBtn']").hide();
                form.find("button[name='removeBtn']").hide();
            }
        };

        /**
         * 구역 목록 Render
         * @author psb
         */
        var areaRender = function(areaList){
            for(var index in areaList){
                var area = areaList[index];
                if(area['delYn']!="Y"){
                    var targetTag = null;
                    var parentTag = _areaList[area['parentAreaId']];
                    if(parentTag!=null && parentTag['element']!=null){
                        if(parentTag['element'].find("> ul").length==0){
                            parentTag['element'].append($("<ul/>"));
                        }
                        targetTag = parentTag['element'].find("> ul");
                    }else{
                        targetTag = $("#areaList");
                    }

                    var areaTag = $("<li/>",{areaId:area['areaId']}).append(
                        $("<input/>",{type:'checkbox'})
                    ).append(
                        $("<div/>").append(
                            $("<button/>", {areaId:area['areaId']}).text(area['areaName'] + " (" + area['areaId'] + ")").on("click",function(){
                                $("#areaList div").removeClass("on");
                                $("#areaList button").removeClass("on");
                                $(this).parent().addClass("on");
                                $(this).addClass("on");
                                _self.getAreaDetail($(this).attr("areaId"));
                            })
                        )
                    );

                    if(targetTag!=null){
                        targetTag.append(areaTag);
                    }

                    _areaList[area['areaId']] = {
                        element : areaTag
                        ,data : area
                    };
                }
            }

            // 구역 목록 Render 후 장치목록 동기 요청
            _ajaxCall('deviceList');
        };

        /**
         * 장치 목록 Render
         * @author psb
         */
        var deviceRender = function(deviceList){
            for(var index in deviceList){
                var device = deviceList[index];
                if(device['delYn']!="Y"){
                    var targetTag = null;
                    var parentTag = _deviceList[device['parentDeviceId']];
                    if(parentTag!=null && parentTag['element']!=null){
                        if(parentTag['element'].find("> ul").length==0){
                            parentTag['element'].append($("<ul/>"));
                        }
                        targetTag = parentTag['element'].find("> ul");
                    }else{
                        targetTag = $("#deviceList");
                    }

                    var deviceTag = $("<li/>",{deviceId:device['deviceId']}).append(
                        $("<input/>",{type:'checkbox'})
                    ).append(
                        $("<div/>").append(
                            $("<button/>", {deviceId:device['deviceId']}).text(device['deviceName'] + " (" + device['deviceId'] + ")").on("click",function(){
                                $("#deviceList div").removeClass("on");
                                $("#deviceList button").removeClass("on");
                                $(this).parent().addClass("on");
                                $(this).addClass("on");
                                _self.getDeviceDetail($(this).attr("deviceId"));
                            })
                        )
                    );

                    if(targetTag!=null){
                        targetTag.append(deviceTag);
                    }

                    // 구역별 탭 List에 장치 맵핑
                    var area = _areaList[device['areaId']];
                    if(area!=null && area['element']!=null){
                        area['element'].find("> div").append(
                            $("<button/>", {areaId:device['areaId'],deviceId:device['deviceId']}).text(device['deviceName'] + " (" + device['deviceId'] + ")").on("click",function(){
                                $("#areaList div").removeClass("on");
                                $("#areaList button").removeClass("on");
                                $(this).parent().addClass("on");
                                $(this).addClass("on");
                                _self.getDeviceDetail($(this).attr("deviceId"));
                            })
                        )
                    }

                    _deviceList[device['deviceId']] = {
                        element : deviceTag
                        ,data : device
                    };
                }
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
            var refreshFlag = false;

            switch(actionType){
                case 'areaList':
                    areaRender(data['areas']);
                    break;
                case 'deviceList':
                    deviceRender(data['devices']);
                    break;
                case 'addDevice':
                    var license = data['license'];
                    switch (license['status']){
                        case 0:
                        case -99:
                            refreshFlag = true;
                            break;
                        case -1: // 기한만료
                            _alertMessage('expireLicense');
                            break;
                        case -4: // 라이센스 수량 초과
                            _alertMessage('excessLicense');
                            break;
                        default : // 기타 오류
                            alert("status code : "+license['status']+"\n("+license['message']+")");
                    }
                    break;
                default :
                    if(data['resultCode']!=null){
                        switch (data['resultCode']){
                            case "ERR200":
                                _alertMessage('addOverflowFailure');
                                break;
                        }
                    }else{
                        refreshFlag = true;
                    }
            }

            if(refreshFlag){
                _alertMessage(actionType + 'Complete');
                $("div[detail]").removeClass("on");
                $(".ment").addClass("on");
                _self.refreshList();
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

        initialize(rootPath);
    }
);