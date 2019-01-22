package com.icent.isaver.admin.util;

import com.icent.isaver.admin.bean.CodeBean;
import com.icent.isaver.admin.dao.CodeDao;
import com.kst.common.resource.CommonResource;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IsaverCriticalUtil {
    /**
     * critical cache model (codeBean)
     * @author psb
     */
    private static List<CodeBean> CRITICAL_MODEL;

    @Inject
    private CodeDao codeDao;

    public List<CodeBean> getCritical() {
        if (CRITICAL_MODEL == null) {
            Map<String, String> parameters = new HashMap<>();
            parameters.put("useYn", CommonResource.YES);
            parameters.put("groupCodeId","LEV");
            CRITICAL_MODEL = codeDao.findListCode(parameters);
        }

        return CRITICAL_MODEL;
    }

    public void reset() {
        CRITICAL_MODEL = null;
    }
}
