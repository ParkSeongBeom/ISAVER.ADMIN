/**
 * WebSocket Helper
 * - 웹소켓 제어
 *
 * @author psb
 * @type {Function}
 */
var WebSocketHelper = (
    function(webSocketIp){
        var webSocketList = {};
        let WEBSOCKET_IP = null;
        var CONNECT_STATUS = ["connect","disconnect"];
        var SEND_MESSAGE_RETRY = {
            'cnt' : 10
            , 'delay' : 1000
        };
        var _self = this;

        /**
         * initialize
         * @author psb
         */
        var initialize = function(_webSocketIp){
            WEBSOCKET_IP = _webSocketIp;
        };

        /**
         * add WebSocket List
         * @author psb
         * @param _target
         * @param _messageEventHandler
         * @param _conFlag
         */
        this.addWebSocketList = function(_target, _messageEventHandler, _notConnectFlag){
            if(_target==null){
                console.error("[WebSocketHelper][addWebSocketList] target is null");
                return false;
            }

            if(webSocketList[_target]!=null){
                console.error("[WebSocketHelper][addWebSocketList] exist target - " + _target);
                return false;
            }

            if(_messageEventHandler==null || typeof _messageEventHandler != "function"){
                console.error('[WebSocketHelper][addWebSocketList] messageEventHandler is null or type error');
                return false;
            }

            webSocketList[_target] = {
                "url" : "ws://"+WEBSOCKET_IP+":8820/ISAVER.SOCKET/"+_target,
                "options" : {
                    "reConnectFlag" : true
                    ,"reConnectDelay" : 5000
                },
                "messageEventHandler" : _messageEventHandler,
                "ws" : null
            };

            if(!_notConnectFlag){
                _self.wsConnect(_target);
            }
        };

        /**
         * ws Connect
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
         * ws DisConnect
         * @author psb
         * @param _target
         */
        this.wsDisConnect = function(_target){
            if(_target==null || webSocketList[_target]==null){
                console.error("[WebSocketHelper][wsDisConnect] target is null or not in webSocketList");
                return false;
            }

            webSocketList[_target]['ws'].onclose = null;
            webSocketList[_target]['ws'].close();
            webSocketList[_target]['ws'] = null;
            webSocketList[_target]['conn'] = CONNECT_STATUS[1];
            console.log(_target+' websocket closed');
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
                console.warn('[WebSocketHelper][sendMessage] websocket is disconnect - retry '+ (SEND_MESSAGE_RETRY['cnt']-_count));

                if(_count > 0){
                    setTimeout(function(){
                        _self.sendMessage(_target, _text, _count - 1);
                    },SEND_MESSAGE_RETRY['delay']);
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

        initialize(webSocketIp);
    }
);