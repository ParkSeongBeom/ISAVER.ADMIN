/**
 * WebSocket Helper
 * - 웹소켓 제어
 *
 * @author psb
 * @type {Function}
 */
var StompHelper = (
    function(socketIp,socketUser,socketPw){
        let topicList = {};
        let ws = null;
        let SOCKET_IP = null;
        let CONNECT_STATUS = ["connect","disconnect"];
        let SEND_MESSAGE_RETRY = {
            'cnt' : 10
            , 'delay' : 1000
        };
        let RECONNECT_DELAY = 3000;
        let CONNECT_HEADERS;
        let SOKCET_CONNECTED = false;
        let STOMP_PORT = 15674;
        let _self = this;

        var setConnectStatus = function(_target, connFlag){
            topicList[_target]['conn'] = CONNECT_STATUS[(connFlag?0:1)];
            console.log("[StompHelper] " + (connFlag?'subscribe':'unsubscribe') + " target : "+_target);
        };

        /**
         * initialize
         * @author psb
         */
        var initialize = function(_socketIp,_socketUser,_socketPw){
            if(_socketIp==null || _socketUser==null || _socketPw==null){
                console.error("[StompHelper] initialize failure - Insufficient parameters (ip:"+_socketIp+", user:"+_socketUser+", passcode:"+_socketPw);
                return false;
            }
            SOCKET_IP = _socketIp;
            CONNECT_HEADERS = {
                login: _socketUser,
                passcode: _socketPw
            };
            ws = Stomp.client("ws://"+SOCKET_IP+":"+STOMP_PORT+"/ws");
            ws.reconnect_delay = RECONNECT_DELAY;
            ws.connect(CONNECT_HEADERS, function() {
                console.log('[StompHelper] Stomp WebSocket Connect');
                SOKCET_CONNECTED = true;
                for(var index in topicList){
                    _self.wsConnect(index);
                }
            }, function(e){
                try{
                    if(e.headers!=null && e.headers.subscription!=null){
                        for(var index in topicList){
                            if(e.headers.subscription==index){
                                setConnectStatus(index,false);
                                _self.wsConnect(index);
                            }
                        }
                    }
                }catch(e){
                    console.error(e);
                }
            }, function(e){
                console.log('[StompHelper] Stomp WebSocket DisConnect');
                SOKCET_CONNECTED = false;
                for(var index in topicList){
                    setConnectStatus(index,false);
                }
            });
        };

        /**
         * add WebSocket List
         * @author psb
         * @param _target
         * @param _messageEventHandler
         * @param _notConnectFlag
         */
        this.addWebSocketList = function(_target, _messageEventHandler, _notConnectFlag){
            if(_target==null){
                console.error("[StompHelper][addWebSocketList] target is null");
                return false;
            }

            if(topicList[_target]!=null){
                console.error("[StompHelper][addWebSocketList] exist target - " + _target);
                return false;
            }

            if(_messageEventHandler==null || typeof _messageEventHandler != "function"){
                console.error('[StompHelper][addWebSocketList] messageEventHandler is null or type error');
                return false;
            }

            topicList[_target] = {
                "messageEventHandler" : _messageEventHandler,
                "conn" : CONNECT_STATUS[1]
            };

            if(!_notConnectFlag){
                _self.wsConnect(_target);
            }
        };

        this.wsConnect = function(_target){
            if(_target==null || topicList[_target]==null){
                console.error("[StompHelper][subscribe] target is null or not in topicList");
                return false;
            }

            if(!_self.isConnect(_target)){
                try{
                    let result = ws.subscribe("/topic/"+_target, topicList[_target]['messageEventHandler'],{id:_target});
                    topicList[_target]['id'] = result['id'];
                    setConnectStatus(_target,true);
                }catch(e){
                    setConnectStatus(_target,false);
                }
            }
        };

        /**
         * ws DisConnect
         * @author psb
         * @param _target
         */
        this.wsDisConnect = function(_target){
            if(_target==null || topicList[_target]==null){
                console.error("[StompHelper][unsubscribe] target is null or not in topicList");
                return false;
            }
            ws.unsubscribe(topicList[_target]['id']);
            setConnectStatus(_target,false);
        };

        /**
         * send message
         * @author psb
         * @param _topic
         * @param _text
         */
        this.sendMessage = function(_topic, _text, _count){
            if(_topic==null){
                console.error("[StompHelper][sendMessage] topic is null");
                return false;
            }

            if(SOKCET_CONNECTED){
                if(typeof _text=="object"){
                    _text = JSON.stringify(_text);
                }
                ws.send("/topic/"+_topic,{},_text);
            }else{
                if(_count == null){
                    _count = SEND_MESSAGE_RETRY['cnt'];
                }
                console.warn('[StompHelper][sendMessage] websocket is disconnect - retry '+ (SEND_MESSAGE_RETRY['cnt']-_count));

                if(_count > 0){
                    setTimeout(function(){
                        _self.sendMessage(_topic, _text, _count - 1);
                    },SEND_MESSAGE_RETRY['delay']);
                }else{
                    console.error('[StompHelper][sendMessage] failure - retry count over',_topic, _text);
                }
            }
        };

        /**
         * connect confirm
         * @author psb
         * @param _target
         */
        this.isConnect = function(_target){
            if(_target==null || topicList[_target]==null){
                console.error("[StompHelper][isConnect] target is null or not in topicList");
                return false;
            }

            var resultFlag = false;
            switch (topicList[_target]['conn']) {
                case CONNECT_STATUS[0] :
                    resultFlag = true;
                    break;
                case CONNECT_STATUS[1] :
                    resultFlag = false;
                    break;
            }
            return resultFlag;
        };

        initialize(socketIp,socketUser,socketPw);
    }
);