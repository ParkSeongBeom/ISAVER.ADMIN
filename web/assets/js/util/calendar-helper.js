/**
 * Calendar Helper
 * - 달력 제어
 *
 * @author psb
 * @type {Function}
 */
var CalendarHelper = (
    function(_rootPath){
        $.datepicker.regional['ko'] = {
            prevText: '',
            nextText: '',
            monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            dayNames: ['일', '월', '화', '수', '목', '금', '토'],
            dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
            dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
            firstDay: 0,
            yearSuffix: '',
            showAnim: "slideDown"
        };

        // image config model
        var _imgUrlConfig = {
            'button':'/assets/images/ico/ico_date.png'
        };

        /**
         * CalendarHelper initialize
         *
         * @author psb
         * @param systemConfig
         * @param webDbModule
         * @returns
         */
        var _initialize = function(_rootPath){
            for(var key in _imgUrlConfig){
                _imgUrlConfig[key] = _rootPath + _imgUrlConfig[key];
            }

            $.datepicker.setDefaults($.datepicker.regional["ko"]);
        };

        /**
         * set use element
         *
         * @author psb
         * @param target
         * @param pageNavigatorDiv
         */
        CalendarHelper.prototype.load = function(target){
            if(target == null || typeof target != 'object'){
                console.error('[CalendarHelper] setElement failure - target is null or typeerror');
                return false;
            }else if(target.length == 0){
                console.error('[CalendarHelper] setElement failure - target is empty');
                return false;
            }

            $(target).datepicker({
                showOn: "button",
                //buttonImage: _imgUrlConfig['button'],
                //buttonImageOnly: true,
                changeMonth: true,
                changeYear: true,
                //showButtonPanel: false,
                dateFormat: 'yy-mm-dd'
            });
        };

        _initialize(_rootPath);
    }
);