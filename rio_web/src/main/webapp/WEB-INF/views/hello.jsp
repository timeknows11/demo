<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Zeus Depend Graph</title>

    <style type="text/css">
        body {
            font: 10pt sans;
        }

        #mynetwork {
            width: 1600px;
            height: 750px;
            border: 1px solid lightgray;
        }

        .word {
            margin-left: 20px;
            font-size: 25px;
        }
    </style>

    <!-- CSS -->
    <link href="<%=basePath%>/css/test.css" rel="stylesheet" type="text/css"/>

    <!-- vis network -->
    <script type="text/javascript" src="<%=basePath%>/js/vis-network.min.js"></script>
    <!-- jQuery -->
    <script language="javascript" src="<%=basePath%>/js/jquery-1.12.4.min.js"></script>
    <!-- 表单校验 -->
    <script language="javascript" src="<%=basePath%>/js/jquery.validate.js"></script>


    <script type="text/javascript">
        var nodes = null;
        var edges = null;
        var network = null;
        var directionInput = document.getElementById("direction");

        function destroy() {
            if (network !== null) {
                network.destroy();
                network = null;
            }
        }

        function draw(zeusId, dataVal) {
            destroy();
            nodes = [];
            edges = [];
            var connectionCount = [];

            // create a network
            var container = document.getElementById('mynetwork');

            var dataObj = JSON.parse(dataVal)
            var data = {
                nodes: dataObj.nodes,
                edges: dataObj.edges
            };

            var options = {
                edges: {
                    smooth: {
                        type: 'cubicBezier',
                        forceDirection: (directionInput.value == "UD" || directionInput.value == "DU") ? 'vertical' : 'horizontal',
                        roundness: 0.4
                    },
                    arrows: {
                        to: {enabled: true, scaleFactor: 0.5, type: 'arrow'}// 箭头出现在to的节点
                        //  from: {enabled: true, scaleFactor: 0.5, type: 'arrow'}// 箭头出现在from的节点（请删除）
                    },
                    color: { // 结点之间的连接线的颜色
                        color: '#97c2fc', // 默认情况下的颜色
                        highlight: '#FF83FA', // 结点选中时的颜色
                        hover: '#FF7F00', // 鼠标悬浮结点时的颜色 （只有在interaction:{hover:true}属性设置时生效）
                        //inherit: 'from', //这个配置继承from结点的颜色
                        opacity: 1.0
                    }	// 默认线的颜色继承from结点的颜色，通过color对象可以定义特定的颜色， nodes nodes[0]["color"] = 'green'; 或者nodes[0]["color"] = '#97c2fc';
                },
                nodes: {
                    font: {
                        size: 17
                    }
                },
                layout: {
                    hierarchical: {
                        direction: directionInput.value
                    }
                },
                physics: false,
                interaction: {hover: true} // 支持hover事件
            };
            network = new vis.Network(container, data, options);

            network.focus(zeusId, {scale: 0.7})

            // add event listeners
            network.on('select', function (params) {
                document.getElementById('selection').innerHTML = 'Selection: ' + params.nodes;
            });
            network.on("hoverNode", function (params) {
                //console.log('hoverNode Event:', params);
                // event handle
            });
        }

        function clickEnter() {                  //按回车Search
            if (event.keyCode == "13") {         //keyCode=13是回车键
                search();
            }
        };

        function search() {
            var zeusId = $("#zeusIdText").val();
            var upDependRadio = document.getElementById("upDepend");
            var direction = 0;
            if (upDependRadio.checked == true) {
                direction = 1;
            }
            var json = {
                "zeusId": zeusId,
                "direction":direction
            };
            $.ajax({
                type: "POST",
                url: "/bd-monitor/graph",
                data: "searchInfo=" + JSON.stringify(json),
                dataType: "text",
                success: function (data, stats) {
                    draw(parseInt(zeusId), data)
                },
                error: function (data) {
                    alert("请求失败");
                }
            });
        }

    </script>

</head>

<body>
<h2>Depend Graph</h2>

<div style="width:700px; font-size:14px; text-align: justify;">

</div>
<table cellspacing="0" cellpadding="0" border="0">
    <tr>
        <td>Zeus Id:</td>
        <td>
            <input class="text-input" type="text" id="zeusIdText" name="zeusIdText" onkeydown="javascript:clickEnter();"/>
            <input class="button" type="submit" onclick="search()" value="Search"/>
        </td>
        <td>
            <input type="radio" id="downDepend" name="dependRadio" value='1' checked/>影响
            <input type="radio" id="upDepend" name="dependRadio" value='0'/>血缘
        </td>
        <td>
            <font color="#B3EE3A" class="word">Success</font>
            <font color="#EE82EE" class="word">Running</font>
            <font color="#CD2626" class="word">Failed </font>
            <font color="#97c2fc" class="word">Other</font>
        </td>

    </tr>
</table>
<p>
    <input type="button" id="btn-UD" value="Up-Down">
    <input type="button" id="btn-DU" value="Down-Up">
    <input type="button" id="btn-LR" value="Left-Right">
    <input type="button" id="btn-RL" value="Right-Left">
    <input type="hidden" id='direction' value="UD">
</p>

<div id="mynetwork"></div>

<p id="selection"></p>
<script language="JavaScript">
    var directionInput = document.getElementById("direction");
    var btnUD = document.getElementById("btn-UD");
    btnUD.onclick = function () {
        directionInput.value = "UD";
        search();
    };
    var btnDU = document.getElementById("btn-DU");
    btnDU.onclick = function () {
        directionInput.value = "DU";
        search();
    };
    var btnLR = document.getElementById("btn-LR");
    btnLR.onclick = function () {
        directionInput.value = "LR";
        search();
    };
    var btnRL = document.getElementById("btn-RL");
    btnRL.onclick = function () {
        directionInput.value = "RL";
        search();
    };
</script>
</body>
</html>
