// URL Parameter 제거
history.replaceState({}, null, location.pathname);

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
 * input에 숫자 및 소숫점만 입력 하도록 기능제한</br>
 * - onkeypress event handler
 * - input style에 ime-mode:disabled; 같이 추가 필요.
 * @author kst
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

    if (event.keyCode == 13) {
        var _callNumberText = $(event.target).val();

        if(_callNumberText.length > 2) {
            callCommonCtrl.callDialPadFunc();
        }
    }
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