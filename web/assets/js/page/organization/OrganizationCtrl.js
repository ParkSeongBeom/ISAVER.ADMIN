/**
 * [Controller] 조직도
 *
 * @author dhj
 * @since 2014.06.08
 */
function OrganizationCtrl(model) {

    var OrganizationCtrl = new Object();
    OrganizationCtrl._model = model;
    OrganizationCtrl._event = new OrganizationEvent(model);

    /**
     * 조직도 선택
     * @param node
     * @date 2014.05.22
     */
    OrganizationCtrl.selectMenuTree = function (node) {
        if (node != null || node != undefined) {
            var id = node.data.id;
            if (id != null || id != undefined) {
                OrganizationCtrl._model.setOrgId(String(id));
                OrganizationCtrl._model.setPageIndex(0);
                OrganizationCtrl.findMenuDetail();
            }
        }
    };

    /**
     * [cRud]조직도 트리 불러오기
     */
    OrganizationCtrl.findMenuTree = function () {
        this._model.setViewStatus('menuTree');
        var type = this._model.getViewStatus();
        var requestUrl = this._model.getRequestUrl();
        sendAjaxPostRequest(requestUrl, {}, this._event.menuTreeSuccessHandler, this._event.menuTreeErrorHandler, type);
    };

    /**
     * [cRud] 선택한 부서 ID로 상세 정보 가져오기
     */
    OrganizationCtrl.findMenuDetail = function () {
        if (this._model.getOrgId() != null || this._model.getOrgId() != undefined) {

            this.param = {
                id: this._model.getOrgId()
                ,userId: this._model.getUserId()
                ,name: this._model.getUserName()
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
     * 조직도 사용자 상세 조회
     */
    OrganizationCtrl.searchOrgUser = function() {
        if (this.commonVaild()) {
            this._model.setUserId($("input[name='userId']").val());
            this._model.setUserName($("input[name='userName']").val());

            OrganizationCtrl.findMenuDetail();
        }

    };

    /**
     * 전송 전 유효성 체크
     */
    OrganizationCtrl.commonVaild = function(flag) {

        if (this._model.getOrgId() != undefined && String(this._model.getOrgId()).trim().length == 0) {
            alert("좌측 부서 목록에서 부서를 선택해 주세요.");
            return;
        }

        var type = OrganizationCtrl._model.getViewStatus();

        if (flag != undefined && flag) {

            if ($("input[name='orgName']").val().trim().length == 0) {
                $("input[name='orgName']").focus();
                alert(messageConfig.requiredOrgName);
                return;
            }

            if (type != OrganizationModel().model.ACTION.ADD) {

                if($("table tbody tr").eq(2).css("display") != "none"){
                    if ($("input[name='sortOrder']").val().trim().length == 0) {
                        $("input[name='sortOrder']").focus();
                        alert(messageConfig.requiredSortOrder);
                        return;
                    }
                }
            }

        }

        return true;
    };

    /**
     * 조직 등록 전 유효성 검증
     */
    OrganizationCtrl.addOrganizationVaild = function () {

        this._model.setViewStatus(MenuModel().model.ACTION.ADD);
        if (this.commonVaild(true)) {

            var orgName = $("input[name=orgName]").val();
            if(confirm('[' + orgName + ']' + messageConfig['addConfirmMessage'] + '?')) {
                this.addOrganization();
            }

        }
    };

    /**
     * 조직 저장 전 유효성 검증
     */
    OrganizationCtrl.saveOrganizationVaild = function () {

        this._model.setViewStatus(MenuModel().model.ACTION.SAVE);

        if (this.commonVaild(true)) {

            var orgName = $("input[name=orgName]").val();
            if(confirm('[' + orgName + ']' + messageConfig['saveConfirmMessage'] + '?')) {
                this.saveOrganization();
            }

        }

    };

    /**
     * 조직도 삭제 전 유효성 검증
     */
    OrganizationCtrl.removeOrganizationVaild = function () {

        if (this.commonVaild()) {
            if (OrganizationCtrl._model.getOrgId() == OrganizationCtrl._model.getRootOrgId()) {
                alert(String(messageConfig.organizationNotDeleted));
                return;
            }

            var orgName = document.forms[OrganizationCtrl._model.getFormName()]['orgName'].value;

            if (!confirm("[ " + orgName + " ] " + messageConfig['removeConfirmMessage'] + "?")) return;

            OrganizationCtrl.removeOrganization();
        }

    };

    /**
     * [Crud] 조직 등록
     */
    OrganizationCtrl.addOrganization = function () {
        var type = OrganizationCtrl._model.getViewStatus();
        if (type != OrganizationModel().model.ACTION.ADD) {
            return;
        }

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + OrganizationCtrl._model.getFormName();

        $('input:hidden[name=upOrgId]').val($("#selectUpOrgSeq").val());
        OrganizationCtrl._model.setUpOrgId($("#selectUpOrgSeq").val());


        if (OrganizationCtrl._model.getUpOrgId() == OrganizationCtrl._model.getRootOrgId()) {
            $('input[name=depth]').val(0);
        }

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.organizationCudSuccessHandler, this._event.organizationCudErrorHandler, type);
    };

    /**
     * [crUd] 조직 저장
     */
    OrganizationCtrl.saveOrganization = function () {


        var type = OrganizationCtrl._model.getViewStatus();

        if (type != MenuModel().model.ACTION.SAVE) {
            return;
        }

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + OrganizationCtrl._model.getFormName();
        var roleIds = new Array();

        var orgUserLists = [];
        $(formName + " input[name='roleIds']").val("");

        $("table[name='roleListTable'] tbody tr").each(function () {
            var orgSort = $(this).find("input[name='orgSortName']").val();
            this.orgUser = {
                orgId          : $(this).find("input[name='orgIdName']").val()
                ,userId        : $(this).find("input[name='userIdName']").val()
                ,classification : $(this).find("input[name='classification']").val()
                ,sortOrder      : orgSort != "" ? orgSort : "0"
//                ,mainFlag       : $(this).find("input[id='mainFlag']").is(':checked') ? "Y":"N"
            };
            orgUserLists.push(this.orgUser);
        });

        $('input:hidden[name=upOrgId]').val($("select[id=selectUpOrgSeq]").val());

        if (orgUserLists.length > 0 ){
            $(formName + " input[name='roleIds']").val(JSON.stringify(orgUserLists));
        }
        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.organizationCudSuccessHandler, this._event.organizationCudErrorHandler, type);
    };

    /**
     * [cruD] 부서 삭제
     */
    OrganizationCtrl.removeOrganization = function () {

        var type = OrganizationCtrl._model.model.ACTION.REMOVE;
        this._model.setViewStatus(type);

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + OrganizationCtrl._model.getFormName();

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.organizationCudSuccessHandler, this._event.organizationCudErrorHandler, type);

    };

    /**
     * [cruD] 사용자 조직도 삭제, 단건
     * @param userSeq
     */
    OrganizationCtrl.removeOrgUser = function(userSeq, userName) {

        if(!confirm('[ ' + userName + ' ] ' + messageConfig.removeConfirmMessage + '?')) return;

        var type = OrganizationCtrl._model.model.ACTION.ORG_USER_REMOVE;

        this._model.setViewStatus(type);

        var requestUrl = this._model.getRequestUrl();
        sendAjaxPostRequest(requestUrl, {orgSeq: this._model.getOrgSeq(), userSeq: userSeq}, this._event.organizationCudSuccessHandler, this._event.organizationCudErrorHandler, type);
    };

    /**
     * [cruD] 조직에 속한 사용자 삭제, 복수 건
     * @param userSeq
     * @param userName
     */
    OrganizationCtrl.removeOrgUsers = function() {


        var orgUserLists = [];
        var formName = "#" + OrganizationCtrl._model.getFormName();
        $(formName + " input[name='roleIds']").val("");

        $("table[name='roleListTable'] tbody tr").each(function () {
            if ($(this).find("input[type='checkbox']").is(':checked')) {
                var orgSort = $(this).find("input[name='orgSortName']").val();
                this.orgUser = {
                    orgId          : $(this).find("input[name='orgIdName']").val()
                    ,userId        : $(this).find("input[name='userIdName']").val()
                };
                orgUserLists.push(this.orgUser);
            }

        });

        if (orgUserLists.length == 0) {
            alert(messageConfig.removeUserValidationErrorMessage);
            return;
        }

        if (!confirm(orgUserLists.length + " " + messageConfig.removeUserConfirmMessage + "?")) return;


        $('input:hidden[name=upOrgSeq]').val($("select[id=selectUpOrgSeq]").val());

        var type = OrganizationCtrl._model.model.ACTION.ORG_USER_REMOVES;
        this._model.setViewStatus(type);

        var requestUrl = this._model.getRequestUrl();

        if (orgUserLists.length > 0 ){
            $(formName + " input[name='roleIds']").val(JSON.stringify(orgUserLists));
        }

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.organizationCudSuccessHandler, this._event.organizationCudErrorHandler, type);

    }
    /**
     * 조직도 트리 새로 고침
     */
    OrganizationCtrl.setMenuTreeReset = function () {
        $(this._model.getTreaArea()).dynatree('destroy');
        $(this._model.getTreaArea()).empty();

        this.findMenuTree();
    }

    /**
     * 조직도 트리 전체 펼치기
     */
    OrganizationCtrl.treeExpandAll = function () {
        $(this._model.getTreaArea()).dynatree("getRoot").visit(function (node) {
            node.expand(true);
        });
    };

    /**
     * 조직도 등록 전 초기화 모드
     */
    OrganizationCtrl.setAddBefore = function() {
        this._model.setViewStatus(MenuModel().model.ACTION.ADD);
        var orgView = new OrganizationView(this._model);
        orgView.setAddBefore();
    };

    /**
     * 조직도 저장 전 초기화 모드
     */
    OrganizationCtrl.setSaveBefore = function() {
        this._model.setViewStatus(MenuModel().model.ACTION.SAVE);
        var orgView = new OrganizationView(this._model);
        orgView.setSaveBefore();
    };

    /**
     * 부서원 등록 팝업 창 띄우기
     */
    OrganizationCtrl.openPopupUserPage = function() {
        if (this.commonVaild()) {
            this._model.setViewStatus("addOrgUser");
            var orgView = new OrganizationView(this._model);
            orgView.openPopupUserPage();
        }

    };

    return OrganizationCtrl;

}

/**
 * [Event] 조직도
 *
 * @author dhj
 * @since 2014.05.20
 */
function OrganizationEvent(model) {
    var OrganizationEvent = new Object();
    var organizationView = new OrganizationView(model);

    OrganizationEvent._model = model;

    /**
     * [SUCCESS][RES] 부서 전체 목록 불러오기 성공 시 이벤트
     */
    OrganizationEvent.menuTreeSuccessHandler = function (data, dataType, actionType) {
        var menuTreeModel = OrganizationEvent._model.processMenuTreeData(data['organizationList'], OrganizationEvent._model.getRootOrgId());

        organizationView.setMenuTree(menuTreeModel);
    };

    /**
     * [FAIL][RES] 부서 전체 목록 불러오기 실패 시
     */
    OrganizationEvent.menuTreeErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][OrganizationEvent.menuTreeErrorHandler] " + errorThrown);
        alert(messageConfig[OrganizationEvent._model.getViewStatus() + 'Failure']);
    };

    /**
     * [SUCCESS][RES] 부서별 상세 정보 - 불러오기 성공 시 이벤트
     * @param data
     * @param dataType
     * @param actionType
     */
    OrganizationEvent.detailSuccessHandler = function (data, dataType, actionType) {

        organizationView.setFindDetailBefore(data);

        if (typeof data == "object" && data.hasOwnProperty("organization") && data.organization!=null) {
            try {
                OrganizationEvent._model.setOrgId(data.organization.orgId);
            } catch (e) {
                console.error("[Error][OrganizationEvent.detailSuccessHandler] " + e);
            }
            try {
                OrganizationEvent._model.setOrgName(data.organization.orgName);
            } catch (e) {
                console.error("[Error][OrganizationEvent.detailSuccessHandler] " + e);
            }

            try {
                OrganizationEvent._model.setDepth(data.organization.depth);
            } catch (e) {
                organizationView.resetOrgDepth();
                console.error("[Error][OrganizationEvent.detailSuccessHandler] " + e);
            }

            try {
                OrganizationEvent._model.setUpOrgId(data.organization.upOrgId);
            } catch (e) {
                console.error("[Error][OrganizationEvent.detailSuccessHandler] " + e);
            }
            organizationView.setDetail(data.organization);
        }

        $("table[name='roleListTable'] tbody").empty();
        $("#pageContainer").empty();
        $('#selectAll').checked = false;

        if (typeof data == "object" && data.hasOwnProperty("orgUsers") && data["orgUsers"].length > 0) {

            organizationView.setOrgUserDetail(data.orgUsers);
            OrganizationEvent._model.setPageCount(data.totalCount);
            organizationView.setPagingView();
        }
    };

    /**
     * [FAIL][RES] 상세 메뉴 불러오기 실패 시 이벤트
     * @param XMLHttpRequest
     * @param textStatus
     * @param errorThrown
     * @param actionType
     */
    OrganizationEvent.detailErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][OrganizationEvent.detailErrorHandler] " + errorThrown);
        console.error("[Error][OrganizationEvent.detailErrorHandler] " + errorThrown);
        alert(messageConfig[OrganizationEvent._model.getViewStatus() + 'Failure']);
        $('#selectAll').checked = false;
    };

    /**
     * [SUCCESS][RES] 조직 CUD 성공 시 이벤트
     */
    OrganizationEvent.organizationCudSuccessHandler = function (data, dataType, actionType) {
        /*
         * 좌측 트리 및 상단 메뉴 바 초기화
         */
//        menuCtrl.findMenuTopBar();
//        menuCtrl.setMenuTreeReset();

        alert(messageConfig[OrganizationEvent._model.getViewStatus() + 'Complete']);
        //window.location.reload();
        location.href = "./list.html?ctrl=reload";
    };

    /**
     * [FAIL][RES] 조직 CUD 실패 시 이벤트
     */
    OrganizationEvent.organizationCudErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][OrganizationEvent.organizationCudErrorHandler] " + errorThrown);
        alert(messageConfig[OrganizationEvent._model.getViewStatus() + 'Failure']);

    };

    return OrganizationEvent;
}