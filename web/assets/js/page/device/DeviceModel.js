/**
 * [Model] 장치
 * @author dhj
 * @since 2014.06.08
 */
function DeviceModel() {

    var DeviceModel = new Object();

    DeviceModel.model = {
        viewStatus: ''
        ,rootUrl: ''
        ,requestUrl: ''
        ,userId: ''
        ,deviceId: ''
        ,parentDeviceId: ''
        ,sortOrder: 0
        ,depth: 0
        ,deviceName: ''
        ,deviceDesc: ''
        ,formName: 'deviceForm'
        ,treeDevice: '#menuTreeArea'
        ,targetMenuId: ''
        ,rootOrgId: ''
        ,deviceId : ''
        ,areaId : ''
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
        ,deviceTreeList: []
    };

    /**
     * 현재 조직 깊이 정의
     * @param orgdepth
     */
    DeviceModel.setDepth = function (depth) {
        this.model.depth = depth;
    };

    /**
     * 현재 조직 깊이 반환
     * @param orgdepth
     */
    DeviceModel.getDepth = function () {
        return this.model.depth;
    };

    DeviceModel.setTreaDevice = function (device) {
        this.model.treeDevice = device;
    };

    DeviceModel.getTreaDevice = function () {
        return this.model.treeDevice;
    };

    DeviceModel.getMethodValue = function (method) {
        return this.model.METHOD[method];
    };

    DeviceModel.getActionValue = function () {
        return this.model.ACTION[action];
    };
    /**
     * 루트 조직 ID를 정의
     * @param rootMenuId
     */
    DeviceModel.setRootOrgId = function (rootOrgId) {
        this.model.rootOrgId = rootOrgId;
    };
    /**
     * 루트 조직 ID를 반환
     * @returns {string}
     */
    DeviceModel.getRootOrgId = function () {
        return this.model.rootOrgId;
    };

    /**
     * 현재 View 상태를 정의
     * @param status
     * @returns {*}
     */
    DeviceModel.setViewStatus = function (status) {
        this.model.viewStatus = status;
    };
    /**
     * 현재 View 상태의 상태를 반환
     * @returns {string}
     */
    DeviceModel.getViewStatus = function () {
        return this.model.viewStatus;
    };
    /**
     * 요청 루트 도메인을 정의
     * @param url
     * @returns {string|*}
     */
    DeviceModel.setRootUrl = function (url) {
        this.model.rootUrl = url;

    };

    /**
     * 요청 루트 도메인을 반환
     * @param url
     * @returns {string|*}
     */
    DeviceModel.getRootUrl = function () {
        return this.model.rootUrl;

    };

    /**
     * 현재 API 주소를 정의
     * @param requestUrl
     */
    DeviceModel.setRequestUrl = function (requestUrl) {
        this.model.requestUrl = requestUrl;
    };

    /**
     * 현재 API 주소를 반환
     * @returns {string}
     */
    DeviceModel.getRequestUrl = function () {
        return this.model.requestUrl;
    };

    /**
     * 현재 setParentDeviceId 정의
     * @param upOrgId
     * @returns {string|*}
     */
    DeviceModel.setParentDeviceId = function (parentDeviceId) {
        this.model.parentDeviceId = parentDeviceId;
    };

    /**
     * 현재 getParentDeviceId 반환
     * @returns {string}
     */
    DeviceModel.getParentDeviceId = function () {
        return this.model.parentDeviceId;
    };

    /**
     * 현재 DeviceId 정의
     * @param orgSeq
     * @returns {string|*}
     */
    DeviceModel.setDeviceId = function (deviceId) {
        this.model.deviceId = deviceId;
    };

    /**
     * 현재 getDeviceId 반환
     * @returns {string}
     */
    DeviceModel.getDeviceId = function () {
        return this.model.deviceId;
    };

    /**
     * 현재 DeviceDesc 정의
     * @param orgSeq
     * @returns {string|*}
     */
    DeviceModel.setDeviceDesc = function (deviceDesc) {
        this.model.deviceDesc = deviceDesc;
    };

    /**
     * 현재 getDeviceDesc 반환
     * @returns {string}
     */
    DeviceModel.getDeviceDesc = function () {
        return this.model.deviceDesc;
    };

    /**
     * 현재 sortOrder 정의
     * @param orgSeq
     * @returns {string|*}
     */
    DeviceModel.setSortOrder = function (sortOrder) {
        this.model.sortOrder = sortOrder;
    };

    /**
     * 현재 getSortOrder 반환
     * @returns {string}
     */
    DeviceModel.getSortOrder = function () {
        return this.model.sortOrder;
    };

    /**
     * 현재 deviceId 정의
     * @param orgSeq
     * @returns {string|*}
     */
    DeviceModel.setDeviceId = function (deviceId) {
        this.model.deviceId = deviceId;
    };

    /**
     * 현재 deviceId 반환
     * @returns {string}
     */
    DeviceModel.getDeviceId = function () {
        return this.model.deviceId;
    };

    /**
     * 현재 areaId 정의
     * @param areaId
     * @returns {string|*}
     */
    DeviceModel.setAreaId = function (areaId) {
        this.model.areaId = areaId;
    };

    /**
     * 현재 areaId 반환
     * @returns {string}
     */
    DeviceModel.getAreaId = function () {
        return this.model.areaId;
    };

    /**
     * 현재 serialNo 정의
     * @param orgSeq
     * @returns {string|*}
     */
    DeviceModel.setSerialNo = function (serialNo) {
        this.model.serialNo = serialNo;
    };

    /**
     * 현재 serialNo 반환
     * @returns {string}
     */
    DeviceModel.getSerialNo = function () {
        return this.model.serialNo;
    };
    /**
     * 현재 HTML formTag명을 정의
     * @returns {string}
     */
    DeviceModel.setFormName = function (formName) {
        this.model.formName = formName;
    };
    /**
     * 현재 HTML formTag명을 반환
     * @returns {string}
     */
    DeviceModel.getFormName = function () {
        return this.model.formName;
    };

    /**
     * 현재 사용중인 장치 명을 정의
     * @param menuName
     */
    DeviceModel.setDeviceName = function (deviceName) {
        this.model.orgName = deviceName;
    };

    /**
     * 현재 사용중인 장치 명을 반환
     * @returns {string}
     */
    DeviceModel.getDeviceName = function () {
        return this.model.orgName;
    };

    /**
     * 전체 장치 목록을 정의
     * @param menuName
     */
    DeviceModel.setDeviceTreeList = function (deviceTreeList) {
        this.model.deviceTreeList = deviceTreeList;
    };

    /**
     * 장치 목록을 반환
     * @returns {string}
     */
    DeviceModel.getDeviceTreeList = function () {
        return this.model.deviceTreeList;
    };

    DeviceModel.setTargetMenuId = function(targetMenuId) {
        this.model.targetMenuId = targetMenuId;
    };

    DeviceModel.getTargetMenuId = function() {
        return this.model.targetMenuId;
    };

    DeviceModel.setUserName = function(userName) {
        this.model.userName = userName;
    };

    DeviceModel.getUserName = function() {
        return this.model.userName;
    };

    DeviceModel.setPageIndex = function(pageIndex) {
        this.model.pageIndex = pageIndex;
    };

    DeviceModel.getPageIndex = function() {
        return this.model.pageIndex;
    };

    DeviceModel.setPageRowNumber = function(pageRowNumber) {
        this.model.pageRowNumber = pageRowNumber;
    };

    DeviceModel.getPageRowNumber = function() {
        return this.model.pageRowNumber;
    };

    DeviceModel.setPageCount = function(pageCount) {
        this.model.pageCount = pageCount;
    };

    DeviceModel.getPageCount = function() {
        return this.model.pageCount;
    };

    DeviceModel.setRootName = function(rootName) {
        this.model.pageCount = pageCount;
    };

    DeviceModel.getRootName = function() {
        return this.model.rootName;
    };

    DeviceModel.setUserId = function(userId) {
        this.model.userId = userId;
    };

    DeviceModel.getUserId = function() {
        return this.model.userId;
    };

    /**
     * 전체 장치 목록을 정의
     * @param menuName
     */
    DeviceModel.getDeviceDetail = function (deviceId, serialNo, ipAddress) {

        var _deviceIdExistFlag = false;
        var _serialNoExistFlag = false;
        var _ipAddressExistFlag = false;

        if (this.model.deviceTreeList != null) {
            for (var i =0; i < this.model.deviceTreeList.length; i++) {
                var device = this.model.deviceTreeList[i];

                if (device['deviceId'] == deviceId) {
                    _deviceIdExistFlag = true;
                }

                if (device['serialNo'] == serialNo) {

                    if (device['deviceId'] != deviceId) {
                        _serialNoExistFlag = true;
                    }

                }

                if (ipAddress != undefined) {
                    if (ipAddress.trim().length > 0 ) {
                        if (device['ipAddress'] == ipAddress) {
                            if (device['deviceId'] != deviceId) {
                                _ipAddressExistFlag = true;
                            }
                        }
                    }
                }
            }
        }

        return {'deviceIdExistFlag' : _deviceIdExistFlag, 'serialNoExistFlag': _serialNoExistFlag, 'ipAddressExistFlag': _ipAddressExistFlag};
    };

    /**
     * 장치 페이지에서 사용 중인 Request URL 반환
     * @param url
     * @returns {*}
     * @date 2016.06.07
     * @see dhj
     */
    DeviceModel.getRequestUrl = function () {
        var rootUrl = DeviceModel.getRootUrl();
        var viewStatus = DeviceModel.getViewStatus();
        return {
            'add'     : rootUrl + "/device/add.json",
            'save'    : rootUrl + "/device/save.json",
            'remove'  : rootUrl + "/device/remove.json",
            'detail'  : rootUrl + "/device/detail.json",
            'menuTree': rootUrl + "/device/treeList.json",
            'addOrgUser': rootUrl + "/device/detailUserPopup.html",
            'orgUserRemove': rootUrl + "/device/remove.json"
        }[viewStatus];
    };

    /**
     * 장치 트리 가공
     * @author dhj
     */
    DeviceModel.processMenuTreeData = function (_list, _rootId) {
        var obj = {};

        obj.orgCode = null;
        obj.depth = 0;
        obj.deviceName = DeviceModel.getRootName();
        obj.deviceId = DeviceModel.getRootOrgId();
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
                if (String(child.id) === String(item.parentDeviceId) || item.parentDeviceId == null) {

                    var view =
                    {
                        id        : String(item.deviceId),
                        title     : "<span style='font-weight: bold;' device_id='"+item['deviceId']+"'>"+String(item['deviceCodeName'] + "</span> (" + item['deviceId'] +")"),
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
                    //if (String(item.orgId) == String(OrganizationModel.getRootOrgId()) ) {

                    var view = {
                        id: String(item.deviceId),
                        title: String(item.deviceName),
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

        //트리 변환 여부 + 무한 루프 방지
//        while (_treeLength != _listLength && _listLength != _loopLength++) {
//
//            //전체 리스트를 탐색
//            for (var i = 0, item; item = _list[i]; i++) {
//                //최상위 객체면,
//                if(item.depth == 0){
//
//                    var view = {
//                        id: String(item.deviceId),
//                        title     : String(item['deviceCodeName'] + " (" + item['deviceId'] +")"),
//                        isFolder: true,
//                        children: []
//                    };
//
//                    if(String(item['delYn']) =='N') {
//                        //현재 요소를 추가하고,
//                        _treeModel.push(view);
//                    }
//
//                    //트리 크기를 반영하고,
//                    _treeLength++;
//
//                    //데이터상에서는 삭제
//                    _list.splice(i, 1);
//                    //현재 트리 계층을 정렬
//
//                    _treeModel.sort(function (a, b) {
//                        return a.orgSort < b.orgSort ? -1 : a.orgSort > b.orgSort ? 1 : 0;
//                    });
////                    _treeModel.sortByProp('orgSort');
//                    break;
//                }else if(item.depth == 2){
//                    item.parentId = DeviceModel.getRootOrgId();
//                    getParentNode(_treeModel, item);
//                } else {
//                    //하위 객체면,
//                    getParentNode(_treeModel, item);
//                }
//            }
//        }

//        console.debug("_listLength : " + _listLength);
//        console.debug("_treeLength : " + _treeLength);
//        console.debug("_loopLength : " + _loopLength);

        return _treeModel;
    }

    return DeviceModel;
}