package main.java.com.icent.isaver.admin.common.util;

import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

/**
 * Created by icent on 2017. 2. 1..
 */
public class TransactionUtil {
    public TransactionUtil() {
    }

    public static TransactionStatus getMybatisTransactionStatus(DataSourceTransactionManager transactionManager) {
        return transactionManager.getTransaction(new DefaultTransactionDefinition());
    }

    public static TransactionStatus getMybatisTransactionStatus(DataSourceTransactionManager transactionManager, int transactionDefinition, int isolationLevel) {
        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        def.setIsolationLevel(isolationLevel);
        def.setPropagationBehavior(transactionDefinition);
        return transactionManager.getTransaction(def);
    }
}
