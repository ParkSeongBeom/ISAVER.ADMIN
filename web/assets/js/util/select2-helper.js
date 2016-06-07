/**
 * select2 helper
 * - selectbox 이벤트 및 데이터를 처리한다.
 *
 * @author psb
 * @type {Function}
 */
var Select2Helper = (
    function(userList){
        var _model = {
            'userList' : []
        };

        // page size
        var _pageSize = 10;

        // element info
        var _element;

        // option info
        var _options = {
            width: "100%" // 가로크기
            , placeholder: " " // 타이틀
            , closeOnSelect : true // 선택후 창닫기
            , dropdownCssClass : null // 드롭다운 class
            , minimumInputLength : 0 // 최소검색입력 수
            , showCloseBtn : false // 닫기(x) 버튼 활성화
            , resultAddClass : '' // 클래스 추가
        };

        /**
         * Select2Helper initialize
         *
         * @author psb
         * @param userList
         * @returns
         */
        var _initialize = function(userList){
            if(userList == null || typeof userList != 'object'){
                console.error('[Select2Helper] _initialize failure - userList is null || typeerrer');
                return false;
            }

            _model['userList'] = getSelect2DataList(userList);
            console.debug('[Select2Helper] _initialize complete');
        };

        /**
         * set use element
         *
         * @author psb
         * @param target
         */
        Select2Helper.prototype.setElement = function(target){
            if(target == null || typeof target != 'object'){
                console.error('[Select2Helper] setElement failure - target is null or typeerror');
                return false;
            }else if(target.length == 0){
                console.error('[Select2Helper] setElement failure - target is empty');
                return false;
            }

            _element = target;
        };

        /**
         * set use option
         *
         * @author psb
         * @param options
         */
        Select2Helper.prototype.setOption = function(options){
            if(options == null || typeof options != 'object'){
                console.error('[Select2Helper] setOption failure - target is null or typeerror');
                return false;
            }

            for(var index in options){
                _options[index] = options[index];
            }
        };

        /**
         * load previous Selectbox
         *
         * @author psb
         */
        Select2Helper.prototype.load = function(){
            $(_element).select2({
                minimumInputLength: _options['minimumInputLength'],
                placeholder: _options['placeholder'],
                width:_options['width'],
                multiple: true,
                closeOnSelect: _options['closeOnSelect'],
                dropdownAutoWidth:true,
                dropdownCssClass: _options['dropdownCssClass'],
                enable:false,
                formatResult: formatResult,
                formatSelection: formatSelection,
                formatNoMatches: function(term){
                    return "검색된 결과가 없습니다.";
                },
                formatSearching: "검색중..",
                formatLoadMore:"Loading more results…",
                formatResultCssClass:formatResultCssClass,
                formatInputTooShort: function () {
                    $("."+_options['dropdownCssClass']).hide();
                },
                query: function (query) {
                    var data = _model['userList'];
                    var results = data.filter(function(e) {
                        var values = "";
                        for (var i in e){ values += e[i] + " "; }

                        if(query.term == "" || values.toUpperCase().indexOf(query.term.toUpperCase()) >= 0){
                            return true;
                        }else{
                            return false;
                        }
                    });

                    query.callback({results:results.slice((query.page-1)*_pageSize, query.page*_pageSize),more:results.length >= query.page*_pageSize });
                }
            });

            select2Option();
        };

        var select2Option = function(){
            if(_options['showCloseBtn']){
                $('.search_close').click(function(event) {
                    $("#select2-drop-mask").click();
                });

                $(_element).on("select2-loaded", function(e) {
                    $(".search_close").show();
                }).on("select2-close", function(e){
                    $('.search_close').hide();
                })
            }

            if(_options['resultAddClass']!=''){
                $(".select2-drop > .select2-results").addClass(_options['resultAddClass']);
            }
        };


        /**
         * get Select2 dataList
         *
         * @author psb
         * @param orgList
         */
        var getSelect2DataList = function(_userList){
            var dataList = [];

            for (var i in _userList){
                var user = _userList[i];

                dataList.push({
                    id: user['userId']
                    ,name: user['userName']
                    ,classification: user['classification']
                    ,nickName: user['nickName']
                    ,extension: user['extension']
                    ,mobile: user['mobile']
                    ,phone: user['phone']
                    ,profile: user['profile']
                    ,special: user['special']
                    ,domain: user['domain']
                    ,email: user['email']
                    ,photoFilePath: user['photoFilePath']
                    ,disabled:false
                });
            }

            dataList.sort(function(a, b)
            {
                return a['name'].toUpperCase().localeCompare(b['name'].toUpperCase());
            });

            return dataList;
        };

        /**
         * result data format
         *
         * @author psb
         * @param repo
         */
        var formatResult = function(repo){
            var name = repo['name'];

            if(repo['classification']!=null){
                name += " " + repo['classification'];
            }

            var markup = '<li id="'+repo['userId']+'">' + name + '</li>';

            $("."+_options['dropdownCssClass']).show();

            return markup;
        };

        /**
         * result select data format
         *
         * @author psb
         * @param repo
         */
        var formatSelection = function(repo) {
            var name = repo['name'];

            if(repo['classification']!=null){
                name += " " + repo['classification'];
            }

            return name;
        };

        /**
         * result select data format
         *
         * @author psb
         * @param repo
         */
        var formatResultCssClass = function(repo){
            return "";
        };

        /**
         * reset data
         *
         * @author psb
         */
        Select2Helper.prototype.reset = function(){
            $(_element).select2("data", "");
        };

        /**
         * set selectedList
         *
         * @author psb
         */
        Select2Helper.prototype.setSelectedList = function(selList){
            var dataList = [];

            for (var k in selList){
                var sel = selList[k];

                for (var i in _model['userList']){
                    var user = _model['userList'][i];
                    var jid = user['id']+'@'+user['domain'];

                    if(sel['id'] == user['id'] || sel['id'] == jid || sel['id'] == user['email']){
                        dataList.push(user);
                    }
                }
            }

            $(_element).select2("data", dataList);
        };

        /**
         * get selectedList
         *
         * @author psb
         */
        Select2Helper.prototype.getSelectedList = function(){
            return $(_element).select2("data");
        };

        _initialize(userList);
    }
);