/**
 * Code Helper
 *
 * @author psb
 * @type {Function}
 */
var CodeHelper = (
    function(rootPath){
        var _rootPath;
        var _urlConfig = {
            listUrl : "/code/list.json"
            ,addGroupCodeUrl : "/groupcode/add.json"
            ,saveGroupCodeUrl : "/groupcode/save.json"
            ,removeGroupCodeUrl : "/groupcode/remove.json"
            ,addCodeUrl : "/code/add.json"
            ,saveCodeUrl : "/code/save.json"
            ,removeCodeUrl : "/code/remove.json"
        };
        var _messageConfig;
        var _groupCodeList = {};
        var _codeList = {};
        var _selectedId = null;
        var _self = this;

        /**
         * initialize
         */
        var initialize = function(rootPath){
            _rootPath = rootPath;
            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
            console.log('[CodeHelper] initialize complete');
        };

        /**
         * set message config
         * @author psb
         */
        this.setMessageConfig = function(messageConfig){
            _messageConfig = messageConfig;
        };

        /**
         * refresh List Data
         */
        this.refreshList = function(){
            $("#codeList").empty();
            _groupCodeList = {};
            _codeList = {};
            _ajaxCall('list',{"mode":"search"});
        };

        /**
         * groupCode validate
         * actionType : add / save / remove
         */
        var groupCodeVaild = function(actionType){
            var form = $("#groupCodeForm");
            if(form.find('input[name=groupCodeId]').val().length == 0){
                _alertMessage('requireGroupCodeId');
                return false;
            }else if(form.find('input[name=groupCodeId]').val().length != 3){
                _alertMessage('lengthFailGroupCodeId');
                return false;
            }

            switch (actionType){
                case "add" :
                    if(form.find('input[name=groupName]').val().length == 0){
                        _alertMessage('requireGroupName');
                        return false;
                    }
                    break;
                case "save" :
                    break;
                case "remove" :
                    break;
            }
            return true;
        };

        /**
         * code validate
         * actionType : add / save / remove
         */
        var codeVaild = function(actionType){
            var form = $("#codeForm");
            if(form.find('input[name=codeId]').val().length == 0){
                _alertMessage('requireCodeId');
                return false;
            }else if(form.find('input[name=codeId]').val().length != 6){
                _alertMessage('lengthFailCodeId');
                return false;
            }else if(form.find('input[name=sortOrder]').val().length == 0){
                _alertMessage('requireSortOrder');
                return false;
            }

            switch (actionType){
                case "add" :
                    if(form.find('input[name=codeName]').val().length == 0){
                        _alertMessage('requireCodeName');
                        return false;
                    }
                    break;
                case "save" :
                    break;
                case "remove" :
                    break;
            }
            return true;
        };

        /**
         * submit (add,save,remove)
         */
        this.submit = function(mode, actionType){
            switch (mode){
                case "groupCode" :
                    if(groupCodeVaild(actionType)){
                        if(confirm(_messageConfig[actionType+'ConfirmMessage'])){
                            _ajaxCall(actionType+'GroupCode',$("#groupCodeForm").serialize());
                        }
                    }
                    break;
                case "code" :
                    if(codeVaild(actionType)){
                        if(confirm(_messageConfig[actionType+'ConfirmMessage'])){
                            _ajaxCall(actionType+'Code',$("#codeForm").serialize());
                        }
                    }
                    break;
            }
        };

        /**
         * GroupCode 상세
         * @author psb
         */
        this.getGroupCodeDetail = function(groupCodeId){
            var form = $("#groupCodeForm");
            // 구역 정보 초기화
            form[0].reset();
            form.find(".table_btn_set button").show();
            $("div[detail]").removeClass("on");
            $(".groupCode_table").addClass("on");

            if(groupCodeId!=null){ // 수정모드
                if(_groupCodeList[groupCodeId]==null){
                    _alertMessage("groupCodeDetailFailure");
                    return false;
                }
                var data = _groupCodeList[groupCodeId]['data'];
                form.find("input[name='groupCodeId']").val(groupCodeId).prop("readonly",true);
                form.find("input[name='groupName']").val(data['groupName']);
                form.find("td[name='insertUserName']").text(data['insertUserName']);
                form.find("td[name='insertDatetime']").text(new Date(data['insertDatetime']).format("yyyy-MM-dd HH:mm:ss"));
                form.find("td[name='updateUserName']").text(data['updateUserName']?data['updateUserName']:'');
                form.find("td[name='updateDatetime']").text(new Date(data['updateDatetime']).format("yyyy-MM-dd HH:mm:ss"));
                form.find("tr[modifyTag]").show();
                form.find("button[name='addBtn']").hide();
                _selectedId = groupCodeId;
            }else{ // 등록모드
                form.find("input[name='groupCodeId']").prop("readonly",false);
                form.find("tr[modifyTag]").hide();
                form.find("button[name='saveBtn']").hide();
                form.find("button[name='removeBtn']").hide();
            }
        };

        /**
         * Code 상세
         * @author psb
         */
        this.getCodeDetail = function(codeId){
            var form = $("#codeForm");
            // 구역 정보 초기화
            form[0].reset();
            form.find(".table_btn_set button").show();
            $("div[detail]").removeClass("on");
            $(".code_table").addClass("on");

            // 그룹코드 셀렉트박스 리로드
            form.find("select[name='groupCodeId']").empty();
            for(var index in _groupCodeList){
                form.find("select[name='groupCodeId']").append(
                    $("<option/>",{value:index}).text(_groupCodeList[index]['data']['groupName']+"("+_groupCodeList[index]['data']['groupCodeId']+")")
                );
            }

            if(codeId!=null){ // 수정모드
                if(_codeList[codeId]==null){
                    _alertMessage("codeDetailFailure");
                    return false;
                }
                var data = _codeList[codeId]['data'];
                form.find("select[name='groupCodeId']").val(data['groupCodeId']).prop("selected", true);
                form.find("input[name='codeName']").val(data['codeName']);
                form.find("input[name='codeId']").val(data['codeId']).prop("readonly",true);
                form.find("input[name='codeDesc']").val(data['codeDesc']!=null?data['codeDesc']:'');
                form.find("#useYnCB").prop("checked",data['useYn']=='Y').trigger("change");
                form.find("input[name='sortOrder']").val(data['sortOrder']!=null?data['sortOrder']:'');
                form.find("td[name='insertUserName']").text(data['insertUserName']);
                form.find("td[name='insertDatetime']").text(new Date(data['insertDatetime']).format("yyyy-MM-dd HH:mm:ss"));
                form.find("td[name='updateUserName']").text(data['updateUserName']?data['updateUserName']:'');
                form.find("td[name='updateDatetime']").text(new Date(data['updateDatetime']).format("yyyy-MM-dd HH:mm:ss"));
                form.find("tr[modifyTag]").show();
                form.find("button[name='addBtn']").hide();
                _selectedId = null;
            }else{ // 등록모드
                if(_selectedId!=null){
                    form.find("select[name='groupCodeId']").val(_selectedId).prop("selected", true);
                }
                form.find("input[name='codeId']").prop("readonly",false);
                form.find("#useYnCB").prop("checked",false).trigger("change");
                form.find("select[name='deviceCode']").trigger("change");
                form.find("tr[modifyTag]").hide();
                form.find("button[name='saveBtn']").hide();
                form.find("button[name='removeBtn']").hide();
            }
        };

        /**
         * Render
         * @author psb
         */
        var codeRender = function(groupCodeList, codeList){
            // 그룹코드 render
            for(var index in groupCodeList){
                var groupCode = groupCodeList[index];
                var _tag = $("<li/>").append(
                    $("<input/>",{type:'checkbox'})
                ).append(
                    $("<div/>").append(
                        $("<button/>").text(groupCode['groupName'] + " (" + groupCode['groupCodeId'] + ")").click({
                            groupCodeId: groupCode['groupCodeId']
                        },function(evt){
                            $("#codeList div").removeClass("on");
                            $("#codeList button").removeClass("on");
                            $(this).parent().addClass("on");
                            $(this).addClass("on");
                            _self.getGroupCodeDetail(evt.data.groupCodeId);
                        })
                    )
                );

                $("#codeList").append(_tag);

                _groupCodeList[groupCode['groupCodeId']] = {
                    element : _tag
                    ,data : groupCode
                };
            }

            // 코드 render
            for(var index in codeList){
                var code = codeList[index];
                var parentTag = _groupCodeList[code['groupCodeId']];

                if(parentTag!=null && parentTag['element']!=null){
                    if(parentTag['element'].find("> ul").length==0){
                        parentTag['element'].append($("<ul/>"));
                    }

                    var _tag = $("<li/>").append(
                        $("<input/>",{type:'checkbox'})
                    ).append(
                        $("<div/>").append(
                            $("<button/>", {codeId:code['codeId']}).text(code['codeName'] + " (" + code['codeId'] + ")").click({
                                codeId: code['codeId']
                            },function(evt){
                                $("#codeList div").removeClass("on");
                                $("#codeList button").removeClass("on");
                                $(this).parent().addClass("on");
                                $(this).addClass("on");
                                _self.getCodeDetail(evt.data.codeId);
                            })
                        )
                    );
                    parentTag['element'].find("> ul").append(_tag);

                    _codeList[code['codeId']] = {
                        element : _tag
                        ,data : code
                    };
                }else{
                    console.warn("[CodeHelper][codeRender] Parent Code is not found - groupCodeId : "+code['groupCodeId']+", codeID : "+code['codeId'])
                }
            }
        };

        /**
         * ajax call
         * @author psb
         */
        var _ajaxCall = function(actionType, data){
            sendAjaxPostRequest(_urlConfig[actionType+'Url'],data,_successHandler,_failureHandler,actionType);
        };

        /**
         * success handler
         * @author psb
         */
        var _successHandler = function(data, dataType, actionType){
            switch(actionType){
                case 'list':
                    codeRender(data['groupCodeList'],data['codeList']);
                    break;
                default :
                    _alertMessage(actionType + 'Complete');
                    $("div[detail]").removeClass("on");
                    $(".ment").addClass("on");
                    _self.refreshList();
            }
        };

        /**
         * failure handler
         * @author psb
         */
        var _failureHandler = function(XMLHttpRequest, textStatus, errorThrown, actionType){
            if(XMLHttpRequest['status']!="0"){
                _alertMessage(actionType + 'Failure');
            }
        };

        /**
         * alert message method
         * @author psb
         */
        var _alertMessage = function(type){
            alert(_messageConfig[type]);
        };

        initialize(rootPath);
    }
);