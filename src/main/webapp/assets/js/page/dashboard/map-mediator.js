/**
 * Map Mediator
 * - 맵 관련 이벤트 및 데이터를 처리한다.
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var MapMediator = (
    function(_rootPath, _version){
        var rootPath;
        var version;
        var MARKER_TYPE = ['device', 'fence', 'object','camera'];

        // 코엑스 전시회
        //var defaultCenterLat = {lat: 37.51118474372142, lng: 127.05980761824708};
        // 사내
        var defaultCenterLat = {lat : 37.495450, lng : 127.031012};

        var canvas;
        var map;
        var marker = {
            'device' : {},
            'fence' : {},
            'object' : {},
            'camera' : {}
        };
        var options = {
            "device" : {
                'content' : "<div class='device'><div class='g-m8'></div><div class='g-camera'></div></div>"
                ,'content1' : "<div class='device'><div class='g-m8'></div></div>"
                ,"targetClass" : ".device"
            },
            "fence" : {
                "fillColor" : ["#f6b900", "#FF0000"]
                ,"strokeColor" : ["#f6b900", "#FF0000"]
            },
            "object" : {
                'content' : "<div class='g-tracking'></div>"
                ,"targetClass" : ".g-tracking"
                ,'animate' : {
                    easing: "swing"
                    ,'duration' : 200
                }
            },
            "camera" : {
                'useFlag' : false
                ,'lat' : 33.227130639998
                , 'lng' : 126.47661713772118
            },
            "image" : {
                'useFlag' : false
                ,'url' : "/assets/library/googlemap/images/mapex_n.svg"
                //,'lat' : {north: 37.51305614478644, east: 127.06221758679703, south: 37.50981366171428, west: 127.05675300502435} // 코엑스
                ,'lat' : {north: 37.49586539601683, east: 127.03165207272161, south: 37.49505460178254, west: 127.03028592727844} // 사내
                ,'content' : "<div class='mapimages'><div></div></div>"
            }
        };

        var _self = this;

        /**
         * initialize
         * @author psb
         * @param _canvas
         * @returns
         */
        var _initialize = function(_rootPath, _version){
            rootPath = _rootPath;
            version = _version;
            options['image']['url'] = rootPath + options['image']['url'] + "?version="+_version;
        };

        /**
         * set canvas
         * @author psb
         * @param _canvas
         * @returns
         */
        this.setMap = function(_canvas, _lat, _deviceList){
            if(_canvas==null){
                console.error("[MapMediator][_initialize] canvas is null");
                return false;
            }
            canvas = _canvas;

            if(_lat==null || _lat==""){
                _lat = defaultCenterLat;
            }else if(typeof _lat!="object"){
                _lat = eval("("+_lat+")");
            }

            map = new google.maps.Map(canvas.get(0), {
                center: new google.maps.LatLng(_lat['lat'], _lat['lng']),
                zoom: 22, // 지도 zoom단계
                /**
                 * roadmap : 기본 도로 지도 뷰를 표시합니다. 기본 지도 유형입니다.
                 * satellite : Google 어스 위성 이미지를 표시합니다.
                 * hybrid : 일반 뷰와 위성 뷰를 섞어서 표시합니다.
                 * terrain : 지형 정보를 기반으로 실제 지도를 표시합니다.
                 */
                mapTypeId: "roadmap",
                //draggable: false,
                //zoomControl: false,
                mapTypeControl : false,
                mapTypeControlOptions: {
                    position: google.maps.ControlPosition.LEFT_BOTTOM
                },
                streetViewControl : false,
                scaleControl : false,
                fullscreenControl : false
            });

            map.addListener('tilesloaded', function() {
                for(var index in _deviceList){
                    if(_deviceList[index]['deviceCode']=="DEV013"){
                        webSocketHelper.sendMessage("map",{"messageType":"getDevice","areaId":_deviceList[index]['areaId'],"deviceId":_deviceList[index]['deviceId'],"ipAddress":_deviceList[index]['ipAddress']});
                    }else if(_deviceList[index]['deviceCode']=='DEV002'){
                        _self.addCamera(_deviceList[index]['deviceId']);
                    }
                }
            });
        };

        this.getMap = function(){
            return map;
        };

        this.addCamera = function(_id){
            if(!options['camera']['useFlag']){
                return false;
            }
            if(_id==null){
                console.error("[MapMediator][addCamera] parameter not enough");
                return false;
            }
            if(marker['camera']!=null && marker['camera'][_id]!=null){
                console.warn("[MapMediator][addCamera] marker is exist - [camera][" + _id + "]");
                return false;
            }

            marker['camera'][_id] = new RichMarker({
                position: new google.maps.LatLng(options['camera']['lat'], options['camera']['lng']),
                title : _id,
                map: map,
                content : "<div class='device'><div class='icon-ptz'></div></div>",
                anchor: RichMarkerPosition.MIDDLE
            });
        };

        /**
         * add marker
         * @author psb
         */
        this.addMarker = function(messageType, data){
            if(data['id']==null || data['location']==null){
                console.error("[MapMediator][addMarker] parameter not enough");
                return false;
            }
            if(marker[messageType]!=null && marker[messageType][data['id']]!=null){
                console.warn("[MapMediator][addMarker] marker is exist - [" + messageType + "][" + data['id'] + "]");
                return false;
            }

            try{
                switch (messageType){
                    case MARKER_TYPE[0] : // Device
                        marker[messageType][data['id']] = new RichMarker({
                            position: new google.maps.LatLng(data['location'][0]['lat'], data['location'][0]['lng']),
                            title : data['id'],
                            map: map,
                            content : !options['camera']['useFlag']?options[messageType]["content"]:options[messageType]["content1"],
                            anchor: RichMarkerPosition.MIDDLE
                        });
                        marker[messageType][data['id']]['objects'] = [];
                        break;
                    case MARKER_TYPE[2] : // Object
                        marker[messageType][data['id']] = new RichMarker({
                            position: new google.maps.LatLng(data['location'][0]['lat'], data['location'][0]['lng']),
                            title : data['id'],
                            map: map,
                            content : options[messageType]["content"],
                            anchor: RichMarkerPosition.MIDDLE
                        });
                        break;
                    case MARKER_TYPE[1] : // Fence
                        data['location'] = validateLat(data['location']);
                        marker[messageType][data['id']] = new google.maps.Polygon({
                            paths: data['location'],
                            strokeColor: options["fence"]["strokeColor"][0],
                            strokeOpacity: 0.8,
                            strokeWeight: 2,
                            fillColor: options["fence"]["fillColor"][0],
                            fillOpacity: 0.35,
                            text:data['id']
                        });
                        marker[messageType][data['id']]['objects'] = [];
                        marker[messageType][data['id']].setMap(map);

                        var bounds = new google.maps.LatLngBounds();
                        for (var i=0; i< data['location'].length; i++) {
                            bounds.extend(data['location'][i]);
                        }
                        var myLatlng = bounds.getCenter();
                        var mapLabel = new MapLabel({
                            text: data['id'],
                            position: myLatlng,
                            map: map,
                            fontSize: 11
                        });
                        break;
                }
                console.debug("[MapMediator][addMarker] complete - [" + messageType + "][" + data['id'] + "]");
            }catch(e){
                console.error("[MapMediator][addMarker] error- [" + messageType + "][" + data['id'] + "] - " + e.message);
            }
        };

        /**
         * save marker
         * @author psb
         */
        this.saveMarker = function(messageType, data){
            if(messageType==null || data['id']==null || data['location']==null){
                console.error("[MapMediator][saveMarker] parameter not enough");
                return false;
            }

            var target = marker[messageType][data['id']];
            switch (messageType){
                case MARKER_TYPE[1] : // fence
                    if(target!=null){
                        _self.removeMarker(messageType, data);
                    }
                    _self.addMarker(messageType, data);
                    break;
                case MARKER_TYPE[2] : // Object
                    if(target!=null){
                        if(data['location'] instanceof Array){
                            data['location'] = data['location'][0];
                        }
                        if(!(data['location'] instanceof google.maps.LatLng)){
                            data['location'] = new google.maps.LatLng(data['location']['lat'], data['location']['lng']);
                        }
                        target.animateTo(data['location'], options[MARKER_TYPE[2]]['animate']);
                    }else{
                        _self.addMarker(messageType, data);
                    }
                    break;
            }
        };

        /**
         * remove marker
         * @author psb
         */
        this.removeMarker = function(messageType, data){
            if(messageType==null || data['id']==null){
                console.error("[MapMediator][removeMarker] parameter not enough");
                return false;
            }

            switch (messageType){
                case MARKER_TYPE[0] : // Device
                case MARKER_TYPE[1] : // Fence
                case MARKER_TYPE[2] : // Object
                    if(marker[messageType][data['id']]!=null){
                        marker[messageType][data['id']].setMap(null);
                        delete marker[messageType][data['id']];
                        console.debug("[MapMediator][removeMarker] complete - [" + messageType + "][" + data['id'] + "]");
                    }
                    break;
            }
        };

        /**
         * animation
         * @author psb
         */
        this.setAnimate = function(actionType, className, data){
            //var deviceMarker = _self.getMarker("device", data['deviceId']);
            //if(deviceMarker!=null && deviceMarker['objects'] instanceof Array){
            //    switch (actionType){
            //        case "add" :
            //            if(deviceMarker['objects'].length == 0 || deviceMarker['objects'].indexOf(data['objectId'])==-1){
            //                deviceMarker['objects'].push(data['objectId']);
            //            }
            //            $(deviceMarker.markerWrapper_).find(options["device"]["targetClass"]).addClass(className);
            //            break;
            //        case "remove" :
            //            if(deviceMarker['objects'].indexOf(data['objectId']) > -1){
            //                deviceMarker['objects'].splice(deviceMarker['objects'].indexOf(data['objectId']),1);
            //            }
            //            if(deviceMarker['objects'].length == 0) {
            //                $(deviceMarker.markerWrapper_).find(options["device"]["targetClass"]).removeClass(className);
            //            }
            //            break;
            //    }
            //}else{
            //    console.warn("[MapMediator][setAnimate] not found device marker or child object - deviceId : " + _deviceId + ", objectId : " + data['objectId']);
            //}

            var fenceMarker = _self.getMarker("fence", data['fenceId']);
            if(fenceMarker!=null && fenceMarker['objects'] instanceof Array){
                switch (actionType){
                    case "add" :
                        if(fenceMarker['objects'].length == 0 || fenceMarker['objects'].indexOf(data['objectId'])<0){
                            fenceMarker['objects'].push(data['objectId']);
                        }
                        break;
                    case "remove" :
                        if(fenceMarker['objects'].indexOf(data['objectId']) > -1){
                            fenceMarker['objects'].splice(fenceMarker['objects'].indexOf(data['objectId']),1);
                        }
                        break;
                }

                marker[MARKER_TYPE[1]][data['fenceId']].strokeColor = fenceMarker['objects'].length==0?options["fence"]["strokeColor"][0]:options["fence"]["strokeColor"][1];
                marker[MARKER_TYPE[1]][data['fenceId']].fillColor = fenceMarker['objects'].length==0?options["fence"]["fillColor"][0]:options["fence"]["fillColor"][1];
                marker[MARKER_TYPE[1]][data['fenceId']].setVisible(false);
                marker[MARKER_TYPE[1]][data['fenceId']].setVisible(true);
            }else{
                console.warn("[MapMediator][setAnimate] not found fence marker or child object - fenceId : " + data['fenceId'] + ", objectId : " + data['objectId']);
            }

            var objectMarker = _self.getMarker("object", data['objectId']);
            if(objectMarker!=null){
                switch (actionType){
                    case "add" :
                        $(objectMarker.markerWrapper_).find(options["object"]["targetClass"]).addClass(className);
                        break;
                    case "remove" :
                        $(objectMarker.markerWrapper_).find(options["object"]["targetClass"]).removeClass(className);
                        break;
                }
            }else{
                console.warn("[MapMediator][setAnimate] not found object marker - objectId : " + data['objectId']);
            }
        };

        /**
         * get marker
         * @author psb
         */
        this.getMarker = function(_type, _id){
            switch (_type){
                case MARKER_TYPE[0] : // Device
                case MARKER_TYPE[1] : // Fence
                case MARKER_TYPE[2] : // Object
                    if(marker[_type][_id]!=null){
                        return marker[_type][_id];
                    }
                    break;
                case "all" : // Object
                    return marker;
            }
            return null;
        };

        var validateLat = function( jsonData ) {
            if(jsonData instanceof Array){
                for(var key in jsonData) {
                    for(var i in jsonData[key]) {
                        if( typeof jsonData[key][i] === 'object' || typeof jsonData[key][i] === 'array' ) {
                            jsonData[key][i] = typeCheck( jsonData[key][i] );
                        } else {
                            if( /^(0|[1-9][0-9].*)$/.test( jsonData[key][i] ) ) {
                                jsonData[key][i] = Number( jsonData[key][i] );
                            }
                        }
                    }
                }
            }else{
                for(var key in jsonData) {
                    if( typeof jsonData[key] === 'object' || typeof jsonData[key] === 'array' ) {
                        jsonData[key] = typeCheck( jsonData[key] );
                    } else {
                        if( /^(0|[1-9][0-9].*)$/.test( jsonData[key] ) ) {
                            jsonData[key] = Number( jsonData[key] );
                        }
                    }
                }
            }
            return jsonData;
        };

        var historicalOverlay = null;
        this.addImage = function(){
            if(!options['image']['useFlag']){
                return false;
            }

            historicalOverlay = new google.maps.GroundOverlay(options['image']['url'],options['image']['lat']);
            historicalOverlay.setMap(map);
            canvas.addClass("map_images");
        };

        this.removeImage = function(){
            if(historicalOverlay!=null){
                historicalOverlay.setMap(null);
            }
            canvas.removeClass("map_images");
        };

        _initialize(_rootPath, _version);
    }
);