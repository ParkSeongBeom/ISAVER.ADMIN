<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<input type="hidden" name="pageNumber"/>

<article class="search_area search_tline">
    <div class="search_contents">
        <!-- 일반 input 폼 공통 -->
        <div class="itype_01">
            <span><spring:message code="bussinessboard.column.type" /></span>
            <span>
                <div class="cs_color_select ccs_type01">
                    <input type="hidden" name="type" value="${paramBean.type}" />
                    <p>전체</p>
                    <p style="background-color: #3366cc;" bgcolor="#3366cc"></p>
                    <p style="background-color: #22aa99;" bgcolor="#22aa99"></p>
                    <p style="background-color: #b027b0;" bgcolor="#b027b0"></p>
                    <p style="background-color: #76a72d;" bgcolor="#76a72d"></p>
                    <p style="background-color: #e25091;" bgcolor="#e25091"></p>
                    <p style="background-color: #f2812e;" bgcolor="#f2812e"></p>
                </div>
            </span>
        </div>
        <p class="itype_01">
            <span><spring:message code="bussinessboard.column.title" /></span>
            <span>
                <input type="text" name="title" value="${paramBean.title}"/>
            </span>
        </p>
        <p class="itype_03">
            <span><spring:message code="bussinessboard.column.bussinessDate" /></span>
            <span>
                <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                <em>~</em>
                <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
            </span>
        </p>
    </div>
    <div class="search_btn">
        <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
    </div>
</article>

<div class="table_title_area">
    <h4></h4>
    <div class="table_btn_set">
        <button class="btn btype01 bstyle03" onclick="javascript:bussinessDetailRender('new'); return false;"><spring:message code="bussinessboard.button.add"/></button>
    </div>
</div>

<div class="table_contents">
    <!-- 입력 테이블 Start -->
    <table class="t_defalut t_type01 t_style02">
        <colgroup>
            <col style="width:70px" />
            <col style="width:*" />
            <col style="width:140px" />
            <col style="width:150px" />
        </colgroup>
        <thead>
            <tr>
                <th class="t_center"><spring:message code="bussinessboard.column.type"/></th>
                <th><spring:message code="bussinessboard.column.title"/></th>
                <th><spring:message code="bussinessboard.column.bussinessDate"/></th>
                <th><spring:message code="bussinessboard.column.staff"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${bussinessBoardList != null and fn:length(bussinessBoardList) > 0}">
                    <c:forEach var="bussinessBoard" items="${bussinessBoardList}">
                        <tr onclick="javascript:detail('${bussinessBoard.bussinessId}');">
                            <td>
                                <div class="colorbox" style="background-color: ${bussinessBoard.backgroundColor};">
                                </div>
                            </td>
                            <td class="t_left" title="${bussinessBoard.title}">${bussinessBoard.title}</td>
                            <td>
                                <fmt:formatDate pattern="yy.MM.dd" value="${bussinessBoard.startDatetime}" /> ~ <fmt:formatDate pattern="yy.MM.dd" value="${bussinessBoard.endDatetime}" />
                            </td>
                            <td>${bussinessBoard.staff}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="4"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- 테이블 공통 페이징 Start -->
    <div id="pageContainer" class="page" />
</div>

<script type="text/javascript">
    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        calendarHelper.load($('input[name=startDatetimeStr]'));
        calendarHelper.load($('input[name=endDatetimeStr]'));

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });

        $(".cs_color_select > p").click(function(){
            $(".cs_color_select .on").removeClass("on");
            $(this).addClass("on");
            $("input[name='type']").val($(this).attr("bgcolor"));
        });

        var colorCode = "${paramBean.type}";
        if(colorCode!="" && colorCode!=null){
            $(".cs_color_select > p[bgcolor='"+"${paramBean.type}"+"']").addClass("on");
        }else{
            $(".cs_color_select > p:first").addClass("on");
        }
    });

    /*
     페이지 네이게이터를 그린다.
     @author psb
     */
    function drawPageNavigater(pageSize,pageNumber,totalCount){
        var pageNavigater = new PageNavigator(pageSize,pageNumber,totalCount);
        pageNavigater.setClass('paging','p_arrow pll','p_arrow pl','','page_select','');
        pageNavigater.setGroupTag('《','〈','〉','》');
        pageNavigater.showInfo(false);
        $('#pageContainer').append(pageNavigater.getHtml());
    }

    /*
     페이지 이동
     @author psb
     */
    function goPage(pageNumber){
        $('input[name=pageNumber]').val(pageNumber);
        search();
    }

    /*
     조회조건 validate
     @author psb
     */
    function validateSearch(){
        var startDatetiemStr = $('input[name=startDatetimeStr]').val();
        if(startDatetiemStr.length != 0 && !startDatetiemStr.checkDatePattern('-')){
            alertMessage('confirmStartDatetime');
            return false;
        }

        var endDatetimeStr = $('input[name=endDatetimeStr]').val();
        if(endDatetimeStr.length != 0 && !endDatetimeStr.checkDatePattern('-')){
            alertMessage('confirmEndDatetime');
            return false;
        }

        var sDate = new Date(startDatetiemStr);
        var eDate = new Date(endDatetimeStr);

        if (sDate > eDate) {
            alert('시작일이 종료일보다 클 수 없습니다.');
            return false;
        }

        return true;
    }

    /*
     조회
     @author psb
     */
    function search(){
        if(validateSearch()){
            parameters['viewType'] = 'listView';
            parameters['pageNumber'] = $("input[name='pageNumber']").val();
            parameters['title'] = $("input[name='title']").val();
            parameters['type'] = $("input[name='type']").val();
            parameters['startDatetimeStr'] = $("input[name='startDatetimeStr']").val();
            parameters['endDatetimeStr'] = $("input[name='endDatetimeStr']").val();
            $(".tabs > li[rel='listView']").trigger("click");
        }
    }
</script>