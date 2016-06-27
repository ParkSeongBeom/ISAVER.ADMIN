package dhj;

import org.junit.Test;

import java.text.DecimalFormat;

/**
 * Created by icent on 16. 6. 27..
 */
public class dhjTest01 {

    @Test
    public void genTest01() {
        StringBuilder sb = new StringBuilder();

        Integer totalCount = 100;
        String id = "AR";

        String suffix = String.format("%04d", totalCount);
        sb.append(id).append(suffix);
        System.out.println(sb.toString());

    }

}
