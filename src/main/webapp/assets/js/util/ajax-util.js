/**
 * 비동기 요청 처리</br>
 * - 반복되는 코드를 줄이기 위함.</br>
 * - 기본적인 구성만 해 놓음.
 *
 * @author kst
 * @since 2013. 11. 01
 */
var requestArr = [];

function checkExcuteArray(reqUrl,method,data,actionType){
    var resultFlag = false;

    for(var index in requestArr){
        var req = requestArr[index];
        if(req['url']==reqUrl && req['method']==method && req['data']==data && req['actionType']==actionType){
            resultFlag = true;
        }
    }
    return resultFlag;
}

function addExcuteArray(reqUrl,method,data,actionType){
    requestArr.push({
        'url' : reqUrl
        ,'method' : method
        ,'data' : data
        ,'actionType' : actionType
    });
}

function removeExcuteArray(reqUrl,method,data,actionType){
    var removeIndex = null;

    for(var index in requestArr){
        var req = requestArr[index];
        if(req['url']==reqUrl && req['method']==method && req['data']==data && req['actionType']==actionType){
            removeIndex = index;
        }
    }
    if(removeIndex!=null){
        requestArr.splice(removeIndex,1)
    }
}

/**
 * 비동기 POST 요청
 *
 * @author kst
 * @param reqUrl
 * @param data
 * @param successCallback
 * @param errorCallback
 * @param actionType
 */
function sendAjaxPostRequest(reqUrl,data,successCallback,errorCallback,actionType){
    ajaxRequest(reqUrl,'POST',data,successCallback,errorCallback,actionType);
}

/**
 * 비동기 GET 요청
 *
 * @author kst
 * @param reqUrl
 * @param data
 * @param successCallback
 * @param errorCallback
 * @param actionType
 */
function sendAjaxGetRequest(reqUrl,data,successCallback,errorCallback,actionType){
    ajaxRequest(reqUrl,'GET',data,successCallback,errorCallback,actionType);
}

/**
 * 비동기 요청 Biz
 *
 * @author kst
 * @param reqUrl
 * @param method
 * @param data
 * @param successCallback
 * @param errorCallback
 * @param actionType
 */
function ajaxRequest(reqUrl,method,data,successCallback,errorCallback,actionType){
    if(reqUrl == null){
        return;
    }

    if(checkExcuteArray(reqUrl,method,data,actionType)){
        console.error("[ajaxRequest] exist excute url - " + reqUrl + ", method - " + method +", data - "+data);
        alert(commonMessageConfig['inProgress']);
        return false;
    }else{
        addExcuteArray(reqUrl,method,data,actionType);
    }

    if(successCallback == null || typeof successCallback != 'function'){
        successCallback = ajaxDefaultSucCallback;
    }

    if(errorCallback == null || typeof errorCallback != 'function'){
        errorCallback = ajaxDefaultErrCallback;
    }

    $.ajax({
        type: method,
        url: reqUrl,
        dataType: 'json',
        accept : "application/json; charset=UTF-8;",
        contentsType: 'application/json',
        data: data,
        success : function(resultData, dataType){
            removeExcuteArray(reqUrl,method,data,actionType);
            successCallback(resultData, dataType, actionType);
        },
        error : function(XMLHttpRequest, textStatus, errorThrown){
            removeExcuteArray(reqUrl,method,data,actionType);
            errorCallback(XMLHttpRequest, textStatus, errorThrown, actionType);
        }
    });
}

/**
 * 비동기 파일전송 요청
 *
 * @author kst
 * @param reqUrl
 * @param form
 * @param successCallback
 * @param errorCallback
 * @param actionType
 */
function sendAjaxFileRequest(reqUrl,form,successCallback,errorCallback,actionType){

    if(successCallback == null || typeof successCallback != 'function'){
        successCallback = ajaxDefaultSucCallback;
    }

    if(errorCallback == null || typeof errorCallback != 'function'){
        errorCallback = ajaxDefaultErrCallback;
    }
    if(typeof FormData == 'undefined'){ // ie
        form.attr('enctype','multipart/form-data');
        form.attr('action',reqUrl);
        form.iframePostForm(
            {
                json : true
                ,complete : function(response){
                    if(!response.success){
                        errorCallback(null, 'iframePostForm failure', null, actionType);
                    }else{
                        successCallback({},'json',actionType);
                    }
                }
            }
        );
    }else{ // etc
        //var formData = new FormData(form);
        var formData = new FormData();
        form.find('input:text').each(function(){
            formData.append($(this).attr('name'),$(this).val());
        });

        form.find('input:password').each(function(){
            formData.append($(this).attr('name'),$(this).val());
        });

        form.find('select').each(function(){
            formData.append($(this).attr('name'),$(this).val());
        });

        form.find('input:hidden').each(function(){
            formData.append($(this).attr('name'),$(this).val());
        });

        form.find('input:radio').each(function(){
            if($(this).is(':checked')){
                formData.append($(this).attr('name'),$(this).val());
            }
        });

        form.find('textarea').each(function(){
            formData.append($(this).attr('name'),$(this).val());
        });

        form.find('input:file').each(function(){
            if($(this).val().length > 0){
                formData.append($(this).attr('name'),$(this)[0].files[0]);
            }
        });

        $.ajax({
            url: reqUrl,
            type: 'POST',
            data:  formData,
            mimeType:"multipart/form-data",
            contentType: false,
            cache: false,
            processData:false,
            success : function(data, dataType){
                successCallback(data, dataType, actionType);
            },
            error : function(XMLHttpRequest, textStatus, errorThrown){
                errorCallback(XMLHttpRequest, textStatus, errorThrown, actionType);
            }
        });
    }
}


function ajaxDefaultSucCallback(data, dataType, actionType){

}

function ajaxDefaultErrCallback(XMLHttpRequest, textStatus, errorThrown, actionType){
    alert("ajax request Error : " + textStatus);
}