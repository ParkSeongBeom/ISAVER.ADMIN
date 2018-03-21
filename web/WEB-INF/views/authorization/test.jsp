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
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js?version=${version}"></script>
</head>
<body class="login_mode">
    <header></header>
    <article>
        <section class="Safe-Guard">
            <h2>Safe-Guard</h2>
            <div>
                <div class="set">
                    <div class="select_set">
                        <p>거수자감지</p>
                        <select area type="guard">
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP005'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select device type="guard">
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

        <section class="Detector">
            <h2>Detector</h2>
            <div>
                <div class="set">
                    <div class="select_set">
                        <p>일산화탄소(Co) 감지</p>
                        <select type="co" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select type="co" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="button_set">
                        <button class="level-danger" onclick="javascript:addEvent('co')"></button>
                    </div>
                </div>
                <div class="set">
                    <div class="select_set">
                        <p>연기 감지</p>
                        <select type="smoke" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select type="smoke" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="button_set">
                        <button class="level-danger" onclick="javascript:addEvent('smoke')"></button>
                    </div>
                </div>

                <div class="set">
                    <div class="select_set">
                        <p>가스(LPG/LNG) 감지</p>
                        <select type="gas" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select type="gas" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="button_set">
                        <button class="level-danger" onclick="javascript:addEvent('gas')"></button>
                    </div>
                </div>

                <div class="set">
                    <div class="select_set">
                        <p>이산화탄소</p>
                        <select type="co2" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select type="co2" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="button_set">
                        <button class="level-caution" onclick="javascript:addEvent('co2', 7)"></button>
                        <button class="level-warning" onclick="javascript:addEvent('co2', 53)"></button>
                        <button class="level-danger" onclick="javascript:addEvent('co2', 123)"></button>
                    </div>
                </div>

                <div class="set">
                    <div class="select_set">
                        <p>온/습도 감지</p>
                        <select type="temp" area>
                            <option value="">감시구역선택</option>
                            <c:forEach items="${areaList}" var="area">
                                <c:if test="${area.templateCode == 'TMP004'}">
                                    <option value="${area.areaId}">${area.areaName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <select type="temp" device>
                            <option value="">감시장치선택</option>
                            <c:forEach items="${deviceList}" var="device">
                                <option style="display:none;" areaId="${device.areaId}" deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceCodeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="button_set">
                        <button class="level-caution" onclick="javascript:addEvent('temp',28)"></button>
                        <button class="level-warning" onclick="javascript:addEvent('temp',33)"></button>
                        <button class="level-danger" onclick="javascript:addEvent('temp',38)"></button>
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

            switch($(this).attr("type")){
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
            }
        });

        $.each($("select[area]"),function(){
            $(this).find("option:eq(1)").prop("selected",true).trigger("change");
        });
    });

    function addEventGuard(command){
        sendAjaxPostRequest(urlConfig['guardUrl'], {type:command},successHandler,failureHandler,command+'Guard');
    }

    function addEvent(actionType, value){
        var areaTag = $("select[area][type='"+actionType+"'] option:selected");
        var deviceTag = $("select[device][type='"+actionType+"'] option:selected");
        if(areaTag.val()==""){
            alert("선택된 구역이 없습니다.");
            return false;
        }else if(deviceTag.val()==""){
            alert("선택된 장치가 없습니다.");
            return false;
        }

        var data = {
            'areaId' : areaTag.val()
            ,'areaName' : areaTag.text()
            ,'deviceId' : deviceTag.val()
            ,'deviceName' : deviceTag.text()
            ,'value' : value
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
        switch(actionType){
            case 'startGuard':
                alertMessage("거수자감지 시작!");
                break;
            case 'stopGuard':
                alertMessage("거수자감지 종료!");
                break;
            case 'co':
                alertMessage("CO(일산화탄소) 전송 성공!");
                break;
            case 'co2':
                alertMessage("CO2(이산화탄소) 전송 성공!");
                break;
            case 'gas':
                alertMessage("가스 전송 성공!");
                break;
            case 'smoke':
                alertMessage("연기 전송 성공!");
                break;
            case 'temp':
                alertMessage("온도 전송 성공!");
                break;
        }
    }

    function failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        switch(actionType){
            case 'guard':
                alertMessage("거수자감지 종료!");
                break;
            case 'co':
                alertMessage("CO(일산화탄소) 전송 실패!");
                break;
            case 'co2':
                alertMessage("CO2(이산화탄소) 전송 실패!");
                break;
            case 'gas':
                alertMessage("가스 전송 실패!");
                break;
            case 'smoke':
                alertMessage("연기 전송 실패!");
                break;
            case 'temp':
                alertMessage("온도 전송 실패!");
                break;
        }
        console.log(XMLHttpRequest, textStatus, errorThrown);
    }

    function alertMessage(message){
        $("#logArea").append(
            $("<div/>").text(message)
        )
    }

</script>
</body>
</html>