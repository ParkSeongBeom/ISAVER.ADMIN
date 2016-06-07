<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-B000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-B000-0000-0000-000000000005" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.userUpload"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="excelForm" method="POST">
        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_03">
                    <span><input type="radio" name="tabs" value="adLdap"/><spring:message code="user.column.uploadAdLdap" /></span>
                    <span><input type="radio" name="tabs" value="cucm"/><spring:message code="user.column.uploadCucm" /></span>
                    <span><input type="radio" name="tabs" value="excel"/><spring:message code="user.column.uploadExcel" /></span>
                </p>
                <!-- 일반 input 폼 공통 -->
                <p class="itype_04 displayNone search_server">
                    <span><spring:message code="user.column.serverName" /></span>
                    <span>
                        <select name="serverName" class="type01"></select>
                    </span>
                </p>
                <!-- 일반 input 폼 공통 -->
                <p class="itype_04 displayNone search_excel">
                    <span><spring:message code="user.column.uploadExcel" /></span>
                    <!-- 파일 첨부 시작 -->
                    <span class="infile_set">
                        <input type="text" class="excelUpload" readonly="readonly" title="File Route" id="file_route">
                        <span class="btn_infile btype03 bstyle04">
                            <input type="file" name="excel" onchange="javascript:document.getElementById('file_route').value=this.value">
                        </span>
                    </span>
                    <!-- 파일 첨부 끝  -->
                    <span class="search_btn">
                        <button class="btn btype03 bstyle03" onclick="javascript:downloadExcel(); return false;"><spring:message code="user.button.sampleDownload"/></button>
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.import"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <span class="titleCheckBox">
                <input type="checkbox" name="resetPassword"><spring:message code="user.column.resetPassword" />
            </span>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle03" onclick="javascript:saveUpload(); return false;"><spring:message code="common.button.save"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <div class="page_loading"></div>

            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style03" id="userListTb">
                <colgroup>
                    <col style="width: 35px;" />
                    <col style="width: 8%;" />
                    <col style="width: 8%;" />
                    <col style="width: 8%;" />
                    <col style="width: 73px;" />
                    <col class="hideColumn" style="width: 7%;" />
                    <col class="hideColumn" style="width: 7%;" />
                    <col style="width: 8%;" />
                    <col style="width: 8%;" />
                    <col class="hideColumn" style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col class="hideColumn" style="width: 10%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><input type="checkbox" name="allCheckbox" onchange="checkAllControl(this)"></th>
                        <th><spring:message code="user.column.userId"/></th>
                        <th><spring:message code="user.column.password"/></th>
                        <th colspan="2"><spring:message code="user.column.orgName"/></th>
                        <th class="hideColumn"><spring:message code="user.column.position"/></th>
                        <th class="hideColumn"><spring:message code="user.column.classification"/></th>
                        <th><spring:message code="user.column.userName"/></th>
                        <th><spring:message code="user.column.extension"/></th>
                        <th class="hideColumn"><spring:message code="user.column.phone"/></th>
                        <th><spring:message code="user.column.mobile"/></th>
                        <th class="hideColumn"><spring:message code="user.column.email"/></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="12"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </article>
</section>
<!-- END : contents -->

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var defalutTab = 'adLdap';
    var defalutPassword = '1234!';

    var urlConfig = {
        'targetSynchronizeListUrl':'${rootPath}/targetSynchronize/list.json'
        ,'adLdapUserListUrl':'${rootPath}/directory/userList.json'
        ,'cucmUserListUrl':'${rootPath}/cucm/userList.json'
        ,'excelUserListUrl':'${rootPath}/user/uploadExcel.json'
        ,'downloadExcelUrl':'${rootPath}/user/downloadExcel.json'
        ,'upsertUserUrl':'${rootPath}/user/upsert.json'
        ,'organizationPopupUrl':'${rootPath}/organization/organizationPopup.html'
    };

    var messageConfig = {
        'saveConfirm':'<spring:message code="user.message.saveConfirm"/>'
        ,'upsertUserConfirm':'<spring:message code="user.message.upsertUserConfirm"/>'
        ,'targetSynchronizeListFailure':'<spring:message code="user.message.targetSynchronizeListFailure"/>'
        ,'adLdapUserListFailure':'<spring:message code="user.message.adLdapUserListFailure"/>'
        ,'excelUserListFailure':'<spring:message code="user.message.excelUserListFailure"/>'
        ,'cucmUserListFailure':'<spring:message code="user.message.cucmUserListFailure"/>'
        ,'upsertUserFailure':'<spring:message code="user.message.upsertUserFailure"/>'
        ,'upsertUserComplete':'<spring:message code="user.message.upsertUserComplete"/>'
        ,'workSynchronizeUser':'<spring:message code="user.message.workSynchronizeUser"/>'
        ,'targetSynchronizeFailure':'<spring:message code="user.message.targetSynchronizeFailure"/>'
        ,'emptyServerName':'<spring:message code="user.message.emptyServerName"/>'
        ,'requireSelectRow':'<spring:message code="user.message.requireSelectRow"/>'
        ,'requireSelectFile':'<spring:message code="user.message.requireSelectFile"/>'
        ,'notValidateFileExtension':'<spring:message code="user.message.notValidateFileExtension"/>'
    };

    var userTrHtmlTag = $("<tr/>").append(
        $("<td/>").append(
            $("<input/>").attr("type","checkbox").attr("name","target").attr("onclick","javascript:event.stopPropagation();")
        )
    ).append(
        $("<td/>").append(
            $("<span/>").attr("name","userId")
        )
    ).append(
        $("<td/>").append(
            $("<input/>").attr("type","text").attr("name","japplePassword")
        )
    ).append(
        $("<td/>").append(
            $("<span/>").attr("name","orgName")
        )
    ).append(
        $("<td/>").append(
            $("<button/>").attr("name","findBtn").addClass("btn btype02 bstyle03")
                .text('<spring:message code="common.button.find"/>')
        )
    ).append(
        $("<td/>").addClass("hideColumn").append(
            $("<input/>").attr("type","text").attr("name","position")
        )
    ).append(
        $("<td/>").addClass("hideColumn").append(
            $("<input/>").attr("type","text").attr("name","classification")
        )
    ).append(
        $("<td/>").append(
            $("<input/>").attr("type","text").attr("name","userName")
        )
    ).append(
        $("<td/>").append(
            $("<input/>").attr("type","text").attr("name","extension")
        )
    ).append(
        $("<td/>").addClass("hideColumn").append(
            $("<input/>").attr("type","text").attr("name","phone")
        )
    ).append(
        $("<td/>").append(
            $("<input/>").attr("type","text").attr("name","mobile")
        )
    ).append(
        $("<td/>").addClass("hideColumn").append(
            $("<input/>").attr("type","text").attr("name","email")
        )
    );

    var emptyTrHtmlTag = $("<tr/>").append(
        $("<td/>").text('<spring:message code="common.message.emptyData"/>')
    );

    $(document).ready(function(){
        $("input:radio[name='tabs']").click(function(){
            var selValue = $(this).val();
            $(".displayNone").hide();

            switch(selValue){
                case 'adLdap':
                case 'cucm':
                    sendAjax('targetSynchronizeList',{'type':selValue});
                    break;
                case 'excel':
                    $(".search_excel").show();
                    break;
            }
        });

        $("input:radio[name='tabs'][value='"+defalutTab+"']").prop("checked",true).trigger('click');
    });

    /*
     가져오기
     @author psb
     */
    function search(){
        var tabId = $("input:radio[name='tabs']:checked").val();

        switch(tabId){
            case 'adLdap':
            case 'cucm':
                if(validate('search')){
                    resetTable(tabId);
                    var server = $("select[name='serverName'] option:selected");

                    var data = {
                        'ip':server.attr('ip')
                        ,'port':server.attr('port')
                        ,'id':server.attr('authId')
                        ,'password':server.attr('authPassword')
                        ,'directory':server.attr('directory')
                    };
                    $(".page_loading").show();
                    sendAjax(tabId+'UserList',data);
                }
                break;
            case 'excel':
                if(validate('excel')){
                    resetTable(tabId);
                    $(".page_loading").show();
                    sendAjax('excelUserList', $('#excelForm'), 'file');
                }
                break;
        }
    }

    /*
     저장
     @author psb
     */
    function saveUpload(){
        if(!confirm(messageConfig['upsertUserConfirm'])){
            return false;
        }

        var userList = [];
        var synchronizeUserList = [];
        var orgUserList = [];

        $.each($('input:checkbox[name=target]:checked'),function(){
            var target = $(this).parent("td").parent("tr");

            if(target.attr("id")!=null){
                /**
                 * 사용자 등록/수정 목록
                 */
                var japplePassword = target.find("input[name='japplePassword']").val();
                if(($("input[name='resetPassword']").is(":checked") || target.attr("mode")=="INS") && japplePassword==""){
                    japplePassword = target.attr("id")+defalutPassword;
                }

                userList.push({
                    'userId' : target.attr("id")
                    ,'domain' : target.attr("domain")
                    ,'japplePassword' : japplePassword
                    ,'classification' : target.find("input[name='classification']").val()
                    ,'userName' : target.find("input[name='userName']").val()
                    ,'extension' : target.find("input[name='extension']").val()
                    ,'phone' : target.find("input[name='phone']").val()
                    ,'mobile' : target.find("input[name='mobile']").val()
                    ,'email' : target.find("input[name='email']").val()
                    ,'insertUserId': '${authUserId}'
                    ,'updateUserId': '${authUserId}'
                });

                /**
                 * 수정된 필드 동기화 목록
                 */
                var synchronizeInfoList = [];
                $(target).find('.syncType').each(function(){
                    var beforeText = $(this).attr("beforeText")!=null ? $(this).attr("beforeText") : "";
                    if(beforeText!=$(this).val()){
                        synchronizeInfoList.push({
                            'key' : $(this).attr("name")
                            ,'value' : $(this).val()
                        });
                    }
                });

                synchronizeUserList.push({
                    'userId' : target.attr("id")
                    ,'infoBeans' : synchronizeInfoList
                    ,'detailBeans' : [{
                        'type' : target.attr("mode")
                    }]
                });

                /**
                 * 부서 등록 목록
                 */
                if(target.find("span[name='orgName']").attr("orgId")!=null){
                    orgUserList.push({
                        'userId' : target.attr("id")
                        ,'orgId' : target.find("span[name='orgName']").attr("orgId")
                        ,'classification' : target.find("input[name='position']").val()
                    });
                }
            }
        });

        if(synchronizeUserList!=null){
            var data = {
                'userList':JSON.stringify(userList)
                ,'synchronizeUserList':JSON.stringify(synchronizeUserList)
                ,'orgUserList':JSON.stringify(orgUserList)
            };

            sendAjax('upsertUser',data);
        }else{
            alertMessage('requireSelectRow');
        }
    }

    /*
     엑셀업로드
     @author psb
     */
    function sendExcel(){
        if(validate('excel')){
            sendAjax('excelUserList', $('#excelForm'), 'file');
        }
    }

    /*
     validation
     @author psb
     */
    function validate(type){
        if(type=='search'){
            var server = $("select[name='serverName'] option:selected");

            if(server.val()==""){
                alertMessage('emptyServerName');
                return false;
            }

            if(server.attr("ip").trim()=="" ||
                server.attr("port").trim()=="" ||
                server.attr("id")=="" ||
                server.attr("japplePassword")=="" ||
                server.attr("directory")==""){
                alertMessage('targetSynchronizeFailure');
                return false;
            }
        }else if(type=='excel'){
            var file = $('#excelForm input:file').val();
            if(!file || file.length == 0){
                alertMessage('requireSelectFile');
                return false;
            }

            var extension = file.substring(file.lastIndexOf('.')+1,file.length);
            switch(extension.toLowerCase()){
                case 'xls':
                case 'xlsx':
                    break;
                default:
                    alertMessage('notValidateFileExtension');
                    return false;
            }
        }

        return true;
    }

    /*
     테이블 초기화 및 show/hide 컬럼 정의
     @author psb
     */
    function resetTable(tabId){
        $("#userListTb > tbody").empty();
        if(tabId=="cucm") {
            emptyTrHtmlTag.find("td").attr("colspan",$("#userListTb > colgroup").find("col").not(".hideColumn").length);
            $(".hideColumn").hide();
            userTrHtmlTag.find(".hideColumn").hide();
        }else{
            emptyTrHtmlTag.find("td").attr("colspan",$("#userListTb > colgroup").find("col").length);
            $(".hideColumn").show();
            userTrHtmlTag.find(".hideColumn").show();
        }
    }

    /*
     엑셀 다운로드
     @author psb
     */
    function downloadExcel(){
        location.href=urlConfig['downloadExcelUrl'];
    }

    /*
     체크박스 컨트롤
     @author psb
     */
    function checkControl(target){
        var checkFlag = $(target).find("input[name='target']").is(':checked');
        $(target).find("input[name='target']").prop('checked',!checkFlag)
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
     조직팝업
     @author psb
     */
    function organizationPopup(userId){
        window.open(urlConfig['organizationPopupUrl']+"?userId="+userId,'organizationPopup','scrollbars=no,width=550,height=470,left=50,top=50');
    }

    /*
     ajax call
     @author kst
     */
    function sendAjax(actionType, data, ajaxType){
        switch(ajaxType){
            case 'file':
                sendAjaxFileRequest(
                    urlConfig[actionType + 'Url']
                    ,data
                    ,successHandler
                    ,failureHandler
                    ,actionType
                );
                break;
            default:
                sendAjaxPostRequest(
                    urlConfig[actionType + 'Url']
                    ,data
                    ,successHandler
                    ,failureHandler
                    ,actionType
                );
        }
    }

    /*
     ajax success handler
     @author psb
     */
    function successHandler(data, dataType, actionType) {
        switch(actionType){
            case 'targetSynchronizeList':
                makeHtmlTagSelectBox(data);
                break;
            case 'excelUserList':
                makeHtmlTagUserTable(JSON.parse(data));
                break;
            case 'cucmUserList':
            case 'adLdapUserList':
                makeHtmlTagUserTable(data);
                break;
            case 'upsertUser':
                if(data.resultValue==200){
                    alertMessage('upsertUserComplete');
                }else if(data.resultValue==100){
                    alertMessage('workSynchronizeUser');
                }else{
                    alertMessage('upsertUserFailure');
                }
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType+'Failure');
        console.log(XMLHttpRequest, textStatus, errorThrown);
        $(".page_loading").hide();
    }

    /*
     서버명 그리기
     @author psb
     */
    function makeHtmlTagSelectBox(data) {
        var targetSynchronizes = data.targetSynchronizes;

        // selectbox 초기화
        $("select[name='serverName']").empty().append(
            $("<option/>").val("").text("선택하세요")
        );

        if(targetSynchronizes.length>0){
            for(var index in targetSynchronizes){
                var targetSynchronize = targetSynchronizes[index];
                $("select[name='serverName']").append(
                    $("<option/>")
                        .val(targetSynchronize['targetId'])
                        .attr("ip",targetSynchronize['ip'])
                        .attr("port",targetSynchronize['port'])
                        .attr("authId",targetSynchronize['id'])
                        .attr("authPassword",targetSynchronize['password'])
                        .attr("directory",targetSynchronize['directory'])
                        .text(targetSynchronize['name'])
                );
            }
        }

        $(".search_server").show();
    }

    /*
     가져온 계정 정보 그리기
     @author psb
     */
    function makeHtmlTagUserTable(data) {
        var userList = data.userList;

        if(userList!=null && userList.length>0){
            for(var index in userList){
                var user = userList[index];
                var _trHtmlTag = userTrHtmlTag.clone();

                _trHtmlTag.attr("id",user['userId']).attr("domain",user['domain']).attr("mode",user['mode']);
                _trHtmlTag.find("span[name='userId']").text(user['userId']);
                _trHtmlTag.find("input[name='japplePassword']").addClass("syncType").val(user['japplePassword']).attr("beforeText",user['beforeJapplePassword']!=null ? user['beforeJapplePassword'] : user['japplePassword']);
                _trHtmlTag.find("span[name='orgName']").text(user['orgName']!=null ? user['orgName'] : '');
                _trHtmlTag.find("input[name='position']").val(user['position']).attr("beforeText",user['beforePosition']!=null ? user['beforePosition'] : user['position']);
                _trHtmlTag.find("input[name='classification']").addClass("syncType").val(user['classification']).attr("beforeText",user['beforeClassification']!=null ? user['beforeClassification'] : user['classification']);
                _trHtmlTag.find("input[name='userName']").addClass("syncType").val(user['userName']).attr("beforeText",user['beforeUserName']!=null ? user['beforeUserName'] : user['userName']);
                _trHtmlTag.find("input[name='extension']").val(user['extension']).attr("beforeText",user['beforeExtension']!=null ? user['beforeExtension'] : user['extension']);
                _trHtmlTag.find("input[name='phone']").val(user['phone']).attr("beforeText",user['beforePhone']!=null ? user['beforePhone'] : user['phone']);
                _trHtmlTag.find("input[name='mobile']").addClass("syncType").val(user['mobile']).attr("beforeText",user['beforeMobile']!=null ? user['beforeMobile'] : user['mobile']);
                _trHtmlTag.find("input[name='email']").addClass("syncType").val(user['email']).attr("beforeText",user['beforeEmail']!=null ? user['beforeEmail'] : user['email']);
                _trHtmlTag.find("button[name='findBtn']").attr("onclick","javascript:organizationPopup('"+user['userId']+"'); return false;");

                _trHtmlTag.on("click",function(){
                    if(event.target.nodeName!="INPUT" && event.target.nodeName!="BUTTON"){
                        checkControl(this);
                    }
                });

                $("#userListTb > tbody").append(_trHtmlTag);
            }
        }else{
            var _trHtmlTag = emptyTrHtmlTag.clone();
            $("#userListTb > tbody").append(_trHtmlTag);
        }

        $(".page_loading").hide();
    }

    /*
     alert message method
     @author kst
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>