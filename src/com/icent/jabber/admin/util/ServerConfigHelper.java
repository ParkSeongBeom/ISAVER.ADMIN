package com.icent.jabber.admin.util;

import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.repository.bean.ServerBean;
import com.icent.jabber.repository.dao.base.ServerDao;
import com.kst.common.util.StringUtils;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;

/**
 * 서버설정정보를 가져오는 biz helper
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 10. 7.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 7.     kst           최초 생성
 * </pre>
 */
public class ServerConfigHelper {

    @Inject
    public ServerDao serverDao;

    public ServerBean findByServer(String name){
        if(StringUtils.nullCheck(name) || StringUtils.nullCheck(AdminResource.SERVER_TYPE.get(name))){
            return null;
        }

        final String type = AdminResource.SERVER_TYPE.get(name);

        if(AdminResource.SERVER_CONFIG.get(type) == null){
            List<ServerBean> servers = serverDao.findListServer(new HashMap<String, String>(){{put("type",type);}});
            AdminResource.SERVER_CONFIG.put(type,servers);
        }

        int length = AdminResource.SERVER_CONFIG.get(type).size();
        int index = Double.valueOf(Math.random() * length).intValue();
        index = index == length ? 0 : index;

        ServerBean server = AdminResource.SERVER_CONFIG.get(type).get(index);

        return server;
    }

    public ServerBean findByServerForReset(String name){
        if(StringUtils.nullCheck(name) || StringUtils.nullCheck(AdminResource.SERVER_TYPE.get(name))){
            return null;
        }

        final String type = AdminResource.SERVER_TYPE.get(name);

        List<ServerBean> servers = serverDao.findListServer(new HashMap<String, String>(){{put("type",type);}});
        AdminResource.SERVER_CONFIG.put(type,servers);

        int length = AdminResource.SERVER_CONFIG.get(type).size();
        int index = Double.valueOf(Math.random() * length).intValue();
        index = index == length ? 0 : index;

        ServerBean server = AdminResource.SERVER_CONFIG.get(type).get(index);

        return server;
    }

    public List<ServerBean> findListServer(String name){
        if(StringUtils.nullCheck(name) || StringUtils.nullCheck(AdminResource.SERVER_TYPE.get(name))){
            return null;
        }

        final String type = AdminResource.SERVER_TYPE.get(name);

        if(AdminResource.SERVER_CONFIG.get(type) == null){
            List<ServerBean> servers = serverDao.findListServer(new HashMap<String, String>(){{put("type",type);}});
            AdminResource.SERVER_CONFIG.put(type,servers);
        }

        return AdminResource.SERVER_CONFIG.get(type);
    }
}
