package spring;

import com.icent.isaver.admin.common.PropertyManager;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;
import com.mongodb.client.MongoDatabase;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.inject.Inject;
import java.util.Collections;

@Configuration("MongoConfigurer")
public class MongoConfigurer {
    private static Logger logger = LoggerFactory.getLogger(MongoConfigurer.class);

    @Inject
    private PropertyManager propertyManager;

    @Bean
    public MongoDatabase mongoDatabase() throws Exception {
        MongoClient mongoClient = null;

        try{
            mongoClient = new MongoClient(
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
                            .socketTimeout(60000)
                            .socketKeepAlive(true)
                            .build()
            );
        }catch (Exception e){
            logger.error(e.getMessage());
        }
        return mongoClient != null ? mongoClient.getDatabase(propertyManager.getProperty("db.mongo.database")) : null;
    }
}
