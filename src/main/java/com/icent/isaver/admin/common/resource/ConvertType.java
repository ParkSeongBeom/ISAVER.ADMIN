package main.java.com.icent.isaver.admin.common.resource;

/**
 * Created by icent on 2017. 2. 1..
 */
public enum ConvertType {
    ENCODE(0),
    DECODE(1);

    private int value = -1;

    private ConvertType(int value) {
        this.value = value;
    }

    public int getValue() {
        return this.value;
    }
}
