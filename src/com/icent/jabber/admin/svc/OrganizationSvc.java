package com.icent.jabber.admin.svc;

import com.icent.jabber.repository.bean.OrganizationBean;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

/**
 * 조직도 Service Interface
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 07.     dhj           최초 생성
 * </pre>
 */
public interface OrganizationSvc {

    /**
     * 조직도 전체 트리를 반환한다.
     * @param parameters
     * @return
     */
    public ModelAndView findAllOrganizationTree(Map<String, String> parameters);

    /**
     * 조직도 전체를 반환한다.
     * @return
     */
    public List<OrganizationBean> findAllOrganization();

    /**
     * 단건에 대한 조직도를 반환한다.
     * @param parameters
     * @return
     */
    public ModelAndView findByOrganization(Map<String, String> parameters);

    /**
     * 단건에 대한 조직도를 등록한다.
     * @param parameters
     * @return
     */
    public ModelAndView addOrganization(Map<String, String> parameters);

    /**
     * 단건에 대한 조직도를 저장한다.
     * @param parameters
     * @return
     */
    public ModelAndView saveOrganization(Map<String, String> parameters);

    /**
     * 단건에 대한 조직도를 제거한다.
     * @param parameters
     * @return
     */
    public ModelAndView removeOrganization(Map<String, String> parameters);

    /**
     * 전체 조직도 트리를 반환한다.
     * @param parameters
     * - 없음
     * @return
     */
    public List<OrganizationBean> orgTreeDataStructure(Map<String, String> parameters);

    /**
     * 조직도 전체 트리를 JSON Array String 타입으로 반환한다.
     * @param parameters
     * @return
     */
    public ModelAndView findAllOrganizationConvertJson(Map<String, String> parameters);

    /**
     * 조직도 전체 트리를 반환한다.
     * @param parameters
     * @return
     */
    public ModelAndView findListOrganizationTree(Map<String, String> parameters);
}
