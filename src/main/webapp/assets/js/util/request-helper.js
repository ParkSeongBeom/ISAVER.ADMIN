/**
 * Request helper
 *
 * @author psb
 * @type {Function}
 */
var RequestHelper = (
    function(){
        var _intervalInfo = {
            'refreshTime' : 2000
            ,'interval' : null
        };

        var _requestData = {};
        var _self = this;

        /**
         * interval start
         * @author psb
         */
        this.startInterval = function(time){
            if(time == null || typeof time != 'number'){
                time = _intervalInfo['refreshTime'];
            }

            _self.stopInterval();
            _intervalInfo['interval'] = setInterval(function() {
                _self.getData();
            }, time);
        };

        /**
         * interval stop
         * @author psb
         */
        this.stopInterval = function(){
            if(_intervalInfo['interval']!=null){
                clearInterval(_intervalInfo['interval']);
            }
        };

        /**
         * request data add
         * @author psb
         */
        this.addRequestData = function(_actionType, _url, _data, _successHandler, _failureHandler){
            if(_actionType==null){
                console.error('[RequestHelper][addRequestData] _actionType is null');
                return false;
            }

            if(_url==null){
                console.error('[RequestHelper][addRequestData] _url is null');
                return false;
            }

            if(_successHandler==null || typeof _successHandler != "function"){
                console.error('[RequestHelper][addRequestData] _successHandler is null or type error');
                return false;
            }

            if(_failureHandler==null || typeof _failureHandler != "function"){
                console.error('[RequestHelper][addRequestData] _failureHandler is null or type error');
                return false;
            }

            if(_requestData[_actionType]!=null){
                console.error('[RequestHelper][addRequestData] _actionType is duplicate');
                return false;
            }

            _requestData[_actionType] = {
                'url' : _url
                ,'data' : _data
                ,'success' : _successHandler
                ,'failure' : _failureHandler
            };
        };

        /**
         * request data save
         * @author psb
         */
        this.saveRequestData = function(_actionType, _data){
            if(_requestData[_actionType]!=null){
                _requestData[_actionType]['data'] = _data;
            }
        };

        /**
         * request data remove
         * @author psb
         */
        this.removeRequestData = function(_actionType){
            if(_requestData[_actionType]!=null){
                delete _requestData[_actionType];
            }
        };

        /**
         * get data
         * @author psb
         */
        this.getData = function(_actionType){
            if(_actionType==null){
                for(var index in _requestData){
                    var _requestInfo = _requestData[index];
                    sendAjaxPostRequest(_requestInfo['url'],_requestInfo['data'],_requestInfo['success'],_requestInfo['failure'],index);
                }
            }else{
                if(_requestData[_actionType]!=null){
                    sendAjaxPostRequest(_requestData[_actionType]['url'],_requestData[_actionType]['data'],_requestData[_actionType]['success'],_requestData[_actionType]['failure'],_actionType);
                }
            }
        };
    }
);