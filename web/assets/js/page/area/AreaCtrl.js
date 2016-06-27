/**
 * [Controller] 구역
 *
 * @author dhj
 * @since 2016.06.07
 */
function AreaCtrl(model) {

    var AreaCtrl = new Object();
    AreaCtrl._model = model;
    AreaCtrl._event = new AreaEvent(model);

    /**
     * 구역 선택
     * @param node
     * @date 2014.05.22
     */
    AreaCtrl.selectMenuTree = function (node) {
        if (node != null || node != undefined) {

            var id = node.data.id;
            if (id != null || id != undefined) {
                AreaCtrl._model.setAreaId(String(id));
                AreaCtrl._model.setPageIndex(0);
                AreaCtrl.findMenuDetail();
            }
        }
    };

    /**
     * [cRud] 구역 트리 불러오기
     */
    AreaCtrl.findMenuTree = function () {
        this._model.setViewStatus('menuTree');
        var type = this._model.getViewStatus();
        var requestUrl = this._model.getRequestUrl();

        sendAjaxPostRequest(requestUrl, {}, this._event.menuTreeSuccessHandler, this._event.menuTreeErrorHandler, type);
    };

    /**
     * [cRud] 선택한 구역 ID로 상세 정보 가져오기
     */
    AreaCtrl.findMenuDetail = function () {

        if (this._model.getAreaId() != null || this._model.getAreaId() != undefined) {

            this.param = {
                areaId : this._model.getAreaId()
                ,deviceId: this._model.getDeviceId()
                ,serialNo: this._model.getSerialNo()
                ,pageIndex: (this._model.getPageIndex() > 0) ? this._model.getPageIndex() * this._model.getPageRowNumber()-this._model.getPageRowNumber() : 0
                ,pageRowNumber: this._model.getPageRowNumber()
            };

            this._model.setViewStatus('detail');
            var type = this._model.getViewStatus();
            var requestUrl = this._model.getRequestUrl();

            sendAjaxPostRequest(requestUrl, this.param, this._event.detailSuccessHandler, this._event.detailErrorHandler, type);
        }
    };

    /**
     * 구역별 장치 상세 조회
     */
    AreaCtrl.searchDevice = function() {
        this._model.setDeviceId($("input[name='deviceId']").val());
        this._model.setSerialNo($("input[name='serialNo']").val());

        AreaCtrl.findMenuDetail();

    };

    /**
     * 전송 전 유효성 체크
     */
    AreaCtrl.commonVaild = function(flag) {

        //if (this._model.getParentAreaId() != undefined && String(this._model.getParentAreaId()).trim().length == 0) {
        //    alert("좌측 구역 목록에서 부서를 선택해 주세요.");
        //    return;
        //}

        var type = AreaCtrl._model.getViewStatus();

        if (flag != undefined && flag) {

            //if ($("input[name='areaId']").val().trim().length == 0) {
            //    $("input[name='areaId']").focus();
            //    alert(messageConfig['requiredAreaId']);
            //    return;
            //}

            if ($("input[name='areaName']").val().trim().length == 0) {
                $("input[name='areaName']").focus();
                alert(messageConfig['requiredAreaName']);
                return;
            }

            if ($("input[name='sortOrder']").val().trim().length == 0) {
                $("input[name='sortOrder']").focus();
                alert(messageConfig['requiredSortOrder']);
                return;
            }


        }

        return true;
    };

    /**
     *  구역 등록 전 유효성 검증
     */
    AreaCtrl.addAreaVaild = function () {

        this._model.setViewStatus(AreaModel().model.ACTION.ADD);
        if (this.commonVaild(true)) {

            var areaObj = AreaCtrl._model.getAreaDetail($("input[name='areaId']").val());
            if (areaObj != null) {
                alert( messageConfig['existsAreaId'] );
                $("input[name=areaId]").focus();
                return;
            }

            var areaName = $("input[name=areaName]").val();
            if(confirm('[' + areaName + '] ' + messageConfig['addConfirmMessage'] + '?')) {
                this.addArea();
            }

        }
    };

    /**
     * 구역 저장 전 유효성 검증
     */
    AreaCtrl.saveAreaVaild = function () {

        this._model.setViewStatus(AreaModel().model.ACTION.SAVE);

        if (this.commonVaild(true)) {

            var areaName = $("input[name=areaName]").val();
            if(confirm('[' + areaName + '] ' + messageConfig['saveConfirmMessage'] + '?')) {
                this.saveArea();
            }

        }

    };

    /**
     * 구역 삭제 전 유효성 검증
     */
    AreaCtrl.removeAreaVaild = function () {

        if (this.commonVaild()) {

            var areaName = document.forms[AreaCtrl._model.getFormName()]['areaName'].value;

            if (!confirm("[ " + areaName + " ] " + messageConfig['removeConfirmMessage'] + "?")) return;

            AreaCtrl.removeArea();
        }

    };

    /**
     * [Crud] 구역  등록
     */
    AreaCtrl.addArea = function () {
        var type = AreaCtrl._model.getViewStatus();
        if (type != AreaModel().model.ACTION.ADD) {
            return;
        }

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + AreaCtrl._model.getFormName();

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.areaCudSuccessHandler, this._event.areaCudErrorHandler, type);
    };

    /**
     * [crUd] 구역 저장
     */
    AreaCtrl.saveArea = function () {
        var type = AreaCtrl._model.getViewStatus();
        if (type != AreaModel().model.ACTION.SAVE) {
            return;
        }

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + AreaCtrl._model.getFormName();

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.areaCudSuccessHandler, this._event.areaCudErrorHandler, type);
    };

    /**
     * [cruD] 구역 삭제
     */
    AreaCtrl.removeArea = function () {

        var type = AreaCtrl._model.model.ACTION.REMOVE;
        this._model.setViewStatus(type);

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + AreaCtrl._model.getFormName();

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.areaCudSuccessHandler, this._event.areaCudErrorHandler, type);

    };

    /**
     * 구역 트리 새로 고침
     */
    AreaCtrl.setMenuTreeReset = function () {
        $(this._model.getTreaArea()).dynatree('destroy');
        $(this._model.getTreaArea()).empty();

        this.findMenuTree();
    }

    /**
     * 구역 트리 전체 펼치기
     */
    AreaCtrl.treeExpandAll = function () {
        $(this._model.getTreaArea()).dynatree("getRoot").visit(function (node) {
            node.expand(true);
        });
    };

    /**
     * 구역 등록 전 초기화 모드
     */
    AreaCtrl.setAddBefore = function() {
        this._model.setViewStatus(MenuModel().model.ACTION.ADD);
        var areaView = new AreaView(this._model);
        areaView.setAddBefore();
    };

    /**
     * 구역 저장 전 초기화 모드
     */
    AreaCtrl.setSaveBefore = function() {
        this._model.setViewStatus(MenuModel().model.ACTION.SAVE);
        var orgView = new AreaView(this._model);
        orgView.setSaveBefore();
    };

    /**
     * 부서원 등록 팝업 창 띄우기
     */
    AreaCtrl.openPopupUserPage = function() {
        if (this.commonVaild()) {
            this._model.setViewStatus("addOrgUser");
            var orgView = new AreaView(this._model);
            orgView.openPopupUserPage();
        }

    };

    return AreaCtrl;

}

/**
 * [Event] 구역
 *
 * @author dhj
 * @since 2016.06.07
 */
function AreaEvent(model) {
    var AreaEvent = new Object();
    var areaView = new AreaView(model);

    AreaEvent._model = model;

    /**
     * [SUCCESS][RES] 구역 전체 목록 불러오기 성공 시 이벤트
     */
    AreaEvent.menuTreeSuccessHandler = function (data, dataType, actionType) {
        AreaEvent._model.setAreaTreeList(JSON.parse(JSON.stringify(data['areaList'])));
        var menuTreeModel = AreaEvent._model.processMenuTreeData(data['areaList'], AreaEvent._model.getRootOrgId());

        areaView.setMenuTree(menuTreeModel);
    };

    /**
     * [FAIL][RES] 구역 전체 목록 불러오기 실패 시
     */
    AreaEvent.menuTreeErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][AreaEvent.menuTreeErrorHandler] " + errorThrown);
        alert(messageConfig[AreaEvent._model.getViewStatus() + 'Failure']);
    };

    /**
     * [SUCCESS][RES] 구역별 상세 정보 - 불러오기 성공 시 이벤트
     * @param data
     * @param dataType
     * @param actionType
     */
    AreaEvent.detailSuccessHandler = function (data, dataType, actionType) {

        areaView.setFindDetailBefore(data);

        if (typeof data == "object" && data.hasOwnProperty("area") && data['area']!=null) {

            try {
                AreaEvent._model.setAreaId(data['area'].areaId);
            } catch (e) {
                console.error("[Error][AreaEvent.detailSuccessHandler] " + e);
            }
            try {
                AreaEvent._model.setAreaName(data['area'].areaName);
            } catch (e) {
                console.error("[Error][AreaEvent.detailSuccessHandler] " + e);
            }

            try {
                AreaEvent._model.setDepth(data['area'].depth);
            } catch (e) {
                areaView.resetOrgDepth();
                console.error("[Error][AreaEvent.detailSuccessHandler] " + e);
            }

            try {
                AreaEvent._model.setParentAreaId(data['area'].parentAreaId);
            } catch (e) {
                console.error("[Error][AreaEvent.detailSuccessHandler] " + e);
            }

            areaView.setDetail(data.area);
        }

        $("table[name='roleListTable'] tbody").empty();
        $("#pageContainer").empty();
        $('#selectAll').checked = false;

        if (typeof data == "object" && data.hasOwnProperty("devices") && data["devices"].length > 0) {

            areaView.setOrgUserDetail(data['devices']);
            AreaEvent._model.setPageCount(data.totalCount);
            areaView.setPagingView();
        }
    };

    /**
     * [FAIL][RES] 상세 메뉴 불러오기 실패 시 이벤트
     * @param XMLHttpRequest
     * @param textStatus
     * @param errorThrown
     * @param actionType
     */
    AreaEvent.detailErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][AreaEvent.detailErrorHandler] " + errorThrown);
        console.error("[Error][AreaEvent.detailErrorHandler] " + errorThrown);
        alert(messageConfig[AreaEvent._model.getViewStatus() + 'Failure']);
        $('#selectAll').checked = false;
    };

    /**
     * [SUCCESS][RES] 구역 CUD 성공 시 이벤트
     */
    AreaEvent.areaCudSuccessHandler = function (data, dataType, actionType) {
        /*
         * 좌측 트리 및 상단 메뉴 바 초기화
         */
//        menuCtrl.findMenuTopBar();
//        menuCtrl.setMenuTreeReset();

        alert(messageConfig[AreaEvent._model.getViewStatus() + 'Complete']);
        //window.location.reload();
        location.href = "./list.html?ctrl=reload";
    };

    /**
     * [FAIL][RES] 구역 CUD 실패 시 이벤트
     */
    AreaEvent.areaCudErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][AreaEvent.organizationCudErrorHandler] " + errorThrown);
        alert(messageConfig[AreaEvent._model.getViewStatus() + 'Failure']);

    };

    return AreaEvent;
}