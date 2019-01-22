/**
 * html elements util For javascript</br>
 * - jquery dependence
 *
 * @author kst
 */

/**
 * hour select
 * @param select element
 * @param value - select value
 * @param desc - default value sort order
 */
function setHourDataToSelect(select, value, desc){
    var cnt = 0;

    while(cnt < 24) {
        function n(n){
            return n > 9 ? "" + n: "0" + n;
        }
        var hh = n(cnt);
        var optTag = document.createElement("option");
        optTag.setAttribute("value", hh);
        optTag.textContent = n(cnt);
        select.append(optTag);
        cnt++;
    }
    if(value != null && value != ''){
        select.val(value);
    }else{
        if(desc){
            select.find('option:last').attr('selected',true);
        }else{
            select.find('option:first').attr('selected',true);
        }
    }
}