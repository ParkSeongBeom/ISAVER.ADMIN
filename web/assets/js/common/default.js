
// 사이즈별 클래스 부여
(function () {
    if (window.CssChange) return;
    var resizeClass = null;
    CssChange = {
        DetectResolution: function () {
            var $wrapper = $('html, body'); //CSS가 바뀔 최상위 Wrapper
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

$(function(){
    var areaTitleWidth = $(".watch_area  header > h3");
    areaTitleWidth.hover(function() {
        if($(this).width() >= ($(this).parent().width() - 80) ) {
            $(this).parent().addClass("wid");
        } else {
            $(this).parent().removeClass("wid");
        }
    });
});

// header 경계선 켜기 끄기
$(function(){
    //Keep track of last scroll
    var lastScroll = 0;
    $(window).scroll(function(){
        //Sets the current scroll position
        var st = $(this).scrollTop();
        //Determines up-or-down scrolling
        if (st > lastScroll){
            //Replace this with your function call for downward-scrolling
            $("header").addClass("up");
        }
        else {
            //Replace this with your function call for upward-scrolling
            $("header").removeClass("up");
        }
        //Updates scroll position
        lastScroll = st;
    });
    /*
     $(".contents-area ").bind('mousewheel DOMMouseScroll', function(e){
     if (e.originalEvent.wheelDelta / 120 > 0) {
     $(this).removeClass("up");
     }
     else {

     $(this).addClass("up");
     }
     });*/
});