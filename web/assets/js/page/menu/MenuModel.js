/**
 * [Model] 메뉴 관리
 * @author dhj
 * @since 2014.05.20
 */
function MenuModel() {

    var MenuModel = new Object();

    MenuModel.model = {
        viewStatus: '',
        rootUrl: '',
        requestUrl: '',
        menuId: '',
        parentMenuId: '',
        menuName: '',
        useFlag: '',
        formName: 'menuForm',
        treeArea: '#menuTreeArea',
        targetMenuId: '',
        rootMenuId: 'MN000000-0000-0000-0000-000000000000',
        rootName: "HOME",
        METHOD: {
            ADD: 'add',
            SAVE: 'save',
            REMOVE: 'remove',
            DETAIL: 'detail'
        },
        ACTION: {
            ADD: 'add',
            SAVE: 'save',
            REMOVE: 'remove',
            DETAIL: 'detail'
        }
    };

    MenuModel.setMenuDepth = function (menuDepth) {
        this.model.menuDepth = menuDepth;
    };

    MenuModel.getMenuDepth = function () {
        return this.model.menuDepth;
    };

    MenuModel.setTreaArea = function (area) {
        this.model.treeArea = area;
    };

    MenuModel.getTreaArea = function () {
        return this.model.treeArea;
    };

    MenuModel.getMethodValue = function (method) {
        return this.model.METHOD[method];
    };

    MenuModel.getActionValue = function () {
        return this.model.ACTION[action];
    };
    /**
     * 루트 메뉴 ID를 정의
     * @param rootMenuId
     */
    MenuModel.setRootMenuId = function (rootMenuId) {
        this.model.menuName = rootMenuId;
    };
    /**
     * 루트 메뉴 ID를 반환
     * @returns {string}
     */
    MenuModel.getParentMenuId = function () {
        return this.model.parentMenuId;
    };
    /**
     * 부모 메뉴 ID를 정의
     * @param rootMenuId
     */
    MenuModel.setParentMenuId = function (parentMenuId) {
        this.model.parentMenuId = parentMenuId;
    };
    /**
     * 부모 메뉴 ID를 반환
     * @returns {string}
     */
    MenuModel.getRootMenuId = function () {
        return this.model.rootMenuId;
    };
    /**
     * 현재 View 상태를 정의
     * @param status
     * @returns {*}
     */
    MenuModel.setViewStatus = function (status) {
        this.model.viewStatus = status;
    };
    /**
     * 현재 View 상태의 상태를 반환
     * @returns {string}
     */
    MenuModel.getViewStatus = function () {
        return this.model.viewStatus;
    };
    /**
     * 요청 루트 도메인을 적용
     * @param url
     * @returns {string|*}
     */
    MenuModel.setRootUrl = function (url) {
        this.model.rootUrl = url;

    };
    /**
     * 요청 루트 도메인을 반환
     * @param url
     * @returns {string|*}
     */
    MenuModel.getRootUrl = function () {
        return this.model.rootUrl;

    };
    /**
     * 현재 루트 도메인을 반환
     * @returns {string}
     */
    MenuModel.getRequestUrl = function () {
        return this.model.requestUrl;
    };

    /**
     * 현재 menuId 적용
     * @param menuId
     * @returns {string|*}
     */
    MenuModel.setMenuId = function (menuId) {
        this.model.menuId = menuId;
    };
    /**
     * 현재 menuId를 반환
     * @returns {string}
     */
    MenuModel.getMenuId = function () {
        return this.model.menuId;
    };

    MenuModel.setUseFlag = function (useFlag) {
        this.model.useFlag = useFlag;
    };

    MenuModel.getUseFlag = function () {
        return this.model.useFlag;
    };

    /**
     * 현재 HTML formTag명을 정의
     * @returns {string}
     */
    MenuModel.setFormName = function (formName) {
        this.model.formName = formName;
    };
    /**
     * 현재 HTML formTag명을 반환
     * @returns {string}
     */
    MenuModel.getFormName = function () {
        return this.model.formName;
    };

    /**
     * 현재 사용중인 메뉴명을 정의
     * @param menuName
     */
    MenuModel.setMenuName = function (menuName) {
        this.model.menuName = menuName;
    };

    /**
     * 현재 사용중인 메뉴명을 반환
     * @returns {string}
     */
    MenuModel.getMenuName = function () {
        return this.model.menuName;
    };

    MenuModel.setTargetMenuId = function(targetMenuId) {
        this.model.targetMenuId = targetMenuId;
    };

    MenuModel.getTargetMenuId = function() {
        return this.model.targetMenuId;
    };

    /**
     * 메뉴 페이지에서 사용 중인 Request URL 반환
     * @param url
     * @returns {*}
     * @date 2014.05.22
     * @see dhj
     */
    MenuModel.getRequestUrl = function () {
        var rootUrl = MenuModel.getRootUrl();
        var viewStatus = MenuModel.getViewStatus();
        return {
            'add': rootUrl + "/menu/add.json",
            'save': rootUrl + "/menu/save.json",
            'remove': rootUrl + "/menu/remove.json",
            'detail': rootUrl + "/menu/detail.json",
            'menuTree': rootUrl + "/menu/treeList.json",
            'menuBar': rootUrl + "/menu/menuBarList.json"
        }[viewStatus];
    };

    /**
     * 메뉴 트리 가공
     */
    MenuModel.processMenuTreeData = function (_list, _rootId) {

        //최종적인 트리 데이터
        var _treeModel = [];

        //전체 데이터 길이
        var _listLength = _list.length;

        //트리 크기
        var _treeLength = 0;

        //반복 횟수
        var _loopLength = 0;

        if (!Array.indexOf) {
            Array.prototype.indexOf = function (obj, start) {
                for (var i = (start || 0); i < this.length; i++) {
                    if (this[i] == obj) {
                        return i;
                    }
                }
            }
        }

        //재귀 호출
        function getParentNode(_children, item) {

            //전체 리스트를 탐색
            for (var i = 0, child; child = _children[i]; i++) {
                //부모를 찾았으면,
                if (String(child.id) === String(item.parentMenuId)) {
                    var view =
                    {
                        id        : String(item.menuId),
                        title     : String(item.menuName) + " (" + String(item.menuType) + ")",
                        isFolder  : false,
                        sortOrder : Number(item.sortOrder),
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
                        return a.sortOrder < b.sortOrder ? -1 : a.sortOrder > b.sortOrder ? 1 : 0;
                    });

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
                if (item.menuId === _rootId) {

                    var view =
                    {
                        id:         String(item.menuId),
                        title:      String(item.menuName) + " (" + String(item.menuType) + ")",
                        isFolder:   true,
                        children:   []
                    };

                    //현재 요소를 추가하고,
                    _treeModel.push(view);

                    //트리 크기를 반영하고,
                    _treeLength++;

                    //데이터상에서는 삭제
                    _list.splice(i, 1);
                    //현재 트리 계층을 정렬
                    _treeModel.sort(function (a, b) {
                        return a.sortOrder < b.sortOrder ? -1 : a.sortOrder > b.sortOrder ? 1 : 0;
                    });

                    break;
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

    return MenuModel;
}