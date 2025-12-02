<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 대중교통 위치/시간표</title>

    <!-- 검색/핀 아이콘용 -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Noto Sans KR", -apple-system, BlinkMacSystemFont,
            "Segoe UI", system-ui, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ===== 헤더 ===== */
        header {
            height: 64px;
            background-color: #78866B;
            color: #fff;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .header-logo-box {
            width: 34px;
            height: 34px;
            border-radius: 4px;
            background-color: #fff;
        }

        .header-title {
            font-size: 22px;
            font-weight: 700;
            letter-spacing: .10em;
        }

        .header-nav {
            display: flex;
            align-items: center;
            gap: 26px;
            font-size: 15px;
        }

        .header-nav a {
            color: #fff;
            text-decoration: none;
        }

        .header-nav a:hover {
            text-decoration: underline;
        }

        .header-nav a.active {
            font-weight: 700;
            text-decoration: underline;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 14px;
        }

        .btn-logout {
            padding: 6px 16px;
            border-radius: 4px;
            border: none;
            background-color: #fff;
            color: #78866B;
            font-weight: 600;
            cursor: pointer;
        }

        /* ===== 본문: 화면 전체 사용 (가운데 정렬 X) ===== */
        .main-wrap {
            flex: 1;
            display: flex;
            min-height: 0;
        }

        /* 왼쪽 패널 */
        .sidebar {
            width: 380px;
            background-color: #ffffff;
            padding: 26px 28px;
            border-right: 1px solid #e4e4e4;
        }

        .sidebar-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .search-box {
            display: flex;
            margin-bottom: 10px;
        }

        .search-box input {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #cfcfcf;
            border-right: none;
            border-radius: 4px 0 0 4px;
            font-size: 13px;
            outline: none;
        }

        .search-box button {
            width: 44px;
            border-radius: 0 4px 4px 0;
            border: 1px solid #cfcfcf;
            background-color: #fff;
            cursor: pointer;
        }

        .search-box button i {
            font-size: 14px;
        }

        .sidebar-desc {
            margin-top: 8px;
            font-size: 13px;
            color: #777;
        }

        /* 오른쪽 지도 영역 */
        .map-area {
            flex: 1;
            position: relative;
            background-color: #f3f3f3;
        }

        #map {
            width: 100%;
            height: 100%;
        }

        /* 핀 버튼 */
        .map-pin-btn {
            position: absolute;
            top: 18px;
            right: 26px;
            width: 46px;
            height: 46px;
            border-radius: 50%;
            border: none;
            background-color: #ffffff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.18);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .map-pin-btn i {
            color: #ff4b6a;
            font-size: 18px;
        }

        /* 줌 버튼 (+ / -) */
        .map-zoom {
            position: absolute;
            right: 24px;
            bottom: 24px;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .map-zoom button {
            width: 32px;
            height: 32px;
            border-radius: 4px;
            border: 1px solid #d0d0d0;
            background-color: #ffffff;
            font-size: 18px;
            cursor: pointer;
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

<div class="main-wrap">
    <!-- 왼쪽 검색 패널 -->
    <aside class="sidebar">
        <h2 class="sidebar-title">대중교통 위치/시간표 - 첫 화면</h2>

        <div class="search-box">
            <input type="text" placeholder="장소, 주소, 정류장 검색">
            <button type="button"><i class="fas fa-search"></i></button>
        </div>

        <p class="sidebar-desc">장소, 주소, 정류장을 검색해 주세요.</p>
    </aside>

    <!-- 오른쪽 지도 영역 -->
    <section class="map-area">
        <!-- 실제 지도 대신 회색 영역 -->
        <div id="map"></div>

        <button type="button" class="map-pin-btn">
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
