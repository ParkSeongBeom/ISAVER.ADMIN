/**
 * [VIEW] 메뉴 관리
 *
 * @author dhj
 * @since 2014.05.20
 */
function MenuView(model) {
    var MenuView = new Object();
    MenuView._model = model;
    var formName = "#" + model.getFormName();

    var switchMenuDetailObj = {
        menuId: function (data) {
            $(formName + " [name='menuId']").val(data.menuId);
        },
        parentMenuId: function (data) {
            $(formName + " [name='parentMenuId']").val(data.parentMenuId);
            $(formName + " select[id=selectParentMenuId]").val(data.parentMenuId).attr("selected", true);
        },
        menuName: function (data) {
            $(formName + " [name='menuName']").val(data.menuName);
        },
        menuPath: function (data) {
            $(formName + " [name='menuPath']").val(data.menuPath);
        },
        useYn: function (data) {
            if(data.useYn=="Y"){
                $(formName + " #useYnCheckBox").prop("checked", true);
            }else{
                $(formName + " #useYnCheckBox").prop("checked", false);
            }
            $("input[name='useYn']").val(data.useYn);
        },
        menuFlag: function (data) {
            $(formName + " select[name=menuFlag]").val(data.menuFlag);
        },
        sortOrder: function (data) {
            $(formName + " [name='sortOrder']").val(data.sortOrder);
        },
        insertUserId: function (data) {
            $(formName + " td[name='insertUserId']").text(data.insertUserId);
        },
        insertDatetime: function (data) {
            $(formName + " td[name='insertDatetime']").text(new Date(data.insertDatetime).format('yyyy-MM-dd HH:mm'));
        },
        updateUserId: function (data) {
            $(formName + " td[name='updateUserId']").text(data.updateUserId);
        },
        updateDatetime: function (data) {
            $(formName + " td[name='updateDatetime']").text(new Date(data.updateDatetime).format('yyyy-MM-dd HH:mm'));
        },
        _default: function () {
        }
    };

    /**
     * [Draw] 메뉴 상세 테이블 생성
     *
     * @param obj
     * @see dhj
     * @date 2014.05.20
     */
    MenuView.setDetail = function (obj) {

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
        MenuView.setSaveBefore();

        /* 숫자 입력만 허용 */
        $("input[name='sortOrder']").keypress(function() {
            return (/\d/.test(String.fromCharCode(event.which) ))
        });
    };

    /**
     * [Draw] 권한 테이블 생성
     *
     * @param obj
     * @see dhj
     * @date 2014.05.20
     */
    MenuView.setRoleList = function (obj) {

        $("table[name='roleListTable'] tbody").empty();
        Object.keys(obj).forEach(function (key) {
            var tr = document.createElement("tr");

            var checkBox_td = document.createElement("td");
            var checkBox_input = document.createElement("input");
            checkBox_input.setAttribute("type", "checkbox");
            checkBox_input.setAttribute("name", "checkbox01")

            /**
             * 사용 여부
             */
            if (this[ key ].useYn == 'Y') {
                checkBox_input.setAttribute("checked", "checked");
            }
            checkBox_td.appendChild(checkBox_input);

            var roleId_td = document.createElement("td");
            roleId_td.textContent = String(this[ key ].roleId);

            var roleName_td = document.createElement("td");
            roleName_td.textContent = String(this[ key ].roleName);

            tr.appendChild(checkBox_td);
            tr.appendChild(roleId_td);
            tr.appendChild(roleName_td);

            $("table[name='roleListTable'] tbody").append(tr);
        }, obj);

    };

    /**
     * [Draw] 좌측 트리 메뉴 그리기
     * @param obj
     */
    MenuView.setMenuTree = function (menuTreeModel) {

        var ctrlMenu = new MenuCtrl(MenuView._model);

        $(MenuView._model.getTreaArea()).dynatree({
            minExpandLevel: 2, debugLevel: 1, persist: true, onPostInit: function (isReloading, isError) {
                this.reactivate();
            },
            children: menuTreeModel, onActivate: ctrlMenu.selectMenuTree
        });
    };

    /**
     * [Draw] 상위 메뉴바 그리기
     * @param obj
     */
    MenuView.setTopMenuBar = function (menuBarModel, areaList) {
        if(menuBarModel==null){
            console.error("[MenuView.setTopMenuBar]load error - menu model is null");
            return false;
        }

        var mainMenuTag = $("<ul/>",{menu_main:''});
        var childMenuLiTag = $("<li/>").append(
            $("<button/>", {href:"#"})
        ).append(
            $("<ul/>")
        );

        for(var index in menuBarModel){
            var _menu = menuBarModel[index];
            if(_menu['menuDepth']==0){
                var _childMenuLiTag = childMenuLiTag.clone();
                _childMenuLiTag.attr("name",_menu['menuId']);
                _childMenuLiTag.find("button").text(_menu['menuName']);

                switch (_menu['menuId']){
                    case "000000" : // ADMINISRATION
                        break;
                    case "100000" : // DASHBOARD
                        _childMenuLiTag.find("button").attr("onclick", "javascript:moveDashboard();");
                        break;
                    case "200000" : // STATISTICS
                        break;
                }
                mainMenuTag.append(_childMenuLiTag);
            }else{
                if (_menu['menuFlag'] == 'M') {
                    var _childMenuLiTag = childMenuLiTag.clone();
                    _childMenuLiTag.attr("name", _menu['menuId']);
                    _childMenuLiTag.find("button").text(_menu['menuName']);

                    if(_menu['menuPath']!="/"){
                        _childMenuLiTag.find("button").attr("onclick", "javascript:location.href='" + MenuView._model.getRootUrl() + _menu['menuPath'] + "';");
                    }

                    if(mainMenuTag.find("li[name='"+_menu['parentMenuId']+"'] > ul > li").length==0 && _menu['menuPath']!="/"){
                        mainMenuTag.find("li[name='"+_menu['parentMenuId']+"'] > button").attr("onclick", "javascript:location.href='" + MenuView._model.getRootUrl() + _menu['menuPath'] + "';");
                    }
                    mainMenuTag.find("li[name='"+_menu['parentMenuId']+"'] > ul").append(_childMenuLiTag);
                }
            }
        }

        // ADMINISTRATOR 하위 메뉴 없을시 제거
        var adminTag = mainMenuTag.find("li[name='000000']");
        if(adminTag.length > 0 && adminTag.find("ul > li").length==0){
            adminTag.remove();
        }

        for(var index in areaList){
            var _area = areaList[index];
            if(_area['templateCode']!='TMP009'){
                var _childMenuLiTag = childMenuLiTag.clone();
                _childMenuLiTag.attr("name", _area['areaId']);
                _childMenuLiTag.find("button").text(_area['areaName']);
                if(_area['childAreaIds']!=null){
                    _childMenuLiTag.find("button").attr("onclick", "javascript:moveDashboard('"+_area['areaId']+"');");
                }else{
                    _childMenuLiTag.find("button").attr("onclick", "javascript:moveDashboard('','"+_area['areaId']+"');");
                }
                mainMenuTag.find("li[name='100000'] > ul").append(_childMenuLiTag);
            }
        }

        $("#topMenu").append(mainMenuTag);

        if(!setSelectedMenu(MenuView._model.getTargetMenuId())){
            setSelectedMenu(MenuView._model.getParentMenuId());
        }

        function setSelectedMenu(_targetMenuId){
            var targetTag = $("li[name='"+_targetMenuId+"']");
            if(targetTag.length > 0){
                targetTag.find("> button").addClass("on");
                setSelectedMenu(targetTag.parent().parent().attr("name"));
                return true;
            }
            return false;
        }
    };

    /**
     * 메뉴 등록 전 초기화 모드
     */
    MenuView.setAddBefore = function() {
        $("table tbody tr").eq(6).hide();
        $("table tbody tr").eq(7).hide();

        $("input[name='menuId']").val("");
        $("input[name='menuName']").val("");
        $("input[name='menuPath']").val("");
        $("input[name='sortOrder']").val(0);
        $("button[name='addBtn']").show();
        $("button[name='saveBtn']").hide();
        $("button[name='removeBtn']").hide();

        var formName = "#" + model.getFormName();
        $(formName + " select[id=selectParentMenuId]").val(MenuView._model.getMenuId()).attr("selected", true);

        $('input[type=checkbox]').each(function() {
            this.checked = false;
        });

        $("input[name='menuName']").focus();
    };

    /**
     * 메뉴 저장 전 초기화 모드
     */
    MenuView.setSaveBefore = function() {
        $("table tbody tr").eq(6).show();
        $("table tbody tr").eq(7).show();
        $("button[name='addBtn']").hide();
        $("button[name='saveBtn']").show();
        $("button[name='removeBtn']").show();
    };

    return MenuView;
};