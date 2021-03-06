<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<!doctype html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content = "telephone=no">
    <meta name="autocomplete" content="off" />
    <meta http-equiv="imagetoolbar" content="no" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${rootPath}/assets/test/css/reset.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/test/css/gs.css?version=${version}" rel="stylesheet" type="text/css" />
    <title>iSaver Simulator</title>

    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js?version=${version}"></script>
</head>
<body class="login_mode">
    <header></header>
    <article>
        <section>
            <h2>DB Update</h2>
            <div>
                <div class="set">
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:dbMigration();"></button>
                    </div>
                </div>
            </div>
        </section>

        <section class="Safe-Eye">
            <h2>Safe-Eye</h2>
            <div>
                <div class="set">
                    <div class="select_set">
                        <p>위험지역.작업자감지</p>
                        <select area eventType="worker">
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP002'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select device eventType="worker">
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <input type="hidden" name="workerValue" value="1"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('worker')"></button>
                    </div>
                </div>
            </div>
        </section>

        <section class="Blinker">
            <h2>Blinker</h2>
            <div>
                <div class="set">
                    <div class="select_set">
                        <p>진입</p>
                        <select area eventType="in">
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP003'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select device eventType="in">
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <input type="text" name="inValue" placeholder="진입자 수 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('in')"></button>
                    </div>
                </div>
                <div class="set">
                    <div class="select_set">
                        <p>진출</p>
                        <select area eventType="out">
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP003'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select device eventType="out">
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <input type="text" name="outValue" placeholder="진출자 수 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('out')"></button>
                    </div>
                </div>
            </div>
        </section>

        <section class="Detector">
            <h2>Detector</h2>
            <div>
                <div class="set">
                    <div class="select_set">
                        <p>일산화탄소(Co) 감지</p>
                        <select eventType="co" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select eventType="co" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <input type="text" name="coValue" placeholder="임계치 수치 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('co')"></button>
                    </div>
                </div>
                <div class="set">
                    <div class="select_set">
                        <p>연기 감지</p>
                        <select eventType="smoke" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select eventType="smoke" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <input type="text" name="smokeValue" placeholder="임계치 수치 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('smoke')"></button>
                    </div>
                </div>

                <div class="set">
                    <div class="select_set">
                        <p>가스(LPG/LNG) 감지</p>
                        <select eventType="gas" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select eventType="gas" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <input type="text" name="gasValue" placeholder="임계치 수치 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('gas')"></button>
                    </div>
                </div>

                <div class="set">
                    <div class="select_set">
                        <p>이산화탄소</p>
                        <select eventType="co2" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select eventType="co2" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <input type="text" name="co2Value" placeholder="임계치 수치 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('co2')"></button>
                    </div>
                </div>

                <div class="set">
                    <div class="select_set">
                        <p>온/습도 감지</p>
                        <select eventType="temp" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select eventType="temp" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <input type="text" name="tempValue" placeholder="임계치 수치 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('temp')"></button>
                    </div>
                </div>
            </div>
        </section>

        <section class="Safe-Guard">
            <h2>Safe-Guard</h2>
            <div>
                <div class="set">
                    <div class="select_set">
                        <p>거수자감지</p>
                        <select area eventType="guardIn">
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP005' or area.templateCode == 'TMP012'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select device eventType="guardIn">
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <select fence eventType="guardIn">
                            <option value="">펜스 선택</option>
                            <c:forEach items="${fenceList}" var="fence">
                                <c:if test="${fence.fenceType!='ignore'}">
                                    <option style="display:none;" deviceId="${fence.deviceId}" value="${fence.fenceId}">${fence.fenceName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <input type="text" name="guardInValue" placeholder="ObjectID 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('guardIn')"></button>
                    </div>
                </div>
                <div class="set">
                    <div class="select_set">
                        <p>거수자감지 해제</p>
                        <select area eventType="guardOut">
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP005' or area.templateCode == 'TMP012'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select device eventType="guardOut">
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" deviceName="${device.deviceName}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <select fence eventType="guardOut">
                            <option value="">펜스 선택</option>
                            <c:forEach items="${fenceList}" var="fence">
                                <c:if test="${fence.fenceType!='ignore'}">
                                    <option style="display:none;" deviceId="${fence.deviceId}" value="${fence.fenceId}">${fence.fenceName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <input type="text" name="guardOutValue" placeholder="ObjectID 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEvent('guardOut')"></button>
                    </div>
                </div>
            </div>
        </section>

        <section>
            <h2>사용자정의</h2>
            <div>
                <div class="set">
                    <div class="select_set">
                        <p>Custom Event</p>
                        <select name="customDeviceId">
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                            </c:forEach>
                        </select>
                        <select name="customEventId">
                            <option value="">이벤트 선택</option>
                            <c:forEach items="${eventList}" var="event">
                                <option value="${event.eventId}">${event.eventName}</option>
                            </c:forEach>
                        </select>
                        <input type="text" name="customValue" placeholder="Value 입력" onkeypress="javascript:isNumberWithPoint();"/>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addCustomEvent();"></button>
                    </div>
                </div>
            </div>
        </section>
    </article>

    <aside>
        <div>
            <select id="intervalTime">
                <option value="1000">1초</option>
                <option value="3000">3초</option>
                <option value="5000">5초</option>
                <option value="10000">10초</option>
            </select>
            <button class="level-start" onclick="javascript:startInterval(this);"></button>
        </div>
        <div id="logArea"></div>
    </aside>

<script type="text/javascript">
    var urlConfig = {
        'eventUrl':'${rootPath}/test/event.json'
        ,'guardUrl':'${rootPath}/test/guard.json'
        ,'dbMigrationUrl':'${rootPath}/database/pgsqlMigration.json'
    };

    var _intervalInfo = {
        'interval' : null
        ,'param' : null
        ,'actionType' : null
    };

    $(document).ready(function(){
        $("select[area]").on("change",function(){
            var deviceTag = $(this).next();
            $(deviceTag).val("");
            $(deviceTag).find("option").not("option[value='']").hide();

//            $(deviceTag).find("option[areaId='"+$(this).val()+"']").show();
//            $(deviceTag).find("option[areaId='"+$(this).val()+"']:eq(0)").prop("selected",true);

            switch($(this).attr("eventType")){
                case 'guard':
                case 'guardIn':
                case 'guardOut':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"']").filter("[deviceCode='DEV013'],[deviceCode='DEV020']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"']").filter("[deviceCode='DEV013'],[deviceCode='DEV020']").filter(":eq(0)").prop("selected",true).trigger("change");
                    break;
                case 'co':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV905']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV905']:eq(0)").prop("selected",true);
                    break;
                case 'co2':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV902']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV902']:eq(0)").prop("selected",true);
                    break;
                case 'gas':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV903']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV903']:eq(0)").prop("selected",true);
                    break;
                case 'smoke':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV904']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV904']:eq(0)").prop("selected",true);
                    break;
                case 'temp':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV901']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV901']:eq(0)").prop("selected",true);
                    break;
                case 'in':
                case 'out':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV009']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV009']:eq(0)").prop("selected",true);
                    break;
                case 'worker':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV014']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV014']:eq(0)").prop("selected",true);
                    break;
            }
        });

        $("select[device]").on("change",function() {
            var fenceTag = $(this).next();
            $(fenceTag).val("");
            $(fenceTag).find("option").not("option[value='']").hide();

            switch($(this).attr("eventType")){
                case 'guardIn':
                case 'guardOut':
                    $(fenceTag).find("option[deviceId='"+$(this).val()+"']").show();
                    $(fenceTag).find("option[deviceId='"+$(this).val()+"']:eq(0)").prop("selected",true);
                    break;
            }
        });

        $.each($("select[area]"),function(){
            $(this).find("option:eq(1)").prop("selected",true).trigger("change");
        });
    });

    function addEventGuard(command){
        sendAjaxPostRequest(urlConfig['guardUrl'], {type:command},successHandler,failureHandler,command+'Guard');
    }

    function addEvent(actionType){
        var areaTag = $("select[area][eventType='"+actionType+"'] option:selected");
        var deviceTag = $("select[device][eventType='"+actionType+"'] option:selected");
        var fenceTag = $("select[fence][eventType='"+actionType+"'] option:selected");
        var valueTag = $("input[name='"+actionType+"Value']");

        var valueValidateFlag = false;
        var fenceValidateFlag = false;

        if(areaTag.val()==""){
            alert("선택된 구역이 없습니다.");
            return false;
        }else if(deviceTag.val()==""){
            alert("선택된 장치가 없습니다.");
            return false;
        }

        var data = {
            'deviceId' : deviceTag.val()
            ,'eventDatetime' : new Date().format("yyyy-MM-dd HH:mm:ss.000")
            ,'eventFlag' : 'D'
        };

        switch(actionType){
            case 'co':
                data['eventId'] = "EVT302";
                valueValidateFlag = true;
                break;
            case 'co2':
                data['eventId'] = "EVT303";
                valueValidateFlag = true;
                break;
            case 'gas':
                data['eventId'] = "EVT304";
                valueValidateFlag = true;
                break;
            case 'smoke':
                data['eventId'] = "EVT305";
                valueValidateFlag = true;
                break;
            case 'temp':
                data['eventId'] = "EVT306";
                valueValidateFlag = true;
                break;
            case 'in' :
                data['eventId'] = "EVT300";
                data['inCount'] = Number(valueTag.val());
                data['outCount'] = 0;
                data['direction'] = "test";
                valueValidateFlag = true;
                break;
            case 'out':
                data['eventId'] = "EVT301";
                data['inCount'] = 0;
                data['outCount'] = Number(valueTag.val());
                data['direction'] = "test";
                valueValidateFlag = true;
                break;
            case 'worker':
                data['eventId'] = "EVT013";
                data['riskFlag'] = 0;
                data['targetCount'] = valueTag.val();
                break;
            case 'guardIn':
                data['eventId'] = "EVT314";
                fenceValidateFlag = true;
                break;
            case 'guardOut':
                data['eventId'] = "EVT315";
                fenceValidateFlag = true;
                break;
            default :
                alert("알수 없는 타입의 요청 입니다.");
                return false;
        }

        if(valueValidateFlag){
            if(valueTag.val()==""){
                alert("수치값을 입력해 주세요.");
                return false;
            }
            data['value'] = Number(valueTag.val());
        }

        if(fenceValidateFlag){
            if(fenceTag.val()==""){
                alert("펜스를 선택해 주세요.");
                return false;
            }
            data['fenceId'] = fenceTag.val();
            data['objectId'] = valueTag.val();
        }
        ajaxCall(actionType, {eventData:JSON.stringify(data)});
    }

    function addCustomEvent(){
        var data = {
            'deviceId' : $("select[name='customDeviceId'] option:selected").val()
            ,'eventId' : $("select[name='customEventId'] option:selected").val()
            ,'eventDatetime' : new Date().format("yyyy-MM-dd HH:mm:ss.000")
            ,'eventFlag' : 'D'
            ,'value': $("input[name='customValue']").val()
        };
        ajaxCall('custom', {eventData:JSON.stringify(data)});
    }

    function dbMigration(){
        sendAjaxPostRequest(
            urlConfig['dbMigrationUrl']
            ,null
            ,function(data, dataType){
                var logTag = $("<div/>");
                let resultList = data['result'];
                for(var i in resultList){
                    let result = resultList[i];
                    logTag.append(
                        $("<div/>").text("=======================")
                    ).append(
                        $("<div/>").text(result['version']+" ["+result['code']+"]")
                    ).append(
                        $("<div/>").text(result['message'])
                    ).append(
                        $("<div/>").text("=======================")
                    )
                }
                addLog(logTag);
            },failureHandler
        );
    }

    function ajaxCall(actionType,data){
        sendAjaxPostRequest(urlConfig['eventUrl'],data,successHandler,failureHandler,actionType);
    }

    function successHandler(data, dataType, actionType){
        if(data['result']['code']!=200){
            failureLog(actionType,data['result']);
            return false;
        }
        data['paramBean'] = JSON.parse(data['paramBean']);

        var logTag = $("<div/>");

        switch(actionType){
            case 'startGuard':
                logTag.text("거수자감지 시작!");
                break;
            case 'stopGuard':
                logTag.text("거수자감지 종료!");
                break;
            case 'custom' :
                logTag.append(
                    $("<div/>").text("전송 성공!")
                ).append(
                    $("<div/>").text("장치구분 : "+$("select[name='customDeviceId'] option:selected").text())
                );

                if(data['paramBean']['value']!=null){
                    logTag.append(
                        $("<div/>").text("임계치 수치 : "+data['paramBean']['value'])
                    );
                }
                _intervalInfo['param'] = {eventData:JSON.stringify(data['paramBean'])};
                _intervalInfo['actionType'] = actionType;
                break;
            default :
                logTag.append(
                    $("<div/>").text("전송 성공!")
                ).append(
                    $("<div/>").text("구역명 : "+$("select[area][eventType='"+actionType+"'] option:selected").text())
                ).append(
                    $("<div/>").text("장치구분 : "+$("select[device][eventType='"+actionType+"'] option:selected").attr("deviceName"))
                );

                if(data['paramBean']['value']!=null){
                    logTag.append(
                        $("<div/>").text("임계치 수치 : "+data['paramBean']['value'])
                    );
                }
                if(data['paramBean']['fenceId']!=null){
                    logTag.append(
                        $("<div/>").text("펜스ID : "+data['paramBean']['fenceId'])
                    );
                }
                if(data['paramBean']['objectId']!=null){
                    logTag.append(
                        $("<div/>").text("ObjectId : "+data['paramBean']['objectId'])
                    );
                }
                _intervalInfo['param'] = {eventData:JSON.stringify(data['paramBean'])};
                _intervalInfo['actionType'] = actionType;
                break;
        }
        addLog(logTag);
    }

    function failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        failureLog(actionType);
        console.log(XMLHttpRequest, textStatus, errorThrown);
    }

    function failureLog(actionType, data){
        var logTag = $("<div/>");
        switch(actionType){
            case 'guardIn':
                logTag.text("거수자감지 전송 실패!");
                break;
            case 'guardOut':
                logTag.text("거수자감지 해제 전송 실패!");
                break;
            case 'startGuard':
                logTag.text("거수자감지 시작 실패!");
                break;
            case 'stopGuard':
                logTag.text("거수자감지 종료 실패!");
                break;
            case 'co':
                logTag.text("CO(일산화탄소) 전송 실패!");
                break;
            case 'co2':
                logTag.text("CO2(이산화탄소) 전송 실패!");
                break;
            case 'gas':
                logTag.text("가스 전송 실패!");
                break;
            case 'smoke':
                logTag.text("연기 전송 실패!");
                break;
            case 'temp':
                logTag.text("온도 전송 실패!");
                break;
            case 'in':
                logTag.text("진입 전송 실패!");
                break;
            case 'out':
                logTag.text("진출 전송 실패!");
                break;
        }
        if(data!=null && data['desc']!=null){
            logTag.append(
                $("<div/>").text("에러 상세 : "+data['desc'])
            );
        }
        addLog(logTag);
    }

    function addLog(addTag){
        $("#logArea").prepend(
            $("<br/>")
        ).prepend(
            $("<div/>").append(
                $("<div/>").text("["+new Date().format("yy.MM.dd HH:mm:ss")+"]")
            ).append(addTag)
        );
    }


    /**
     * interval start
     * @author psb
     */
    function startInterval(_this){
        if($(_this).hasClass("reset")){
            stopInterval();
            $(_this).removeClass("reset");
            $(_this).addClass("level-start");
        }else{
            if(_intervalInfo['actionType']==null || _intervalInfo['param']==null){
                alert("실행된 이력이 없습니다.");
                return false;
            }
            $(_this).removeClass("level-start");
            $(_this).addClass("reset");
            _intervalInfo['interval'] = setInterval(function() {
                ajaxCall(_intervalInfo['actionType'], _intervalInfo['param']);
            }, eval($("#intervalTime option:selected").val()));
        }
    }

    /**
     * interval stop
     * @author psb
     */
    function stopInterval(){
        if(_intervalInfo['interval']!=null){
            clearInterval(_intervalInfo['interval']);
        }
    }
</script>
</body>
</html>