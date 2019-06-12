// URL Parameter 제거
history.replaceState({}, null, location.pathname);

/*
 show hide Event Binding
 @author psb
 */
(function($) {
    $.each(['show', 'hide'], function(i, ev) {
        var el = $.fn[ev];
        $.fn[ev] = function () {
            var result = el.apply(this, arguments);
            result.promise().done(function () {
                this.trigger(ev, [result]);
            });
            return result;
        };
    });
})(jQuery);

/**
 * 일반적인 유틸 모음</br>
 * - 해당 function에 대한 기능 간략히 주척 필히.
 *
 * @author kst
 */

/*
 input에 숫자만 임력 하도록 기능제한</br>
 - onkeypress event handler
 - input style에 ime-mode:disabled; 같이 추가 필요.
 @author kst
 */
function isNumber(input){
    if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
        return true;
    }else{
        event.returnValue = false;
    }
}

/**
 * input에 숫자 및 하이픈 및 소숫점만 입력 하도록 기능제한</br>
 * - onkeypress event handler
 * - input style에 ime-mode:disabled; 같이 추가 필요.
 * @author psb
 */
function isNumberWithPointWithPhone(input){
    if ((event.keyCode >= 48 && event.keyCode <= 57) || event.keyCode == 45 || event.keyCode == 46) {
        return true;
    }else{
        event.returnValue = false;
    }
}

/**
 * input에 숫자 및 소숫점만 입력 하도록 기능제한</br>
 * - onkeypress event handler
 * - input style에 ime-mode:disabled; 같이 추가 필요.
 * @author psb
 */
function isNumberWithPoint(input){
    if ((event.keyCode >= 48 && event.keyCode <= 57) || event.keyCode == 46) { //숫자키 및 소수점만 입력
        return true;
    }else{
        event.returnValue = false;
    }
}

/**
 * input에 숫자 및 하이픈 입력 하도록 기능제한
 * - onkeypress event handler
 * @author psb
 */
function checkPhoneNumber(target){
    var flag = (event.keyCode >= 48 && event.keyCode <= 57) || event.keyCode == 45;
    if (flag) {
        return true;
    }else{
        event.returnValue = false;
    }
}

String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/gi, "");
};

// 숫자만 입력받기
function onlyNumberPress(event){
    if(event.keyCode<48 || event.keyCode>57){
        event.returnValue=false;
    }
}

// 숫자만 입력받기
function onlyCallNumberPress(event){
    if(event.keyCode > 47 && event.keyCode < 58 || event.keyCode == 35 || event.keyCode == 42){
        event.returnValue=true;
    }else{
        event.returnValue=false;
    }
}

// 한글입력방지
function onlyNumberDown(_this){
    if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46){
        return;
    }
    _this.value = _this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g,'');
}

// 클래스 추가/삭제
function modifyElementClass(_element, _className, _type){
    if(_className==null){
        return false;
    }

    switch (_type){
        case "add" :
            if(!_element.hasClass(_className)){
                _element.addClass(_className);
            }
            break;
        case "remove" :
            if(_element.hasClass(_className)){
                _element.removeClass(_className);
            }
            break;
    }
}

function inputNumberCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }

    if (object.value > object.max){
        object.value = object.value.slice(0, object.maxLength);
    }

    if (object.value == '-'){
        object.value = object.value.slice(0, object.maxLength);
    }
}

function isDuplicationArray(array){
    var duplicates = array.reduce(function(acc, el, i, arr) {
        if (arr.indexOf(el) !== i && acc.indexOf(el) < 0) acc.push(el); return acc;
    }, []);

    if(duplicates.length>0){
        return true;
    }else{
        return false;
    }
}

function uniqArrayList(array){
    return array.reduce(function(a,b){
        if (a.indexOf(b) < 0 ) a.push(b);
        return a;
    },[]);
}

function setCheckBoxYn(_this, targetElementId, reverse) {
    if($(_this).is(":checked")){
        $("input[name='"+targetElementId+"'").val(reverse==null?"Y":"N");
    }else{
        $("input[name='"+targetElementId+"'").val(reverse==null?"N":"Y");
    }
}

function minMaxFunc(value, min, max) {
    if(parseInt(value) < min || isNaN(value))
        return 0;
    else if(parseInt(value) > max)
        return max;
    else return value;
}

function addAsynchronousScript(_src){
    var script= document.createElement('script');
    try{
        script.type= 'text/javascript';
        script.src= _src;
        document.getElementsByTagName('head')[0].appendChild(script);
    }catch(e){
        console.error("[addAsynchronousScript]" + e);
    }
}

/**
 * 값의 소수점 자르기
 * value : 값, places : 소수점자리수
 * @author psb
 */
function toRound(value, places) {
    var multiplier = Math.pow(10, places);
    return (Math.round(value * multiplier) / multiplier);
}

function isPassive() {
    var supportsPassiveOption = false;
    try {
        addEventListener("test", null, Object.defineProperty({}, 'passive', {
            get: function () {
                supportsPassiveOption = true;
            }
        }));
    } catch(e) {}
    return supportsPassiveOption;
}

/**
 * uuid 만들기
 * @author psb
 */
function uuid38() {
    return '{' + s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4() + '}';
}

function uuid32() {
    return s4() + s4() + s4() + s4() + s4() + s4() + s4() + s4();
}

function s4() {
    return ((1 + Math.random()) * 0x10000 | 0).toString(16).substring(1);
}

$.fn.immediateText = function() {
    return this.contents().not(this.children()).text();
};

function ctPointLabels(options) {
    return function ctPointLabels(_chart) {
        var defaultOptions = {
            labelClass: 'ct-label01',
            labelOffset: {
                x: 0,
                y: -10
            },
            textAnchor: 'middle'
        };

        options = Chartist.extend({}, defaultOptions, options);

        if (_chart instanceof Chartist.Line) {
            _chart.on('draw', function (data) {
                if (data.type === 'point') {
                    data.group.elem('text', {
                        x: data.x + options.labelOffset.x,
                        y: data.y + options.labelOffset.y + 5,
                        style: 'text-anchor: ' + options.textAnchor
                    }, options.labelClass).text(data.value.y);
                }
            });
        }
    }
}