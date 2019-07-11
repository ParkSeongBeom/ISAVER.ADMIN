package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.TemplateSettingBean;

import java.util.List;
import java.util.Map;

/**
 * [DAO] Dashboard Template 환경설정
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 12.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 12.     psb           최초 생성
 * </pre>
 */
public interface TemplateSettingDao {

    /**
     *
     * @return
     */
    List<TemplateSettingBean> findListTemplateSetting();

    /**
     *
     * @return
     */
    List<TemplateSettingBean> findListTemplateSettingCanvasSize();

    /**
     *
     * @return
     */
    void upsertTemplateSetting(List<Map<String, String>> parameterList);
}