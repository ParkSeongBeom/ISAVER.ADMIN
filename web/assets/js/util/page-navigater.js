var PageNavigator = (
	/**
	 * <pre>PageNavigator 생성
	 * - pageSize (not null) : 현 페이지 노출 컨텐츠 갯수
	 * - currentPageNum (not null) : 현재 페이지 번호
	 * - totalCount (not null) : 컨텐츠 총 갯수
	 * - pageBarSize : 페이지 네비게이터 페이지번호 노출 갯수
	 * 참조) 페이지 이동 요청시 'goPage(num)' 호출
	 * </pre>
	 * @author kst
	 * @since 2013. 11. 14
	 */
	function(pageSize,currentPageNum,totalCount,pageBarSize){
		/**
		 * 한 화면 컨텐츠 노출 갯수
		 */
		var _pageSize;
		
		/**
		 * 현재 페이지 번호
		 */
		var _pageNum;
		
		/**
		 * 전체 컨텐츠 갯수
		 */
		var _totalCount;
		
		/**
		 * 페이지 네비게이터 버튼 갯수
		 */
		var _pageBarSize;
		
		/**
		 * 초기화 Flag
		 */
		var _initFlag;
		
		/**
		 * 페이지 부가정보 노출여부
		 */
		var _infoFlag = true;
		
		/**
		 * 스타일 정의
		 */
		var _classes = {
			"layout":null
            ,"fnGroup":null
			,"pnGroup":null
			,"num":null
			,"select":null
			,"info":null
		};
		
		/**
		 * 그룹버튼 태그정의
		 */
		var _groupTags = {
			"first":null
			,"pre":null
			,"next":null
			,"end":null
		};
		
		/**
		 * 초기화
		 */
		var initialize = function(pageSize, currentPageNum, totalCount, pageBarSize){
			var initFlag = true;
			
			if(isNaN(pageSize)){
				initFlag = false;
			}else{
				_pageSize = typeof pageSize == "string" ? Number(pageSize) : pageSize;
			}
			if(isNaN(currentPageNum)){
				initFlag = false;
			}else{
				_pageNum = typeof currentPageNum == "string" ? Number(currentPageNum) : currentPageNum;
			}
			if(isNaN(totalCount)){
				initFlag = false;
			}else{
				_totalCount = typeof totalCount == "string" ? Number(totalCount) : totalCount;
			}
			if(pageBarSize == null){
				_pageBarSize = 10;
			}else if(isNaN(pageBarSize)){
				initFlag = false;
			}else{
				_pageBarSize = typeof pageBarSize == "string" ? Number(pageBarSize) : pageBarSize;
			}
			
			return initFlag;
		};
		
		/**
		 * make HTML Tag
		 */
		var makePageNavigatorHtmlTag = function(){
			var resultHtml = new Array();
			var lineCount = 0;
			
			if(!_initFlag){
				resultHtml[lineCount++] = "[PageNavigator] ERROR : Require confirmation by of you arguments</br>";
			}else{
				// 전체 페이지 수
				var pageCount = parseInt(_totalCount / _pageSize);
				if(_totalCount % _pageSize > 0){
					pageCount++;
				}
				//Math.round(_totalCount / _pageSize);
				
				// 전체 페이지버튼 그룹 갯수
				var pageGroupCount = pageCount / _pageBarSize;
				
				// 현재 페이지버튼 그룹
				var currentPageGroup = parseInt((_pageNum - 1) / _pageBarSize);
				resultHtml[lineCount++] = "<p";
				
				// 스타일 지정
				resultHtml[lineCount++] = getClassTag("layout");
				resultHtml[lineCount++] = ">";
				
				// 이전 페이지버튼 그룹
				var prePageGroup = currentPageGroup - 1;
				
				// 맨 앞으로
                resultHtml[lineCount++] = "<button"
                resultHtml[lineCount++] = getClassTag("fnGroup");

				if(_pageNum == 1){
					resultHtml[lineCount++] = " onclick='alert(\"현재 첫번째 페이지 입니다.\"); return false;'";
				}else{
					resultHtml[lineCount++] = " onclick='goPage(1); return false;'";
				}
				resultHtml[lineCount++] = ">";
				if(_groupTags["first"] != null){
					resultHtml[lineCount++] = _groupTags["first"];
				}else{
					resultHtml[lineCount++] = "&laquo;";
				}
                resultHtml[lineCount++] = "</button>";

				// 이전 그룹으로
                resultHtml[lineCount++] = "<button"
                resultHtml[lineCount++] = getClassTag("pnGroup");
				if(currentPageGroup <= 0 && _pageNum == 1){
					resultHtml[lineCount++] = " onclick='javascript:alert(\"현재 첫번째 페이지 입니다.\"); return false;'";
				}else if(currentPageGroup <= 0 && _pageNum != 1){
					resultHtml[lineCount++] = " onclick='javascript:goPage(1); return false;'";
				}else{
					// 해당 그룹의 첫번째 페이지 번호
					var preGroupPageNum = (prePageGroup * _pageBarSize) + _pageBarSize;
					resultHtml[lineCount++] = " onclick='javascript:goPage(" +preGroupPageNum+ "); return false;'";
				}
				resultHtml[lineCount++] = " >";
				if(_groupTags["pre"] != null){
					resultHtml[lineCount++] = _groupTags["pre"];
				}else{
					resultHtml[lineCount++] = "&lt;"; //&gt; 
				}
                resultHtml[lineCount++] = "</button>";

				// 페이지번호
				for(var i = 1; i <= _pageBarSize; i++){
					var tempNum = i + (currentPageGroup * _pageBarSize);
					if(pageCount < tempNum){
						break;
					}else if(tempNum == _pageNum){
                        resultHtml[lineCount++] = "<button";
                        resultHtml[lineCount++] = getClassTag("select");
                        resultHtml[lineCount++] = ">";
						resultHtml[lineCount++] = tempNum;
                        resultHtml[lineCount++] = "</button>";
                    }else{
                        resultHtml[lineCount++] = "<button";
                        resultHtml[lineCount++] = getClassTag("num")
						resultHtml[lineCount++] = " onclick='javascript:goPage(";
						resultHtml[lineCount++] = tempNum;
						resultHtml[lineCount++] = "); return false;' >";
						resultHtml[lineCount++] = tempNum;
                        resultHtml[lineCount++] = "</button>";
					}
				}
				
				// 다음 그룹으로
				var nextPageGroup = currentPageGroup + 1;
                resultHtml[lineCount++] = "<button";
                resultHtml[lineCount++] = getClassTag("pnGroup");
				resultHtml[lineCount++] = " onclick='javascript:";
				if(nextPageGroup >= pageGroupCount && _pageNum == pageCount){
					resultHtml[lineCount++] = "alert(\"현재 마지막 페이지 입니다.\"); return false;";
				}else if(nextPageGroup >= pageGroupCount && _pageNum < pageCount){
					resultHtml[lineCount++] = "goPage(";
					resultHtml[lineCount++] = pageCount;
					resultHtml[lineCount++] = "); return false;";
				}else{
					// 해당 그룹의 마지막 페이지 번호
					var nextGroupPageNum = (nextPageGroup * _pageBarSize) + 1;
					resultHtml[lineCount++] = "goPage(";
					resultHtml[lineCount++] = nextGroupPageNum;
					resultHtml[lineCount++] = "); return false;";
				}
				resultHtml[lineCount++] = "'>";
				if(_groupTags["next"] != null){
					resultHtml[lineCount++] = _groupTags["next"];
				}else{
					resultHtml[lineCount++] = "&gt;";
				}
                resultHtml[lineCount++] = "</button>";
				
				// 마지막 그룹으로
                resultHtml[lineCount++] = "<button";
                resultHtml[lineCount++] = getClassTag("fnGroup");
				resultHtml[lineCount++] = " onclick='javascript:";
				if(_pageNum == pageCount){
					resultHtml[lineCount++] = "alert(\"현재 마지막 페이지 입니다.\"); return false;";
				}else{
					resultHtml[lineCount++] = "goPage("; 
					resultHtml[lineCount++] = pageCount;
					resultHtml[lineCount++] = "); return false;";
				}
				resultHtml[lineCount++] = "' >";
				if(_groupTags["end"] != null){
					resultHtml[lineCount++] = _groupTags["end"];
				}else{
					resultHtml[lineCount++] = "&raquo;";
				}
                resultHtml[lineCount++] = "</button>";
				
				resultHtml[lineCount++] = "</p>";

                if(_infoFlag){
                    resultHtml[lineCount++] = "&nbsp;";
                    resultHtml[lineCount++] = "<span";
                    resultHtml[lineCount++] = getClassTag("info");
                    resultHtml[lineCount++] = ">";
                    resultHtml[lineCount++] = "총 ";
                    resultHtml[lineCount++] = _totalCount;
                    resultHtml[lineCount++] = " 건";
                    resultHtml[lineCount++] = "(";
                    resultHtml[lineCount++] = _pageNum;
                    resultHtml[lineCount++] = " / ";
                    resultHtml[lineCount++] = pageCount;
                    resultHtml[lineCount++] = " page)";
                    resultHtml[lineCount++] = "</span>";
                }
			}
			return resultHtml.join("");
		};
		
		/**
		 * make class attribute
		 */
		var getClassTag = function(name){
			var classTag = "";
			if(_classes[name] != null){
                classTag = " class='";
                if(name=="select"){
                    classTag += _classes[name] + " " + _classes['num'];
                }else{
                    classTag += _classes[name];
                }
				classTag += "'";
			}
			return classTag;
		};
		
		/**
		 * <pre>스타일 지정
		 * - layoutClass : (div) Container class
         * - fnGroupClass : (a)first,end group button class
		 * - pnGroupClass : (a)pre,next group button class
		 * - numClass : (a)page number buttom class
		 * - selectNumClass : (a)selected page num button class
		 * - infoClass : (span)page info text class
		 * </pre>
		 * @author kst
		 * @since 2013. 11. 14
		 */
		PageNavigator.prototype.setClass = function(layoutClass,fnGroupClass,pnGroupClass,numClass,selectNumClass,infoClass){
			_classes['layout'] = layoutClass;
			_classes['fnGroup'] = fnGroupClass;
            _classes['pnGroup'] = pnGroupClass;
			_classes['num'] = numClass;
			_classes['select'] = selectNumClass;
			_classes['info'] = infoClass;
		};
		
		
		/**
		 * <pre>그룹이동 Tag 지정
		 * > 첫페이지, 이전페이지, 다음페이지, 마지막페이지 이동 버튼을 CustomTag 로 지정한다.
		 * - firstGroupTag : 첫페이지
		 * - preGroupTag : 이전 그룹
		 * - nextGroupTag : 다음 그룹
		 * - endGroupTag : 마지막 페이지
		 * </pre>
		 * @autor kst
		 * @since 2013. 11. 24
		 */
		PageNavigator.prototype.setGroupTag = function(firstGroupTag,preGroupTag,nextGroupTag,endGroupTag){
			_groupTags['first'] = firstGroupTag;
			_groupTags['pre'] = preGroupTag;
			_groupTags['next'] = nextGroupTag;
			_groupTags['end'] = endGroupTag;
		};
		
		/**
		 * 페이지 부가정보 노출 여부
		 * @author kst
		 * @since 2013. 11. 14
		 * @param boolean
		 */
		PageNavigator.prototype.showInfo = function(boolean){
			if(typeof boolean == "boolean"){
				_infoFlag = boolean;
			}else{
				_initFlag = false;
			}
		};
		/**
		 * 페이지 네비게이터 HTML 정보를 가져온다.
		 * @author kst
		 * @since 2013. 11. 14
		 * @returns
		 */
		PageNavigator.prototype.getHtml = function(){
			return makePageNavigatorHtmlTag();
		};
		/**
		 * 페이지 네비게이터 HTML 정보를 그린다.
		 * @author kst
		 * @since 2013. 11. 14
		 */
		PageNavigator.prototype.draw = function(){
			document.write(makePageNavigatorHtmlTag());
		};

		_initFlag = initialize(pageSize,currentPageNum,totalCount,pageBarSize);
	}
);
