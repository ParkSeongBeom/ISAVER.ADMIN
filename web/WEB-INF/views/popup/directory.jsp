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
    <link rel="stylesheet" type="text/css" href="${rootPath}/assets/css/dynatree/skin-vista/ui.dynatree.css" >
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

    <script type="text/javascript" src="${rootPath}/assets/js/common/dynatree/jquery.dynatree.js" charset="UTF-8"></script>
</head>

<body>

<div class="window_wrap">
    <section class="container sub_area">
        <!-- 2depth 타이틀 영역 Start -->
        <article class="sub_title_area">
            <!-- 2depth 타이틀 Start-->
            <h3 class="1depth_title"><spring:message code="organization.title.directoryPopup"/></h3>
        </article>
        <!-- 2depth 타이틀 영역 End -->

        <!-- 트리 영역 Start -->
        <article class="table_area">
            <div class="table_title_area">
                <h4></h4>
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle01" onclick="javascript:choice(); return false;"><spring:message code='common.button.confirm'/></button>
                </div>
            </div>
            <div class="table_contents">
                <div id="directoryTreeArea" class="tree_box"></div>
            </div>
        </article>
        <!-- 트리 영역 End -->
    </section>
    <!-- section End -->
</div>

</body>

<script type="text/javascript">
    var urlConfig = {
        'orgUserUrl':'${rootPath}/organization/detail.json'
    };

    var messageConfig = {
        'directoryTreeFailure' : '<spring:message code="organization.message.directoryTreeFailure"/>'
    };

    $(document).ready(function(){
        if("${resultFlag}"=="true"){
            $("#directoryTreeArea").dynatree({
                minExpandLevel: 2
                ,debugLevel: 1
                ,persist: true
                ,generateIds : true
                ,children: [
                        <c:if test="${!empty baseDn}">
                            {
                                title: "${baseDn}"
                                ,key: "${baseDn}"
                                ,isFolder: true
                                ,openFlag : false
                                ,type:'org'
                                ,children: [
                                    <c:forEach var="directory" items="${directoryList}">
                                        {
                                            title: "${directory}"
                                            ,key: "${directory}"
                                            ,isFolder: true
                                            ,openFlag : true
                                            ,type:'org'
                                            ,children: []
                                        },
                                    </c:forEach>
                                ]
                            }
                        </c:if>
                ]
                ,onClick : function (node){
                    if (node != null || node != undefined) {
                        if(!node.isExpanded() && !node.data.openFlag && node.data.isFolder){
//                            sendAjaxPostRequest(urlConfig['orgUserUrl'], {'id':node.data.key}, successHandler, errorHandler, 'orgUser');
                        }
                    }
                }
            });
        }else{
            alert(messageConfig['directoryTreeFailure'] + " - ${resultText}");
            window.close();
        }
    });

    function successHandler(data, dataType, actionType) {
        switch (actionType) {
            case 'orgUser':
                if(data['organization']!=null && data['orgUsers']!=null){
                    findChildUser(data.organization.orgId, data.orgUsers);
                }
                break;
        }
    }

    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error]["+actionType+"] " + errorThrown);
    }

    function findChildUser(orgId, _list){
        var activeNode = $("#directoryTreeArea").dynatree("getActiveNode");

        for(var index in _list){
            var item = _list[index];

            try{
                activeNode.addChild({
                    title: String(item['username'] + " " + item['classification'])
                    ,key: String(item['userid'])
                    ,isFolder: false
                    ,children: []
                });
            }catch(e){
                console.error("[findChildUser Failed][upOrgId is not find] orgid:" + item['orgid'] + ", userName:" + item['username'] + ", userId:" + item['userid']);
            }
        }

        if(activeNode.hasChildren()){
            activeNode.data.openFlag = true;
            activeNode.render();
            activeNode.expand(true);
        }
    }

    function choice(){
        var activeNode = $("#directoryTreeArea").dynatree("getActiveNode");
        var choiceOrgName;

        if(activeNode['data']['isFolder']){
            choiceOrgName = activeNode['data']['title'];
        }else{
            choiceOrgName = activeNode.parent['data']['title'];
        }

        opener.$("input[name='directory']").val(choiceOrgName);
        window.close();
    }
</script>
</html>