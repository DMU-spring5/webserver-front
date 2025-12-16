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
    <title>MILLI ROAD - 버스</title>
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
        .row{display:flex;gap:8px;margin-bottom:8px;}
        .inp{flex:1;height:42px;border-radius:6px;border:1px solid #d0d0c8;padding:0 12px;background:#fff;}
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
        #map{width:100%;height:100%;border-radius:6px;border:1px solid #d0d0c8;background:#eaeaea;position:relative;}
        .hint{padding:12px;color:#666;font-size:13px;}
        .clickable{cursor:pointer}
        .clickable:hover{background:#fafafa}
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
            <input id="startAddress" class="inp" placeholder="출발지 입력" value="<%=startAddress%>"/>
            <div class="arrow">↓</div>
            <input id="endAddress" class="inp" placeholder="도착지 입력" value="<%=endAddress%>"/>

            <div class="tabs">
                <button class="tab" onclick="goTab('map_walk')">도보</button>
                <button class="tab active" onclick="goTab('map_bus')">버스</button>
                <button class="tab" onclick="goTab('map_subway')">지하철</button>
                <button class="tab" onclick="goTab('map_walk')">종합</button>
            </div>

            <div class="row">
                <input id="busNo" class="inp" placeholder="버스 번호 (예: 150)" />
                <button class="btn primary" onclick="busSearch()">버스검색</button>
            </div>

            <div class="row">
                <input id="stationName" class="inp" placeholder="정류장 이름 (예: 강남역)" />
                <button class="btn" onclick="stationSearch()">정류장검색</button>
            </div>

            <div class="head" id="headText">버스 검색 결과</div>
            <div class="list" id="list">
                <div class="hint">버스번호 또는 정류장 이름을 검색해봐.</div>
            </div>
        </div>

        <div id="map">
            <div class="hint">지도는 map.jsp에서 먼저 확인(임시 OSM). 나중에 네이버 지도 붙이면 여기에도 동일하게 붙이면 됨.</div>
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

    // 탭 이동 시 출발/도착 유지
    function goTab(path){
        var s = document.getElementById("startAddress").value || "";
        var e = document.getElementById("endAddress").value || "";
        try{
            localStorage.setItem("startAddress", s);
            localStorage.setItem("endAddress", e);
        }catch(err){}
        location.href = ctx + "/" + path + "?startAddress=" + encodeURIComponent(s) + "&endAddress=" + encodeURIComponent(e);
    }

    // 로컬스토리지 복원
    (function restore(){
        try{
            var s = localStorage.getItem("startAddress");
            var e = localStorage.getItem("endAddress");
            if(s && !document.getElementById("startAddress").value) document.getElementById("startAddress").value = s;
            if(e && !document.getElementById("endAddress").value) document.getElementById("endAddress").value = e;
        }catch(err){}
    })();

    async function fetchJson(url){
        var res = await fetch(url);
        var txt = await res.text();
        try{ return JSON.parse(txt); }catch(e){ throw new Error("JSON 파싱 실패: " + txt); }
    }

    function setHead(t){ document.getElementById("headText").textContent = t; }
    function setHtml(html){ document.getElementById("list").innerHTML = html; }

    async function busSearch(){
        var busNo = (document.getElementById("busNo").value || "").trim();
        if(!busNo){ alert("버스 번호를 입력해줘."); return; }

        setHead("버스 검색 결과");
        setHtml('<div class="hint">불러오는 중...</div>');

        var url = "https://webserver-backend.onrender.com/api/v1/transport/bus/search?cityCode=1000&busNo=" + encodeURIComponent(busNo);

        try{
            var data = await fetchJson(url);
            var lanes = (data && data.result && data.result.lane) ? data.result.lane : [];
            if(!lanes.length){
                setHtml('<div class="hint">검색 결과 없음</div>');
                return;
            }

            var html = "";
            for(var i=0;i<lanes.length;i++){
                var lane = lanes[i];
                var laneId = lane.busID; // 너가 준 샘플에서 busID가 laneId처럼 보임
                html += '<div class="item clickable" onclick="busDetail(' + Number(laneId) + ')">';
                html +=   '<div class="title">' + escHtml(lane.busNo) + ' (' + escHtml(lane.busCompanyNameKor || "") + ')</div>';
                html +=   '<div class="muted">구간: ' + escHtml(lane.busStartPoint || "") + ' → ' + escHtml(lane.busEndPoint || "") + '</div>';
                html +=   '<div class="muted">첫차 ' + escHtml(lane.busFirstTime || "") + ' / 막차 ' + escHtml(lane.busLastTime || "") + ' / 배차 ' + escHtml(lane.busInterval || "") + '분</div>';
                html += '</div>';
            }
            setHtml(html);

        }catch(err){
            setHead("에러");
            setHtml('<div class="item"><div class="title">요청 실패</div><div class="muted">' + escHtml(err.message) + '</div></div>');
        }
    }

    async function busDetail(laneId){
        setHead("정류장 리스트 (laneId=" + laneId + ")");
        setHtml('<div class="hint">불러오는 중...</div>');

        var url = "https://webserver-backend.onrender.com/api/v1/transport/bus/detail?laneId=" + encodeURIComponent(String(laneId));

        try{
            var data = await fetchJson(url);
            var st = (data && data.station) ? data.station : [];
            if(!st.length){
                setHtml('<div class="hint">정류장 정보 없음</div>');
                return;
            }

            var html = "";
            for(var i=0;i<st.length;i++){
                var a = st[i];
                html += '<div class="item">';
                html +=   '<div class="title">' + (i+1) + '. ' + escHtml(a.stationName || "") + '</div>';
                html +=   '<div class="muted">stationID: ' + escHtml(a.stationID) + ' / arsID: ' + escHtml(a.arsID || "") + '</div>';
                html += '</div>';
            }
            setHtml(html);

        }catch(err){
            setHead("에러");
            setHtml('<div class="item"><div class="title">요청 실패</div><div class="muted">' + escHtml(err.message) + '</div></div>');
        }
    }

    async function stationSearch(){
        var name = (document.getElementById("stationName").value || "").trim();
        if(!name){ alert("정류장 이름을 입력해줘."); return; }

        setHead("정류장 검색 결과");
        setHtml('<div class="hint">불러오는 중...</div>');

        var url = "https://webserver-backend.onrender.com/api/v1/transport/bus/station/search?name=" + encodeURIComponent(name);

        try{
            var data = await fetchJson(url);

            // 응답 구조가 아직 확정이 아니라 안전하게 처리
            var list = [];
            if(Array.isArray(data)) list = data;
            else if(data && data.result && Array.isArray(data.result)) list = data.result;
            else if(data && data.result && Array.isArray(data.result.station)) list = data.result.station;

            if(!list.length){
                setHtml('<div class="hint">검색 결과 없음</div>');
                return;
            }

            var html = "";
            for(var i=0;i<list.length;i++){
                var s = list[i];
                html += '<div class="item">';
                html +=   '<div class="title">' + escHtml(s.stationName || s.name || "") + '</div>';
                html +=   '<div class="muted">' + escHtml(JSON.stringify(s)) + '</div>';
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
