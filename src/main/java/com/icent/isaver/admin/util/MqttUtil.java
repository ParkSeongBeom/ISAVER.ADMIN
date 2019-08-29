package com.icent.isaver.admin.util;

import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * The type Web socket svc.
 */
public class MqttUtil implements MqttCallbackExtended {
    private static Logger logger = LoggerFactory.getLogger(MqttUtil.class);

    private static MqttAsyncClient Client;
    private static MqttMessage message;
    private static MemoryPersistence persistence;
    private static MqttConnectOptions connOpts;

    public void connect(String broker, String clientId, String username, String password){
        try {
            persistence = new MemoryPersistence();
            Client = new MqttAsyncClient(broker, clientId, persistence);
            Client.setCallback(this);

            connOpts = new MqttConnectOptions();
            connOpts.setUserName(username);
            connOpts.setPassword(password.toCharArray());
            connOpts.setCleanSession(true);
            connOpts.setAutomaticReconnect(true);
            logger.info("[MQTT] Connecting to broker : {}",broker);
            Client.connect(connOpts);
            message = new MqttMessage();
        } catch(MqttException me) {
            logger.error("[MQTT] Connect Failure reason : {}, msg : {}, loc : {}, cause : {}, excep : {}",me.getReasonCode(),me.getMessage(),me.getLocalizedMessage(),me.getCause(),me);
        }
    }

    public void disconnect(){
        try {
            Client.disconnect();
            Client.close();
        } catch (MqttException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void publish(String topic, String msg, int qos){
        message.setQos(qos);
        message.setPayload(msg.getBytes());

        try {
            Client.publish(topic, message);
        } catch (MqttPersistenceException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (MqttException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void subscribe(String topic, int qos){
        try {
            Client.subscribe(topic,qos);
        } catch (MqttException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    @Override
    public void messageArrived(String topic, MqttMessage mqttMessage) throws Exception {
    }

    @Override
    public void connectionLost(Throwable cause) {
        logger.info("[MQTT] Lost Connection cause : {}", cause.getMessage());
    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken iMqttDeliveryToken) {
        try {
            logger.info("[MQTT] {} Message with {} delivered.", iMqttDeliveryToken.getTopics(), iMqttDeliveryToken.getMessage());
        } catch (MqttException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void connectComplete(boolean reconnect, String serverURI) {
        logger.info("[MQTT] Connected : {}",serverURI);
    }
}
