package main.java.com.icent.isaver.admin.bean;

public class License {
    // 상태코드
    private int status;

    // 에러 메시지
    private String message = null;

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
