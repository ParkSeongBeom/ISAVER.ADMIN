package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 데이터베이스 Service 관리
 * @author : psb
 * @version : 1.0
 * @since : 2019. 12. 27.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 12. 27.     psb           최초 생성
 * </pre>
 */
public interface DatabaseSvc {

    /**
     * Postgresql Database Migration.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView postgresqlMigration(Map<String, String> parameters);
}
