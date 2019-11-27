<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<!doctype html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content = "telephone=no">
    <meta name="autocomplete" content="off" />
    <meta http-equiv="imagetoolbar" content="no" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>iSaver Dev</title>

    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui.min.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js?version=${version}"></script>

    <style>
        body {
            background-color: #3c3c3c;
        }

        section {
            display: flex;
            padding: 30px 30px;
            width: 500px;
            height: 500px;
            border-style: solid;
            border-width: 2px;
            border-color: whitesmoke;
            color: whitesmoke;
        }

        .test_set {
            background-position: top left;
            width: 100px;
            height: 50px;
            border-style: solid;
            border-width: 2px;
            border-color: whitesmoke;
        }
        .test_set, section { padding: 0.5em; }

        .ui-resizable-handle {
            position: absolute;
            font-size: 0.1px;
            display: block;
            -ms-touch-action: none;
            touch-action: none;
        }
        .ui-resizable-s {
            cursor: s-resize;
            height: 7px;
            width: 100%;
            bottom: -5px;
            left: 0;
        }
        .ui-resizable-e {
            cursor: e-resize;
            width: 7px;
            right: -5px;
            top: 0;
            height: 100%;
        }
        .ui-resizable-se {
            cursor: se-resize;
            width: 12px;
            height: 12px;
            right: 1px;
            bottom: 1px;
        }
    </style>
</head>
<body>
<article>
    <section class="drag_section">
        <div class="test_set">
            <p>TEST 1</p>
        </div>
        <div class="test_set">
            <p>TEST 2</p>
        </div>
        <div class="test_set">
            <p>TEST 3</p>
        </div>
    </section>
</article>

<script type="text/javascript">
    $(document).ready(function(){
        $(".test_set").draggable({
            opacity: 0.5, // The transparency level of the dragged element
            cursor: 'move', // Change the cursor shape when dragging
            revert: 'invalid', // Put back the dragged element if it could not be dropped
            containment: '.drag_section' // Limit the area of dragging
        }).resizable({
            containment: '.drag_section'
        });
    });
</script>
</body>
</html>