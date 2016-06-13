/**
 * [Model] 구역
 * @author dhj
 * @since 2014.06.08
 */
function AreaModel() {

    var AreaModel = new Object();

    AreaModel.model = {
        viewStatus: ''
        ,rootUrl: ''
        ,requestUrl: ''
        ,userId: ''
        ,areaId: ''
        ,parentAreaId: ''
        ,sortOrder: 0
        ,depth: 0
        ,areaName: ''
        ,areaDesc: ''
        ,formName: 'areaForm'
        ,treeArea: '#menuTreeArea'
        ,targetMenuId: ''
        ,rootOrgId: ''
        ,deviceId : ''
        ,serialNo : ''
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
        ,areaTreeList: []
    };

    /**
     * 현재 조직 깊이 정의
     * @param orgdepth
     */
    AreaModel.setDepth = function (depth) {
        this.model.depth = depth;
    };

    /**
     * 현재 조직 깊이 반환
     * @param orgdepth
     */
    AreaModel.getDepth = function () {
        return this.model.depth;
    };

    AreaModel.setTreaArea = function (area) {
        this.model.treeArea = area;
    };

    AreaModel.getTreaArea = function () {
        return this.model.treeArea;
    };

    AreaModel.getMethodValue = function (method) {
        return this.model.METHOD[method];
    };

    AreaModel.getActionValue = function () {
        return this.model.ACTION[action];
    };
    /**
     * 루트 조직 ID를 정의
     * @param rootMenuId
     */
    AreaModel.setRootOrgId = function (rootOrgId) {
        this.model.rootOrgId = rootOrgId;
    };
    /**
     * 루트 조직 ID를 반환
     * @returns {string}
     */
    AreaModel.getRootOrgId = function () {
        return this.model.rootOrgId;
    };

    /**
     * 현재 View 상태를 정의
     * @param status
     * @returns {*}
     */
    AreaModel.setViewStatus = function (status) {
        this.model.viewStatus = status;
    };
    /**
     * 현재 View 상태의 상태를 반환
     * @returns {string}
     */
    AreaModel.getViewStatus = function () {
        return this.model.viewStatus;
    };
    /**
     * 요청 루트 도메인을 정의
     * @param url
     * @returns {string|*}
     */
    AreaModel.setRootUrl = function (url) {
        this.model.rootUrl = url;

    };

    /**
     * 요청 루트 도메인을 반환
     * @param url
     * @returns {string|*}
     */
    AreaModel.getRootUrl = function () {
        return this.model.rootUrl;

    };

    /**
     * 현재 API 주소를 정의
     * @param requestUrl
     */
    AreaModel.setRequestUrl = function (requestUrl) {
        this.model.requestUrl = requestUrl;
    };

    /**
     * 현재 API 주소를 반환
     * @returns {string}
     */
    AreaModel.getRequestUrl = function () {
        return this.model.requestUrl;
    };

    /**
     * 현재 setParentAreaId 정의
     * @param upOrgId
     * @returns {string|*}
     */
    AreaModel.setParentAreaId = function (parentAreaId) {
        this.model.parentAreaId = parentAreaId;
    };

    /**
     * 현재 getParentAreaId 반환
     * @returns {string}
     */
    AreaModel.getParentAreaId = function () {
        return this.model.parentAreaId;
    };

    /**
     * 현재 AreaId 정의
     * @param orgSeq
     * @returns {string|*}
     */
    AreaModel.setAreaId = function (areaId) {
        this.model.areaId = areaId;
    };

    /**
     * 현재 getAreaId 반환
     * @returns {string}
     */
    AreaModel.getAreaId = function () {
        return this.model.areaId;
    };

    /**
     * 현재 AreaDesc 정의
     * @param orgSeq
     * @returns {string|*}
     */
    AreaModel.setAreaDesc = function (areaDesc) {
        this.model.areaDesc = areaDesc;
    };

    /**
     * 현재 getAreaDesc 반환
     * @returns {string}
     */
    AreaModel.getAreaDesc = function () {
        return this.model.areaDesc;
    };

    /**
     * 현재 sortOrder 정의
     * @param orgSeq
     * @returns {string|*}
     */
    AreaModel.setSortOrder = function (sortOrder) {
        this.model.sortOrder = sortOrder;
    };

    /**
     * 현재 getSortOrder 반환
     * @returns {string}
     */
    AreaModel.getSortOrder = function () {
        return this.model.sortOrder;
    };

    /**
     * 현재 deviceId 정의
     * @param orgSeq
     * @returns {string|*}
     */
    AreaModel.setDeviceId = function (deviceId) {
        this.model.deviceId = deviceId;
    };

    /**
     * 현재 deviceId 반환
     * @returns {string}
     */
    AreaModel.getDeviceId = function () {
        return this.model.deviceId;
    };

    /**
     * 현재 serialNo 정의
     * @param orgSeq
     * @returns {string|*}
     */
    AreaModel.setSerialNo = function (serialNo) {
        this.model.serialNo = serialNo;
    };

    /**
     * 현재 serialNo 반환
     * @returns {string}
     */
    AreaModel.getSerialNo = function () {
        return this.model.serialNo;
    };
    /**
     * 현재 HTML formTag명을 정의
     * @returns {string}
     */
    AreaModel.setFormName = function (formName) {
        this.model.formName = formName;
    };
    /**
     * 현재 HTML formTag명을 반환
     * @returns {string}
     */
    AreaModel.getFormName = function () {
        return this.model.formName;
    };

    /**
     * 현재 사용중인 구역 명을 정의
     * @param menuName
     */
    AreaModel.setAreaName = function (areaName) {
        this.model.orgName = areaName;
    };

    /**
     * 현재 사용중인 구역 명을 반환
     * @returns {string}
     */
    AreaModel.getAreaName = function () {
        return this.model.orgName;
    };

    /**
     * 전체 구역 목록을 정의
     * @param menuName
     */
    AreaModel.setAreaTreeList = function (areaTreeList) {
        this.model.areaTreeList = areaTreeList;
    };

    /**
     * 구역 목록을 반환
     * @returns {string}
     */
    AreaModel.getAreaTreeList = function () {
        return this.model.areaTreeList;
    };

    AreaModel.setTargetMenuId = function(targetMenuId) {
        this.model.targetMenuId = targetMenuId;
    };

    AreaModel.getTargetMenuId = function() {
        return this.model.targetMenuId;
    };

    AreaModel.setUserName = function(userName) {
        this.model.userName = userName;
    };

    AreaModel.getUserName = function() {
        return this.model.userName;
    };

    AreaModel.setPageIndex = function(pageIndex) {
        this.model.pageIndex = pageIndex;
    };

    AreaModel.getPageIndex = function() {
        return this.model.pageIndex;
    };

    AreaModel.setPageRowNumber = function(pageRowNumber) {
        this.model.pageRowNumber = pageRowNumber;
    };

    AreaModel.getPageRowNumber = function() {
        return this.model.pageRowNumber;
    };

    AreaModel.setPageCount = function(pageCount) {
        this.model.pageCount = pageCount;
    };

    AreaModel.getPageCount = function() {
        return this.model.pageCount;
    };

    AreaModel.setRootName = function(rootName) {
        this.model.pageCount = pageCount;
    };

    AreaModel.getRootName = function() {
        return this.model.rootName;
    };

    AreaModel.setUserId = function(userId) {
        this.model.userId = userId;
    };

    AreaModel.getUserId = function() {
        return this.model.userId;
    };

    /**
     * 전체 구역 목록을 정의
     * @param menuName
     */
    AreaModel.getAreaDetail = function (areaId) {

        var resultData = null;

        for (var i =0; i < this.model.areaTreeList.length; i++) {
            var area = this.model.areaTreeList[i];

            if (area['areaId'] == areaId) {
                resultData = area;
                break;
            }

        }

        return resultData;
    };

    /**
     * 구역 페이지에서 사용 중인 Request URL 반환
     * @param url
     * @returns {*}
     * @date 2016.06.07
     * @see dhj
     */
    AreaModel.getRequestUrl = function () {
        var rootUrl = AreaModel.getRootUrl();
        var viewStatus = AreaModel.getViewStatus();
        return {
            'add'     : rootUrl + "/area/add.json",
            'save'    : rootUrl + "/area/save.json",
            'remove'  : rootUrl + "/area/remove.json",
            'detail'  : rootUrl + "/area/detail.json",
            'menuTree': rootUrl + "/area/treeList.json",
            'addOrgUser': rootUrl + "/area/detailUserPopup.html",
            'orgUserRemove': rootUrl + "/area/remove.json"
        }[viewStatus];
    };

    /**
     * 구역 트리 가공
     * @author dhj
     */
    AreaModel.processMenuTreeData = function (_list, _rootId) {
        var obj = {};

        obj.orgCode = null;
        obj.depth = 0;
        obj.areaName = AreaModel.getRootName();
        obj.areaId = AreaModel.getRootOrgId();
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
                if (String(child.id) === String(item.parentAreaId) || item.parentAreaId == null) {

                    var view =
                    {
                        id        : String(item.areaId),
                        title     : "<span style='font-weight: bold;'>"+String(item['areaName'] + "</span> (" + item['areaId'] +")"),
                        isFolder  : false,
                        orgSort   : Number(item.sortOrder),
                        children  : []
                    };

                    //현재 요소를 추가하고
                    if(String(item['delYn']) =='N') {
                        child.children.push(view);
                    }

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

                    var view = {
                        id: String(item.areaId),
                        title: String(item['areaName']),
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
                    item.parentId = AreaModel.getRootOrgId();
                    getParentNode(_treeModel, item);
                } else {
                    //하위 객체면,
                    getParentNode(_treeModel, item);
                }
            }
        }

//        console.debug("_listLength : " + _listLength);
//        console.debug("_treeLength : " + _treeLength);
//        console.debug("_loopLength : " + _loopLength);

        return _treeModel;
    }

    return AreaModel;
}


Array.prototype.sortByProp = function(p){
    return this.sort(function(a,b){
        return (a[p] > b[p]) ? 1 : (a[p] < b[p]) ? -1 : 0;
    });
}