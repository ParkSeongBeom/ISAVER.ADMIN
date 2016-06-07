/**
 * 브라우저 콘솔로드 제어
 * - 특정조건 하에 로그기능을 무력화 한다.
 * @author kst
 * @dependence jquery
 * @constructor
 */
window.console=(
    function(original){
        if(!window.console){
            console = {};
        }
        var flag=true;
        //var logArray = {
        //        logs: [],
        //        errors: [],
        //        warns: [],
        //        infos: []
        //};
        return {
            log: function(){
                //logArray.logs.push(arguments)
                flag && original.log && original.log.apply(original,arguments);
            }
            ,warn: function(){
                //logArray.warns.push(arguments)
                flag && original.warn && original.warn.apply(original,arguments);
            }
            ,error: function(){
                //logArray.errors.push(arguments)
                original.error && original.error.apply(original,arguments);
            }
            ,info: function(v){
                //logArray.infos.push(arguments)
                flag && original.info && original.info.apply(original,arguments);
            }
            ,debug: function(v){
                flag && original.info && original.debug.apply(original,arguments);
            }
            ,on: function(){
                flag = true;
            }
            ,off: function(){
                flag = false;
            }
            ,useable: function(){
                return flag;
            }
            //,logArray: function(){
            //    return logArray;
            //}
        };
    }(window.console)
);

// 허용 도메인
var hosts = ['127.0.0.1','localhost', '172.16.120.203', '172.16.120.160'];

// 허용하지않는 ie 버전
var notSupportVersion = ['9'];

var getInternetExplorerVersion = function() {
    var returnFlag = true; // Return value assumes failure.

    if (navigator.appName == 'Microsoft Internet Explorer') {
        var rv = -1; // Return value assumes failure.
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null) { rv = parseFloat(RegExp.$1); }

        try{
            if(notSupportVersion.indexOf(rv.toString()) > -1){
                returnFlag = false;
            }
        }catch(e){}
    }
    return returnFlag;
};

$(document).ready(function(){
    var flag = false;
    try{
        if(getInternetExplorerVersion()){
            flag = hosts.indexOf(document.location.host.split(':')[0]) > -1;
        }
    }catch(e){
        flag = false;
    }

    if(flag){
        console.on();
    }else{
        console.off();
    }
});