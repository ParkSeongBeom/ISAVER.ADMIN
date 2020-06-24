package com.icent.isaver.admin.svcImpl;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.*;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.StatisticsSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.meous.common.spring.TransactionUtil;
import com.meous.common.util.StringUtils;
import com.mongodb.BasicDBObject;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.BsonField;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 이벤트 통계 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 8. 4.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 8. 4.     psb           최초 생성
 *  2018. 2. 21.     psb           통계 메뉴 정리
 *  2018. 2. 23.     psb           통계 테이블 변경으로 인한 수정
 * </pre>
 */
@Service
public class StatisticsSvcImpl implements StatisticsSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private EventStatisticsDao eventStatisticsDao;

    @Inject
    private StatisticsDao statisticsDao;

    @Inject
    private FenceDao fenceDao;

    @Inject
    private AreaDao areaDao;

    @Inject
    private EventDao eventDao;

    @Inject
    private MongoDatabase mongoDatabase;

    @Override
    public ModelAndView findListStatistics(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        if(StringUtils.notNullCheck(parameters.get("mode")) && parameters.get("mode").equals(AdminResource.SEARCH_MODE)){
            modelAndView.addObject("statisticsList",statisticsDao.findListStatistics());
        }else{
            modelAndView.addObject("fenceList",fenceDao.findListFenceForAll());
            modelAndView.addObject("eventList",eventDao.findListEvent(null));
        }
        return modelAndView;
    }

    @Override
    public ModelAndView findListStatisticsSearch(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        Map<String, Map> resultList = new HashMap<>();

        try {
            JsonParser parser = new JsonParser();
            JsonObject jsonObj = (JsonObject) parser.parse(parameters.get("jsonData"));

            // x축
            JsonObject xAxis = jsonObj.get("xAxis").getAsJsonObject();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String dateType = xAxis.get("interval").getAsString();
            parameters.put("interval",dateType);
            Date startDatetime = sdf.parse(xAxis.get("startDatetime").getAsString());
            Date endDatetime = sdf.parse(xAxis.get("endDatetime").getAsString());
            BasicDBObject eventDatetimeWhere = new BasicDBObject();
            eventDatetimeWhere.put("$gte",startDatetime);
            eventDatetimeWhere.put("$lte",endDatetime);

            List<Date> chartDateList = AdminHelper.findListDateTimeForType(startDatetime, endDatetime, dateType);
            MongoCollection<Document> collection = mongoDatabase.getCollection(parameters.get("collectionName"));

            String format = "%Y-%m-%d %H:%M:%S";
            switch (dateType){
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

            // 사용자정의
            if(parameters.get("template").equals("custom")){
                // y축
                JsonArray yAxisArr = (JsonArray) jsonObj.get("yAxis");
                for(int i=0;i<yAxisArr.size();i++){
                    JsonObject yAxis = (JsonObject) yAxisArr.get(i);
                    // group by
                    String aggregation = yAxis.get("aggregation").getAsString();
                    String field = yAxis.get("field").getAsString();
                    String label = yAxis.get("label").getAsString();
                    String index = yAxis.get("index").getAsString();
                    BsonField bsonField = null;
                    switch (aggregation){
                        case "count" :
                            bsonField = Accumulators.sum("value", 1);
                            break;
                        case "avg" :
                            bsonField = Accumulators.avg("value", new BasicDBObject("$toDouble", "$" + field));
                            break;
                        case "sum" :
                            bsonField = Accumulators.sum("value", new BasicDBObject("$toDouble", "$" + field));
                            break;
                        case "min" :
                            bsonField = Accumulators.min("value", new BasicDBObject("$toDouble", "$" + field));
                            break;
                        case "max" :
                            bsonField = Accumulators.max("value", new BasicDBObject("$toDouble", "$" + field));
                            break;
                    }

                    // where
                    JsonArray conditionList = (JsonArray) yAxis.get("condition");
                    BasicDBObject match = new BasicDBObject();
                    for(int k=0;k<conditionList.size();k++){
                        JsonObject condition = (JsonObject) conditionList.get(k);
                        match.put(condition.get("key").getAsString(), new BasicDBObject(condition.get("type").getAsString(),condition.get("value").getAsString()));
                    }
                    match.put("eventDatetime", eventDatetimeWhere);
                    // query
                    AggregateIterable<Document> aggregate = collection.aggregate(
                            Arrays.asList(
                                    Aggregates.match(match),
                                    Aggregates.group(
                                            Document.parse("{ $dateToString : { format:'" + format + "',date : '$eventDatetime', timezone: 'Asia/Seoul' }}")
                                            , bsonField
                                    ),
                                    Aggregates.sort(Sorts.ascending("_id"))
                            )
                    ).allowDiskUse(true);

                    Map resultMap = new HashMap<>();
                    resultMap.put("label",label);
                    resultMap.put("dataList",aggregate.into(new ArrayList<>()));
                    resultMap.put("aggregation", aggregation);
                    resultList.put(index, resultMap);
                }
            }else{ // template
                BasicDBObject commonMatch = new BasicDBObject();
                JsonArray conditions = (JsonArray) jsonObj.get("condition");
                for(int k=0;k<conditions.size();k++){
                    JsonObject condition = (JsonObject) conditions.get(k);
                    if(condition.get("value").isJsonArray()){
                        commonMatch.put(condition.get("key").getAsString(), new BasicDBObject(condition.get("type").getAsString(),convertJsonArrayToList(condition.get("value").getAsJsonArray())));
                    }else{
                        commonMatch.put(condition.get("key").getAsString(), new BasicDBObject(condition.get("type").getAsString(),condition.get("value").getAsString()));
                    }
                }

                JsonArray customConditions = (JsonArray) jsonObj.get("customCondition");
                BasicDBObject customMatch = new BasicDBObject();
                for(int k=0;k<customConditions.size();k++){
                    JsonObject condition = (JsonObject) customConditions.get(k);
                    String key = condition.get("key").getAsString();
                    switch (condition.get("type").getAsString()){
                        case "include" :
                            BasicDBObject includeMatch = new BasicDBObject();
                            includeMatch.put("$gte",condition.get("start").getAsString());
                            includeMatch.put("$lte",condition.get("end").getAsString());
                            customMatch.put("$elemMatch",new BasicDBObject(key,includeMatch));
                            break;
                        case "exclude" :
                            BasicDBObject exceptMatch = new BasicDBObject();
                            exceptMatch.put("$gte",condition.get("start").getAsString());
                            exceptMatch.put("$lte",condition.get("end").getAsString());
                            customMatch.put("$not",new BasicDBObject("$elemMatch",new BasicDBObject(key,exceptMatch)));
                            break;
                    }
                }
                if(customMatch.size()>0){
                    commonMatch.put("location",customMatch);
                }
                commonMatch.put("eventDatetime", eventDatetimeWhere);

                JsonObject group = jsonObj.get("group").getAsJsonObject();
                String aggregation = group.get("aggregation").getAsString();
                String field = group.get("field").getAsString();
                List<Bson> groupList = new ArrayList<>();
                if(aggregation.equals("count")){
                    groupList.add(Aggregates.group(
                        Document.parse("{ $dateToString : { format:'" + format + "',date : '$eventDatetime', timezone: 'Asia/Seoul' }}")
                        , Accumulators.sum("value", 1)
                    ));
                }else{
                    groupList.add(Aggregates.unwind(field.split("\\.")[0]));
                    groupList.add(Aggregates.group(
                        Document.parse("{eventDt:'$eventDatetime',groupValue:{'$"+aggregation+"':{$toDouble:'"+field+"'}}}")
                    ));

                    BsonField groupBsonField = null;
                    switch (aggregation){
                        case "avg" :
                            groupBsonField = Accumulators.avg("aggValue", "$_id.groupValue");
                            break;
                        case "min" :
                            groupBsonField = Accumulators.min("aggValue", "$_id.groupValue");
                            break;
                        case "max" :
                            groupBsonField = Accumulators.max("aggValue", "$_id.groupValue");
                            break;
                    }
                    groupList.add(Aggregates.group(
                        Document.parse("{eventDatetime:'$_id.eventDt'}")
                        , groupBsonField
                    ));

                    JsonArray customLabels = group.get("customLabel").getAsJsonArray();
                    if(customLabels.size()>0){
                        groupList.add(Aggregates.group(
                            Document.parse("{\n" +
                                    "       $concat: [\n" +
                                    "          { $cond: [{$lt: ['$aggValue',10]}, '~10km/h', ''] },\n" +
                                    "          { $cond: [{$and:[ {$gt:['$aggValue',10]}, {$lt: ['$aggValue', 20]}]},'~20km/h', ''] },\n" +
                                    "          { $cond: [{$and:[ {$gt:['$aggValue',20]}, {$lt: ['$aggValue', 30]}]},'~30km/h', ''] },\n" +
                                    "          { $cond: [{$and:[ {$gt:['$aggValue',30]}, {$lt: ['$aggValue', 40]}]},'~40km/h', ''] },\n" +
                                    "          { $cond: [{$and:[ {$gt:['$aggValue',40]}, {$lt: ['$aggValue', 50]}]},'~50km/h', ''] },\n" +
                                    "          { $cond: [{$and:[ {$gt:['$aggValue',50]}, {$lt: ['$aggValue', 60]}]},'~60km/h', ''] },\n" +
                                    "          { $cond: [{$and:[ {$gt:['$aggValue',60]}, {$lt: ['$aggValue', 70]}]},'~70km/h', ''] },\n" +
                                    "          { $cond: [{$and:[ {$gt:['$aggValue',70]}, {$lt: ['$aggValue', 80]}]},'~80km/h', ''] },\n" +
                                    "          { $cond: [{$and:[ {$gt:['$aggValue',80]}, {$lt: ['$aggValue', 90]}]},'~90km/h', ''] },\n" +
                                    "          { $cond: [{$gt: [ '$aggValue',90]},'~100km/h', ''] }\n" +
                                    "       ]\n" +
                                    "    }")
                            , Accumulators.sum("value", 1)
                        ));
                        List<String> labelList = new LinkedList<>();
                        for(int i=0;i<customLabels.size();i++){
                            labelList.add(customLabels.get(i).getAsString());
                        }
                        modelAndView.addObject("labelList", labelList);
                    }else{
                        BsonField bsonField = null;
                        switch (aggregation){
                            case "avg" :
                                bsonField = Accumulators.avg("value", "$aggValue");
                                break;
                            case "min" :
                                bsonField = Accumulators.min("value", "$aggValue");
                                break;
                            case "max" :
                                bsonField = Accumulators.max("value", "$aggValue");
                                break;
                        }
                        groupList.add(Aggregates.group(
                            Document.parse("{ $dateToString : { format:'" + format + "',date : '$_id.eventDatetime', timezone: 'Asia/Seoul' }}")
                            , bsonField
                        ));
                    }
                }

                JsonArray rows = jsonObj.get("rows").getAsJsonArray();
                for(int i=0;i<rows.size();i++){
                    JsonObject row = (JsonObject) rows.get(i);
                    BasicDBObject match = (BasicDBObject) commonMatch.clone();
                    String fenceId = row.get("fenceId").getAsString();
                    match.put("fenceId", fenceId);

                    List<Bson> arrayList = new ArrayList<>();
                    arrayList.add(Aggregates.match(match));
                    for(Bson aggGroup : groupList){
                        arrayList.add(aggGroup);
                    }
                    arrayList.add(Aggregates.sort(Sorts.ascending("_id")));

                    // query
                    AggregateIterable<Document> aggregate = collection.aggregate(arrayList).allowDiskUse(true);
                    Map resultMap = new HashMap<>();
                    resultMap.put("fenceId",fenceId);
                    resultMap.put("areaName",row.get("areaName").getAsString());
                    resultMap.put("fenceName",row.get("fenceName").getAsString());
                    resultMap.put("dataList",aggregate.into(new ArrayList<>()));
                    resultMap.put("aggregation", aggregation);
                    resultList.put(String.valueOf(i), resultMap);
                }
            }
            modelAndView.addObject("dateList", chartDateList);
            modelAndView.addObject("chartList", resultList);
        } catch (Exception e) {
            throw new IsaverException("");
        }
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private List<String> convertJsonArrayToList(JsonArray jsonArray) {
        List<String> list = new ArrayList<String>();
        for (int i=0; i<jsonArray.size(); i++) {
            list.add( jsonArray.get(i).getAsString() );
        }
        return list;
    }

    @Override
    public ModelAndView addStatistics(Map<String, String> parameters) {
        parameters.put("statisticsId", StringUtils.getGUID32());
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            statisticsDao.addStatistics(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView saveStatistics(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            statisticsDao.saveStatistics(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView removeStatistics(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            statisticsDao.removeStatistics(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        return new ModelAndView();
    }
}
