/**
 * [Model] 조직도
 * @author dhj
 * @since 2014.06.08
 */
function OrganizationModel() {

    var OrganizationModel = new Object();

    OrganizationModel.model = {
        viewStatus: ''
        ,rootUrl: ''
        ,requestUrl: ''
        ,userId: ''
        ,orgId: ''
        ,upOrgId: ''
        ,depth: ''
        ,orgName: ''
        ,formName: 'menuForm'
        ,treeArea: '#menuTreeArea'
        ,targetMenuId: ''
        ,rootOrgId: '0'
        ,METHOD: {
            ADD: 'add',
            SAVE: 'save',
            REMOVE: 'remove',
            DETAIL: 'detail'
        }
        ,ACTION: {
            ADD: 'add',
            SAVE: 'save',
            REMOVE: 'remove',
            ORG_USER_REMOVE: 'orgUserRemove',
            ORG_USER_REMOVES: 'orgUserRemoves',
            DETAIL: 'detail'
        }
        ,gwUserId:''
        ,userName:''
        ,pageIndex: 0
        ,pageRowNumber: 0
        ,pageCount: 0
        ,rootName: "HOME"
    };

    /**
     * 현재 조직 깊이 정의
     * @param orgdepth
     */
    OrganizationModel.setDepth = function (depth) {
        this.model.depth = depth;
    };

    /**
     * 현재 조직 깊이 반환
     * @param orgdepth
     */
    OrganizationModel.getDepth = function () {
        return this.model.depth;
    };

    OrganizationModel.setTreaArea = function (area) {
        this.model.treeArea = area;
    };

    OrganizationModel.getTreaArea = function () {
        return this.model.treeArea;
    };

    OrganizationModel.getMethodValue = function (method) {
        return this.model.METHOD[method];
    };

    OrganizationModel.getActionValue = function () {
        return this.model.ACTION[action];
    };
    /**
     * 루트 조직 ID를 정의
     * @param rootMenuId
     */
    OrganizationModel.setRootOrgId = function (rootOrgId) {
        this.model.rootOrgId = rootOrgId;
    };
    /**
     * 루트 조직 ID를 반환
     * @returns {string}
     */
    OrganizationModel.getRootOrgId = function () {
        return this.model.rootOrgId;
    };

    /**
     * 현재 View 상태를 정의
     * @param status
     * @returns {*}
     */
    OrganizationModel.setViewStatus = function (status) {
        this.model.viewStatus = status;
    };
    /**
     * 현재 View 상태의 상태를 반환
     * @returns {string}
     */
    OrganizationModel.getViewStatus = function () {
        return this.model.viewStatus;
    };
    /**
     * 요청 루트 도메인을 정의
     * @param url
     * @returns {string|*}
     */
    OrganizationModel.setRootUrl = function (url) {
        this.model.rootUrl = url;

    };

    /**
     * 요청 루트 도메인을 반환
     * @param url
     * @returns {string|*}
     */
    OrganizationModel.getRootUrl = function () {
        return this.model.rootUrl;

    };

    /**
     * 현재 API 주소를 정의
     * @param requestUrl
     */
    OrganizationModel.setRequestUrl = function (requestUrl) {
        this.model.requestUrl = requestUrl;
    };

    /**
     * 현재 API 주소를 반환
     * @returns {string}
     */
    OrganizationModel.getRequestUrl = function () {
        return this.model.requestUrl;
    };

    /**
     * 현재 upOrgId 정의
     * @param upOrgId
     * @returns {string|*}
     */
    OrganizationModel.setUpOrgId = function (upOrgId) {
        this.model.upOrgId = upOrgId;
    };

    /**
     * 현재 getUpOrgId 반환
     * @returns {string}
     */
    OrganizationModel.getUpOrgId = function () {
        return this.model.upOrgId;
    };

    /**
     * 현재 orgId 정의
     * @param orgSeq
     * @returns {string|*}
     */
    OrganizationModel.setOrgId = function (orgId) {
        this.model.orgId = orgId;
    };

    /**
     * 현재 getOrgId 반환
     * @returns {string}
     */
    OrganizationModel.getOrgId = function () {
        return this.model.orgId;
    };

    /**
     * 현재 HTML formTag명을 정의
     * @returns {string}
     */
    OrganizationModel.setFormName = function (formName) {
        this.model.formName = formName;
    };
    /**
     * 현재 HTML formTag명을 반환
     * @returns {string}
     */
    OrganizationModel.getFormName = function () {
        return this.model.formName;
    };

    /**
     * 현재 사용중인 조직명을 정의
     * @param menuName
     */
    OrganizationModel.setOrgName = function (orgName) {
        this.model.orgName = orgName;
    };

    /**
     * 현재 사용중인 메뉴명을 반환
     * @returns {string}
     */
    OrganizationModel.getOrgName = function () {
        return this.model.orgName;
    };

    OrganizationModel.setTargetMenuId = function(targetMenuId) {
        this.model.targetMenuId = targetMenuId;
    };

    OrganizationModel.getTargetMenuId = function() {
        return this.model.targetMenuId;
    };

    OrganizationModel.setUserName = function(userName) {
        this.model.userName = userName;
    };

    OrganizationModel.getUserName = function() {
        return this.model.userName;
    };

    OrganizationModel.setPageIndex = function(pageIndex) {
        this.model.pageIndex = pageIndex;
    };

    OrganizationModel.getPageIndex = function() {
        return this.model.pageIndex;
    };

    OrganizationModel.setPageRowNumber = function(pageRowNumber) {
        this.model.pageRowNumber = pageRowNumber;
    };

    OrganizationModel.getPageRowNumber = function() {
        return this.model.pageRowNumber;
    };

    OrganizationModel.setPageCount = function(pageCount) {
        this.model.pageCount = pageCount;
    };

    OrganizationModel.getPageCount = function() {
        return this.model.pageCount;
    };

    OrganizationModel.setRootName = function(rootName) {
        this.model.pageCount = pageCount;
    };

    OrganizationModel.getRootName = function() {
        return this.model.rootName;
    };

    OrganizationModel.setUserId = function(userId) {
        this.model.userId = userId;
    };

    OrganizationModel.getUserId = function() {
        return this.model.userId;
    };
    /**
     * 조직도 페이지에서 사용 중인 Request URL 반환
     * @param url
     * @returns {*}
     * @date 2014.05.22
     * @see dhj
     */
    OrganizationModel.getRequestUrl = function () {
        var rootUrl = OrganizationModel.getRootUrl();
        var viewStatus = OrganizationModel.getViewStatus();
        return {
            'add'     : rootUrl + "/organization/add.json",
            'save'    : rootUrl + "/organization/save.json",
            'remove'  : rootUrl + "/organization/remove.json",
            'detail'  : rootUrl + "/organization/detail.json",
            'menuTree': rootUrl + "/organization/treeList.json",
            'addOrgUser': rootUrl + "/organization/detailUserPopup.html",
            'orgUserRemove': rootUrl + "/orgUser/remove.json",
            'orgUserRemoves': rootUrl + "/orgUser/removes.json"
        }[viewStatus];
    };

    /**
     * 부서 트리 가공
     * @author dhj
     */
    OrganizationModel.processMenuTreeData = function (_list, _rootId) {
        var obj = {};

        obj.orgCode = null;
        obj.depth = 0;
        obj.orgName = OrganizationModel.getRootName();
        obj.orgId = OrganizationModel.getRootOrgId();
        obj.sortOrder = null;
        obj.upOrgId = null;

        _list.unshift(obj);
        //최종적인 트리 데이터
        var _treeModel = [];

        //전체 데이터 길이
        var _listLength = _list.length;

        //트리 크기
        var _treeLength = 0;

        //반복 횟수
        var _loopLength = 0;

        //재귀 호출
        function getParentNode(_children, item) {

            //전체 리스트를 탐색
            for (var i = 0, child; child = _children[i]; i++) {
                //부모를 찾았으면,
                if (String(child.id) === String(item.upOrgId)) {
                    var view =
                    {
                        id        : String(item.orgId),
                        title     : String(item.orgName),
                        isFolder  : false,
                        orgSort   : Number(item.sortOrder),
                        children  : []
                    };

                    //현재 요소를 추가하고
                    child.children.push(view);

                    //트리 크기를 반영하고,
                    _treeLength++;

                    //데이터상에서는 삭제
                    _list.splice(_list.indexOf(item), 1);


                    //현재 트리 계층을 정렬
                    child.children.sort(function (a, b) {
                        return a.orgSort < b.orgSort ? -1 : a.orgSort > b.orgSort ? 1 : 0;
                    });
//                    child.children.sortByProp('orgSort');
                } else {

                    if (child.children.length) {
                        arguments.callee(child.children, item);
                    }
                }

            }
        }

        //트리 변환 여부 + 무한 루프 방지
        while (_treeLength != _listLength && _listLength != _loopLength++) {

            //전체 리스트를 탐색
            for (var i = 0, item; item = _list[i]; i++) {
                //최상위 객체면,
                if(item.depth == 0){
                //if (String(item.orgId) == String(OrganizationModel.getRootOrgId()) ) {

                    var view = {
                        id: String(item.orgId),
                        title: String(item.orgName),
                        isFolder: true,
                        children: []
                    };

                    //현재 요소를 추가하고,
                    _treeModel.push(view);

                    //트리 크기를 반영하고,
                    _treeLength++;

                    //데이터상에서는 삭제
                    _list.splice(i, 1);
                    //현재 트리 계층을 정렬

                    _treeModel.sort(function (a, b) {
                        return a.orgSort < b.orgSort ? -1 : a.orgSort > b.orgSort ? 1 : 0;
                    });
//                    _treeModel.sortByProp('orgSort');
                    break;
                }else if(item.depth == 1){
                    item.upOrgId = '0';
                    getParentNode(_treeModel, item);
                }

                //하위 객체면,
                else {
                    //
                    getParentNode(_treeModel, item);
                }
            }
        }

//        console.debug("_listLength : " + _listLength);
//        console.debug("_treeLength : " + _treeLength);
//        console.debug("_loopLength : " + _loopLength);

        return _treeModel;
    }

    return OrganizationModel;
}


Array.prototype.sortByProp = function(p){
    return this.sort(function(a,b){
        return (a[p] > b[p]) ? 1 : (a[p] < b[p]) ? -1 : 0;
    });
}