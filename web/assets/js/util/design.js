//$(function () {
//    //	making the input editable
//    $( "input.readon" ).on( 'click', function() {
//        $( this ).prop( 'readonly', '' );
//        $( this ).focus();
//    });
//
//    // making the input readonly
//    $( "input.readon" ).on( 'blur', function() {
//        $( this ).prop( 'readonly', 'readonly' );
//    });
//});


(function () {
    if (window.CssChange) return;

    var resizeClass = null;

    CssChange = {
        DetectResolution: function () {
            var $wrapper = $('body'); //CSS가 바뀔 최상위 Wrapper
            //var $content = $('.container'); // content area
            var className = 'adaptive';  // 대표 클래스명
            var contentAreaWidth = $(window).width();
            //alert(contentAreaWidth);

            if (resizeClass && resizeClass.start <= contentAreaWidth && resizeClass.end > contentAreaWidth) {
                $wrapper.removeClass().addClass(resizeClass.className);
                //$content.removeClass().addClass(resizeClass.className);


            } else {
                // 해상도별 클래스 셋팅 class='res1300'
                if (contentAreaWidth > 1250) {
                    $wrapper.removeClass().addClass(className + '_max');
                    $wrapper.removeClass().removeClass(className + '_min');
                }
                // 웹 최소 사이즈일때 class='res1025'
                else if (contentAreaWidth < 1249) {
                    $wrapper.removeClass().addClass(className + '_min');
                    $wrapper.removeClass().removeClass(className + '_max');
                }
                /*
                 else if (contentAreaWidth > 1024 && contentAreaWidth <= 1290) {
                 $wrapper.removeClass().addClass(className + '1025');

                 }
                 // 웹 중간 사이즈일때 class='res1000'
                 else if (contentAreaWidth >= 769 && contentAreaWidth <= 1024) {
                 $wrapper.removeClass().addClass(className + '1000');


                 }
                 // 웹 최소 사이즈일때 class='res720'
                 else if (contentAreaWidth > 480 && contentAreaWidth < 769) {
                 $wrapper.removeClass().addClass(className + '720');

                 }
                 else if (contentAreaWidth <= 480) {
                 $wrapper.removeClass().addClass(className + '720-mobile');

                 }

                 else {
                 $wrapper.removeClass();


                 }
                 */
            }
        },
        setWrapperClass: function (info) {
            resizeClass = info;
            CssChange.DetectResolution();
        },
        resetWrapperClass: function () {
            var $wrapper = $('body');
            //var $content = $('.container');
            resizeClass = null;
            CssChange.DetectResolution();
        }
    };
})(window);


$(function () {
    $(window).resize(function () {
        CssChange.DetectResolution();
    });
    CssChange.DetectResolution();
});

document.addEventListener("touchstart", function () { }, true);

//스크롤바 플러그인 호출
//$(function($){
//    $(window).load(function(){
//        $(".t_scroll").mCustomScrollbar({
//            axis:"y"
//        });
//    });
//});
//
//
////LNB 컨트롤
//// Click
//$(function () {
//    $(".nav_click").click(function () {
//        $(".lnb_ico").toggleClass("lnb_ico_on");
//        $("aside").toggleClass("aside_on");
//        $(".lnb01").toggleClass("lnb_on");
//        $(".container").toggleClass("container_on");
//    });
//    return false;
//});
//
//$(function () {
//
//    $(".btn_sitemap ").click(function () {
//        $(this).toggleClass("site_o");
//        $('.site_map').toggleClass("site_map_call");
//    });
//    return false;
//});
//
//
//$(function () {
//    $(document).click(function(){
//        if (!$(event.target).closest(".site_map, .btn_sitemap").length) {
//            if($(".btn_sitemap").hasClass("site_o")){
//                $(".btn_sitemap").toggleClass("site_o");
//                $('.site_map').toggleClass("site_map_call");
//            }
//        }
//    });
//});
//
//$(function () {
//    $('.gotop').hide();
//    //위로가기 버튼
//    $(window).scroll(function () {
//        if ($(this).scrollTop() > 100) {
//            $('.gotop').fadeIn();
//        } else {
//            $('.gotop').fadeOut();
//        }
//    });
//    //Click event to scroll to top
//    $('.gotop').click(function () {
//        $('html, body').animate({ scrollTop: 0 }, 200);
//        return false;
//    });
//});
//
//
//
//$(function () {
//    //팝업 테스트
////    $(".layer_popup").hide();
//    $(".ipop_type01").click(function () {
//        $('.layer_popup').addClass("ipop_type01");
//        $('.layer_wrap').addClass("i_type01");
//        $('.ipop_type01').fadeIn(200);
//        return false;
//    });
//
//    $(".ipop_type02").click(function () {
//        $('.layer_popup').addClass("ipop_type02");
//        $('.ipop_type02').fadeIn(200);
//        $('.layer_wrap').addClass("i_type02");
//        return false;
//    });
//
//    $(".ipop_type03").click(function () {
//        $('.layer_popup').addClass("ipop_type03");
//        $('.ipop_type03').fadeIn(200);
//        $('.layer_wrap').addClass("i_type03");
//        return false;
//    });
//
//    $(".ipop_close, .ipop_x").click(function () {
//        $('.layer_popup').fadeOut(200);
//        setTimeout(function () {
//            $('.layer_popup').removeClass("ipop_type01");
//            $('.layer_popup').removeClass("ipop_type02");
//            $('.layer_popup').removeClass("ipop_type03");
//            $('.layer_wrap').removeClass("i_type01");
//            $('.layer_wrap').removeClass("i_type02");
//            $('.layer_wrap').removeClass("i_type03");
//        }, 300);
//        return false;
//    });
//});
//
//$(function () {
//    if($(".infile_set").children("p").hasClass("before_file")) {
//        $(".infile_set").addClass("on");
//    }
//});
//
//function numberWithCommas(x) {
//    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
//}
//
//function numberWithoutCommas(x) {
//    return x.toString().replace(",", "");
//}