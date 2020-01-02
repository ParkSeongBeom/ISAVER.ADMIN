package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.DatabaseSvc;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 데이터베이스 Migration Controller
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
@Controller
@RequestMapping(value="/database/*")
public class DatabaseCtrl {

    @Inject
    private DatabaseSvc databaseSvc;

    /**
     * Postgresql Database Migration.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/pgsqlMigration")
    public ModelAndView postgresqlMigration(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = databaseSvc.postgresqlMigration(parameters);
        return modelAndView;
    }
}
