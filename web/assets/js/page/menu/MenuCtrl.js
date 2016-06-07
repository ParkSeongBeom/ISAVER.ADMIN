/**
 * [Controller] 메뉴 관리
 *
 * @author dhj
 * @since 2014.05.20
 */
function MenuCtrl(model) {

    var MenuCtrl = new Object();
    MenuCtrl._model = model;
    MenuCtrl._event = new MenuEvent(model);

    /**
     * 메뉴 선택
     * @param node
     * @date 2014.05.22
     */
    MenuCtrl.selectMenuTree = function (node) {
        if (node != null || node != undefined) {
            var menuId = node.data.id;
            if (menuId != null || menuId != undefined) {
                MenuCtrl.findMenuDetail(menuId);
            }
        }
    };

    /**
     * 선택한 메뉴 ID로 상세 정보 가져오기
     * @date 2014.05.22
     */
    MenuCtrl.findMenuDetail = function (menuId) {
        if (menuId != null || menuId != undefined) {
            this._model.setMenuId(menuId);
            this.param = {
                menuId: menuId
            };

            this._model.setViewStatus('detail');
            var requestUrl = this._model.getRequestUrl();
            sendAjaxPostRequest(requestUrl, this.param, this._event.detailSuccessHandler, this._event.detailErrorHandler);
        }
    };

    /**
     * [cRud]메뉴 상위 바 불러오기
     */
    MenuCtrl.findMenuTopBar = function (targetMenuId) {

        this._model.setViewStatus('menuBar');
        this._model.setTargetMenuId(targetMenuId);
        var type = this._model.getViewStatus();
        var requestUrl = this._model.getRequestUrl();
        sendAjaxPostRequest(requestUrl, this.param, this._event.menuTopBarSuccessHandler, this._event.menuTopBarErrorHandler, type);
    },

    /**
     * [cRud]메뉴 트리 불러오기
     */
    MenuCtrl.findMenuTree = function (menuId) {

        this._model.setViewStatus('menuTree');
        var type = this._model.getViewStatus();
        var requestUrl = this._model.getRequestUrl();
        sendAjaxPostRequest(requestUrl, {}, this._event.menuTreeSuccessHandler, this._event.menuTreeErrorHandler, type);
    };

    /**
     * 메뉴 등록 전 초기화 모드
     */
    MenuCtrl.setAddBefore = function() {
        this._model.setViewStatus(MenuModel().model.ACTION.ADD);
        var mView = new MenuView(this._model);
        mView.setAddBefore();
    };

    /**
     * 메뉴 저장 전 초기화 모드
     */
    MenuCtrl.setSaveBefore = function() {
        this._model.setViewStatus(MenuModel().model.ACTION.SAVE);
        var mView = new MenuView(this._model);
        mView.setSaveBefore();
    };

    /**
     * 전송 전 유효성 체크
     */
    MenuCtrl.commonVaild = function() {

        var num_regx=/^[0-9]*$/;

        if ($("input[name='menuName']").val().trim().length == 0) {
            $("input[name='menuName']").focus();
            alert(messageConfig.requiredMenuName);
            return false;
        }

        if ($("input[name='menuUrl']").val().trim().length == 0) {
            $("input[name='menuUrl']").focus();
            alert(messageConfig.requiredMenuUrl);
            return false;
        }

        if ($("input[name='sortOrder']").val().trim().length == 0) {
            $("input[name='sortOrder']").focus();
            alert(messageConfig.requiredMenuUrl);
            return false;
        }

        if(!num_regx.test($("input[name='sortOrder']").val())) {
            $("input[name='sortOrder']").focus();
            alert(messageConfig.regexpDigits);
            return false;
        }

        return true;
    };

    /**
     * 메뉴 등록 전 유효성 검증
     */
    MenuCtrl.addMenuVaild = function() {

        if (this.commonVaild()) {
            this._model.setViewStatus(MenuModel().model.ACTION.ADD);
            var menuName = $("input[name=menuName]").val();
            if(confirm('[' + menuName + ']' + messageConfig['addConfirmMessage'] + '?')) {
                this.addMenu();
            }

        }

    };

    /**
     * 메뉴 저장 전 유효성 검증
     */
    MenuCtrl.saveMenuVaild = function() {

        if (this.commonVaild()) {
            this._model.setViewStatus(MenuModel().model.ACTION.SAVE);
            var menuName = $("input[name=menuName]").val();
            if(confirm('[' + menuName + ']' + messageConfig['saveConfirmMessage'] + '?')) {
                this.saveMenu();
            }

        }
    };

    /**
     * 메뉴 삭제 전 유효성 검증
     */
    MenuCtrl.removeMenuVaild = function() {
        if (MenuCtrl._model.getMenuDepth() == "0") {
            alert(String(messageConfig.menuNotDeleted));
            return;
        }
        MenuCtrl.removeMenu();
    };

    /**
     * [Crud]메뉴 등록
     */
    MenuCtrl.addMenu = function() {

        var type = MenuCtrl._model.getViewStatus();

        if(type != MenuModel().model.ACTION.ADD) {
            return;
        }

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + MenuCtrl._model.getFormName();

        /*
            hidden 필드에 부모 아이디를 삽입
         */
        $('input:hidden[name=parentMenuId]').val($("#selectParentMenuId").val());

        var roleIds = new Array();

        $("table[name='roleListTable'] tbody tr").each(function() {

            if ($(this).find('input:checkbox').is(':checked')) {
                roleIds.push($(this).find("td").eq(1).text());
            }
        });

        $(formName + " input[name='roleIds']").val(roleIds.join(","));
        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.menuCudSuccessHandler, this._event.menuCudErrorHandler, type);
    };


    /**
     * [crUd] 메뉴 수정
     */
    MenuCtrl.saveMenu = function() {

        var type = MenuCtrl._model.getViewStatus();

        if (MenuCtrl._model.getMenuDepth() == "0") {
            $('input:hidden[name=parentMenuId]').val("");
        }

        if(type != MenuModel().model.ACTION.SAVE) {
            return;
        }

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + MenuCtrl._model.getFormName();
        var roleIds = new Array();

        $("table[name='roleListTable'] tbody tr").each(function() {

            if ($(this).find('input:checkbox').is(':checked')) {
                roleIds.push($(this).find("td").eq(1).text());
            }
        });

        $(formName + " input[name='roleIds']").val(roleIds.join(","));

        if ($('input:hidden[name=menuid]').val() == this._model.getRootUrl()) {
            $('input:hidden[name=parentMenuId]').val('');
        }

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.menuCudSuccessHandler, this._event.menuCudErrorHandler, type);
    };

    /**
     * [cruD] 메뉴 삭제
     */
    MenuCtrl.removeMenu = function() {

        var menuName = document.forms[menuModel.getFormName()]['menuName'].value;

        if(!confirm("[ " + menuName +" ] " +messageConfig.removeConfirmMessage+"?")) return;

        var type = MenuCtrl._model.model.ACTION.REMOVE;
        this._model.setViewStatus(type);

        var requestUrl = this._model.getRequestUrl();
        var formName = "#" + MenuCtrl._model.getFormName();

        var roleIds = new Array();

        $("table[name='roleListTable'] tbody tr").each(function() {

            if ($(this).find('input:checkbox').is(':checked')) {
                roleIds.push($(this).find("td").eq(1).text());
            }
        });

        $(formName + " input[name='roleIds']").val(roleIds.join(","));

        if ($('input:hidden[name=menuid]').val() == this._model.getRootUrl()) {
            $('input:hidden[name=parentMenuId]').val('');
        }

        sendAjaxPostRequest(requestUrl, $(formName).serialize(), this._event.menuCudSuccessHandler, this._event.menuCudErrorHandler, type);

    };

    /**
     * 메뉴 트리 새로 고침
     */
    MenuCtrl.setMenuTreeReset = function() {
        $(this._model.getTreaArea()).dynatree('destroy');
        $(this._model.getTreaArea()).empty();

        this.findMenuTree();
    }

    /**
     * 메뉴 트리 전체 펼치기
     */
    MenuCtrl.treeExpandAll = function() {
        $(this._model.getTreaArea()).dynatree("getRoot").visit(function(node){
            node.expand(true);
        });
    };
    return MenuCtrl;
}

/**
 * [Event] 메뉴 관리
 *
 * @author dhj
 * @since 2014.05.20
 */
function MenuEvent(model) {
    var MenuEvent = new Object();
    var menuView = new MenuView(model);

    MenuEvent._model = model;

    /**
     * [SUCCESS][RES] 상위 메뉴 바 불러오기 성공 시
     * @param data
     * @param dataType
     * @param actionType
     */
    MenuEvent.menuTopBarSuccessHandler = function (data, dataType, actionType) {
        menuView.setTopMenuBar(data['menuBarList']);
    };

    /**
     * [FAIL][RES] 상위 메뉴 바 불러오기 실패시
     * @param data
     * @param dataType
     * @param actionType
     */
    MenuEvent.menuTopBarErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][MenuEvent.menuTopBarErrorHandler] " + errorThrown);
        alert(messageConfig[actionType + 'Failure']);
    };

    /**
     * [SUCCESS][RES] 트리 메뉴 불러오기 성공 시 이벤트
     */
    MenuEvent.menuTreeSuccessHandler = function (data, dataType, actionType) {
        var menuTreeModel = MenuEvent._model.processMenuTreeData(data.menuTreeList, MenuEvent._model.getRootMenuId());
        menuView.setMenuTree(menuTreeModel);
    };

    /**
     * [FAIL][RES] 트리 메뉴 불러오기 실패 시
     */
    MenuEvent.menuTreeErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][MenuEvent.menuTreeErrorHandler] " + errorThrown);
        alert(messageConfig[actionType + 'Failure']);
    };

    /**
     * [SUCCESS][RES] 상세 메뉴 불러오기 성공 시 이벤트
     * @param data
     * @param dataType
     * @param actionType
     */
    MenuEvent.detailSuccessHandler = function (data, dataType, actionType) {
        if (typeof data == "object" && data.hasOwnProperty("menu")) {
            try {
                MenuEvent._model.setMenuId(data.menu.menuId);
                MenuEvent._model.setMenuName(data.menu.menuName);
                MenuEvent._model.setUseFlag(data.menu.useFlag);
                MenuEvent._model.setMenuDepth(data.menu.menuDepth);
                MenuEvent._model.setParentMenuId(data.menu.parentMenuId);
            } catch(e) {
                console.error("[Error][MenuEvent.detailSuccessHandler] " + e);
            }
            menuView.setDetail(data.menu);
        }
        if (typeof data == "object" && data.hasOwnProperty("roles")) {
            menuView.setRoleList(data.roles);
        }

        $('#selectAll').checked = false;
    };

    /**
     * [FAIL][RES] 상세 메뉴 불러오기 실패 시 이벤트
     * @param XMLHttpRequest
     * @param textStatus
     * @param errorThrown
     * @param actionType
     */
    MenuEvent.detailErrorHandler = function (XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][MenuEvent.detailErrorHandler] " + errorThrown);
        alert(messageConfig[actionType + 'Failure']);
        $('#selectAll').checked = false;
    };

    /**
     * [SUCCESS][RES] 메뉴 CUD 성공 시 이벤트
     */
    MenuEvent.menuCudSuccessHandler = function(data, dataType, actionType) {
        alert(messageConfig[actionType + 'Complete']);
        window.location.reload();
    };

    /**
     * [FAIL][RES] 메뉴 CUD 실패 시 이벤트
     */
     MenuEvent.menuCudErrorHandler = function(XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][MenuEvent.menuCudErrorHandler] " + errorThrown);
        alert(messageConfig[actionType + 'Failure']);

     };

    return MenuEvent;
}