<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>MILLI ROAD - 대중교통 위치/시간표</title>

    <!-- Leaflet (키 없이 지도 표시 가능) -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        body{
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,"Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;color:#333;
        }
        header{
            height:64px;background:#78866B;color:#fff;padding:0 40px;
            display:flex;align-items:center;justify-content:space-between;
        }
        .header-left{display:flex;align-items:center;gap:14px;}
        .header-logo-box{width:34px;height:34px;border-radius:4px;background:#fff;}
        .header-title{font-size:22px;font-weight:700;letter-spacing:.10em;}
        .header-nav{display:flex;align-items:center;gap:26px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{display:flex;align-items:center;gap:16px;font-size:14px;}
        .btn-logout{padding:6px 16px;border-radius:4px;border:none;background:#fff;color:#78866B;font-weight:600;cursor:pointer;}

        .layout{
            display:grid;
            grid-template-columns: 360px 1fr;
            height: calc(100vh - 64px);
        }
        .left{
            background:#f3f3f0;
            border-right:1px solid #e6e6df;
            padding:18px 16px;
        }
        .h1{font-size:20px;font-weight:800;margin-bottom:10px;}
        .sub{font-size:13px;color:#777;margin-bottom:14px;}

        .search-wrap{position:relative;margin-bottom:10px;}
        .search-input{
            width:100%;height:44px;border-radius:6px;border:1px solid #d0d0c8;
            padding:0 44px 0 12px;font-size:14px;background:#fff;
        }
        .search-btn{
            position:absolute;right:8px;top:50%;transform:translateY(-50%);
            width:34px;height:34px;border:none;border-radius:6px;cursor:pointer;
            background:#78866B;color:#fff;font-weight:700;
        }
        .help{font-size:13px;color:#888;margin-top:10px;}

        #map{width:100%;height:100%;background:#eaeaea;position:relative;}
        .floating-pin{
            position:absolute;right:18px;top:18px;z-index:500;
            width:44px;height:44px;border-radius:10px;border:1px solid #ddd;background:#fff;
            cursor:pointer;display:flex;align-items:center;justify-content:center;
            box-shadow:0 4px 10px rgba(0,0,0,.08);
        }
        .floating-pin span{font-size:18px;}
        .goto-route{
            margin-top:12px;
            width:100%;height:42px;border:none;border-radius:6px;
            background:#78866B;color:#fff;font-weight:800;cursor:pointer;
        }
    </style>
</head>
<body>

<header>
    <div class="header-left">
        <div class="header-logo-box"></div>
        <div class="header-title">MILLI ROAD</div>
    </div>
    <nav class="header-nav">
        <a href="<%=ctx%>/main/mainpage.jsp">뉴스</a><span>|</span>
        <a href="<%=ctx%>/social/board">소셜</a><span>|</span>
        <a href="<%=ctx%>/health">건강</a><span>|</span>
        <a href="<%=ctx%>/map" class="active">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="layout">
    <div class="left">
        <div class="h1">대중교통 위치/시간표</div>
        <div class="sub">장소, 주소, 정류장을 검색해 주세요.</div>

        <div class="search-wrap">
            <input id="q" class="search-input" placeholder="장소, 주소, 정류장 검색" />
            <button id="btnSearch" class="search-btn">⌕</button>
        </div>

        <button id="btnGo" class="goto-route">길찾기 화면으로 이동</button>


    </div>

    <div id="map">
        <button class="floating-pin" id="btnPin" title="핀 페이지">
            <span>📍</span>
        </button>
    </div>
</div>

<script>
    var ctx = "<%=ctx%>";
    var qEl = document.getElementById("q");

    // 저장된 목적지 복원
    try{
        var savedEnd = localStorage.getItem("endAddress");
        if(savedEnd) qEl.value = savedEnd;
    }catch(e){}

    // 지도 (키 없이 보이게)
    var map = L.map("map").setView([37.4996, 126.8676], 14); // 구일역 근처 대충
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        maxZoom: 19, attribution: "&copy; OpenStreetMap"
    }).addTo(map);

    var marker = null;
    map.on("click", function(e){
        if(marker) map.removeLayer(marker);
        marker = L.marker(e.latlng).addTo(map);
        try{
            localStorage.setItem("pinLat", String(e.latlng.lat));
            localStorage.setItem("pinLng", String(e.latlng.lng));
        }catch(err){}
    });

    function saveEnd(){
        var endAddress = (qEl.value || "").trim();
        if(!endAddress){
            alert("목적지를 입력해줘.");
            return null;
        }
        try{ localStorage.setItem("endAddress", endAddress); }catch(e){}
        return endAddress;
    }

    document.getElementById("btnSearch").addEventListener("click", function(){
        saveEnd();
    });
    qEl.addEventListener("keydown", function(e){
        if(e.key === "Enter") saveEnd();
    });

    // 길찾기 화면(도보)로 이동 (출발지는 일단 '현재 위치'로 넣어둠)
    document.getElementById("btnGo").addEventListener("click", function(){
        var endAddress = saveEnd();
        if(!endAddress) return;
        var startAddress = "현재 위치";
        var url = ctx + "/map_walk?startAddress=" + encodeURIComponent(startAddress)
            + "&endAddress=" + encodeURIComponent(endAddress);
        location.href = url;
    });

    // 핀 페이지 이동
    document.getElementById("btnPin").addEventListener("click", function(){
        location.href = ctx + "/map_pin";
    });
</script>

</body>
</html>