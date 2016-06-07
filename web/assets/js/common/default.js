	// Gnb Style	
$(function(){
	$(".container section:not("+$("#gnb ul li a.active").attr("href")+")").hide();
	$("#gnb ul li a").click(function(){
		$("#gnb ul li a").removeClass("active");
		$(this).addClass("active");
		$(".container section").hide();
		$($(this).attr("href")).show();
		return false;
	});
});

/*	// Snb Style
jQuery(function($){
	$(".container section:not("+$(".snb ul li a.selected").attr("href")+")").hide();
	$(".snb ul li a").click(function(){
		$(".snb ul li a").removeClass("selected");
		$(this).addClass("selected");
		$(".container section").hide();
		$($(this).attr("href")).show();
		return false;
	});
});*/

	
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