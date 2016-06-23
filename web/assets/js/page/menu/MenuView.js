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
            $("input:radio[name='useYn']").removeAttr("checked");
            $(formName + " input[name=useYn]").checked =false;
            $(formName + " input[name=useYn]:input[value='"+data.useYn+"']").prop("checked", true).button("refresh");
        },
        menuFlag: function (data) {
            $(formName + " input[name=menuFlag]").checked =false;
            $(formName + " input[name=menuFlag]:input[value='"+data.menuFlag+"']").prop("checked", true).button("refresh");
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
        var textSpaceSize = 9;
        function leadingSpaces(n, digits) {
            var space = '';
            n = n.toString();

            if (n.length < digits) {
                for (var i = 0; i < digits - n.length; i++)
                    space += "\u00A0";
            }
            return space;

        }

        function setSelectedMenu(_rootUlTag){
            var selGnb = MenuView._model.getTargetMenuId();
            var selDepth;
            var endFlag = true;

            while(endFlag){
                for(var i in menuBarModel){
                    var _item = menuBarModel[i];
                    if (_item.menuId == selGnb){
                        if(Number(_item.menuDepth)>1){
                            selDepth = _item.menuId;
                            selGnb = _item.parentMenuId;
                        }else{
                            endFlag = false;
                        }
                        break;
                    }
                }

                if(selDepth==null){
                    endFlag = false;
                }
            }

            if(selDepth==null){
                selDepth = 'H00000';
            }

            $(_rootUlTag).find("li[name='"+selDepth+"']").addClass('on');
            $(_rootUlTag).find("li[name='"+selGnb+"']").addClass('on');
        }

        function n(n){
            return n > 9 ? "" + n: "0" + n;
        }

        var _listLength = menuBarModel.length;
        var _loopLength = 0;
        var rootUlTag = $("<ul/>").addClass("lnb nano-content");

        var menuLiTag = $("<li/>").append(
            $("<button/>").attr("href","#")
        );

        while (_listLength != _loopLength) {
            function getDrawTagFunc(item, loopCount) {
                if (Number(item["menuDepth"]) == 1) {
                    var _menuLiTag = menuLiTag.clone();

                    switch (item.menuId){
                        case "H00000": // 대쉬보드
                            _menuLiTag.addClass("nl_dash");
                            break;
                        case "G00000": // 이력
                            _menuLiTag.addClass("nl_reco");
                            break;
                        case "J00000": // 통계
                            _menuLiTag.addClass("nl_stat");
                            break;
                        case "B00000": // 시스템관리
                            _menuLiTag.addClass("nl_syst");
                            break;
                        case "A00000": // 사용자관리
                            _menuLiTag.addClass("nl_user");
                            break;
                        case "F00000": // 조치관리
                            _menuLiTag.addClass("nl_even");
                            break;
                        case "C00000": // 구역관리
                            _menuLiTag.addClass("nl_watc");
                            break;
                        case "D00000": // 장치관리
                            _menuLiTag.addClass("nl_devi");
                            break;
                        case "E00000": // 라이센스관리
                            _menuLiTag.addClass("nl_lice");
                            break;
                    }

                    _menuLiTag.attr("name", item.menuId);
                    _menuLiTag.find("button").text(item['menuName']);
                    if(item.menuPath!="/"){
                        _menuLiTag.find("button").attr("onclick", "javascript:location.href = '" + MenuView._model.getRootUrl() + item.menuPath + "';");
                    }
                    rootUlTag.append(_menuLiTag);
                } else if (Number(item["menuDepth"]) > 1) {
                    var _menuLiTag = menuLiTag.clone();
                    _menuLiTag.attr("name", item.menuId);
                    _menuLiTag.find("button").attr("onclick", "javascript:location.href = '" + MenuView._model.getRootUrl() + item.menuPath + "';").text(item['menuName']);

                     /**
                     * 현병춘K 요청으로 대메뉴 클릭시 첫번째 하위메뉴의 화면 호출
                     */
                    if($(rootUlTag).find("li[name='"+item.parentMenuId+"'] .nano-content > li").length == 0){
                        $(rootUlTag).find("li[name='"+item.parentMenuId+"'] > button").attr("onclick", "javascript:location.href = '" + MenuView._model.getRootUrl() + item.menuPath + "';");
                    }

                    if($(rootUlTag).find("li[name='"+item.parentMenuId+"'] .nano-content").length>0){
                        $(rootUlTag).find("li[name='"+item.parentMenuId+"'] .nano-content").append(_menuLiTag);
                    }else{
                        $(rootUlTag).find("li[name='"+item.parentMenuId+"']").append(
                            $("<div/>").addClass('nano').append(
                                $("<ul/>").addClass('nano-content').append(_menuLiTag)
                            )
                        )
                    }
                }
            }

            var item = menuBarModel[_loopLength];
            try {
                if (item != undefined) {
                    if (item['menuFlag'] == 'M') {
                        getDrawTagFunc(item, _loopLength);
                    }
                }
            } catch (e) {
                console.error(e);
            }

            _loopLength++;
        }

        if (_listLength == _loopLength) {
            if(areaList!=null){
                if($(rootUlTag).find("li[name='H00000'] .nano-content").length==0){
                    $(rootUlTag).find("li[name='H00000']").append(
                        $("<div/>").addClass('nano').append(
                            $("<ul/>").addClass('nano-content')
                        )
                    );
                }

                for(var index in areaList){
                    var area = areaList[index];
                    var _menuLiTag = menuLiTag.clone();
                    _menuLiTag.attr("name", area['areaId']);
                    _menuLiTag.find("button").attr("onclick", "javascript:moveDashBoardDetail('"+area['areaId']+"','"+area['areaName']+"');").text(area['areaName']);
                    $(rootUlTag).find("li[name='H00000'] .nano-content").append(_menuLiTag);
                }
            }

            if(MenuView._model.getParentMenuId()!=""){
                setSelectedMenu(rootUlTag);
            }

            $(".nav_area").html(rootUlTag);

            //스크롤바 플러그인 호출
            $(".nano").nanoScroller();
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