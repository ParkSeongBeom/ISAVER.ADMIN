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
    <link href="${rootPath}/assets/test/css/base.css" rel="stylesheet" type="text/css" />
    <title>iSaver Simulator</title>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js?version=${version}"></script>
</head>
<body class="login_mode">
    <header></header>
    <article>
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
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
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
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
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
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
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
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
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
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
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
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
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
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
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
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
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
                        <select area eventType="guard">
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP005'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select device eventType="guard">
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="button_set">
                        <button class="level-start" onclick="javascript:addEventGuard('start')"></button>
                        <button class="reset" onclick="javascript:addEventGuard('stop')"></button>
                    </div>
                </div>
            </div>
        </section>
    </article>

    <aside id="logArea"></aside>

<script type="text/javascript">
    var urlConfig = {
        'eventUrl':'${rootPath}/test/event.json'
        ,'guardUrl':'${rootPath}/test/guard.json'
    };

    $(document).ready(function(){
        $("select[area]").on("change",function(){
            var deviceTag = $(this).next();
            $(deviceTag).val("");
            $(deviceTag).find("option").not("option[value='']").hide();

            switch($(this).attr("eventType")){
                case 'guard':
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV013']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV013']:eq(0)").prop("selected",true);
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
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV003']").show();
                    $(deviceTag).find("option[areaId='"+$(this).val()+"'][deviceCode='DEV003']:eq(0)").prop("selected",true);
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
        var valueTag = $("input[name='"+actionType+"Value']");
        if(areaTag.val()==""){
            alert("선택된 구역이 없습니다.");
            return false;
        }else if(deviceTag.val()==""){
            alert("선택된 장치가 없습니다.");
            return false;
        }else if(valueTag.val()==""){
            alert("수치값을 입력해 주세요.");
            return false;
        }

        var data = {
            'areaId' : areaTag.val()
            ,'areaName' : areaTag.text()
            ,'deviceId' : deviceTag.val()
            ,'deviceName' : deviceTag.text()
            ,'value' : valueTag.val()
        };

        switch(actionType){
            case 'co':
                data['eventId'] = "EVT302";
                data['eventName'] = "CO(일산화탄소)";
                break;
            case 'co2':
                data['eventId'] = "EVT303";
                data['eventName'] = "CO2(이산화탄소)";
                break;
            case 'gas':
                data['eventId'] = "EVT304";
                data['eventName'] = "가스";
                break;
            case 'smoke':
                data['eventId'] = "EVT305";
                data['eventName'] = "연기";
                break;
            case 'temp':
                data['eventId'] = "EVT306";
                data['eventName'] = "온도";
                break;
            case 'in' :
                data['eventId'] = "EVT300";
                data['eventName'] = "피플카운터 진입자 감지";
                data['inCount'] = valueTag.val();
                data['outCount'] = 0;
                data['value'] = 0;
                data['direction'] = "test";
                break;
            case 'out':
                data['eventId'] = "EVT301";
                data['eventName'] = "피플카운터 진출자 감지";
                data['inCount'] = 0;
                data['outCount'] = valueTag.val();
                data['value'] = 0;
                data['direction'] = "test";
                break;
            case 'worker':
                data['eventId'] = "EVT013";
                data['eventName'] = "위험지역.작업자감지";
                data['riskFlag'] = 0;
                data['targetCount'] = valueTag.val();
                break;
            default :
                alert("알수 없는 타입의 요청 입니다.");
                return false;
        }

        ajaxCall(actionType, data);
    }

    function ajaxCall(actionType,data){
        sendAjaxPostRequest(urlConfig['eventUrl'],data,successHandler,failureHandler,actionType);
    }

    function successHandler(data, dataType, actionType){
        var logTag = $("<div/>");

        switch(actionType){
            case 'startGuard':
                logTag.text("거수자감지 시작!");
                break;
            case 'stopGuard':
                logTag.text("거수자감지 종료!");
                break;
            default :
                logTag.append(
                    $("<div/>").text("전송 성공!")
                ).append(
                    $("<div/>").text("구역명 : "+data['paramBean']['areaName'])
                ).append(
                    $("<div/>").text("장치명 : "+data['paramBean']['deviceName'])
                ).append(
                    $("<div/>").text("이벤트명 : "+data['paramBean']['eventName'])
                ).append(
                    $("<div/>").text("임계치 수치 : "+data['paramBean']['value'])
                );
                break;
        }

        addLog(logTag);
    }

    function failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        var logTag = $("<div/>");
        switch(actionType){
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

        addLog(logTag);
        console.log(XMLHttpRequest, textStatus, errorThrown);
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

</script>
</body>
</html>