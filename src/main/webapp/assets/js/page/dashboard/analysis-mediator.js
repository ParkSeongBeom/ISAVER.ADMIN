/**
 * Analysis Mediator
 * - 영상분석.
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var AnalysisMediator = (
    function(rootPath){
        var _areaId;
        var _element;
        var _rootPath;
        var _urlConfig = {
            'toiletRoomUrl' : "/eventLog/toiletRoom.json"
        };
        var _statusCss = {
            'empty' : 'ico-sprout' // 기본 (0)
            ,'straw' : 'ico-straw' // 딸기 (1)
            ,'strawDamage' : 'ico-straw-x' // 상한 딸기 (2)
            ,'grape' : 'ico-grape' // 포도 (3)
            ,'grapeDamage' : 'ico-grape-x' // 상한 포도 (4)
            ,'tomato' : 'ico-tomato' // 토마토 (5)
            ,'tomatoDamage' : 'ico-tomato-x' // 상한 토마토 (6)
            ,'tangerine' : 'ico-tanger' // 귤 (7)
            ,'tangerineDamage' : 'ico-tanger-x' // 상한 귤 (8)
            ,'ginseng' : 'ico-ginseng' // 인삼 (9)
            ,'ginsengDamage' : 'ico-ginseng-x' // 상한 인삼 (10)
        };
        var _self = this;

        /**
         * initialize
         * @author psb
         */
        var _initialize = function(rootPath){
            _rootPath = rootPath;
            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
        };

        /**
         * fenceList init
         * @author psb
         */
        this.init = function(areaId){
            _areaId = areaId;
            //_ajaxCall('toiletRoom',{areaId:_areaId});
        };

        /**
         * set element
         * @author psb
         */
        this.setElement = function(element){
            if(element==null || element.length==0){
                console.error("[AnalysisMediator][setElement] _element is null or not found");
                return false;
            }
            _element = element;
        };

        /**
         * animation
         * @author psb
         */
        this.setAnimate = function(data){
            let status = data['cropCondition'];

            if(status=='' || status==null){
                status = 'empty';
            }
            for(var key in _statusCss){
                _element.find("div[name='statusIco']").removeClass(_statusCss[key]);
            }
            if(status!=null){
                _element.find("div[name='statusIco']").addClass(_statusCss[status]);
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
                case 'toiletRoom':
                    _self.setAnimate(data);
                    break;
            }
        };

        /**
         * failure handler
         * @author psb
         */
        var _failureHandler = function(XMLHttpRequest, textStatus, errorThrown, actionType){
            if(XMLHttpRequest['status']!="0"){
                console.error(XMLHttpRequest, textStatus, errorThrown, actionType);
            }
        };
        _initialize(rootPath);
    }
);