
// 사이즈별 클래스 부여
(function () {
    if (window.CssChange) return;
    var resizeClass = null;
    CssChange = {
        DetectResolution: function () {
            var $wrapper = $('html, body'); //CSS가 바뀔 최상위 Wrapper
            //var maxName = 'adaptive_max';  // 대표 클래스명
            //var minName = 'adaptive_min';
            var webclassName =    'adaptive_pc';
            var mobileclassName = 'adaptive_mobile';  // mobile 사이즈 일때 클래스 부여
            var tabletclassName = 'adaptive_tablet';  // tablet 사이즈 일때 클래스 부여
            var contentAreaWidth = $(window).width();

            if (resizeClass && resizeClass.start <= contentAreaWidth && resizeClass.end > contentAreaWidth  ) {
                $wrapper.removeClass().addClass(resizeClass.className);
            } else {
                if (contentAreaWidth < 719) {
                    $wrapper.removeClass(tabletclassName).removeClass(webclassName).addClass(mobileclassName);
                }
                else if (contentAreaWidth > 720 && contentAreaWidth < 1025 ) {
                    $wrapper.removeClass(mobileclassName).removeClass(webclassName).addClass(tabletclassName);
                }
                else if (contentAreaWidth > 1026 ) {
                    $wrapper.removeClass(mobileclassName).removeClass(tabletclassName).addClass(webclassName);
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

// 구역명 길때 마우스 hover 시 보여주기
$(function(){
    var areaTitleWidth = $(".watch_area header > h3");
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
            $(".wrap > header").addClass("up");
        }
        else {
            //Replace this with your function call for upward-scrolling
            $(".wrap > header").removeClass("up");
        }
        //Updates scroll position
        lastScroll = st;
    });
});

//th에 체크박스가 있는 경우
if($("th input").hasClass("checkbox")){$("th input").parent('th').addClass("notbefore");}