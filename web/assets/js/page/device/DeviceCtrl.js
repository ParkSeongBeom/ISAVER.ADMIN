/**
 * [Controller] 장치
 *
 * @author dhj
 * @since 2016.06.07
 */
function DeviceCtrl(model) {

    var DeviceCtrl = new Object();
    DeviceCtrl._model = model;
    DeviceCtrl._event = new DeviceEvent(model);

    /**
     * 장치 선택
     * @param node
     * @date 2014.05.22
     */
    DeviceCtrl.selectMenuTree = function (node) {
        if (node != null || node != undefined) {

            var id = node.data.id;
            if (id != null || id != undefined) {
                DeviceCtrl._model.setDeviceId(String(id));
                DeviceCtrl._model.setPageIndex(0);
                DeviceCtrl.findMenuDetail();
            }
        }
    };

    /**
     * [cRud] 장치 트리 불러오기
     */
    DeviceCtrl.findMenuTree = function () {
        this._model.setViewStatus('menuTree');
        var type = this._model.getViewStatus();
        var requestUrl = this._model.getRequestUrl();

        sendAjaxPostRequest(requestUrl, {}, this._event.menuTreeSuccessHandler, this._event.menuTreeErrorHandler, type);
    };

    /**
     * [cRud] 선택한 장치 ID로 상세 정보 가져오기
     */
    DeviceCtrl.findMenuDetail = function () {

        if (this._model.getDeviceId() != null || this._model.getDeviceId() != undefined) {

            this.param = {
                deviceId: this._model.getDeviceId()
                ,serialNo: this._model.getSerialNo()
                ,pageIndex: (this._model.getPageIndex() > 0) ? this._model.getPageIndex() * this._model.getPageRowNumber()-this._model.getPageRowNumber() : 0
                ,pageRowNumber: this._model.getPageRowNumber()
            };

            this._model.setViewStatus('detail');
            var type = this._model.getViewStatus();
            var requestUrl = this._model.getRequestUrl();


            var formName = "#" + this._model.getFormName();
            $( formName + " [name='parentDeviceId'] option").attr('disabled', false);

            sendAjaxPostRequest(requestUrl, this.param, this._event.detailSuccessHandler, this._event.detailErrorHandler, type);
        }
    };

    /**
     * 장치별 장치 상세 조회
     */
    DeviceCtrl.searchDevice = function() {
        this._model.setDeviceId($("input[name='deviceId']").val());
        this._model.setSerialNo($("input[name='serialNo']").val());
        this._model.setAreaId($("select[name=areaId]").val());
        DeviceCtrl.findMenuDetail();
    };


    /**
     * IP 주소 유효성 검증
     * @param ipaddress
     * @returns {boolean}
     * @constructor
     */
    DeviceCtrl.validateIPaddress = function(ipaddress) {
        if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipaddress)) {
            return (true);
        } else {
            return (false)
        }

    }

    /**
     * 전송 전 유효성 체크
     */
    DeviceCtrl.commonVaild = function(flag) {

        //if (this._model.getParentDeviceId() != undefined && String(this._model.getParentDeviceId()).trim().length == 0) {
        //    alert("좌측 장치 목록에서 부서를 선택해 주세요.");
        //    return;
        //}

        var type = DeviceCtrl._model.getViewStatus();

        if (flag != undefined && flag) {

            //if ($("input[name='deviceId']").val().trim().length == 0) {
            //    $("input[name='deviceId']").focus();
            //    alert(messageConfig['requiredDeviceId']);
            //    return;
            //}

            if ($("input[name='serialNo']").val().trim().length == 0) {
                $("input[name='serialNo']").focus();
                alert(messageConfig['requiredSerialNo']);
                return;
            }

            if ($("select[name='areaId']").val() == "" || $("select[name='areaId']").val() == null) {
                alert(messageConfig['requiredAreaId']);
                return;
            }
        }

        return true;
    };

    /**
     *  장치 등록 전 유효성 검증
     */
    DeviceCtrl.addDeviceVaild = function () {

        this._model.setViewStatus(DeviceModel().model.ACTION.ADD);
        if (this.commonVaild(true)) {

            var deviceObj = DeviceCtrl._model.getDeviceDetail($("input[name='deviceId']").val(), $("input[name='serialNo']").val());

            if (deviceObj['deviceIdExistFlag'] == true) {
                alert( messageConfig['existsDeviceId'] );
                $("input[name=deviceId]").focus();
                return;
            }

            if (deviceObj['serialNoExistFlag'] == true) {
                alert( messageConfig['existsSerialNo'] );
                $("input[name=serialNo]").focus();
                return;
            }

            if ($("select[name=deviceCode]").val() == "DEV010") {
                if ($("input[name='linkUrl']").val().trim().length == 0) {
                    alert( messageConfig['emptyLinkUrl'] );
                    $("input[name=linkUrl]").focus();
                    return;
                }
            }

            var deviceId = $("input[name=deviceId]").val();
            if(confirm('[' + deviceId + '] ' + messageConfig['addConfirmMessage'] + '?')) {
                this.addDevice();
            }
        }
    };

    /**
     * 장치 저장 전 유효성 검증
     */
    DeviceCtrl.saveDeviceVaild = function () {

        this._model.setViewStatus(DeviceModel().model.ACTION.SAVE);

        if (this.commonVaild(true)) {

            var deviceObj = DeviceCtrl._model.getDeviceDetail($("input[name='deviceId']").val(), $("input[name='serialNo']").val());

            if (deviceObj['serialNoExistFlag'] == true) {
                alert( messageConfig['existsSerialNo'] );
                $("input[name=serialNo]").focus();
                return;
            }

            if ($("select[name=deviceCode]").val() == "DEV010") {
                if ($("input[name='linkUrl']").val().trim().length == 0) {
                    alert( messageConfig['emptyLinkUrl'] );
                    $("input[name=linkUrl]").focus();
                    return;
                }
            }

            var deviceId = $("input[name=deviceId]").val();
            if(confirm('[' + deviceId + '] ' + messageConfig['saveConfirmMessage'] + '?')) {
                this.saveDevice();
            }
        }
    };

    /**
     * 장치 삭제 전 유효성 검증
     */
    DeviceCtrl.removeDeviceVaild = function () {

        var deviceId = $("input[name=deviceId]").val();

        if (!confirm("[ " + deviceId + " ] " + messageConfig['removeConfirmMessage'] + "?")) return;

        DeviceCtrl.removeDevice(deviceId);

    };

    /**
     * [Crud] 장치  등록
     */
    DeviceCtrl.addDevice = function () {
        var type = DeviceCtrl._model.getViewStatus();
        if (type != DeviceModel().model.ACTION.ADD) {
            return;
        }

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + DeviceCtrl._model.getFormName();

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.areaCudSuccessHandler, this._event.areaCudErrorHandler, type);
    };

    /**
     * [crUd] 장치 저장
     */
    DeviceCtrl.saveDevice = function () {
        var type = DeviceCtrl._model.getViewStatus();
        if (type != DeviceModel().model.ACTION.SAVE) {
            return;
        }

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + DeviceCtrl._model.getFormName();

        $(formName + " [name='deviceId']").removeAttr("disabled");
        $(formName + " [name='serialNo']").removeAttr("disabled");

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.areaCudSuccessHandler, this._event.areaCudErrorHandler, type);

        $(formName + " [name='deviceId']").attr("disabled", "disabled");
        $(formName + " [name='serialNo']").attr("disabled", "disabled");
    };

    /**
     * [cruD] 장치 삭제
     */
    DeviceCtrl.removeDevice = function (_deviceId) {

        var type = DeviceCtrl._model.model.ACTION.REMOVE;
        this._model.setViewStatus(type);

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + DeviceCtrl._model.getFormName();

        var param = {
           'deviceId' : _deviceId
        };

        sendAjaxPostRequest(requestUrl, param, this._event.areaCudSuccessHandler, this._event.areaCudErrorHandler, type);

    };

    /**
     * 장치 트리 새로 고침
     */
    DeviceCtrl.setMenuTreeReset = function () {
        $(this._model.getTreaDevice()).dynatree('destroy');
        $(this._model.getTreaDevice()).empty();

        this.findMenuTree();
    }

    /**
     * 장치 트리 전체 펼치기/닫기
     */
    DeviceCtrl.treeExpandAll = function (flag) {
        $(this._model.getTreaDevice()).dynatree("getRoot").visit(function (node) {
            node.expand(flag);
            if(flag){
                $("#expandClose").show();
                $("#expandShow").hide();
            }else{
                $("#expandClose").hide();
                $("#expandShow").show();
            }
        });
    };

    /**
     * 장치 등록 전 초기화 모드
     */
    DeviceCtrl.setAddBefore = function() {
        this._model.setViewStatus(MenuModel().model.ACTION.ADD);
        var deviceView = new DeviceView(this._model);
        deviceView.resetData();
        deviceView.setAddBefore();
    };

    /**
     * 부서원 등록 팝업 창 띄우기
     */
    DeviceCtrl.openPopupUserPage = function() {
        if (this.commonVaild()) {
            this._model.setViewStatus("addOrgUser");
            var orgView = new DeviceView(this._model);
            orgView.openPopupUserPage();
        }
    };

    /**
     * 알림 대상 전송 IVAS->SIOC
     */
    DeviceCtrl.alarmListLoadFunc = function() {
        openPopup('list_popup');
        DeviceCtrl.alarmDeviceLoadFunc();
    };

    /**
     * 알림 대상 장치 추가 / 제거
     */
    DeviceCtrl.appendAlarmDeviceFunc = function() {
        var _tags = $("input[type=checkbox]:checked");

        var sendData = [];

        for (var i =0; i < _tags.length; i++) {
            var aDeviceId = _tags.eq(i).attr("device_id");
            sendData.push(aDeviceId);
        }

        var data = {
            tDeviceId : DeviceCtrl._model.getDeviceId()
            , aDeviceId : sendData.join()
        };

        var rootUrl = DeviceCtrl._model.getRootUrl();
        var _url = rootUrl + "/alarmTargetDevice/append.json";
        var actionType = "alarmAppend";

        sendAjaxPostRequest(_url, data, this._event.alarmTargetAppendSuccessHandler, this._event.alarmTargetAppendErrorHandler, actionType);
    };

    /**
     * 알림 목록 장치 불러오기
     */
    DeviceCtrl.alarmDeviceLoadFunc = function() {
        var data = {
            deviceId : DeviceCtrl._model.getDeviceId()
            , findDeviceId : $("input[name=pop_device_id]").val()
            , findDeviceTypeCode : $("#pop_device_code").val()
            , findAreaName : $("input[name=pop_areaName]").val()
        };

        /*  테이블 목록 - 내용 */
        $("#actionList > tbody").empty();
        var rootUrl = DeviceCtrl._model.getRootUrl();
        var _url = rootUrl + "/device/alarmMappingList.json";
        var actionType = "alarmListLoad";
        sendAjaxPostRequest(_url, data, this._event.alarmListLoadSuccessHandler, this._event.alarmListLoadErrorHandler, actionType);
    };
    return DeviceCtrl;

}

/**
 * [Event] 장치
 *
 * @author dhj
 * @since 2016.06.07
 */
function DeviceEvent(model) {
    var DeviceEvent = new Object();
    var deviceView = new DeviceView(model);

    DeviceEvent._model = model;

    /**
     * [SUCCESS][RES] 장치 전체 목록 불러오기 성공 시 이벤트
     */
    DeviceEvent.menuTreeSuccessHandler = function (data, dataType, actionType) {

        DeviceEvent._model.setDeviceTreeList(JSON.parse(JSON.stringify(data['deviceList'])));

        var menuTreeModel = DeviceEvent._model.processMenuTreeData(data['deviceList'], DeviceEvent._model.getRootOrgId());
        deviceView.setMenuTree(menuTreeModel);
    };

    /**
     * [FAIL][RES] 장치 전체 목록 불러오기 실패 시
     */
    DeviceEvent.menuTreeErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][DeviceEvent.menuTreeErrorHandler] " + errorThrown);
        alert(messageConfig[DeviceEvent._model.getViewStatus() + 'Failure']);
    };

    /**
     * [SUCCESS][RES] 장치별 상세 정보 - 불러오기 성공 시 이벤트
     * @param data
     * @param dataType
     * @param actionType
     */
    DeviceEvent.detailSuccessHandler = function (data, dataType, actionType) {
        deviceView.resetData();
        deviceView.setFindDetailBefore(data);

        if (typeof data == "object" && data.hasOwnProperty("device") && data['device']!=null) {
            try {
                DeviceEvent._model.setDeviceId(data['device'].deviceId);
            } catch (e) {
                console.error("[Error][DeviceEvent.detailSuccessHandler] " + e);
            }
            try {
                DeviceEvent._model.setSerialNo(data['device'].serialNo);
            } catch (e) {
                console.error("[Error][DeviceEvent.detailSuccessHandler] " + e);
            }

            try {
                DeviceEvent._model.setDepth(data['device'].depth);
            } catch (e) {
                console.error("[Error][DeviceEvent.detailSuccessHandler] " + e);
            }

            try {
                DeviceEvent._model.setAreaId(data['device'].areaId);
            } catch (e) {
                //deviceView.resetOrgDepth();
                console.error("[Error][DeviceEvent.detailSuccessHandler] " + e);
            }

            try {
                DeviceEvent._model.setParentDeviceId(data['device'].parentDeviceId);
            } catch (e) {
                console.error("[Error][DeviceEvent.detailSuccessHandler] " + e);
            }

            deviceView.setDetail(data['device']);
        }

    };

    /**
     * [FAIL][RES] 상세 메뉴 불러오기 실패 시 이벤트
     * @param XMLHttpRequest
     * @param textStatus
     * @param errorThrown
     * @param actionType
     */
    DeviceEvent.detailErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][DeviceEvent.detailErrorHandler] " + errorThrown);
        console.error("[Error][DeviceEvent.detailErrorHandler] " + errorThrown);
        alert(messageConfig[DeviceEvent._model.getViewStatus() + 'Failure']);
        $('#selectAll').checked = false;
    };

    /**
     * [SUCCESS][RES] 장치 CUD 성공 시 이벤트
     */
    DeviceEvent.areaCudSuccessHandler = function (data, dataType, actionType) {

        if (actionType =="remove") {
            if (data['provisionExist'] != null && data['provisionExist'] =='Y' && actionType =="remove") {

                alert("장치 ID[" + data['provisionDeviceId'] + "] 의 " +  messageConfig['provisionExistError']);
            }  else {
                alert(messageConfig[DeviceEvent._model.getViewStatus() + 'Complete']);
                //window.location.reload();
                location.href = "./list.html?ctrl=reload";
            }
        } else {

            if (data['resultFlag'] == false) {
                switch(data['licenseMsg']) {
                    case "NOT_EXIST":
                        alert(DeviceEvent._model.getAlertMessageList()[0]);
                        break;
                    case "DAY_OVER":
                        alert(DeviceEvent._model.getAlertMessageList()[1]);
                        break;
                    case "QUANTITY_SHORTAGE":
                        alert(DeviceEvent._model.getAlertMessageList()[2]);
                        break;
                    default:
                        alert(DeviceEvent._model.getAlertMessageList()[3]);
                        break;
                }
            } else {
                alert(messageConfig[DeviceEvent._model.getViewStatus() + 'Complete']);
                location.href = "./list.html?ctrl=reload";
            }

        }


    };

    /**
     * [FAIL][RES] 장치 CUD 실패 시 이벤트
     */
    DeviceEvent.areaCudErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][DeviceEvent.areaCudErrorHandler] " + errorThrown);
        alert(messageConfig[DeviceEvent._model.getViewStatus() + 'Failure']);

    };

    /**
     * [SUCCESS][RES] 알림 장치 목록 불러오기 성공 시 이벤트
     */
    DeviceEvent.alarmListLoadSuccessHandler = function (data, dataType, actionType) {
        if (typeof data == "object" && data.hasOwnProperty("deviceBeanList") && data['deviceBeanList']!=null) {
            deviceView.makeAlarmDeviceListFunc(data['deviceBeanList'], data['alarmTargetDeviceConfigList']);
        }
    };

    /**
     * [FAIL][RES] 알림 장치 목록 불러오기 실패 시 이벤트
     */
    DeviceEvent.alarmListLoadErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][DeviceEvent.alarmListLoadErrorHandler] " + errorThrown);
        alert(messageConfig[DeviceEvent._model.getViewStatus() + 'Failure']);
    };

    /**
     * [SUCCESS][RES] 알림 장치 목록 저장 성공 시 이벤트
     */
    DeviceEvent.alarmTargetAppendSuccessHandler = function (data, dataType, actionType) {
        alert("알림 대상 장치 목록을 저장하였습니다");
    };

    /**
     * [FAIL][RES] 알림 장치 목록 저장 실패 시 이벤트
     */
    DeviceEvent.alarmTargetAppendErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][DeviceEvent.alarmTargetAppendErrorHandler] " + errorThrown);
        alert(messageConfig[DeviceEvent._model.getViewStatus() + 'Failure']);

    };

    return DeviceEvent;
}