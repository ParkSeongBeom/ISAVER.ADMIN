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

            $(formName + " [id='selectParentDeviceId']").val(data.parentDeviceId);
            $("#deviceForm" + " [id='selectParentDeviceId']").find("option[value=" +DeviceView._model.getDeviceId()+"]").attr('disabled', true);
        },
        deviceTypeCode: function (data) {
            var deviceTypeCode = data['deviceTypeCode'];
            $(formName + " [id='selectDeviceType']").val(deviceTypeCode);
        },
        areaId: function (data) {
            $(formName + " [id='selectAreaId']").val(data.areaId);
            $(formName + " [name='areaId']").val(data.areaId);
        },
        deviceCode: function (data) {
            var deviceCode = data['deviceCode'];
            $(formName + " [id='selectDeviceCode']").val(deviceCode);
        },
        serialNo: function (data) {
            $(formName + " [name='serialNo']").val(data.serialNo);
        },
        ipAddress: function (data) {
            $(formName + " [name='ipAddress']").val(data.ipAddress);
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

        DeviceView.setSaveBefore();


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
            persist: true,
            onPostInit: function (isReloading, isError) {
                var myParam = location.search.split('ctrl=')[1];

                if (myParam) {
                    if ("reload" == myParam) {
                        this.reactivate();
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

        $(formName + " [name='deviceId']").val("");
        $(formName + " [name='serialNo']").val("");
        //$(formName + " [id='selectUpOrgSeq']").val("");

        //$(formName + " [name='areaName']").val("");
        $(formName + " [name='deviceId']").removeAttr("readonly");
        $(formName + " [name='serialNo']").removeAttr("readonly");
        //$(formName + " [name='orgDepth']").val("");
        //$(formName + " [name='sortOrder']").val("");
        $(formName + " td[name='insertUserId']").text("");
        $(formName + " td[name='insertDatetime']").text("");
        $(formName + " td[name='updateUserId']").text("");
        $(formName + " td[name='updateDatetime']").text("");

        $("table tbody tr").eq(1).show();
        $("table tbody tr").eq(2).show();
        $("table tbody tr").eq(3).show();
        $("table tbody tr").eq(4).show();
        $("table tbody tr").eq(5).show();


        if (DeviceView._model.getDeviceId() == DeviceView._model.getRootOrgId()) {

            $("table tbody tr").eq(1).hide();
            $("table tbody tr").eq(2).hide();
            $("table tbody tr").eq(3).hide();
            $("table tbody tr").eq(4).hide();
            $("table tbody tr").eq(5).hide();

            $(formName + " [name='areaName']").attr("readonly", "readonly");
            $(formName + " [name='areaName']").val("HOME");
            $(formName + " [name='areaId']").val(DeviceView._model.getDeviceId());
            $(formName + " [name='parentDeviceId']").val("");

            $("table[name='roleListTable'] tbody").empty();
            $("#pageContainer").empty();
            $('#selectAll').checked = false;

            $("[name='showHideTag']").hide();
            $("button[name='addBtn']").hide();
            $("button[name='saveBtn']").hide();
            $("button[name='removeBtn']").hide();

            $(".search_area").show();
            $("#roleListTable").show();
        }
    };
    /**
     * 장치 등록 전 초기화 모드
     */
    DeviceView.setAddBefore = function() {
        $("[name='showHideTag']").hide();

        $("input[name='deviceId']").val("").removeAttr("readonly");
        $("input[name='serialNo']").val("").removeAttr("readonly");

        $("textarea[name='deviceDesc']").val("");

        $("button[name='addBtn']").show();
        $("button[name='saveBtn']").hide();
        $("button[name='removeBtn']").hide();
        $("button[name='orgUserAddBtn']").hide()
        $("button[name='orgUserRemoveBtn']").hide();

        $("input:hidden[name='parentDeviceId']").val(DeviceView._model.getDeviceId());

        $("select[id=selectDeviceType]  option:eq(0)").attr("selected", "selected");
        $("select[id=selectDeviceCode]  option:eq(0)").attr("selected", "selected");
        $("select[id=selectAreaId]  option:eq(0)").attr("selected", "selected");

        var formName = "#" +DeviceView._model.getFormName();
        $( formName + " [id='selectParentDeviceId'] option").attr('disabled', false);

        if (DeviceView._model.getParentDeviceId() == null || DeviceView._model.getParentDeviceId() == "") {
            $( formName + " [id='selectParentDeviceId']").val("");
        } else {
            $( formName + " [id='selectParentDeviceId']").val(DeviceView._model.getDeviceId());
        }

        $( formName + " [id='selectAreaId']").val(DeviceView._model.getAreaId());

        $("input[name='deviceId']").focus();

    };

    /**
     * 장치 저장 전 초기화 모드
     */
    DeviceView.setSaveBefore = function() {
        $("[name='showHideTag']").show();

        $("tr[name='orgSortTr']").show();
        $("tr[name='orgDateTr']").show();
        $("button[name='addBtn']").hide();
        $("button[name='saveBtn']").show();
        $("input[name='orgSort']").show();
        $("button[name='removeBtn']").show();
        $("button[name='orgUserAddBtn']").show();
        $("button[name='orgUserRemoveBtn']").show();

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

    return DeviceView;
};