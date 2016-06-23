/**
 * [VIEW] 구역
 *
 * @author dhj
 * @since 2016.06.07
 */
function AreaView(model) {
    var AreaView = new Object();
    AreaView._model = model;
    var formName = "#" + model.getFormName();
    var switchMenuDetailObj = {
        areaId: function (data) {
            $(formName + " [name='areaId']").val(data.areaId);
        },
        parentAreaId: function (data) {

            $(formName + " [name='parentAreaId']").val(data.parentAreaId);

            $(formName + " [id='selectParentAreaId'] option").attr('disabled', false);
            $(formName + " [id='selectParentAreaId']").find("option[value=" +AreaView._model.getAreaId()+"]").attr('disabled', true);

            if (data['parentAreaId'] != null && String(data['parentAreaId']).trim().length > 0) {
                $(formName + " [id='selectParentAreaId']").val(data.parentAreaId);
            } else {
                $(formName + " [id='selectParentAreaId']").val("");
            }

        },
        areaName: function (data) {
            $(formName + " [name='areaName']").val(data.areaName);
        },
        areaDesc: function (data) {
            $(formName + " [name='areaDesc']").val(data.areaDesc);
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
            insertDatetime.setTime(data.insertDatetime);
            $(formName + " td[name='insertDatetime']").text(insertDatetime.format("yyyy-MM-dd HH:mm:ss"));
        },
        updateUserName: function (data) {
            $(formName + " td[name='updateUserName']").text(data.updateUserName);
        },
        updateDatetime: function (data) {

            var updateDatetime = new Date();
            updateDatetime.setTime(data.updateDatetime);
            $(formName + " td[name='updateDatetime']").text(updateDatetime.format("yyyy-MM-dd HH:mm:ss"));
        },
        _default: function () {
        }
    };

    /**
     * [Draw] 구역 상세 생성
     *
     * @param obj
     * @see dhj
     * @date 2014.05.20
     */
    AreaView.setDetail = function (obj) {

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

        AreaView.setSaveBefore();


    };

    /**
     * [Draw] 좌측 구역 트리 그리기
     * @param obj
     */
    AreaView.setMenuTree = function (menuTreeModel) {

        var areaCtrl = new AreaCtrl(AreaView._model);

        $(AreaView._model.getTreaArea()).dynatree({
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
            ,onActivate: areaCtrl.selectMenuTree
        });


    };

    /**
     * [Draw] 구역 정렬 순서 동적으로 생성하기
     */
    AreaView.setOrgUserDetail = function(deviceModel) {

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
    AreaView.setPagingView = function() {
        $("#pageContainer").empty();
        var num = this._model.getPageIndex() == 0 ? 1 :this._model.getPageIndex();
        drawPageNavigater(this._model.getPageRowNumber(), num, this._model.getPageCount());
    };

    /**
     * 구역 상세 정보 호출 전 초기화 모드
     */
    AreaView.setFindDetailBefore = function (data) {

        var AreaView = new Object();
        AreaView._model = model;
        var formName = "#" + model.getFormName();

        $(formName + " [name='areaId']").val("");
        $(formName + " [id='selectUpOrgSeq']").val("");

        $(formName + " [name='areaName']").val("");
        $(formName + " [name='areaName']").removeAttr("readonly");
        $(formName + " [name='orgDepth']").val("");
        $(formName + " [name='sortOrder']").val("");
        $(formName + " td[name='insertUserId']").text("");
        $(formName + " td[name='insertDatetime']").text("");
        $(formName + " td[name='updateUserId']").text("");
        $(formName + " td[name='updateDatetime']").text("");


        $("table tbody tr").eq(1).show();
        $("table tbody tr").eq(2).show();
        $("table tbody tr").eq(3).show();
        $("table tbody tr").eq(4).show();
        $("table tbody tr").eq(5).show();


        if (AreaView._model.getAreaId() == AreaView._model.getRootOrgId()) {

            $("table tbody tr").eq(1).hide();
            $("table tbody tr").eq(2).hide();
            $("table tbody tr").eq(3).hide();
            $("table tbody tr").eq(4).hide();
            $("table tbody tr").eq(5).hide();

            $(formName + " [name='areaName']").attr("readonly", "readonly");
            $(formName + " [name='areaName']").val("HOME");
            $(formName + " [name='areaId']").val(AreaView._model.getAreaId());
            $(formName + " [name='parentAreaId']").val("");

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
     * 구역 등록 전 초기화 모드
     */
    AreaView.setAddBefore = function() {

        $("table tbody tr").eq(1).show();
        $("table tbody tr").eq(2).show();
        $("table tbody tr").eq(3).show();
        $("table tbody tr").eq(4).show();
        $("table tbody tr").eq(5).show();
        $("table tbody tr").eq(6).show();

        $("[name='showHideTag']").hide();

        var AreaView = new Object();
        AreaView._model = model;
        var formName = "#" + model.getFormName();

        $("[name='showHideTag']").hide();

        $("tr[name='orgSortTr']").hide()
        $("tr[name='orgDateTr']").hide();

        $("input[name='areaId']").val("").removeAttr("readonly");
        $("input[name='areaName']").val("").removeAttr("readonly");
        $("textarea[name='areaDesc']").val("");
        $("input[name='sortOrder']").val(0);

        $("button[name='addBtn']").show();
        $("button[name='saveBtn']").hide();
        $("button[name='removeBtn']").hide();
        $("button[name='orgUserAddBtn']").hide()
        $("button[name='orgUserRemoveBtn']").hide();


        $("input:hidden[name='parentAreaId']").val(AreaView._model.getAreaId());

        $( formName + " [id='selectParentAreaId'] option").attr('disabled', false);
        $( formName + " [id='selectParentAreaId']").val(AreaView._model.getAreaId());

        $("input[name='areaId']").focus();

    };

    /**
     * 구역 저장 전 초기화 모드
     */
    AreaView.setSaveBefore = function() {
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
     * 구역 등록 팝업 창 띄우기
     */
    AreaView.openPopupUserPage = function() {
        window.open(this._model.getRequestUrl('addOrgUser') + "?id=" + this._model.getOrgId(),'detailUserPopup','scrollbars=no,width=800,height=680,left=50,top=50');
    };

    /**
     * 구역 깊이 초기화
     */
    AreaView.resetOrgDepth = function() {
        $(formName + " [name='orgDepth']").val("0");
    };

    return AreaView;
};