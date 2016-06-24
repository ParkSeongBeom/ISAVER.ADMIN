
(function () {
    if (window.CssChange) return;
    var resizeClass = null;
    CssChange = {
        DetectResolution: function () {
            var $wrapper = $('body'); //CSS가 바뀔 최상위 Wrapper
            var maxName = 'adaptive_max';  // 대표 클래스명
            var minName = 'adaptive_min';
            var contentAreaWidth = $(window).width();
            if (resizeClass && resizeClass.start <= contentAreaWidth && resizeClass.end > contentAreaWidth) {
                $wrapper.removeClass().addClass(resizeClass.className);
            } else {
                // 해상도별 클래스 셋팅 class='res1300'
                if (contentAreaWidth > 1679) {
                    $wrapper.addClass(maxName).removeClass(minName);
                }
                // 웹 최소 사이즈일때 class='res1025'
                else if (contentAreaWidth < 1680) {
                    $wrapper.addClass(minName).removeClass(maxName);
                }
            }

        }
    };
})(window);
$(function () {
    $(window).resize(function () {
        CssChange.DetectResolution();
    });
    CssChange.DetectResolution();
});