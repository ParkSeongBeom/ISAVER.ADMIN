package main.java.com.icent.isaver.admin.util;

import com.icent.isaver.admin.bean.TargetBean;
import com.icent.isaver.admin.dao.TargetDao;

import javax.inject.Inject;

public class IsaverTargetUtil {
    /**
     * critical cache model (codeBean)
     * @author psb
     */
    private static TargetBean TARGET_MODEL;

    @Inject
    private TargetDao targetDao;

    public TargetBean getTarget() {
        if (TARGET_MODEL == null) {
            TARGET_MODEL = targetDao.findByTarget(null);
        }

        return TARGET_MODEL;
    }

    public void reset() {
        TARGET_MODEL = null;
    }
}
