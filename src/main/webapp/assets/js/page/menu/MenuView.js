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

        for(var index in menuBarModel){
            var _menu = menuBarModel[index];
            if(_menu['menuDepth']==0){
                var menuBtnAppendTag = $("<button/>",{'name':_menu['menuId']});
                var menuNavAppendTag = $("<nav/>",{'name':_menu['menuId']}).append(
                    $("<h2/>").text(_menu['menuName'])
                ).append(
                    $("<button/>",{'class':'pin','data-title':'Fix navigation'}).click(function(){
                        $(this).toggleClass("on");
                        $(this).parent().toggleClass("pin");
                        if($(".pin").hasClass("on")){
                            $("menu").addClass("pin");
                        }else{
                            $("menu").removeClass("pin");
                        }
                    })
                ).append(
                    $("<ul/>")
                );

                switch (_menu['menuId']){
                    case "000000" : // ADMINISRATION
                        menuBtnAppendTag.attr({'rel':'nav-admi'}).addClass('menubtn-admi');
                        menuNavAppendTag.addClass('nav-admi');
                        menuNavAppendTag.find("ul").addClass("nav-base");
                        break;
                    case "100000" : // DASHBOARD
                        menuBtnAppendTag.attr({'rel':'nav-dash','onclick':'javascript:moveDashboard();'}).addClass('menubtn-dash');
                        menuNavAppendTag.addClass('nav-dash');
                        menuNavAppendTag.find("ul").addClass("tree-vertical-square tree_ac");
                        break;
                    case "200000" : // STATISTICS
                        menuBtnAppendTag.attr({'rel':'nav-stic'}).addClass('menubtn-stic');
                        menuNavAppendTag.addClass('nav-stic');
                        menuNavAppendTag.find("ul").addClass("nav-base");
                        break;
                }
                $("#menuBtnGroup").append(menuBtnAppendTag);
                $("#menuNav").append(menuNavAppendTag);
            }else{
                if (_menu['menuFlag'] == 'M') {
                    var _childMenuLiTag = $("<li/>",{'name':_menu['menuId'],'parentId':_menu['parentMenuId']});
                    switch (_menu['parentMenuId']){
                        case "000000" : // ADMINISRATION
                        case "200000" : // STATISTICS
                            _childMenuLiTag.append(
                                $("<h3/>", {href:"#"}).text(_menu['menuName'])
                            ).append(
                                $("<ul/>")
                            );
                            $("#menuNav").find("nav[name='"+_menu['parentMenuId']+"'] > ul").append(_childMenuLiTag);
                            break;
                        default :
                            _childMenuLiTag.append(
                                $("<button/>", {'href':"#"}).text(_menu['menuName'])
                            );
                            if(_menu['menuPath']!="/"){
                                _childMenuLiTag.find("button").attr("onclick", "javascript:location.href='" + MenuView._model.getRootUrl() + _menu['menuPath'] + "';");
                            }
                            $("#menuNav").find("li[name='"+_menu['parentMenuId']+"'] > ul").append(_childMenuLiTag);
                    }
                }
            }
        }

        // ADMINISTRATOR 하위 메뉴 없을시 제거
        var adminTag = $("ul[name='000000']");
        if(adminTag.length > 0 && adminTag.find("ul > li").length==0){
            adminTag.remove();
            $("button[name='000000']").remove();
        }

        for(var index in areaList){
            var _area = areaList[index];
            if(_area['templateCode']!='TMP009'){
                var parentAreaId = _area['parentAreaId']==null?'100000':_area['parentAreaId'];
                var _childMenuLiTag = $("<li/>",{'name':_area['areaId'],'parentId':parentAreaId}).append(
                    $("<input/>", {'type':"checkbox",'checked':true})
                ).append(
                    $("<button/>", {'href':"#"}).text(_area['areaName'])
                );

                if(_area['childAreaIds']!=null){
                    _childMenuLiTag.append($("<ul/>"));
                    _childMenuLiTag.find("button").attr("onclick", "javascript:moveDashboard('"+_area['areaId']+"');");
                }else{
                    _childMenuLiTag.find("button").attr("onclick", "javascript:moveDashboard('"+_area['parentAreaId']+"','"+_area['areaId']+"');");
                }

                if(parentAreaId=='100000'){
                    $("#menuNav").find("nav[name='"+parentAreaId+"'] > ul").append(_childMenuLiTag);
                }else{
                    $("#menuNav").find("li[name='"+parentAreaId+"'] > ul").append(_childMenuLiTag);
                }
            }
        }

        // 네비게이션 보기 제어
        var menuButton = $(".menu-btnset button:not(.group-functionbtn button)" );
        var menuNavset = $(".menu-navset > *" );
        menuButton.hover(function () {
            $(".menu-btnset button").removeClass("hover");
            menuNavset.removeClass("on");

            var activeMenu = $(this).attr("rel");
            $(this).addClass("hover");
            $('.' + activeMenu).addClass("on");

            var activeMenuOn = menuNavset.hasClass("on");
            if(activeMenuOn) {
                menuNavset.mouseleave(function(){
                    menuButton.removeClass("hover");
                    menuNavset.removeClass("on");
                });
            }

            var ignoreBtnArea = $(".ignore, .group-functionbtn");
            ignoreBtnArea.hover(function () {
                menuButton.removeClass("hover");
                menuNavset.removeClass("on");
            });
        });

        if(!setSelectedMenu(MenuView._model.getTargetMenuId(),true)){
            setSelectedMenu(MenuView._model.getParentMenuId(),true);
        }

        function setSelectedMenu(_targetMenuId,_flag){
            var navTarget = $("#menuBtnGroup").find("button[name='"+_targetMenuId+"']");
            if(navTarget.length > 0){
                navTarget.addClass("on");
            }

            var targetTag = $("#menuNav").find("li[name='"+_targetMenuId+"']");
            if(targetTag.length > 0){
                if(_flag){
                    targetTag.find("> button").addClass("on");
                }
                setSelectedMenu(targetTag.attr("parentId"),false);
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