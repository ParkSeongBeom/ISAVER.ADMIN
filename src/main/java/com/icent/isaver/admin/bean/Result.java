package main.java.com.icent.isaver.admin.bean;


import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@JsonSerialize(typing = JsonSerialize.Typing.DYNAMIC, include = JsonSerialize.Inclusion.NON_DEFAULT)
//@JsonPropertyOrder(value = {"state", "message", "data"})
@XmlRootElement(name = "result")
@XmlType(propOrder = {"state", "message", "data"})
public class Result<T> {

    // 상태코드
    private String state = null;

    // 에러 메시지
    private String message = null;

    // 결과 데이터
    private T data = null;

    public Result() {
    }

    public Result(T data) {
        this.data = data;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
