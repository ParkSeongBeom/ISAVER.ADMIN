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
            <h3 class="1depth_title"><spring:message code="organization.title.organizationPopup"/></h3>
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
                <div id="orgTreeArea" class="tree_box"></div>
            </div>
        </article>
        <!-- 트리 영역 End -->
    </section>
    <!-- section End -->
</div>

</body>

<script type="text/javascript">
    var parentUserId = String('${paramBean.userId}');

    var urlConfig = {
        'organizationTreeUrl':'${rootPath}/organization/orgTree.json'
        ,'orgUserUrl':'${rootPath}/organization/detail.json'
    };

    var rootData = {
        title: 'HOME'
        ,key: '0'
        ,isFolder: true
        ,openFlag : true
        ,children: []
    };

    $(document).ready(function(){
        $("#orgTreeArea").dynatree({
            minExpandLevel: 2
            ,debugLevel: 1
            ,persist: true
            ,generateIds : true
            ,children: [rootData]
            ,onClick : function (node){
                if (node != null || node != undefined) {
                    if(!node.isExpanded() && !node.data.openFlag && node.data.isFolder){
                        sendAjaxPostRequest(urlConfig['orgUserUrl'], {'id':node.data.key}, successHandler, errorHandler, 'orgUser');
                    }
                }
            }
        });

        search();
    });

    function search(){
        sendAjaxPostRequest(urlConfig['organizationTreeUrl'], {}, successHandler, errorHandler, 'orgTree');
    }

    function successHandler(data, dataType, actionType) {
        switch (actionType) {
            case 'orgTree':
                organizationTreeData(data['organizationList']);
                break;
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

    function organizationTreeData(_list){
        for(var index in _list){
            var item = _list[index];

            var searchKey = item.depth==1 ? rootData['key'] : item['upOrgId'];

            try{
                $("#orgTreeArea").dynatree("getTree").selectKey(searchKey).addChild({
                    title: String(item['orgName'])
                    ,key: String(item['orgId'])
                    ,isFolder: true
                    ,openFlag : false
                    ,type:'org'
                    ,children: []
                });
            }catch(e){
                console.error("[organizationTreeData Failed][upOrgId is not find] orgid:" + item['orgid'] + ", orgName:" + item['orgName'] + ", upOrgId:" + item['upOrgId']);
            }
        }
    }

    function findChildUser(orgId, _list){
        var activeNode = $("#orgTreeArea").dynatree("getActiveNode");

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
        var activeNode = $("#orgTreeArea").dynatree("getActiveNode");
        var choiceOrgId;
        var choiceOrgName;

        if(activeNode['data']['isFolder']){
            choiceOrgId = activeNode['data']['key'];
            choiceOrgName = activeNode['data']['title'];
        }else{
            choiceOrgId = activeNode.parent['data']['key'];
            choiceOrgName = activeNode.parent['data']['title'];
        }

        opener.$("#"+parentUserId).find("span[name='orgName']")
            .text(choiceOrgName)
            .attr("title",choiceOrgName)
            .attr("orgId",choiceOrgId);

        window.close();
    }
</script>
</html>