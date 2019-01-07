/**
 * Template Setting Popup
 * Dashboard 환경설정 팝업 제어
 *
 * @author psb
 * @type {Function}
 */
var TemplateSettingPopup = (
    function(rootPath){
        var _rootPath;
        var _urlConfig = {
            listUrl : "/templateSetting/list.json"
            ,saveUrl : "/templateSetting/save.json"
        };
        var _templateSetting = null;
        var _messageConfig;
        var _element;
        var _self = this;

        /**
         * initialize
         */
        var initialize = function(rootPath){
            _rootPath = rootPath;
            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
            console.log('[TemplateSettingPopup] initialize complete');
        };

        /**
         * set target
         * @author psb
         */
        this.setElement = function(element){
            _element = element;
        };

        /**
         * set message config
         * @author psb
         */
        this.setMessageConfig = function(messageConfig){
            _messageConfig = messageConfig;
        };

        /**
         * reset setting List
         * @author psb
         */
        this.reset = function(){
            _element.find("input").val('');
            _element.find("select").val('');
            _ajaxCall('list');
        };

        /**
         * get setting value
         * @author psb
         */
        this.getSettingValue = function(key){
            var returnValue = null;
            if(_templateSetting!=null){
                returnValue = _templateSetting[key];
            }
            return returnValue;
        };

        /**
         * save setting
         * @author psb
         */
        this.save = function(){
            if(confirm(_messageConfig['saveConfirmMessage'])){
                var paramData = [];
                $.each($(".option_pop").find("input[name], select[name]"), function(){
                    paramData.push(this.name+"|"+this.value);
                });
                _ajaxCall('save', {paramData:paramData.join(",")});
            }
        };

        /**
         * open popup
         * @author psb
         */
        this.openPopup = function(){
            _element.fadeIn();
        };

        /**
         * close popup
         * @author psb
         */
        this.closePopup = function(){
            _element.fadeOut();
        };

        var settingListRender = function(data){
            for(var index in data){
                _element.find("[name='"+index+"']").val(data[index]);
            }
            _templateSetting = data;
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
                case 'list':
                    settingListRender(data['templateSetting']);
                    break;
                case 'save':
                    _alertMessage(actionType + 'Complete');
                    _self.closePopup();
                    break;
                default :
            }
        };

        /**
         * failure handler
         * @author psb
         */
        var _failureHandler = function(XMLHttpRequest, textStatus, errorThrown, actionType){
            if(XMLHttpRequest['status']!="0"){
                _alertMessage(actionType + 'Failure');
            }
        };

        /**
         * alert message method
         * @author psb
         */
        var _alertMessage = function(type){
            alert(_messageConfig[type]);
        };

        initialize(rootPath);
    }
);