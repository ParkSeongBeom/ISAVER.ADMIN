/**
 * [VIEW] 장치
 *
 * @author dhj
 * @since 2016.06.07
 */
function DeviceView(model) {
    var DeviceView = new Object();
    DeviceView._model = model;
    var formName = "#" + model.getFormName();
    var switchMenuDetailObj = {
        deviceId: function (data) {
            $(formName + " [name='deviceId']").val(data.deviceId);
        },
        parentDeviceId: function (data) {
            $(formName + " [name='parentDeviceId']").val(data.parentDeviceId).prop("selected", true);
            $(formName + " [name='parentDeviceId']").find("option[value=" +DeviceView._model.getDeviceId()+"]").attr('disabled', true);

            if (data.parentDeviceId != null && String(data['parentDeviceId']).trim().length > 0) {
                $(formName + " [name='parentDeviceId']").val(data.parentDeviceId);
            }
        },
        deviceTypeCode: function (data) {
            $(formName + " [name='deviceTypeCode']").val(data.deviceTypeCode).prop("selected", true);
        },
        areaId: function (data) {
            $(formName + " [name='areaId']").val(data.areaId).prop("selected", true);
        },
        deviceCode: function (data) {
            $(formName + " [name='deviceCode']").val(data.deviceCode).prop("selected", true);
        },
        serialNo: function (data) {
            $(formName + " [name='serialNo']").val(data.serialNo);
        },
        ipAddress: function (data) {
            $(formName + " [name='ipAddress']").val(data.ipAddress);
        },
        webPort: function (data) {
            $(formName + " [name='webPort']").val(data.webPort);
        },
        rtspPort: function (data) {
            $(formName + " [name='rtspPort']").val(data.rtspPort);
        },
        fileId: function (data) {
            $(formName + " [name='fileId']").val(data.fileId);
        },
        fileName: function (data) {
            $(formName + " [name='fileName']").val(data.fileName);
        },
        eventId: function (data) {
            $(formName + " [name='eventId']").val(data.eventId).prop("selected", true);
        },
        cameraManufacturer: function (data) {
            $(formName + " [name='cameraManufacturer']").val(data.cameraManufacturer).prop("selected", true);
        },
        deviceUserId: function (data) {
            $(formName + " [name='deviceUserId']").val(data.deviceUserId);
        },
        devicePassword: function (data) {
            $(formName + " [name='devicePassword']").val(data.devicePassword);
        },
        deviceDesc: function (data) {
            $(formName + " [name='deviceDesc']").val(data.deviceDesc);
        },
        depth: function (data) {
            $(formName + " [name='depth']").val(data.depth);
        },
        sortOrder: function (data) {
            $(formName + " [name='sortOrder']").val(data.sortOrder);
        },
        provisionFlag: function (data) {
            if (data['provisionFlag'] == 'Y') {
                $(formName + " [name='provisionFlag']").val("Y");
            } else {
                $(formName + " [name='provisionFlag']").val("N");
            }
        },
        deviceAliveFlag: function (data) {
            if (data['deviceAliveFlag'] == 'Y') {
                $(formName + " [name='deviceAliveFlag']").val("Y");
            } else {
                $(formName + " [name='deviceAliveFlag']").val("N");
            }
        },
        deviceAliveCheckType: function (data) {

            if (data.deviceAliveCheckType !=null || data.deviceAliveCheckType == "") {
                $("select[name=deviceAliveCheckType] option").eq(0).prop("checked", true);
            } else {
                $(formName + " [name='deviceAliveCheckType']").val(data.deviceAliveCheckType);
            }
        },
        deviceStat: function (data) {

            if (data['deviceStat'] == 'Y') {
                $("input:radio[name='deviceStat']:radio[value='Y']").prop("checked",true);
            } else {
                $("input:radio[name='deviceStat']:radio[value='N']").prop("checked",true);
            }

        },
        insertUserName: function (data) {
            $(formName + " td[name='insertUserName']").text(data.insertUserName);
        },
        insertDatetime: function (data) {
            var insertDatetime = new Date();
            insertDatetime.setTime(data['insertDatetime']);
            $(formName + " td[name='insertDatetime']").text(insertDatetime.format("yyyy-MM-dd HH:mm:ss"));
        },
        updateUserName: function (data) {
            $(formName + " td[name='updateUserName']").text(data.updateUserName);
        },
        updateDatetime: function (data) {

            var updateDatetime = new Date();
            updateDatetime.setTime(data['updateDatetime']);
            $(formName + " td[name='updateDatetime']").text(updateDatetime.format("yyyy-MM-dd HH:mm:ss"));
        },
        _default: function () {
        }
    };

    /**
     * [Draw] 장치 상세 생성
     *
     * @param obj
     * @see dhj
     * @date 2014.05.20
     */
    DeviceView.setDetail = function (obj) {
        Object.keys(obj).forEach(function (key) {
            try {
                if (this[key] == null)  {
                    this[key] = "";
                }

                switchMenuDetailObj[key](this);
            } catch (e) {
//                console.error("[Error][MenuView.setDetail] " + e);
            }
        }, obj);

        var id  = $("select[name='deviceCode']").val();

        if(deviceModel.checkAlaramSettingDeviceList(id)){
            $("#ipCameraSetting").show();
        }else{
            $("#ipCameraSetting").hide();
        }

        if (id == "DEV002") {
            $(".ipCamShowHide").show();
        } else {
            $(".ipCamShowHide").hide();
        }

        if(deviceModel.checkModifyDeviceIpList(id)){
            $("#deviceForm input[name='ipAddress']").prop("disabled",false);
        }else{
            $("#deviceForm input[name='ipAddress']").prop("disabled",true);
        }
    };

    /**
     * [Draw] 좌측 장치 트리 그리기
     * @param obj
     */
    DeviceView.setMenuTree = function (menuTreeModel) {
        var deviceCtrl = new DeviceCtrl(DeviceView._model);
        $(DeviceView._model.getTreaDevice()).dynatree({
            minExpandLevel: 2,
            debugLevel: 1,
            persist: false,
            onPostInit: function (isReloading, isError) {
                var myParam = location.search.split('ctrl=')[1];

                if (myParam) {
                    if ("reload" == myParam) {
                        this.reactivate();
                    }
                }

                if (selectedDeviceId.trim().length > 0) {
                    try {
                        setTimeout(function() {
                            deviceCtrl.treeExpandAll();
                            $("span[device_id=" +selectedDeviceId+"]").parent().parent().trigger("click");
                        }, 250);

                    } catch(e) {
                        console.log("device tree error : " + e);
                    }
                }

            }
            ,children: menuTreeModel
            ,onActivate: deviceCtrl.selectMenuTree
        });


    };

    /**
     * [Draw] 장치 정렬 순서 동적으로 생성하기
     */
    DeviceView.setOrgUserDetail = function(deviceModel) {

        if (typeof deviceModel == "object" && deviceModel.length > 0) {

            var table = $("table[name='roleListTable'] tbody");

            $(table).empty();

            for(var i=0; i<deviceModel.length; i++) {

                var device = deviceModel[i];
                var tr = document.createElement("tr");

                var deviceId_TD = document.createElement("td");
                var serialNo_TD = document.createElement("td");
                var deviceTypeCode_TD = document.createElement("td");
                var deviceCode_TD = document.createElement("td");

                deviceId_TD.textContent = device['deviceId'];
                serialNo_TD.textContent = device['serialNo'];
                deviceTypeCode_TD.textContent = device['deviceTypeCode'];

                deviceCode_TD.textContent = device['deviceCode'];

                tr.appendChild(deviceId_TD);
                tr.appendChild(serialNo_TD);
                tr.appendChild(deviceTypeCode_TD);
                tr.appendChild(deviceCode_TD);

                $(table).append(tr);
            }

            /* 숫자 입력만 허용 */
            $("input[name='orgSortName']").keypress(function(event) {
                return (/\d/.test(String.fromCharCode(event.which) ))
            });
        }
    };

    /**
     * 페이징 TAG 초기화 설정
     */
    DeviceView.setPagingView = function() {
        $("#pageContainer").empty();
        var num = this._model.getPageIndex() == 0 ? 1 :this._model.getPageIndex();
        drawPageNavigater(this._model.getPageRowNumber(), num, this._model.getPageCount());
    };

    /**
     * 장치 상세 정보 호출 전 초기화 모드
     */
    DeviceView.setFindDetailBefore = function (data) {
        var DeviceView = new Object();
        DeviceView._model = model;
        var formName = "#" + model.getFormName();
        $(formName + " [name='deviceId']").attr("disabled", "disabled");
        $(formName + " [name='serialNo']").attr("disabled", "disabled");

        if (DeviceView._model.getDeviceId() == DeviceView._model.getRootOrgId()) {
            $(formName + " table tbody tr").hide();
            $(formName + " table tbody tr[name='rootShow']").show();
            $(formName + " [name='deviceId']").val("HOME");
            $("button[name='addBtn']").hide();
            $("button[name='saveBtn']").hide();
            $("button[name='removeBtn']").hide();
        }else{
            $("button[name='addBtn']").hide();
        }
    };

    /**
     * 장치 등록 전 초기화 모드
     */
    DeviceView.setAddBefore = function() {
        var formName = "#" +DeviceView._model.getFormName();

        $(formName + " input[name='serialNo']").removeAttr("disabled");

        $(formName + " select[name='parentDeviceId']").val(DeviceView._model.getDeviceId());
        $(formName + " select[name='parentDeviceId']").find("option[value=" +DeviceView._model.getDeviceId()+"]").attr('disabled', false);

        $(formName + " .ipAddressShowHide").hide();
        $(formName + " .ipCamShowHide").hide();
        $(formName + " tr[name='showHideTag']").hide();
        $(formName + " button[name='saveBtn']").hide();
        $(formName + " button[name='removeBtn']").hide();
    };

    DeviceView.resetData = function(){
        var DeviceView = new Object();
        DeviceView._model = model;
        var formName = "#" + model.getFormName();

        $(formName + " input[name='deviceId']").val("");
        $(formName + " input[name='serialNo']").val("");

        $(formName + " select[name='deviceTypeCode'] option").eq(0).prop("checked", true);;
        $(formName + " select[name='deviceCode'] option").eq(0).prop("checked", true);;
        $(formName + " select[name='parentDeviceId'] option").eq(0).prop("checked", true);;
        $(formName + " select[name='areaId'] option").eq(0).prop("checked", true);;

        $(formName + " select[name=eventId]").val("");
        $(formName + " input[name=fileName]").val("");
        $(formName + " input[name=fileId]").val("");
        $(formName + " select[name=cameraManufacturer]").val("");

        $(formName + " input[name=ipAddress]").val("");
        $(formName + " input[name=webPort]").val("");
        $(formName + " input[name=rtspPort]").val("");

        $(formName + " input[name=deviceUserId]").val("");
        $(formName + " input[name=devicePassword").val("");

        $(formName + " textarea[name='deviceDesc']").val("");

        $(formName + " td[name='insertUserId']").text("");
        $(formName + " td[name='insertDatetime']").text("");
        $(formName + " td[name='updateUserId']").text("");
        $(formName + " td[name='updateDatetime']").text("");

        $(formName + " table tbody tr").show();
        $("#ipCameraSetting").hide();
        $("button[name='addBtn']").show();
        $("button[name='saveBtn']").show();
        $("button[name='removeBtn']").show();
    };

    /**
     * 장치 등록 팝업 창 띄우기
     */
    DeviceView.openPopupUserPage = function() {
        window.open(this._model.getRequestUrl('addOrgUser') + "?id=" + this._model.getOrgId(),'detailUserPopup','scrollbars=no,width=800,height=680,left=50,top=50');
    };

    /**
     * 장치 깊이 초기화
     */
    DeviceView.resetOrgDepth = function() {
        $(formName + " [name='orgDepth']").val("0");
    };

    /**
     * 알림 전송 장치 설정 목록 그리기
     * @param devices
     * @param alarmTargetDeviceConfigList
     */
    DeviceView.makeAlarmDeviceListFunc = function(devices, alarmTargetDeviceConfigList) {
        if (devices == null && devices.length == 0) {
            return;
        }

        for (var i=0; i< devices.length; i++) {
            var device = devices[i];

            var deviceId = device['deviceId'];
            var deviceCode = device['deviceCode'];
            var areaName = device['areaName'] != "" && device['areaName'] != null ? device['areaName'] : "없음";
            var provisionFlag = device['provisionFlag'];

            var html_item= "<tr>\n" +
                "<td class=\"t_center\"><input device_id='" + deviceId +"' type=\"checkbox\" class=\"checkbox\" name=\"checkbox01\"></td>\n" +
                "<td title=\"\">" +deviceId +"</td>\n" +
                "<td title=\"\">" + deviceCode + "</td>" +
                "<td title=\"\">" + areaName + "</td>" +
                "<td title=\"\">" + provisionFlag + "</td>" +
                "</tr>";

            var itemObject = $(html_item);

            for (var j =0; j < alarmTargetDeviceConfigList.length; j++) {

                var alarmDeviceId = alarmTargetDeviceConfigList[j]['alarmDeviceId'];

                if (alarmDeviceId == deviceId) {
                    itemObject.find("input[type='checkbox']").attr("checked", "checked");
                    break;
                }

            }

            itemObject.attr("device_id", deviceId );
            $("#actionList > tbody").append(itemObject);
        }
    };

    /**
     * 파일 설정 목록 그리기
     * @param files
     */
    DeviceView.makeFileListFunc = function(files) {
        $("#fileList").empty();

        if (files == null && files.length == 0) {
            $("#fileList").append(emptyListTag.clone());
            return;
        }

        for (var i=0; i< files.length; i++) {
            var file = files[i];
            var selYn = false;

            if(file['fileId']==$("input[name='fileId']").val()){
                selYn = true;
            }

            $("#fileList").append(
                $("<tr/>").append(
                    $("<td/>", {class:'t_center'}).append(
                        $("<input/>", {type:'checkbox', class:'checkbox', name:'fileCheckbox', fileId:file['fileId'], fileName:file['logicalFileName'], checked:selYn}).on("click",function(){
                            if($(this).is(":checked")){
                                $("input[name='fileCheckbox']").prop("checked",false);
                                $(this).prop("checked",true);
                                $("input[name='fileId']").val($(this).attr("fileId"));
                                $("input[name='fileName']").val($(this).attr("fileName"));
                            }else{
                                $("input[name='fileId']").val("");
                                $("input[name='fileName']").val("");
                            }
                        })
                    )
                ).append(
                    $("<td/>").text(file['title'])
                ).append(
                    $("<td/>").text(file['logicalFileName'])
                ).append(
                    $("<td/>").text(file['description'])
                ).append(
                    $("<td/>").text(file['insertUserName'])
                ).append(
                    $("<td/>").text(new Date(file['insertDatetime']).format("yyyy-mm-dd HH:mm:ss"))
                )
            );
        }
    };

    return DeviceView;
};