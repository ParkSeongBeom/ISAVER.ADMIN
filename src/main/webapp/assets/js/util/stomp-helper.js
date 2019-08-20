/**
 * WebSocket Helper
 * - 웹소켓 제어
 *
 * @author psb
 * @type {Function}
 */
var StompHelper = (
    function(){
        let webSocketList = {};
        let CONNECT_STATUS = ["connect","disconnect"];
        let SEND_MESSAGE_RETRY = {
            'cnt' : 10
            , 'delay' : 1000
        };
        let RECONNECT_DELAY = 3000;
        let CONNECT_HEADERS = {
            login: 'icent',
            passcode: 'dkdltpsxm'
        };
        let STOMP_PORT = 15674;
        let _self = this;

        /**
         * initialize
         * @author psb
         */
        this._initialize = function(serverIp){
        };


        /**
         * initialize
         * @author psb
         */
        this._initialize = function(serverIp){
        };

        /**
         * add WebSocket List
         * @author psb
         * @param _target
         * @param _webSocketIp
         * @param _messageEventHandler
         */
        this.addWebSocketList = function(_target, _webSocketIp, _messageEventHandler){
            if(_target==null){
                console.error("[StompHelper][addWebSocketList] target is null");
                return false;
            }

            if(webSocketList[_target]!=null){
                console.error("[StompHelper][addWebSocketList] exist target - " + _target);
                return false;
            }

            if(_webSocketIp==null){
                console.error("[StompHelper][addWebSocketList] webSocketIp is null");
                return false;
            }

            if(_messageEventHandler==null || typeof _messageEventHandler != "function"){
                console.error('[StompHelper][addWebSocketList] messageEventHandler is null or type error');
                return false;
            }

            webSocketList[_target] = {
                "url" : "ws://"+_webSocketIp+":"+STOMP_PORT+"/ws",
                "header" : CONNECT_HEADERS,
                "messageEventHandler" : _messageEventHandler,
                "ws" : null
            };
        };

        this.wsConnect = function(_target){
            if(_target==null || webSocketList[_target]==null){
                console.error("[StompHelper][subscribe] target is null or not in webSocketList");
                return false;
            }

            webSocketList[_target]['ws'] = Stomp.client(webSocketList[_target]['url']);
            webSocketList[_target]['ws'].reconnect_delay = RECONNECT_DELAY;
            webSocketList[_target]['ws'].connect(webSocketList[_target]['header'], function() {
                webSocketList[_target]['conn'] = CONNECT_STATUS[0];
                webSocketList[_target]['ws'].subscribe("/topic/"+_target, webSocketList[_target]['messageEventHandler']);
                console.log(_target+' websocket opened');
            }, function(error) {
                webSocketList[_target]['conn'] = CONNECT_STATUS[1];
            });
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

            webSocketList[_target]['ws'].unsubscribe();
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
                webSocketList[_target]['ws'].send("/topic/"+_target,{},_text);
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