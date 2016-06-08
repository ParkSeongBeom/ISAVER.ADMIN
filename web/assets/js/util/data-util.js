/**
 * data util For javascript</br>
 * - jquery dependence
 *
 * @author kst
 */


/**
 * 날짜(date)를 문자(string)형태로 변환(yyyy-MM-dd)
 * @author kst
 * @returns {String}
 */
Date.prototype.convertDateToString = function(){
    var year = this.getFullYear().toString();
    var month = (this.getMonth() + 1).toString();
    var date = this.getDate().toString();

    return year.toDoubleDigits() + "-" + month.toDoubleDigits() +  "-" + date.toDoubleDigits();
};

/**
 * 날짜(date)를 문자(string)형태로 변환(yyyy-MM-dd hh:mm:ss)
 * @author kst
 * @returns {String}
 */
Date.prototype.convertDatetimeToString = function(){
    var dateStr = this.convertDateToString();
    var hour = this.getHours().toString();
    var minute = this.getMinutes().toString();
    var seconds = this.getSeconds().toString();

    return dateStr + " " + hour.toDoubleDigits() + ":" + minute.toDoubleDigits() + ":" + seconds.toDoubleDigits();
};

/**
 * 숫자형 문자 데이터를 2자릿수로 맞춘다.
 * @author kst
 * @returns {String}
 */
String.prototype.toDoubleDigits = function(){
    return this.toDigits(2);
};

/**
 * 숫자형 문자 데이터를 원하는 자릿수로 맞춘다.
 *
 * @author kst
 * @param digit
 * @returns {String}
 */
String.prototype.toDigits = function(digit){
    var value = this;
    while(this.length < digit){
        value = "0" + this;
    }
    return value;
};

/**
 * 문자열 날짜정보(yyyy-MM-dd)의 유효성을 체크한다.
 *
 * @author kst
 * @param separate
 * @returns {boolean}
 */
String.prototype.checkDatePattern = function(separate){
    var value = this;

    var valueArr = value.split(separate);

    if(valueArr.length != 3){
        return false;
    }

    if(valueArr[0] == null || isNaN(valueArr[0]) || valueArr[0].length != 4){
        return false;
    }

    if(valueArr[1] == null || isNaN(valueArr[1]) || valueArr[1].length != 2){
        return false;
    }else if(Number(valueArr[1]) < 1 || Number(valueArr[1]) > 12){
        return false;
    }

    if(valueArr[2] == null || isNaN(valueArr[2]) || valueArr[2].length != 2){
        return false;
    }else if(Number(valueArr[2]) < 1 || Number(valueArr[2]) > 31){
        return false;
    }

    return true;
};

/**
 * 문자열 시간정보(HH:mm:ss)의 유효성을 체크한다.
 *
 * @author kst
 * @param separate
 * @returns {boolean}
 */
String.prototype.checkTimePattern = function(separate){
    var value = this;

    var valueArr = value.split(separate);

    if(valueArr.length != 3){
        return false;
    }

    if(valueArr[0] == null || isNaN(valueArr[0]) || valueArr[0].length > 2){
        return false;
    }

    if(valueArr[1] == null || isNaN(valueArr[1]) || valueArr[1].length > 2){
        return false;
    }else if(Number(valueArr[1]) < 0 || Number(valueArr[1]) > 59){
        return false;
    }

    if(valueArr[2] == null || isNaN(valueArr[2]) || valueArr[2].length > 2){
        return false;
    }else if(Number(valueArr[2]) < 0 || Number(valueArr[2]) > 59){
        return false;
    }

    return true;
};

/**
 * 문자열 날짜시간정보(yyyy-MM-dd HH:mm:ss)의 유효성을 체크한다.
 *
 * @author kst
 * @param date
 * @param time
 * @param dateSeparate
 * @param timeSeparate
 * @returns {boolean}
 */
String.prototype.checkDatetimePattern = function(datetimeSeparate, dateSeparate, timeSeparate){
    var value = this;

    if(datetimeSeparate == null){
        datetimeSeparate = " ";
    }

    if(value.indexOf(datetimeSeparate) < 0){
        return false;
    }

    var date = value.split(datetimeSeparate)[0];
    var time = value.split(datetimeSeparate)[1];

    if(date == null || time == null){
        return false;
    }

    if(dateSeparate == null){
        dateSeparate = "-";
    }

    if(timeSeparate == null){
        timeSeparate = ":";
    }

    var dateFlag = date.checkDatePattern(dateSeparate);
    var timeFlag = false;
    if(dateFlag){
        timeFlag = time.checkTimePattern(timeSeparate);
    }

    if(dateFlag && timeFlag){
        return true;
    }

    return false;
};

/**
 * 문자열 날짜시간정보(yyyy-MM-dd HH:mm:ss)의 유효성을 체크한다.
 *
 * @author psb
 * @param format
 */
Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";

    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var weekName_02 = ["SUN","MON","TUE","WED","THU","FRI","SAT"];
    var d = this;

    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "e": return weekName[d.getDay()];
            case "E": return weekName_02[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            case "A/P": return d.getHours() < 12 ? "AM" : "PM";
            default: return $1;
        }
    });
};

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};