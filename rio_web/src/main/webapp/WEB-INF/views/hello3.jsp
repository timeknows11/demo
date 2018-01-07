<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Network | Hierarchical Layout, userDefined</title>

    <style type="text/css">
        body {
            font: 10pt sans;
        }

        #mynetwork {
            width: 1600px;
            height: 750px;
            border: 1px solid lightgray;
        }
    </style>
    <script type="text/javascript" src="<%=basePath%>/js/vis-network.min.js"></script>
    <link href="<%=basePath%>/css/test.css" rel="stylesheet" type="text/css"/>


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

        function draw() {
            destroy();
            nodes = [];
            edges = [];
            var connectionCount = [];

            // randomly create some nodes and edges
            <%--var nodeList = eval('(' + '${nodeList}' + ')');--%>
            <%--for(var i in nodeList){--%>
                <%--nodes.push({id: nodeList[i].id, label: String(nodeList[i].label)});--%>
                <%--nodes[i]["level"] = nodeList[i].level;--%>
                <%--nodes[i]["title"] = nodeList[i].title;--%>
                <%--nodes[i]["color"] = nodeList[i].color;--%>
            <%--}--%>

            <%--var edgeList = eval('(' + '${edgeList}' + ')');--%>
            <%--for(var i in edgeList){--%>
                <%--edges.push({from: edgeList[i].from, to: edgeList[i].to});--%>
            <%--}--%>

            // create a network
            var container = document.getElementById('mynetwork');
            var data = {
                nodes: ${nodeList},
                edges: ${edgeList}
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
                nodes:{
                    font:{
                        size:17
                    }
                },
                layout: {
                    hierarchical: {
                        direction: directionInput.value
                    }
                },
                physics:false,
                interaction:{ hover:true } // 支持hover事件
            };
            network = new vis.Network(container, data, options);

            network.focus( ${zeusId},{scale:0.7})

            // add event listeners
            network.on('select', function (params) {
                document.getElementById('selection').innerHTML = 'Selection: ' + params.nodes;
            });
            network.on("hoverNode", function (params) {
                console.log('hoverNode Event:', params);
                // event handle
            });
        }

    </script>

</head>

<body onload="draw();">
<h2>Depend Graph</h2>

<div style="width:700px; font-size:14px; text-align: justify;">

</div>
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
        draw();
    };
    var btnDU = document.getElementById("btn-DU");
    btnDU.onclick = function () {
        directionInput.value = "DU";
        draw();
    };
    var btnLR = document.getElementById("btn-LR");
    btnLR.onclick = function () {
        directionInput.value = "LR";
        draw();
    };
    var btnRL = document.getElementById("btn-RL");
    btnRL.onclick = function () {
        directionInput.value = "RL";
        draw();
    };
</script>
</body>
</html>
