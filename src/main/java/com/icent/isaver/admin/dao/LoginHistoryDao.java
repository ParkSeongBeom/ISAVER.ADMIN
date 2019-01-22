package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.LoginHistoryBean;

import java.util.List;
import java.util.Map;

/**
 * 접속 로그 관리 Dao Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 06. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 06. 07.     psb           최초 생성
 * </pre>
 */
public interface LoginHistoryDao {
    /**
     * 접속 로그 목록을 가져온다.
     * @return the list
     */
    public List<LoginHistoryBean> findListLoginHistory(Map<String, String> parameters);

    /**
     * 접속 로그 목록 갯수를 가져온다.
     * @param parameters
     * @author dhj
     * @return
     */
    public Integer findCountLoginHistory(Map<String, String> parameters);

    /**
     * 로그를 등록한다.
     *
     * @author psb
     * @param loginHistoryBean
     */
    public void addLoginHistory(LoginHistoryBean loginHistoryBean);

    /**
     * 접속 로그 목록을 가져온다 - 엑셀다운로드용
     * @return the list
     */
    public List<LoginHistoryBean> findListLoginHistoryForExcel(Map<String, String> parameters);
}
