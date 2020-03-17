package com.icent.isaver.admin.util;

import com.meous.common.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.regex.Pattern;

public class XSSInterceptor extends HandlerInterceptorAdapter {
	private static Logger logger = LoggerFactory.getLogger(XSSInterceptor.class);

	public static final String SQL_TYPES =
			"TABLE, TABLESPACE, PROCEDURE, FUNCTION, TRIGGER, KEY, VIEW, MATERIALIZED VIEW, LIBRARY" +
					"DATABASE LINK, DBLINK, INDEX, CONSTRAINT, TRIGGER, USER, SCHEMA, DATABASE, PLUGGABLE DATABASE, BUCKET, " +
					"CLUSTER, COMMENT, SYNONYM, TYPE, JAVA, SESSION, ROLE, PACKAGE, PACKAGE BODY, OPERATOR" +
					"SEQUENCE, RESTORE POINT, PFILE, CLASS, CURSOR, OBJECT, RULE, USER, DATASET, DATASTORE, " +
					"COLUMN, FIELD, OPERATOR";

	private static final String[] sqlRegexps = {
			"(?i)(.*)(\\b)+SELECT(\\b)+\\s.*(\\b)+FROM(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+INSERT(\\b)+\\s.*(\\b)+INTO(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+UPDATE(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+DELETE(\\b)+\\s.*(\\b)+FROM(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+UPSERT(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+SAVEPOINT(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+CALL(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+ROLLBACK(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+KILL(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+DROP(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+CREATE(\\b)+(\\s)*(" + SQL_TYPES.replaceAll(",", "|") + ")(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+ALTER(\\b)+(\\s)*(" + SQL_TYPES.replaceAll(",", "|") + ")(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+TRUNCATE(\\b)+(\\s)*(" + SQL_TYPES.replaceAll(",", "|") + ")(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+LOCK(\\b)+(\\s)*(" + SQL_TYPES.replaceAll(",", "|") + ")(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+UNLOCK(\\b)+(\\s)*(" + SQL_TYPES.replaceAll(",", "|") + ")(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+RELEASE(\\b)+(\\s)*(" + SQL_TYPES.replaceAll(",", "|") + ")(\\b)+\\s.*(.*)",
			"(?i)(.*)(\\b)+DESC(\\b)+(\\w)*\\s.*(.*)",
			"(?i)(.*)(\\b)+DESCRIBE(\\b)+(\\w)*\\s.*(.*)",
			"(.*)(/\\*|\\*/|;){1,}(.*)",
			"(.*)(-){2,}(.*)",
	};

	// pre-build the Pattern objects for faster validation
	private List<Pattern> validationPatterns = getValidationPatterns();

	private String isSqlInjectionSafe(String dataString){
		if(StringUtils.notNullCheck(dataString)){
			for(Pattern pattern : validationPatterns){
				dataString = pattern.matcher(dataString).replaceAll("");
			}
		}
		return dataString;
	}

	private static List<Pattern> getValidationPatterns(){
		List<Pattern> patterns = new ArrayList<Pattern>();
		for(String sqlExpression : sqlRegexps){
			patterns.add(Pattern.compile(sqlExpression, Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE));
		}
		return patterns;
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		Map<String, String[]> parameters = request.getParameterMap();
		Iterator<String> keys = parameters.keySet().iterator();

		while( keys.hasNext() ){
			String key = keys.next();
			String values[] = parameters.get(key);

			for(int i=0, s=values.length; i<s; i++) {
				values[i] = cleanXSS(values[i]);
				values[i] = isSqlInjectionSafe(values[i]);
			}
			request.setAttribute(key, values);
		}

		Enumeration<String> e = request.getParameterNames();
		while(e.hasMoreElements()) {
			String key = e.nextElement();
            String values[] = request.getParameterValues(key);
            if(values != null) {

				for(int i=0, s=values.length; i<s; i++) {
					values[i] = stripXSS(values[i]);
				}
				request.setAttribute(key, values);

            	if(values.length == 1) {
            		request.setAttribute(key, stripXSS(values[0]));
            	} else {
            		for(int i=0, s=values.length; i<s; i++) {
            			values[i] = stripXSS(values[i]);
            		}
            		request.setAttribute(key, values);
            	}
            }
		}

		return true;
	}

	private String cleanXSS(String value) {
		//You'll need to remove the spaces from the html entities below
		value = value.replaceAll("<", "& lt;").replaceAll(">", "& gt;");
//		value = value.replaceAll("\\(", "& #40;").replaceAll("\\)", "& #41;");
		value = value.replaceAll("'", "& #39;");
		value = value.replaceAll("eval\\((.*)\\)", "");
		value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
		value = value.replaceAll("script", "");
		return value;
	}

	private String stripXSS(String value) {
		if (value != null) {
			value = value.replaceAll("", "");

			Pattern scriptPattern = Pattern.compile("<script>(.*?)</script>", Pattern.CASE_INSENSITIVE);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("</script>", Pattern.CASE_INSENSITIVE);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE);
			value = scriptPattern.matcher(value).replaceAll("");

			scriptPattern = Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
			value = scriptPattern.matcher(value).replaceAll("");
		}
		return value;
	}

}
