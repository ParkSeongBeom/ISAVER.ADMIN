/**
 * School Mediator
 * - 스쿨존 관련 이벤트 및 데이터를 처리한다.
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var SchoolMediator = (
    function(rootPath){
        let _rootPath;
        let _areaId;
        let _speedMeter;
        let _urlConfig = {
            'fenceListUrl' : "/fence/list.json"
            ,'notificationListUrl' : "/notification/school.json"
        };
        let _now;
        let _options = {};
        let _schoolPopupHandler = null;
        let _info = {
            'crossing' : { // 횡단보도 보행자
                'element' : null
                ,'eventIds' : ['EVT314']
                ,'fenceList' : {}
                ,'data' : {
                    'preValue' : 0
                    ,'todayValue' : 0
                }
                ,'chartData' : {}
            }
            ,'vehicleTraffic' : { // 차량 통행량
                'element' : null
                ,'eventIds' : ['EVT320']
                ,'fenceList' : {}
                ,'data' : {
                    'preValue' : 0
                    ,'todayValue' : 0
                }
                ,'chartData' : {}
            }
            ,'vehicleSpeedAverage' : { // 차량 평균속도
                'element' : null
                ,'eventIds' : ['EVT320']
                ,'fenceList' : {}
                ,'data' : {
                    'preValue' : 0
                    ,'preSum' : 0
                    ,'preCount' : 0
                    ,'todayValue' : 0
                    ,'todaySum' : 0
                    ,'todayCount' : 0
                }
            }
            ,'trespassers' : { // 무단 횡단자
                'element' : null
                ,'eventIds' : ['EVT314']
                ,'fenceList' : {}
                ,'data' : {
                    'preValue' : 0
                    ,'todayValue' : 0
                }
                ,'chartData' : {}
            }
            ,'speedingVehicleTraffic' : { // 과속차량 통행량
                'element' : null
                ,'eventIds' : ['EVT320']
                ,'fenceList' : {}
                ,'data' : {
                    'preValue' : 0
                    ,'todayValue' : 0
                }
                ,'chartData' : {}
            }
            ,'vehicleSpeedMax' : { // 차량 최고속도
                'element' : null
                ,'eventIds' : ['EVT320']
                ,'fenceList' : {}
                ,'data' : {
                    'preValue' : 0
                    ,'todayValue' : 0
                }
            }
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
            _speedMeter = new SpeedMeter();
        };

        /**
         * set element
         * @author psb
         */
        this.setElement = function(element){
            if(element==null || element.length==0){
                console.error("[VideoMediator][setElement] _element is null or not found");
                return false;
            }
            _info['crossing']['element'] = element.find("section[name='crossing']"); // 횡단보도 보행자
            _info['vehicleTraffic']['element'] = element.find("section[name='vehicleTraffic']"); // 차량 통행량
            _info['vehicleSpeedAverage']['element'] = element.find("section[name='vehicleSpeedAverage']"); // 차량 평균속도
            _info['trespassers']['element'] = element.find("section[name='trespassers']"); // 무단 횡단자
            _info['speedingVehicleTraffic']['element'] = element.find("section[name='speedingVehicleTraffic']"); // 과속차량 통행량
            _info['vehicleSpeedMax']['element'] = element.find("section[name='vehicleSpeedMax']"); // 차량 최고속도
        };

        /**
         * fenceList init
         * @author psb
         */
        this.init = function(areaId,options){
            _areaId = areaId;
            for(var index in options){
                if(_options.hasOwnProperty(index)){
                    _options[index] = options[index];
                }
            }

            _info['vehicleSpeedAverage']['chartUuid'] = _speedMeter.setElement(_info['vehicleSpeedAverage']['element'].find("div[name='avg']"));
            _info['vehicleSpeedMax']['chartUuid'] = _speedMeter.setElement(_info['vehicleSpeedMax']['element'].find("div[name='max']"));
            _self.resetData();
            _ajaxCall('fenceList',{areaId:_areaId, fenceType:'normal'});
            _ajaxCall('notificationList',{areaId:_areaId});
        };

        /**
         * 데이터 초기화
         * @author psb
         * @param data
         */
        this.resetData = function(){
            for(var type in _info){
                for(var index in _info[type]['data']){
                    _info[type]['data'][index] = 0;
                }
                if(_info[type].hasOwnProperty('chartData')){
                    for(var i=0; i<=23; i++){
                        _info[type]['chartData'][i] = {
                            'pre' : {}
                            ,'today' : {}
                        };
                    }
                }
                _info[type]['element'].find("p[name='now']").text(0);
                _info[type]['element'].find("p[name='pre']").text(0);
            }

            _now = new Date();
            _now.setHours(0);
            _now.setMinutes(0);
            _now.setSeconds(0);
            _now.setMilliseconds(0);
            render();
        };

        var update = function(data, renderFlag){
            let eventDatetime = new Date(data['eventDatetime']);
            let eventHour = eventDatetime.format('HH');
            let isToday = eventDatetime>_now;
            for(var type in _info){
                if(_info[type]['eventIds'].indexOf(data['eventId'])>-1 && _info[type]['fenceList'][data['fenceId']]!=null){
                    let appendFlag = true;
                    switch (type){
                        case "crossing" : // 횡단보도
                        case "vehicleTraffic" : // 차량 통행량
                        case "trespassers" : // 무단 횡단자
                            isToday?_info[type]['data']['todayValue']++:_info[type]['data']['preValue']++;
                            break;
                        case "speedingVehicleTraffic" : // 과속차량 통행량
                            if(data['criticalLevel'] && data['criticalLevel']=='LEV003'){
                                isToday?_info[type]['data']['todayValue']++:_info[type]['data']['preValue']++;
                            }else{
                                appendFlag = false;
                            }
                            break;
                        case "vehicleSpeedAverage" : // 차량 평균속도
                            if(isToday){
                                _info[type]['data']['todaySum'] += Number(data['value']);
                                _info[type]['data']['todayCount']++;
                                _info[type]['data']['todayValue'] = toRound(_info[type]['data']['todaySum']/_info[type]['data']['todayCount'],1);
                            }else{
                                _info[type]['data']['preSum'] += Number(data['value']);
                                _info[type]['data']['preCount']++;
                                _info[type]['data']['preValue'] = toRound(_info[type]['data']['preSum']/_info[type]['data']['preCount'],1);
                            }
                            break;
                        case "vehicleSpeedMax" : // 차량 최고속도
                            if(isToday){
                                if(data['value'] && Number(data['value']) > _info[type]['data']['todayValue']){
                                    _info[type]['data']['todayValue'] = toRound(Number(data['value']),1);
                                }
                            }else{
                                if(data['value'] && Number(data['value']) > _info[type]['data']['preValue']){
                                    _info[type]['data']['preValue'] = toRound(Number(data['value']),1);
                                }
                            }
                            break;
                    }

                    if(appendFlag && _info[type].hasOwnProperty('chartData')){
                        var updateTarget = _info[type]['chartData'][Number(eventHour)][isToday?'today':'pre'];
                        if(!updateTarget.hasOwnProperty(data['fenceId'])){
                            updateTarget[data['fenceId']] = 1;
                        }else{
                            updateTarget[data['fenceId']]++;
                        }
                    }

                    if(renderFlag){
                        render(type);
                    }
                }
            }
        };

        var render = function(type){
            if(type!=null){
                switch (type){
                    case "crossing" : // 횡단보도
                    case "vehicleTraffic" : // 차량 통행량
                    case "trespassers" : // 무단 횡단자
                    case "speedingVehicleTraffic" : // 과속차량 통행량
                        _info[type]['element'].find("p[name='now']").text(_info[type]['data']['todayValue']);
                        _info[type]['element'].find("p[name='pre']").text(_info[type]['data']['preValue']);
                        break;
                    case "vehicleSpeedAverage" : // 차량 평균속도
                    case "vehicleSpeedMax" : // 차량 최고속도
                        _speedMeter.setValue(_info[type]['chartUuid'], _info[type]['data']['todayValue']);
                        break;
                }
                if(_schoolPopupHandler!=null){
                    _schoolPopupHandler(_areaId, type, _info[type]);
                }
            }else{
                for(var index in _info){
                    render(index);
                }
            }
        };

        /**
         * animation
         * @author psb
         */
        this.setAnimate = function(data){
            update(data,true);
        };

        this.bindSchoolPopupHandler = function(handler){
            _schoolPopupHandler = handler;
        };

        this.getPopupData = function(){
            render();
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
                case 'fenceList':
                    if(data['fenceList']!=null){
                        for(var index in data['fenceList']){
                            let fence = data['fenceList'][index];
                            if(fence['fenceSubType']!=null){
                                switch (fence['fenceSubType']){
                                    case "crosswalk" :
                                        _info['crossing']['fenceList'][fence['fenceId']]=fence['fenceName'];
                                        break;
                                    case "driveway" :
                                        _info['vehicleTraffic']['fenceList'][fence['fenceId']]=fence['fenceName'];
                                        _info['vehicleSpeedAverage']['fenceList'][fence['fenceId']]=fence['fenceName'];
                                        _info['trespassers']['fenceList'][fence['fenceId']]=fence['fenceName'];
                                        _info['speedingVehicleTraffic']['fenceList'][fence['fenceId']]=fence['fenceName'];
                                        _info['vehicleSpeedMax']['fenceList'][fence['fenceId']]=fence['fenceName'];
                                        break;
                                }
                            }
                        }
                    }
                    break;
                case 'notificationList':
                    let todayList = data['todayList'];
                    let preList = data['preList'];
                    for(var index in todayList){
                        update(todayList[index], false);
                    }
                    for(var index in preList){
                        update(preList[index], false);
                    }
                    render();
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