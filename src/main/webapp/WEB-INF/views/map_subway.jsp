<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    String startAddress = request.getParameter("startAddress");
    String endAddress = request.getParameter("endAddress");
    if(startAddress == null) startAddress = "";
    if(endAddress == null) endAddress = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>MILLI ROAD - 지하철</title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:"Noto Sans KR",system-ui,sans-serif;background:#f5f5f5;color:#333;}
        header{height:64px;background:#78866B;color:#fff;padding:0 40px;display:flex;align-items:center;justify-content:space-between;}
        .header-left{display:flex;align-items:center;gap:14px;}
        .header-logo-box{width:34px;height:34px;border-radius:4px;background:#fff;}
        .header-title{font-size:22px;font-weight:700;letter-spacing:.10em;}
        .header-nav{display:flex;align-items:center;gap:26px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{display:flex;align-items:center;gap:16px;font-size:14px;}
        .btn-logout{padding:6px 16px;border-radius:4px;border:none;background:#fff;color:#78866B;font-weight:600;cursor:pointer;}

        .page-wrap{max-width:1200px;margin:26px auto 40px;padding:0 40px;}
        .layout{display:grid;grid-template-columns:360px 1fr;gap:12px;height:650px;}
        .left-box{background:#f3f3f0;border-radius:6px;padding:14px;display:flex;flex-direction:column;}
        .inp{width:100%;height:42px;border-radius:6px;border:1px solid #d0d0c8;padding:0 12px;background:#fff;margin-bottom:8px;}
        .row{display:flex;gap:8px;margin-bottom:8px;}
        .btn{height:42px;padding:0 14px;border-radius:6px;border:1px solid #d0d0c8;background:#fff;cursor:pointer;font-weight:700;}
        .btn.primary{background:#78866B;color:#fff;border-color:#78866B;}
        .arrow{margin:4px 0;text-align:center;font-size:18px;color:#666;}
        .tabs{display:flex;gap:6px;margin:8px 0;}
        .tab{flex:1;height:34px;border-radius:6px;border:1px solid #d0d0c8;background:#f7f7f2;cursor:pointer;}
        .tab.active{background:#78866B;color:#fff;border-color:#78866B;font-weight:800;}
        .head{font-size:12px;color:#777;margin:8px 0 6px;}
        .list{flex:1;background:#fff;border:1px solid #deded5;border-radius:6px;overflow:auto;padding:8px;}
        .item{padding:10px;border-bottom:1px solid #f0f0f0;}
        .item:last-child{border-bottom:none;}
        .title{font-weight:800;margin-bottom:4px;}
        .muted{color:#777;font-size:13px;line-height:1.35}
        #map{width:100%;height:100%;border-radius:6px;border:1px solid #d0d0c8;background:#eaeaea;}
        .hint{padding:12px;color:#666;font-size:13px;}
    </style>
</head>
<body>

<header>
    <div class="header-left">
        <div class="header-logo-box"></div>
        <div class="header-title">MILLI ROAD</div>
    </div>
    <nav class="header-nav">
        <a href="#">뉴스</a><span>|</span>
        <a href="<%=ctx%>/social/board">소셜</a><span>|</span>
        <a href="<%=ctx%>/health">건강</a><span>|</span>
        <a href="<%=ctx%>/map" class="active">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">
    <div class="layout">

        <div class="left-box">
            <input id="startAddress" class="inp" placeholder="출발역(예: 서울역)" value="<%=startAddress%>"/>
            <div class="arrow">↓</div>
            <input id="endAddress" class="inp" placeholder="도착역(예: 강남역)" value="<%=endAddress%>"/>

            <div class="tabs">
                <button class="tab" onclick="goTab('map_walk')">도보</button>
                <button class="tab" onclick="goTab('map_bus')">버스</button>
                <button class="tab active" onclick="goTab('map_subway')">지하철</button>
                <button class="tab" onclick="goTab('map_walk')">종합</button>
            </div>

            <div class="row">
                <input id="time" class="inp" style="margin:0" placeholder="시간(HHmm) 예: 0830" />
                <select id="dayType" class="inp" style="margin:0">
                    <option value="WEEKDAY">WEEKDAY</option>
                    <option value="SATURDAY">SATURDAY</option>
                    <option value="SUNDAY">SUNDAY</option>
                </select>
            </div>

            <div class="row">
                <select id="region" class="inp" style="margin:0">
                    <option value="수도권">수도권</option>
                </select>
                <button class="btn primary" onclick="subwaySearch()">검색</button>
            </div>

            <div class="head" id="headText">지하철 경로</div>
            <div class="list" id="list">
                <div class="hint">출발/도착역을 입력하고 검색해봐.</div>
            </div>
        </div>

        <div id="map">
            <div class="hint">지도는 일단 map.jsp에서 먼저 확인(임시 OSM).</div>
        </div>
    </div>
</div>

<script>
    var ctx = "<%=ctx%>";

    function escHtml(s){
        return String(s)
            .replace(/&/g,"&amp;")
            .replace(/</g,"&lt;")
            .replace(/>/g,"&gt;")
            .replace(/"/g,"&quot;")
            .replace(/'/g,"&#39;");
    }

    function goTab(path){
        var s = document.getElementById("startAddress").value || "";
        var e = document.getElementById("endAddress").value || "";
        try{
            localStorage.setItem("startAddress", s);
            localStorage.setItem("endAddress", e);
        }catch(err){}
        location.href = ctx + "/" + path + "?startAddress=" + encodeURIComponent(s) + "&endAddress=" + encodeURIComponent(e);
    }

    (function restore(){
        try{
            var s = localStorage.getItem("startAddress");
            var e = localStorage.getItem("endAddress");
            if(s && !document.getElementById("startAddress").value) document.getElementById("startAddress").value = s;
            if(e && !document.getElementById("endAddress").value) document.getElementById("endAddress").value = e;
        }catch(err){}
        // 기본 시간
        var now = new Date();
        var hh = String(now.getHours()).padStart(2,"0");
        var mm = String(now.getMinutes()).padStart(2,"0");
        document.getElementById("time").value = hh + mm;
    })();

    async function fetchJson(url){
        var res = await fetch(url);
        var txt = await res.text();
        try{ return JSON.parse(txt); }catch(e){ throw new Error("JSON 파싱 실패: " + txt); }
    }

    function setHead(t){ document.getElementById("headText").textContent = t; }
    function setHtml(html){ document.getElementById("list").innerHTML = html; }

    async function subwaySearch(){
        var region = document.getElementById("region").value;
        var dep = (document.getElementById("startAddress").value || "").trim();
        var arr = (document.getElementById("endAddress").value || "").trim();
        var time = (document.getElementById("time").value || "").trim();
        var dayType = document.getElementById("dayType").value;

        if(!dep || !arr){ alert("출발역/도착역을 입력해줘."); return; }
        if(!/^\d{4}$/.test(time)){ alert("시간은 HHmm 4자리로 입력해줘. 예) 0830"); return; }

        setHead("지하철 경로");
        setHtml('<div class="hint">불러오는 중...</div>');

        var url = "https://webserver-backend.onrender.com/api/v1/transport/subway/path"
            + "?region=" + encodeURIComponent(region)
            + "&departure=" + encodeURIComponent(dep)
            + "&arrival=" + encodeURIComponent(arr)
            + "&time=" + encodeURIComponent(time)
            + "&dayType=" + encodeURIComponent(dayType);

        try{
            var data = await fetchJson(url);

            // 너가 준 샘플 구조 기준
            var totalTime = data.totalTime;
            var transferCount = data.transferCount;
            var stationCount = data.stationCount;
            var totalFare = data.totalFare;
            var paths = Array.isArray(data.paths) ? data.paths : [];

            var html = "";
            html += '<div class="item">';
            html +=   '<div class="title">요약</div>';
            html +=   '<div class="muted">총 ' + escHtml(totalTime) + '분 · 환승 ' + escHtml(transferCount) + '회 · ' + escHtml(stationCount) + '정거장 · 요금 ' + escHtml(totalFare) + '원</div>';
            html += '</div>';

            if(!paths.length){
                html += '<div class="item"><div class="title">경로 없음</div><div class="muted">paths가 비어있음</div></div>';
                setHtml(html);
                return;
            }

            for(var i=0;i<paths.length;i++){
                var p = paths[i];
                html += '<div class="item">';
                html +=   '<div class="title">' + (i+1) + '. ' + escHtml(p.lineName || "") + '</div>';
                html +=   '<div class="muted">' + escHtml(p.startName || "") + ' → ' + escHtml(p.endName || "") + '</div>';
                html +=   '<div class="muted">소요 ' + escHtml(p.sectionTime) + '분 · ' + escHtml(p.stationCount) + '정거장</div>';
                html += '</div>';
            }

            setHtml(html);

        }catch(err){
            setHead("에러");
            setHtml('<div class="item"><div class="title">요청 실패</div><div class="muted">' + escHtml(err.message) + '</div></div>');
        }
    }
</script>

</body>
</html>
