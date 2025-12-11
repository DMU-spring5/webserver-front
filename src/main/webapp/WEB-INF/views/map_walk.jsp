<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 대중교통 위치/시간표 (도보)</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }

        body {
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,
            "Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;
            color:#333;
        }

        /* ===== 공통 헤더 ===== */
        header{
            height:64px;
            background:#78866B;
            color:#fff;
            padding:0 40px;
            display:flex;
            align-items:center;
            justify-content:space-between;
        }
        .header-left{display:flex;align-items:center;gap:14px;}
        .header-logo-box{
            width:34px;height:34px;border-radius:4px;
            background:url('${pageContext.request.contextPath}/img/KakaoTalk_20251204_101657760.png')
            center / contain no-repeat;
        }
        .header-title{font-size:22px;font-weight:700;letter-spacing:.10em;}
        .header-nav{display:flex;align-items:center;gap:26px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{display:flex;align-items:center;gap:16px;font-size:14px;}
        .btn-logout{
            padding:6px 16px;border-radius:4px;border:none;
            background:#fff;color:#78866B;font-weight:600;cursor:pointer;
        }

        /* ===== 페이지 레이아웃 ===== */
        .page-wrap{
            max-width:1200px;
            margin:40px auto 60px;
            padding:0 40px;
        }
        .title{
            font-size:22px;
            font-weight:700;
            margin-bottom:8px;
        }
        .sub{
            font-size:13px;
            color:#777;
            margin-bottom:24px;
        }

        /* 좌우 영역 레이아웃 */
        .layout{
            display:grid;
            grid-template-columns:320px 1fr;
            gap:12px;
            height:600px;
        }

        /* ===== 왼쪽 검색/리스트 박스 ===== */
        .left-box{
            background:#f3f3f0;
            border-radius:4px;
            padding:14px 16px 16px;
            display:flex;
            flex-direction:column;
        }

        .search-group{
            margin-bottom:10px;
        }
        .search-input-wrap{
            position:relative;
        }
        .search-input{
            width:100%;
            height:42px;
            border-radius:4px;
            border:1px solid #d0d0c8;
            padding:0 40px 0 12px;
            font-size:14px;
            background:#fff;
        }
        .search-icon{
            position:absolute;
            right:10px;
            top:50%;
            transform:translateY(-50%);
            width:20px;
            height:20px;
            background:url('${pageContext.request.contextPath}/img/search.png')
            center / 16px no-repeat;
        }

        .arrow{
            text-align:center;
            font-size:18px;
            margin:4px 0;
        }

        .tab-row{
            display:flex;
            gap:6px;
            margin:10px 0 8px;
            font-size:13px;
        }
        .tab-btn{
            flex:1;
            height:32px;
            border-radius:4px;
            border:1px solid #d0d0c8;
            background:#f7f7f2;
            cursor:pointer;
        }
        .tab-btn.active{
            background:#78866B;
            color:#fff;
            border-color:#78866B;
        }

        .info-head{
            font-size:12px;
            color:#777;
            margin-top:8px;
            margin-bottom:6px;
        }

        .route-list{
            flex:1;
            background:#fff;
            border-radius:4px;
            border:1px solid #deded5;
            overflow:auto;
            font-size:13px;
        }
        .route-item{
            padding:10px 12px;
            border-bottom:1px solid #f0f0f0;
        }
        .route-item:last-child{border-bottom:none;}
        .route-title{
            font-size:15px;
            font-weight:700;
            margin-bottom:4px;
        }
        .route-sub{
            color:#777;
        }

        /* ===== 오른쪽 지도 영역 ===== */
        #map{
            width:100%;
            height:100%;
            border-radius:4px;
            border:1px solid #d0d0c8;
            background:#eaeaea;
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
        <a href="#">뉴스</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social/board">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/map" class="active">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <div class="title">대중교통 위치/시간표</div>
    <div class="sub">장소, 주소, 정류장을 검색해 주세요.</div>

    <div class="layout">

        <!-- 왼쪽 -->
        <div class="left-box">

            <div class="search-group">
                <div class="search-input-wrap">
                    <input type="text" class="search-input" value="구일역 1호선">
                    <span class="search-icon"></span>
                </div>
            </div>

            <div class="arrow">↓</div>

            <div class="search-group">
                <div class="search-input-wrap">
                    <input type="text" class="search-input" value="동양미래대학교 정문">
                    <span class="search-icon"></span>
                </div>
            </div>

            <div class="tab-row">
                <button class="tab-btn active"
                        onclick="location.href='${pageContext.request.contextPath}/map_walk'">도보</button>
                <button class="tab-btn"
                        onclick="location.href='${pageContext.request.contextPath}/map_bus'">버스</button>
                <button class="tab-btn"
                        onclick="location.href='${pageContext.request.contextPath}/map_subway'">지하철</button>
                <button class="tab-btn">종합</button>
            </div>

            <div class="info-head">오늘 오후 1:11 출발 | 총 3건</div>

            <div class="route-list">
                <div class="route-item">
                    <div class="route-title">가장 빠른</div>
                    <div class="route-sub">13분 | 706m | 횡단보도 2회 | 계단 1회</div>
                </div>
                <div class="route-item">
                    <div class="route-title">큰 길 우선</div>
                    <div class="route-sub">13분 | 706m | 횡단보도 2회 | 계단 1회</div>
                </div>
                <div class="route-item">
                    <div class="route-title">계단 회피</div>
                    <div class="route-sub">13분 | 706m | 횡단보도 2회 | 계단 1회</div>
                </div>
            </div>
        </div>

        <!-- 오른쪽 지도 -->
        <div id="map"><!-- 카카오 지도 JS 붙일 자리 --></div>

    </div>

</div>

</body>
</html>