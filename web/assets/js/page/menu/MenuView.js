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
        menuUrl: function (data) {
            $(formName + " [name='menuUrl']").val(data.menuUrl);
        },
        useFlag: function (data) {
            $("input:radio[name='useFlag']").removeAttr("checked");
            $(formName + " input[name=useFlag]").checked =false;
            $(formName + " input[name=useFlag]:input[value='"+data.useFlag+"']").prop("checked", true).button("refresh");
        },
        menuType: function (data) {
            $(formName + " input[name=menuType]").checked =false;
            $(formName + " input[name=menuType]:input[value='"+data.menuType+"']").prop("checked", true).button("refresh");
        },
        sortOrder: function (data) {
            $(formName + " [name='sortOrder']").val(data.sortOrder);
        },
        insertUserId: function (data) {
            $(formName + " td[name='insertUserId']").text(data.insertUserId);
        },
        insertDatetime: function (data) {
            $(formName + " td[name='insertDatetime']").text(data.insertDatetime);
        },
        updateUserId: function (data) {
            $(formName + " td[name='updateUserId']").text(data.updateUserId);
        },
        updateDatetime: function (data) {
            $(formName + " td[name='updateDatetime']").text(data.updateDatetime);
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
            if (this[ key ].useFlag == 'Y') {
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
    MenuView.setTopMenuBar = function (menuBarModel) {

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

        function n(n){
            return n > 9 ? "" + n: "0" + n;
        }

        var _listLength = menuBarModel.length;
        var _loopLength = 0;

        var sitemapUlTag = $("<ul/>").addClass("sitemap_area");
        var rootUlTag = $("<ul/>").addClass("gnb");

        var subDivTag = $("<div/>").addClass("nav_area");
        var parentLiTag = null;

        var subMenuCount = 0;

        var sitemapLiTag = $("<li/>").append(
            $("<p/>")
        );

        var menuLiTag = $("<li/>").append(
            $("<a/>").attr("href","#").append(
                $("<span/>")
            )
        );

        while (_listLength != _loopLength++) {

            function getDrawTagFunc(item, loopCount) {
                if (item["menuDepth"] == 1) {
                    var _sitemapLiTag = sitemapLiTag.clone();
                    _sitemapLiTag.attr("name", item.menuId);
                    _sitemapLiTag.find("p").text(item['menuName']);
                    _sitemapLiTag.append($("<ul/>"));
                    sitemapUlTag.append(_sitemapLiTag);

                    var _menuLiTag = menuLiTag.clone();
                    _menuLiTag.attr("name", item.menuId).addClass("depth01");
                    _menuLiTag.find("span").text(item['menuName']);
                    _menuLiTag.append($("<ul/>"));
                    rootUlTag.append(_menuLiTag);

                    subMenuCount++;
                } else if (item["menuDepth"] > 1) {
                    var _sitemapLiTag = menuLiTag.clone();
                    _sitemapLiTag.find("a").attr("href", MenuView._model.getRootUrl() + item.menuUrl);
                    _sitemapLiTag.find("span").text(item['menuName']);

                    var _menuLiTag = menuLiTag.clone();
                    _menuLiTag.attr("name", item.menuId)
                    _menuLiTag.find("a").attr("href", MenuView._model.getRootUrl() + item.menuUrl);
                    _menuLiTag.find("span").text(item['menuName']);

                    $(sitemapUlTag).find("li[name='"+item.parentMenuId+"'] ul").append(_sitemapLiTag);

                    /**
                     * 현병춘K 요청으로 대메뉴 클릭시 첫번째 하위메뉴의 화면 호출
                     */
                    if($(rootUlTag).find(".depth01[name='"+item.parentMenuId+"'] ul > li").length == 0){
                        $(rootUlTag).find(".depth01[name='"+item.parentMenuId+"'] > a").attr("href", MenuView._model.getRootUrl() + item.menuUrl);
                    }
                    $(rootUlTag).find("li[name='"+item.parentMenuId+"'] ul").append(_menuLiTag);
                }

            };

            function getSubDrawTagFunc(_parentMenuId){
                parentLiTag =  $(rootUlTag).find("li[name='"+_parentMenuId+"']");

                $(subDivTag).append(
                    $("<h2/>").addClass("1depth_title").text($(parentLiTag).find(">a").text())
                ).append(
                    $("<ul/>").addClass("lnb")
                );

                $.each($(parentLiTag).find(">ul>li"), function(e){
                    var _class = "";

                    if ($(this).hasClass("depth_on")) {
                        _class = 'lnb_on';
                    }

                    $(subDivTag).find(".lnb").append(
                        $("<li/>").addClass(_class).attr("name",$(this).attr("name")).append($(this).html())
                    );
                });
            }

            var item = menuBarModel[_loopLength];
            try {
                if (item != undefined) {
                    if (item['menuType'] == 'M') {
                        getDrawTagFunc(item, _loopLength);
                    }
                }
            } catch (e) {
                console.error(e);
            }

            function setSelectedMenu(_rootUlTag){
                var selGnb = MenuView._model.getTargetMenuId();
                var selDepth;
                var endFlag = true;

                while(endFlag){
                    for(var i in menuBarModel){
                        var _item = menuBarModel[i];
                        if (_item.menuId == selGnb){
                            if(_item.menuDepth>1){
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

                $(_rootUlTag).find("li[name='"+selDepth+"']").addClass('depth_on');
                $(_rootUlTag).find("li[name='"+selGnb+"']").addClass('gnb_on');
            }

            if (_listLength == _loopLength) {
                if(MenuView._model.getParentMenuId()!=""){
                    setSelectedMenu(rootUlTag);
                    getSubDrawTagFunc(MenuView._model.getParentMenuId());
                }

                $(".site_map_area").html(sitemapUlTag);
                $(".gnb_area").html(rootUlTag);
                $(".nav").html(subDivTag);

                if(subMenuCount>6){
                    $(".top_gnb_area").addClass("ga_btn_on");

                    $("#fx01").touchSlider({
                        // flexible : true,
                        roll : false,
                        view : 6,
                        btn_prev : $("#fx01").next().find(".prebt01"),
                        btn_next : $("#fx01").next().find(".nexbt01")
                    });
                }
//                $(".gnb").html(rootUlTag);
                break;
            }
        };

    };

    /**
     * 메뉴 등록 전 초기화 모드
     */
    MenuView.setAddBefore = function() {
        $("table tbody tr").eq(6).hide();
        $("table tbody tr").eq(7).hide();

        $("input[name='menuId']").val("");
        $("input[name='menuName']").val("");
        $("input[name='menuUrl']").val("");
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