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
    private static String _broker;
    private Boolean isMqtt;

    public Boolean getIsMqtt() {
        return isMqtt;
    }

    public void setIsMqtt(Boolean isMqtt) {
        this.isMqtt = isMqtt;
    }

    public void connect(String broker, String clientId, String username, String password){
        try {
            persistence = new MemoryPersistence();
            _broker = broker;
            Client = new MqttAsyncClient(_broker, clientId, persistence);
            Client.setCallback(this);

            connOpts = new MqttConnectOptions();
            connOpts.setUserName(username);
            connOpts.setPassword(password.toCharArray());
            connOpts.setCleanSession(true);
            connOpts.setAutomaticReconnect(true);
            message = new MqttMessage();
            initServerConnectCheck();
        } catch(MqttException me) {
            logger.error("[MQTT] Connect Failure reason : {}, msg : {}, loc : {}, cause : {}, excep : {}",me.getReasonCode(),me.getMessage(),me.getLocalizedMessage(),me.getCause(),me);
        } catch(Exception e){
            logger.error("[MQTT] Connect Failure reason : {}",e.getMessage());
        }
    }

    /**
     * mqtt server connect check.
     *
     * @throws Exception the exception
     */
    public void initServerConnectCheck() throws Exception {
        Thread thread = new Thread() {
            public void run() {
                boolean initFlag = false;
                while (true) {
                    if(!Client.isConnected()){
                        try {
                            if (initFlag) {
                                logger.info("[MQTT] Connecting retry to broker : {}",_broker);
                                Client.reconnect();
                            }else{
                                logger.info("[MQTT] Connecting to broker : {}",_broker);
                                Client.connect(connOpts);
                            }
                        } catch (MqttException e) {
                            if(e.getReasonCode()!=32110){
                                logger.error(e.getMessage());
                            }
                        } catch (Exception e) {
                            logger.error(e.getMessage());
                        }
                        initFlag = true;
                    }

                    try {
                        Thread.sleep(5000);
                    } catch (InterruptedException e) {
                        logger.error(e.getMessage());
                    }
                }
            }
        };
        thread.setName("Mqtt HeartBeat Thread");
        thread.start();
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
