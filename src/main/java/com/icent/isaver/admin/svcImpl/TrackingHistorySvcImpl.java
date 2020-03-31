package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.TrackingHistorySvc;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

import static com.mongodb.client.model.Filters.eq;

/**
 * 이동경로 이력 Service Interface
 * @author : psb
 * @version : 1.0
 * @since : 2020. 3. 18.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2020. 3. 18.     psb           최초 생성
 * </pre>
 */
@Service
public class TrackingHistorySvcImpl implements TrackingHistorySvc {

    @Inject
    private MongoDatabase mongoDatabase;

    @Override
    public ModelAndView findByTrackingHistory(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            MongoCollection<Document> collection = mongoDatabase.getCollection("tracking");
            Document tracking = collection.find(
                    eq("notificationId", parameters.get("notificationId"))
            ).sort(Sorts.descending("eventDatetime")).first();
            modelAndView.addObject("tracking", tracking);
        } catch (Exception e) {
            throw new IsaverException("");
        }
        return modelAndView;
    }
}
