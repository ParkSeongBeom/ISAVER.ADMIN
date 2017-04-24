package com.icent.isaver.admin.common.resource;

/**
 * Created by icent on 2017. 2. 1..
 */
public class IcentException extends  RuntimeException {

    private String code = null;

    private String message = null;

    public IcentException(String code) {
        //super(message);
        this.code = code;
    }

    public IcentException(String code, String message) {
        //super(message);
        this.code = code;
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Override
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

}
