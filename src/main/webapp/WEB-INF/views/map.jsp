<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 대중교통 위치/시간표</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }

        body {
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,
            "Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;
            color:#333;
            height:100vh;
            display:flex;
            flex-direction:column;
        }

        /* ===== 헤더 ===== */
        header{
            height:64px;
            background:#78866B;
            color:#fff;
            padding:0 40px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            flex-shrink:0;
        }
        .header-left{display:flex;align-items:center;gap:14px;}
        .header-logo-box{
            width:34px;
            height:34px;
            border-radius:4px;
            background:url('${pageContext.request.contextPath}/img/KakaoTalk_20251204_101657760.png')
            center / contain no-repeat;
        }
        .header-title{
            font-size:22px;
            font-weight:700;
            letter-spacing:.10em;
        }
        .header-nav{
            display:flex;
            align-items:center;
            gap:26px;
            font-size:15px;
        }
        .header-nav a{
            color:#fff;
            text-decoration:none;
        }
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{
            font-weight:700;
            text-decoration:underline;
        }
        .header-right{
            display:flex;
            align-items:center;
            gap:16px;
            font-size:14px;
        }
        .btn-logout{
            padding:6px 16px;
            border-radius:4px;
            border:none;
            background:#fff;
            color:#78866B;
            font-weight:600;
            cursor:pointer;
        }

        /* ===== 본문 : 왼쪽 패널 + 오른쪽 지도 ===== */
        .page-wrap{
            flex:1;
            display:flex;
            min-height:0;
            background:#f5f5f5;
        }

        /* 왼쪽 검색 패널 */
        .sidebar{
            width:380px;
            background:#f5f5f5;
            padding:40px 32px;
        }
        .page-title{
            font-size:20px;
            font-weight:700;
            margin-bottom:18px;
        }

        .search-box{
            margin-top:4px;
        }
        .search-bar{
            width:100%;
            height:44px;
            border-radius:4px;
            border:1px solid #d7d7cf;
            background:#fff;
            display:flex;
            align-items:center;
            padding:0 14px;
        }
        .search-input{
            flex:1;
            border:none;
            outline:none;
            background:transparent;
            font-size:13px;
            color:#555;
        }
        .search-btn{
            width:30px;height:30px;
            border:none;background:transparent;
            cursor:pointer;
        }
        .search-btn i{
            font-size:14px;
            color:#555;
        }
        .search-desc{
            margin-top:10px;
            font-size:13px;
            color:#777;
        }

        /* 오른쪽 지도 영역 */
        .map-area{
            flex:1;
            position:relative;
            background:#f3f3f3;
        }
        #map{
            width:100%;
            height:100%;
        }

        .map-pin-btn{
            position:absolute;
            top:20px;
            right:32px;
            width:44px;
            height:44px;
            border-radius:50%;
            border:none;
            background:#fff;
            box-shadow:0 2px 6px rgba(0,0,0,0.18);
            cursor:pointer;
            display:flex;
            align-items:center;
            justify-content:center;
        }
        .map-pin-btn i{
            color:#ff4b6a;
            font-size:18px;
        }

        .map-zoom{
            position:absolute;
            right:32px;
            bottom:32px;
            display:flex;
            flex-direction:column;
            gap:4px;
        }
        .map-zoom button{
            width:30px;
            height:30px;
            border-radius:4px;
            border:1px solid #d0d0d0;
            background:#fff;
            font-size:16px;
            cursor:pointer;
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
        <a href="${pageContext.request.contextPath}/main" class="active">지도</a>
    </nav>

    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <!-- 왼쪽: 검색 패널 -->
    <aside class="sidebar">
        <div class="page-title">대중교통 위치/시간표 - 첫 화면</div>

        <div class="search-box">
            <div class="search-bar">
                <input class="search-input" type="text"
                       placeholder="장소, 주소, 정류장 검색">
                <button class="search-btn" type="button">
                    <i class="fas fa-search"></i>
                </button>
            </div>
            <p class="search-desc">장소, 주소, 정류장을 검색해 주세요.</p>
        </div>
    </aside>

    <!-- 오른쪽: 지도 영역 -->
    <section class="map-area">
        <div id="map"></div>

        <button class="map-pin-btn" type="button">
            <i class="fas fa-map-marker-alt"></i>
        </button>

        <div class="map-zoom">
            <button type="button">+</button>
            <button type="button">-</button>
        </div>
    </section>

</div>

</body>
</html>