<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${pageContext.servletContext.contextPath}/assets/css/base.css" rel="stylesheet" type="text/css" />
    <!--[if lt IE 9] -->
    <script src="${pageContext.servletContext.contextPath}/assets/js/util/html5.js"></script>
    <!--[endif] -->
    <title>Jabber Admin</title>
    <%-- dynatree, dhj --%>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.autosize.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.event.drag-1.5.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.touchSlider.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/calendar-helper.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui.custom.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.mCustomScrollbar.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/design.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/default.js"></script>
    <%-- dynatree, dhj --%>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.cookie.js"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';
    </script>

    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
</head>

<body>

<div class="window_wrap">
    <section class="container sub_area">
        <!-- 2depth 타이틀 영역 Start -->
        <article class="sub_title_area">
            <!-- 2depth 타이틀 Start-->
            <h3 class="1depth_title"><spring:message code="common.title.userCucmConnect"/></h3>
        </article>
        <!-- 2depth 타이틀 영역 End -->

        <form id="cucmDeviceForm" method="POST">
            <input type="hidden" name="pageNumber"/>
            <input type="hidden" name="userId" value="${paramBean.userId}"/>

            <article class="search_area">
                <div class="search_contents">
                    <!-- 일반 input 폼 공통 -->
                    <p class="itype_01">
                        <span><spring:message code="cucm.column.deviceType"/></span>
                        <span>
                            <input type="text" name="deviceType" value="${paramBean.deviceType}"/>
                        </span>
                    </p>
                    <p class="itype_01">
                        <span><spring:message code="cucm.column.deviceName"/></span>
                        <span>
                            <input type="text" name="deviceName" value="${paramBean.deviceName}"/>
                        </span>
                    </p>
                    <p class="itype_01">
                        <span><spring:message code="cucm.column.extension"/></span>
                        <span>
                            <input type="text" name="extension" value="${paramBean.extension}"/>
                        </span>
                    </p>
                </div>
                <div class="search_btn">
                    <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
                </div>
            </article>
        </form>

        <article class="table_area">
            <div class="table_title_area">
                <h4></h4>
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:saveCucmDevice(); return false;"><spring:message code="common.button.confirm"/> </button>
                </div>
            </div>

            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table id="groupTb" class="t_defalut t_type01 t_style02">
                    <colgroup>
                        <col style="width: 10%;" />
                        <col style="width: 25%;" />
                        <col style="width: 30%;" />
                        <col style="width: 20%;" />
                        <col style="width: 15%;" />
                    </colgroup>
                    <thead>
                    <tr>
                        <th><input type="checkbox" onchange="checkAllControl(this)"></th>
                        <th><spring:message code="cucm.column.deviceType"/></th>
                        <th><spring:message code="cucm.column.deviceName"/></th>
                        <th><spring:message code="cucm.column.extension"/></th>
                        <th><spring:message code="cucm.column.description"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${devices != null and fn:length(devices) > 0}">
                            <c:forEach var="device" items="${devices}">
                                <tr onclick="javascript:checkControl(this);">
                                    <td>
                                        <input type="checkbox" name="target">
                                        <input type="hidden" name="devtype" value="${device.devtype}">
                                        <input type="hidden" name="devicename" value="${device.devicename}">
                                    </td>
                                    <td>${device.devtype}</td>
                                    <td>${device.devicename}</td>
                                    <td>${device.telephonenumber}</td>
                                    <td>${device.description}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5"><spring:message code="common.message.emptyData"/></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <!-- 테이블 공통 페이징 Start -->
                <div id="pageContainer" class="page" />
            </div>
        </article>
    </section>
    <!-- section End -->
</div>

</body>

<script type="text/javascript">
    var form = $('#cucmDeviceForm');

    var urlConfig = {
        'listUrl':'${rootPath}/cucm/popup.html'
    };

    var pageConfig = {
        'pageSize':${paramBean.pageRowNumber}
        ,'pageNumber':${paramBean.pageNumber}
        ,'totalCount':${paramBean.totalCount}
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);
    });

    /*
     체크박스 컨트롤
     @author psb
     */
    function checkControl(target){
        if(event.target.nodeName!="INPUT" && event.target.nodeName!="BUTTON"){
            var checkFlag = $(target).find("input[name='target']").is(':checked');
            $(target).find("input[name='target']").prop('checked',!checkFlag)
        }
    }

    /*
     전체 체크박스 컨트롤
     @author psb
     */
    function checkAllControl(target){
        var checkFlag = $(target).is(':checked');
        $('input:checkbox[name=target]').each(function(){
            $(this).prop('checked',checkFlag);
        });
    }

    /*
     페이지 네이게이터를 그린다.
     @author kst
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
     @author kst
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }

    /*
     조회
     @author kst
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     전화장비 저장
     @author psb
     */
    function saveCucmDevice(){
        var deviceBeanList = [];

        $.each($('input:checkbox[name=target]:checked'),function(){
            var deviceBean = {};
            $.each($(this).parent("td").find("input[type='hidden']"),function(){
                deviceBean[this.name] = this.value;
            });
            deviceBeanList.push(deviceBean);
        });

        opener.makeHtmlTagCucm(deviceBeanList);
        window.close();
    }
</script>
</html>