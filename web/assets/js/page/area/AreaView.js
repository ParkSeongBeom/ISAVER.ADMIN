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
        orgId: function (data) {
            $(formName + " [name='orgId']").val(data.orgId);
        },
        upOrgId: function (data) {
            $(formName + " [id='selectUpOrgSeq']").val(data.upOrgId);

            $("select[id='selectUpOrgSeq'] option").removeAttr("disabled");
            $("select[id='selectUpOrgSeq'] option[value='"+ data.orgId + "']").attr('disabled','disabled');
//            $(sprintf(("%s [id='selectUpOrgSeq'] option[value='%s']", formName, data.orgSeq()))).hide().show();
//            var tagName = sprintf("%s select[id=selectUpOrgSeq]", formName);
//            $(tagName).val(data.upOrgSeq).attr("selected", true);

//            if (String(data.orgSeq) == String(AreaView._model.getRootOrgId())) {
//                $(tagName).attr("disabled", "disabled");
//                $("input:hidden[name='upOrgSeq']").val('');
//
//            } else {
//                $(tagName).removeAttr("disabled");
//                $("input:hidden[name='upOrgSeq']").val(data.upOrgSeq);
//            }

        },
        orgName: function (data) {
            $(formName + " [name='orgName']").val(data.orgName);
        },
        depth: function (data) {
            $(formName + " [name='depth']").val(data.depth);
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
     * [Draw] 조직도 상세 생성
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
     * [Draw] 좌측 조직도 트리 그리기
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
     * [Draw] 부서원 정렬 순서 동적으로 생성하기
     */
    AreaView.setOrgUserDetail = function(orgUserModel) {

        if (typeof orgUserModel == "object" && orgUserModel.length > 0) {

            var table = $("table[name='roleListTable'] tbody");

            $(table).empty();
            for(var i=0; i<orgUserModel.length; i++) {
                var tr = document.createElement("tr");
                var orgSeq_Hidden = document.createElement("input");
                var userSeq_Hidden = document.createElement("input");

                orgSeq_Hidden.setAttribute("type", "hidden");
                orgSeq_Hidden.setAttribute("name", "orgIdName");
                orgSeq_Hidden.setAttribute("value", orgUserModel[i]['orgid']);

                userSeq_Hidden.setAttribute("type", "hidden");
                userSeq_Hidden.setAttribute("name", "userIdName");
                userSeq_Hidden.setAttribute("value", orgUserModel[i]['userid']);

                var checkFlag_TD = document.createElement("td");
                var gwuserid_TD = document.createElement("td");
                var username_TD = document.createElement("td");

                var classification_TD = document.createElement("td");
                var classification_Input = document.createElement("input");
                classification_Input.setAttribute("name", "classification");
                classification_Input.setAttribute("value", orgUserModel[i]['classification']);

                var sortorder_TD = document.createElement("td");
                var sortorder_Input = document.createElement("input");

                sortorder_Input.setAttribute("type", "number");
                sortorder_Input.setAttribute("name", "orgSortName");

                gwuserid_TD.textContent = orgUserModel[i]['userid'] ;
                username_TD.textContent = orgUserModel[i]['username'];

                if (orgUserModel[i]['sortorder'] != undefined) {
                    sortorder_Input.setAttribute("value", orgUserModel[i]['sortorder']);
                }

                var checkFlag_Input = document.createElement("input");
                checkFlag_Input.setAttribute("type", "checkbox");
                checkFlag_Input.setAttribute("id", "checkFlag");

                checkFlag_TD.appendChild(checkFlag_Input);
                gwuserid_TD.appendChild(orgSeq_Hidden);
                gwuserid_TD.appendChild(userSeq_Hidden);

                if(orgUserModel[i]['orgid'] != this._model.getRootOrgId()){
                    classification_TD.appendChild(classification_Input);
                    sortorder_TD.appendChild(sortorder_Input);
                }

                tr.appendChild(checkFlag_TD);
                tr.appendChild(gwuserid_TD);
                tr.appendChild(username_TD);
                tr.appendChild(classification_TD);
                tr.appendChild(sortorder_TD);

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
     * 부서 상세 정보 호출 전 초기화 모드
     */
    AreaView.setFindDetailBefore = function (data) {

        var AreaView = new Object();
        AreaView._model = model;
        var formName = "#" + model.getFormName();

        $(formName + " [name='orgId']").val("");
        $(formName + " [id='selectUpOrgSeq']").val("");

        $(formName + " [name='orgName']").val("");
        $(formName + " [name='orgName']").removeAttr("readonly");
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


        if (AreaView._model.getOrgId() == AreaView._model.getRootOrgId()) {

            $("table tbody tr").eq(1).hide();
            $("table tbody tr").eq(2).hide();
            $("table tbody tr").eq(3).hide();
            $("table tbody tr").eq(4).hide();
            $("table tbody tr").eq(5).hide();

            $(formName + " [name='orgName']").attr("readonly", "readonly");
            $(formName + " [name='orgName']").val("HOME");
            $(formName + " [name='orgId']").val(AreaView._model.getOrgId());
            $(formName + " [name='upOrgId']").val("");

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
     * 조직도 등록 전 초기화 모드
     */
    AreaView.setAddBefore = function() {
        $("[name='showHideTag']").hide();

        $("tr[name='orgSortTr']").hide()
        $("tr[name='orgDateTr']").hide();

        $("input[name='orgId']").val("");
        $("input[name='orgName']").val("").removeAttr("readonly");
        $("button[name='addBtn']").show();
        $("button[name='saveBtn']").hide();
        $("button[name='removeBtn']").hide();
        $("button[name='orgUserAddBtn']").hide()
        $("button[name='orgUserRemoveBtn']").hide();

        $("select[id='selectUpOrgSeq'] option").removeAttr("disabled");

        $(formName + " select[id=selectUpOrgSeq]").val(AreaView._model.getOrgId()).attr("selected", true);
        $("input:hidden[name='upOrgId']").val(AreaView._model.getOrgId());

        $("input[name='orgName']").focus();

    };

    /**
     * 조직도 저장 전 초기화 모드
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
     * 부서원 등록 팝업 창 띄우기
     */
    AreaView.openPopupUserPage = function() {
        window.open(this._model.getRequestUrl('addOrgUser') + "?id=" + this._model.getOrgId(),'detailUserPopup','scrollbars=no,width=800,height=680,left=50,top=50');
    };

    /**
     * 부서 깊이 초기화
     */
    AreaView.resetOrgDepth = function() {
        $(formName + " [name='orgDepth']").val("0");
    };

    return AreaView;
};