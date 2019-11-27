package spring;

import com.icent.isaver.admin.common.PropertyManager;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;
import com.mongodb.client.MongoDatabase;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.inject.Inject;
import java.util.Collections;

@Configuration("MongoConfigurer")
public class MongoConfigurer {

    @Inject
    private PropertyManager propertyManager;

    @Bean
    public MongoDatabase mongoDatabase() throws Exception {
        MongoClient mongoClient = new MongoClient(
                new ServerAddress(propertyManager.getProperty("db.mongo.host"), Integer.parseInt(propertyManager.getProperty("db.mongo.port"))),
                Collections.singletonList(
                        MongoCredential.createCredential(
                                propertyManager.getProperty("db.mongo.username"),
                                propertyManager.getProperty("db.mongo.database"),
                                propertyManager.getProperty("db.mongo.password").toCharArray()
                        )
                ),
                new MongoClientOptions.Builder()
                        .connectionsPerHost(8)
                        .threadsAllowedToBlockForConnectionMultiplier(4)
                        .connectTimeout(3000)
                        .maxWaitTime(10000)
                        .socketTimeout(5000)
                        .socketKeepAlive(true)
                        .build()
        );
        return mongoClient.getDatabase(propertyManager.getProperty("db.mongo.database"));
    }

//    @Bean
//    public MongoTemplate mongoTemplate() throws Exception {
//        return new MongoTemplate(
//                new SimpleMongoDbFactory(
//                        new MongoClient(
//                                new ServerAddress(propertyManager.getProperty("db.mongo.host"), Integer.parseInt(propertyManager.getProperty("db.mongo.port"))),
//                                Collections.singletonList(
//                                        MongoCredential.createCredential(
//                                                propertyManager.getProperty("db.mongo.username"),
//                                                propertyManager.getProperty("db.mongo.database"),
//                                                propertyManager.getProperty("db.mongo.password").toCharArray()
//                                        )
//                                ),
//                                new MongoClientOptions.Builder()
//                                        .connectionsPerHost(8)
//                                        .threadsAllowedToBlockForConnectionMultiplier(4)
//                                        .connectTimeout(3000)
//                                        .maxWaitTime(10000)
//                                        .socketTimeout(5000)
//                                        .socketKeepAlive(true)
//                                        .build()
//                        ),
//                        propertyManager.getProperty("db.mongo.database")
//                )
//        );
//    }
}
