package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.InoutConfigurationBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.InoutConfigurationDao;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.EventLogSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.util.CommonUtil;
import com.meous.common.util.POIExcelUtil;
import com.meous.common.util.StringUtils;
import com.mongodb.BasicDBObject;
import com.mongodb.Block;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.mongodb.client.model.Filters.*;

/**
 * Created by icent on 16. 6. 13..
 */
@Service
public class EventLogSvcImpl implements EventLogSvc {

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private InoutConfigurationDao inoutConfigurationDao;

    @Inject
    private MongoDatabase mongoDatabase;

    @Override
    public ModelAndView findListEventLog(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            BasicDBObject query = new BasicDBObject();
            if(StringUtils.notNullCheck(parameters.get("areaId"))){
                query.put("areaId", parameters.get("areaId"));
            }
            if(StringUtils.notNullCheck(parameters.get("deviceCode"))){
                List<String> deviceList = deviceDao.findListDeviceForEventLog(parameters);
                if(deviceList!=null){
                    query.put("deviceId", new BasicDBObject("$in",deviceList));
                }
            }

            BasicDBObject eventDatetimeWhere = new BasicDBObject();
            boolean eventDatetimeFlag = false;
            if(StringUtils.notNullCheck(parameters.get("startDatetimeStr")) && StringUtils.notNullCheck(parameters.get("startDatetimeHour"))){
                eventDatetimeWhere.put("$gte",sdf.parse(parameters.get("startDatetimeStr") + " " + parameters.get("startDatetimeHour") + ":00:00"));
                eventDatetimeFlag = true;
            }
            if(StringUtils.notNullCheck(parameters.get("endDatetimeStr")) && StringUtils.notNullCheck(parameters.get("endDatetimeHour"))){
                eventDatetimeWhere.put("$lte",sdf.parse(parameters.get("endDatetimeStr") + " " + parameters.get("endDatetimeHour") + ":59:59"));
                eventDatetimeFlag = true;
            }
            if(eventDatetimeFlag){
                query.put("eventDatetime", eventDatetimeWhere);
            }

            FindIterable<Document> resultList = collection.find(query)
                    .sort(Sorts.descending("eventDatetime"))
                    .skip(Integer.parseInt(parameters.get("pageIndex")))
                    .limit(Integer.parseInt(parameters.get("pageRowNumber")));
            Long totalCount = collection.count(query);

            AdminHelper.setPageTotalCount(parameters, totalCount);

            modelAndView.addObject("eventLogs", resultList.into(new ArrayList<>()));
            modelAndView.addObject("paramBean",parameters);
        } catch (Exception e) {
            throw new IsaverException("");
        }
        return modelAndView;
    }

    @Override
    public ModelAndView findByEventLog(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");
            Document eventLog = collection.find(
                    eq("eventLogId", parameters.get("eventLogId"))
            ).sort(Sorts.descending("eventDatetime")).first();
            modelAndView.addObject("eventLog", eventLog);
        } catch (Exception e) {
            throw new IsaverException("");
        }
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogChart(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        try {
            List<Date> chartDateList = AdminHelper.findListDateTimeForType(null,parameters.get("dateType"),1);
            MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");

            String format = "%Y-%m-%d %H:%M:%S";
            switch (parameters.get("dateType")){
                case "day":
                    format = "%Y-%m-%d %H:00:00";
                    break;
                case "week":
                case "month":
                    format = "%Y-%m-%d 00:00:00";
                    break;
                case "year":
                    format = "%Y-%m-01 00:00:00";
                    break;
            }

            AggregateIterable<Document> resultList = collection.aggregate(
                    Arrays.asList(
                            Aggregates.match(
                                    and(
                                            eq("areaId", parameters.get("areaId")),
                                            eq("deviceId", parameters.get("deviceId")),
                                            gte("eventDatetime", chartDateList.get(0)),
                                            lte("eventDatetime", chartDateList.get(chartDateList.size() - 1))
                                    )
                            ),
                            Aggregates.project(
                                    Document.parse("{ 'value' : 1 , 'eventDt' : { $dateToString : { format:'"+format+"',date : '$eventDatetime', timezone: 'Asia/Seoul' } } }")
                            ),
                            Aggregates.group("$eventDt", Accumulators.max("value", "$value"))
                    )
            );
            modelAndView.addObject("chartDateList", chartDateList);
            modelAndView.addObject("eventLogs", resultList.into(new ArrayList<>()));
        } catch (Exception e) {
            throw new IsaverException("");
        }
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogResourceChart(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            AggregateIterable<Document> resultList = collection.aggregate(
                    Arrays.asList(
                            Aggregates.match(
                                    and(
                                            eq("areaId", parameters.get("areaId")),
                                            eq("deviceId", parameters.get("deviceId")),
                                            eq("eventId", parameters.get("eventId")),
                                            gte("eventDatetime", sdf.parse(parameters.get("startDatetime"))),
                                            lte("eventDatetime", sdf.parse(parameters.get("endDatetime")))
                                    )
                            ),
                            Aggregates.sort(Sorts.ascending("eventDatetime"))
                    )
            );

            modelAndView.addObject("eventLogChartList", resultList.into(new ArrayList<>()));
        } catch (Exception e) {
            throw new IsaverException("");
        }
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogBlinkerForArea(Map<String, String> parameters) {
        List<HashMap> eventLogList = new LinkedList<>();

        if(StringUtils.notNullCheck(parameters.get("areaIds"))){
            Map inoutParam = new HashMap();
            inoutParam.put("userId", parameters.get("userId"));
            inoutParam.put("areaIds", parameters.get("areaIds").split(","));

            List<InoutConfigurationBean> inoutConfigList = inoutConfigurationDao.findListInoutConfigurationForArea(inoutParam);

            if(inoutConfigList!=null){
                try{
                    MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");

                    for(InoutConfigurationBean inoutConfig : inoutConfigList){
                        HashMap eventMap = new HashMap();
                        Document resultMap = collection.aggregate(
                                Arrays.asList(
                                        Aggregates.match(
                                                and(
                                                        eq("areaId", inoutConfig.getAreaId()),
                                                        gte("eventDatetime", inoutConfig.getStartDatetime()),
                                                        lte("eventDatetime", inoutConfig.getEndDatetime())
                                                )
                                        ),
                                        Aggregates.group("$areaId", Accumulators.sum("inCount", "$inCount"), Accumulators.sum("outCount", "$outCount"))
                                )
                        ).first();

                        if(resultMap!=null){
                            eventMap.put("inCount",resultMap.get("inCount"));
                            eventMap.put("outCount",resultMap.get("outCount"));
                        }
                        eventMap.put("areaId",inoutConfig.getAreaId());
                        eventMap.put("startDatetime",inoutConfig.getStartDatetime());
                        eventMap.put("endDatetime",inoutConfig.getEndDatetime());
                        eventLogList.add(eventMap);
                    }
                }catch(Exception e){
                    throw new IsaverException("");
                }
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLog", eventLogList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByEventLogToiletRoomForArea(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        try{
            MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");
            Document lastStatus = collection.find(
                    eq("areaId", parameters.get("areaId"))
            ).sort(Sorts.descending("eventDatetime")).first();

            if(lastStatus!=null){
                modelAndView.addObject("status", lastStatus.get("status"));
                Document normalDatetime = collection.find(
                        and(
                                eq("areaId", parameters.get("areaId")),
                                eq("status",AdminResource.TOILET_ROOM_STATUS[1])
                        )
                ).sort(Sorts.descending("eventDatetime")).first();
                if(normalDatetime!=null){
                    modelAndView.addObject("eventDatetime", normalDatetime.get("eventDatetime"));
                }
            }
        }catch(Exception e){
            throw new IsaverException("");
        }
        modelAndView.addObject("paramBean", parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            BasicDBObject query = new BasicDBObject();
            if(StringUtils.notNullCheck(parameters.get("areaId"))){
                query.put("areaId", parameters.get("areaId"));
            }
            if(StringUtils.notNullCheck(parameters.get("deviceCode"))){
                List<String> deviceList = deviceDao.findListDeviceForEventLog(parameters);
                if(deviceList!=null){
                    query.put("deviceId", new BasicDBObject("$in",deviceList));
                }
            }
            BasicDBObject eventDatetimeWhere = new BasicDBObject();
            boolean eventDatetimeFlag = false;
            if(StringUtils.notNullCheck(parameters.get("startDatetimeStr")) && StringUtils.notNullCheck(parameters.get("startDatetimeHour"))){
                eventDatetimeWhere.put("$gte",sdf.parse(parameters.get("startDatetimeStr") + " " + parameters.get("startDatetimeHour") + ":00:00"));
                eventDatetimeFlag = true;
            }
            if(StringUtils.notNullCheck(parameters.get("endDatetimeStr")) && StringUtils.notNullCheck(parameters.get("endDatetimeHour"))){
                eventDatetimeWhere.put("$lte",sdf.parse(parameters.get("endDatetimeStr") + " " + parameters.get("endDatetimeHour") + ":59:59"));
                eventDatetimeFlag = true;
            }
            if(eventDatetimeFlag){
                query.put("eventDatetime", eventDatetimeWhere);
            }

            FindIterable<Document> resultList = collection.find(query).sort(Sorts.descending("eventDatetime"));

            List<EventLogExcelBean> eventLogList = new ArrayList<>();
            resultList.forEach(new Block<Document>() {
                @Override
                public void apply(final Document doc) {
                    String locationZ = "";
                    if(doc.get("location")!=null){
                        locationZ = doc.get("location",Map.class).get("z").toString();
                    }
                    eventLogList.add(new EventLogExcelBean(
                        doc.getString("areaName"),
                        doc.getString("deviceName"),
                        doc.getString("eventName"),
                        locationZ,
                        sdf.format(doc.getDate("eventDatetime"))
                    ));
                }
            });

            String[] heads = new String[]{"Area Name","Device Name","Event Name","Location Z","Event Datetime"};
            String[] columns = new String[]{"areaName","deviceName","eventName","locationZ","eventDatetime"};
            POIExcelUtil.downloadExcel(modelAndView, "isaver_event_history_" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()), eventLogList, columns, heads, "EventHistory");
        } catch (Exception e) {
            throw new IsaverException("");
        }
        return modelAndView;
    }

    private class EventLogExcelBean {
        /* 구역 ID*/
        private String areaName;
        /* 장치 ID */
        private String deviceName;
        /* 이벤트 ID*/
        private String eventName;
        /* 이벤트 ID*/
        private String locationZ;
        /* 이벤트 발생 일시 */
        private String eventDatetime;

        EventLogExcelBean(String areaName, String deviceName, String eventName, String locationZ, String eventDatetime){
            this.areaName=areaName;
            this.deviceName=deviceName;
            this.eventName=eventName;
            this.locationZ=locationZ;
            this.eventDatetime=eventDatetime;
        }
    }
}
