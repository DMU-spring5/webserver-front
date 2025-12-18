<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String startAddress = request.getParameter("startAddress");
    String endAddress = request.getParameter("endAddress");
    if(startAddress == null) startAddress = "";
    if(endAddress == null) endAddress = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 대중교통 위치/시간표 (도보)</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body{
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,"Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;color:#333;
        }
        header{
            height:64px;background:#78866B;color:#fff;padding:0 40px;
            display:flex;align-items:center;justify-content:space-between;
        }
        .header-left{display:flex;align-items:center;gap:14px;}
        .header-logo-box{
            width:34px;height:34px;border-radius:4px;
            background:url('<%=request.getContextPath()%>/img/KakaoTalk_20251204_101657760.png')
            center / contain no-repeat;
        }
        .header-title{font-size:22px;font-weight:700;letter-spacing:.10em;}
        .header-nav{display:flex;align-items:center;gap:26px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{display:flex;align-items:center;gap:16px;font-size:14px;}
        .btn-logout{padding:6px 16px;border-radius:4px;border:none;background:#fff;color:#78866B;font-weight:600;cursor:pointer;}

        .page-wrap{max-width:1200px;margin:40px auto 60px;padding:0 40px;}
        .title{font-size:22px;font-weight:700;margin-bottom:8px;}
        .sub{font-size:13px;color:#777;margin-bottom:24px;}

        .layout{display:grid;grid-template-columns:320px 1fr;gap:12px;height:600px;}
        .left-box{
            background:#f3f3f0;border-radius:4px;padding:14px 16px 16px;
            display:flex;flex-direction:column;
        }
        .search-group{margin-bottom:10px;}
        .search-input-wrap{position:relative;}
        .search-input{
            width:100%;height:42px;border-radius:4px;border:1px solid #d0d0c8;
            padding:0 12px;font-size:14px;background:#fff;
        }
        .arrow{text-align:center;font-size:18px;margin:4px 0;color:#777;}

        .tab-row{display:flex;gap:6px;margin:10px 0 8px;font-size:13px;}
        .tab-btn{
            flex:1;height:32px;border-radius:4px;border:1px solid #d0d0c8;background:#f7f7f2;
            cursor:pointer;
        }
        .tab-btn.active{background:#78866B;color:#fff;border-color:#78866B;}

        .info-head{font-size:12px;color:#777;margin-top:8px;margin-bottom:6px;display:flex;justify-content:space-between;}
        .route-list{
            flex:1;background:#fff;border-radius:4px;border:1px solid #deded5;
            overflow:auto;font-size:13px;
        }
        .route-item{padding:10px 12px;border-bottom:1px solid #f0f0f0;cursor:pointer;}
        .route-item:last-child{border-bottom:none;}
        .route-title{font-size:15px;font-weight:700;margin-bottom:4px;}
        .route-sub{color:#777;}

        #map{width:100%;height:100%;border-radius:4px;border:1px solid #d0d0c8;background:#eaeaea;}
    </style>

    <script src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=YOUR_NAVER_CLIENT_ID"></script>
    <script>
        const ctx = "<%=request.getContextPath()%>";

        function goTab(mode){
            const s = document.getElementById("startAddress").value.trim();
            const e = document.getElementById("endAddress").value.trim();
            location.href = ctx + "/" + mode + "?startAddress=" + encodeURIComponent(s) + "&endAddress=" + encodeURIComponent(e);
        }

        // 더미 데이터(도보 경로 후보)
        const walkRoutes = [
            { title:"가장 빠른", sub:"13분 | 706m | 횡단보도 2회 | 계단 1회" },
            { title:"큰 길 우선", sub:"13분 | 706m | 횡단보도 2회 | 계단 1회" },
            { title:"계단 회피", sub:"13분 | 706m | 횡단보도 2회 | 계단 1회" }
        ];

        function renderWalk(){
            const list = document.getElementById("routeList");
            list.innerHTML = "";
            walkRoutes.forEach((r) => {
                const div = document.createElement("div");
                div.className = "route-item";
                div.innerHTML = `<div class="route-title">${r.title}</div><div class="route-sub">${r.sub}</div>`;
                div.onclick = () => alert("도보 상세(경과표) API 붙이면 여기서 상세 펼치기/이동 하면 됨");
                list.appendChild(div);
            });
            document.getElementById("countText").textContent = "총 " + walkRoutes.length + "건";
        }

        let naverMap=null;
        window.addEventListener("load", () => {
            renderWalk();
            try{
                if(window.naver && naver.maps){
                    naverMap = new naver.maps.Map("map", {
                        center: new naver.maps.LatLng(37.5665, 126.9780),
                        zoom: 13
                    });
                }
            }catch(e){}
        });
    </script>
</head>
<body>

<header>
    <div class="header-left">
        <div class="header-logo-box"></div>
        <div class="header-title">MILLI ROAD</div>
    </div>
    <nav class="header-nav">
        <a href="/main/mainpage.jsp">뉴스</a><span>|</span>
        <a href="<%=request.getContextPath()%>/social/board">소셜</a><span>|</span>
        <a href="<%=request.getContextPath()%>/health">건강</a><span>|</span>
        <a href="<%=request.getContextPath()%>/map" class="active">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout" type="button">로그아웃</button>
    </div>
</header>

<div class="page-wrap">
    <div class="title">대중교통 위치/시간표</div>
    <div class="sub">장소, 주소, 정류장을 검색해 주세요.</div>

    <div class="layout">
        <div class="left-box">
            <div class="search-group">
                <div class="search-input-wrap">
                    <input id="startAddress" type="text" class="search-input" value="<%=startAddress%>" placeholder="출발지 입력">
                </div>
            </div>

            <div class="arrow">↓</div>

            <div class="search-group">
                <div class="search-input-wrap">
                    <input id="endAddress" type="text" class="search-input" value="<%=endAddress%>" placeholder="도착지 입력">
                </div>
            </div>

            <div class="tab-row">
                <button class="tab-btn active" type="button" onclick="goTab('map_walk')">도보</button>
                <button class="tab-btn" type="button" onclick="goTab('map_bus')">버스</button>
                <button class="tab-btn" type="button" onclick="goTab('map_subway')">지하철</button>
                <button class="tab-btn" type="button" onclick="alert('종합은 나중에')">종합</button>
            </div>

            <div class="info-head">
                <span>오늘 출발 | 예시</span>
                <span id="countText">총 0건</span>
            </div>

            <div class="route-list" id="routeList"></div>
        </div>

        <div id="map"></div>
    </div>
</div>

</body>
</html>