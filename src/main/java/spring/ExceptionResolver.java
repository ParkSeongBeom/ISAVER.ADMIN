package main.java.spring;


import com.icent.isaver.admin.bean.Result;
import com.icent.isaver.admin.common.resource.CommonResource;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.resource.ResultState;
import com.icent.isaver.admin.util.CommonUtil;
import com.kst.common.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ExceptionResolver implements HandlerExceptionResolver {

    private Logger logger = LoggerFactory.getLogger("info");

    private MessageSource messageSource = null;

    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object object, Exception exception) {
        ModelAndView modelAndView = new ModelAndView();
        Result<String> result = new Result<>();
        String errorMessage = null;

        try {
            if (exception != null && exception instanceof IsaverException) {
                IsaverException iException = (IsaverException) exception;

                if(StringUtils.nullCheck(iException.getCode())){
                    result.setState(ResultState.ERROR_UNKNOWN);
                    result.setMessage(messageSource.getMessage(ResultState.ERROR_UNKNOWN, null, request.getLocale()));
                }else{
                    result.setState(iException.getCode());
                    errorMessage = messageSource.getMessage(result.getState(), null, request.getLocale());
                    result.setMessage(errorMessage);
                }

                if (iException.getMessage() != null) {
                    result.setData(iException.getMessage());
                }else{
                    if (exception.getStackTrace() != null) {
                        result.setData(getExceptionStackTraceToString(exception.getStackTrace()));
                    }
                }
            } else if (exception != null && exception instanceof HttpRequestMethodNotSupportedException) { // http exception
                result.setState(ResultState.ERROR_WRONG_ACCESS);
                errorMessage = messageSource.getMessage(ResultState.ERROR_WRONG_ACCESS, null, request.getLocale());
                result.setMessage(errorMessage);
                result.setData(exception.getMessage());
            } else { // etc exception
                result.setState(ResultState.ERROR_UNKNOWN);
                result.setMessage(messageSource.getMessage(ResultState.ERROR_UNKNOWN, null, request.getLocale()));
                if (exception.getStackTrace() != null) {
                    errorMessage = getExceptionStackTraceToString(exception.getStackTrace());
                    result.setData(errorMessage);
                }
            }

            logger.error("EXCEPTION [Code : {}] [Message : {}], [Detail : {}]"
                    , result.getState()
                    , result.getMessage()
                    , result.getData() == null ? CommonResource.EMPTY_STRING : result.getData());
        } catch (Exception e) {
            logger.error("EXCEPTION [Message : {}]", e.getMessage());
        }

        modelAndView.addObject(AdminResource.RESULT_NODE_NAME, result);
        if(CommonUtil.getViewFromRequest(request).toLowerCase().equals(AdminResource.HTML_VIEW)){
            modelAndView.setViewName("login");
        }else{
            return null;
        }
        return modelAndView;
    }

    private String getExceptionStackTraceToString(StackTraceElement[] stackTraceElements) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < stackTraceElements.length; i++) {
            stringBuilder.append(stackTraceElements[i].toString());
            stringBuilder.append("\n");
        }
        return stringBuilder.toString();
    }
}
