/**
 * WebSocket Helper
 * - 웹소켓 제어
 *
 * @author psb
 * @type {Function}
 */
var WebSocketHelper = (
    function(){
        var webSocketList = {};
        var CONNECT_STATUS = ["connect","disconnect"];
        var SEND_MESSAGE_RETRY = {
            'cnt' : 10
            , 'delay' : 1000
        };
        var messageEventHandler;

        var _self = this;

        /**
         * initialize
         * @author psb
         */
        this._initialize = function(){
        };

        /**
         * add WebSocket List
         * @author psb
         * @param _target
         * @param _webSocketUrl
         * @param _options
         * @param _messageEventHandler
         */
        this.addWebSocketList = function(_target, _webSocketUrl, _options, _messageEventHandler){
            if(_target==null){
                console.error("[WebSocketHelper][addWebSocketList] target is null");
                return false;
            }

            if(webSocketList[_target]!=null){
                console.error("[WebSocketHelper][addWebSocketList] exist target - " + _target);
                return false;
            }

            if(_webSocketUrl==null){
                console.error("[WebSocketHelper][addWebSocketList] webSocketUrl is null");
                return false;
            }

            if(_messageEventHandler==null || typeof _messageEventHandler != "function"){
                console.error('[WebSocketHelper][addWebSocketList] messageEventHandler is null or type error');
                return false;
            }

            webSocketList[_target] = {
                "url" : _webSocketUrl,
                "options" : {
                    "reConnectFlag" : true
                    ,"reConnectDelay" : 5000
                },
                "messageEventHandler" : _messageEventHandler,
                "ws" : null
            };

            if(_options !=null && typeof _options=="object"){
                for (var i in _options){
                    if(typeof webSocketList[_target][i]!="undefined"){
                        webSocketList[_target][i] = _options[i];
                    }
                }
            }
        };

        /**
         * wsConnect
         * @author psb
         * @param _target
         */
        this.wsConnect = function(_target){
            if(_target==null || webSocketList[_target]==null){
                console.error("[WebSocketHelper][wsConnect] target is null or not in webSocketList");
                return false;
            }

            setTimeout(function() {
                webSocketList[_target]['ws'] = new WebSocket(webSocketList[_target]['url']);
                webSocketList[_target]['ws'].onopen = function () {
                    webSocketList[_target]['conn'] = CONNECT_STATUS[0];
                    console.log(_target+' websocket opened');
                };

                webSocketList[_target]['ws'].onmessage = webSocketList[_target]['messageEventHandler'];
                webSocketList[_target]['ws'].onclose = function (event) {
                    webSocketList[_target]['conn'] = CONNECT_STATUS[1];

                    if (webSocketList[_target]['options']['reConnectFlag']) {
                        setTimeout(function() {
                            _self.wsConnect(_target);
                        }, webSocketList[_target]['options']['reConnectDelay']);
                    }
                };
            }, 250);
        };

        /**
         * send message
         * @author psb
         * @param _target
         * @param _text
         */
        this.sendMessage = function(_target, _text, _count){
            if(_target==null || webSocketList[_target]==null){
                console.error("[WebSocketHelper][sendMessage] target is null or not in webSocketList");
                return false;
            }

            if(_self.isConnect(_target)){
                if(typeof _text=="object"){
                    _text = JSON.stringify(_text);
                }
                webSocketList[_target]['ws'].send(_text);
            }else{
                if(_count == null){
                    _count = SEND_MESSAGE_RETRY['cnt'];
                }
                console.error('[WebSocketHelper][sendMessage] websocket is disconnect - retry '+ (SEND_MESSAGE_RETRY['cnt']-_count));

                if(_count > 0){
                    setTimeout(function(){
                        _self.sendMessage(_target, _text, _count - 1);
                    },SEND_MESSAGE_RETRY['deley']);
                }else{
                    console.error('[WebSocketHelper][sendMessage] failure - retry count over',_target, _text);
                }
            }
        };

        /**
         * get WebSocket List
         * @author psb
         * @param _target
         */
        this.getWebSocketList = function(_target){
            if(_target!=null && webSocketList[_target]!=null){
                return webSocketList[_target]
            }else{
                return webSocketList;
            }
        };

        /**
         * connect confirm
         * @author psb
         * @param _target
         */
        this.isConnect = function(_target){
            if(_target==null || webSocketList[_target]==null){
                console.error("[WebSocketHelper][isConnect] target is null or not in webSocketList");
                return false;
            }

            var resultFlag = false;
            switch (webSocketList[_target]['conn']) {
                case CONNECT_STATUS[0] :
                    resultFlag = true;
                    break;
                case CONNECT_STATUS[1] :
                    resultFlag = false;
                    break;
            }
            return resultFlag;
        };
    }
);