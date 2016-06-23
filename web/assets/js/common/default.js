// Tab Style
$(function($){
	$("ul.panel li:not("+$("ul.tab li a.selected").attr("href")+")").hide();
	$("ul.tab li a").click(function(){
		$("ul.tab li a").removeClass("selected");
		$(this).addClass("selected");
		$("ul.panel li").hide();
		$($(this).attr("href")).show();
		return false;
	});
});

// Accordion Style
$(function(){
	$("dl.accor-con dd:not(:first)").css("display","none");
	$("dl.accor-con dt:first").addClass("selected");
	$("dl.accor-con dt").click(function(){
		if($("+dd",this).css("display")=="none"){
			$("dd").slideUp("slow");
			$("+dd",this).slideDown("slow");
			$("dt").removeClass("selected");
			$(this).addClass("selected");
		}
	}).mouseover(function(){
		$(this).addClass("over");
	}).mouseout(function(){
		$(this).removeClass("over");
	});
});

$(function(){
	// Tab navigation
	$('.gnb>ul>li>a')
		.mouseover(function(){
			$('.gnb>ul>li').removeClass('active');
			$(this).parent('li').addClass('active');
	})
		.focus(function(){
			$(this).mouseover();
	});
	// Select navigation
	$('.gnb>select').change(function(){
		window.location = $(this).find('option:selected').val(); // 가상선택자 처럼 옵션 셀렉티드를 찾아 옵션으로 선택된 값을 찾는다.find는 자식선택자를 찾아준다. 
	});
});


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