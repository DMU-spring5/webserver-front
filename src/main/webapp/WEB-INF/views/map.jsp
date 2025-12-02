<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 대중교통 위치/시간표</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: "Noto Sans KR", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background-color: #f5f5f5;
            color: #333;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        header {
            height: 64px;
            background-color: #78866B;
            color: #fff;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .header-logo-box {
            width: 30px;
            height: 30px;
            border-radius: 6px;
            background-color: #fff;
        }
        .header-title {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: .08em;
        }
        .header-nav {
            display: flex;
            align-items: center;
            gap: 24px;
            font-size: 15px;
        }
        .header-nav a {
            color: #fff;
            text-decoration: none;
        }
        .header-nav a:hover { text-decoration: underline; }
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
            padding: 6px 14px;
            border-radius: 6px;
            border: none;
            background-color: #fff;
            color: #78866B;
            font-weight: 600;
            cursor: pointer;
        }

        .main-wrap {
            flex: 1;
            display: flex;
            min-height: 0;
        }
        .sidebar {
            width: 380px;
            background-color: #ffffff;
            padding: 24px 24px;
            border-right: 1px solid #e0e0e0;
        }
        .sidebar-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 18px;
        }
        .search-box {
            display: flex;
            margin-bottom: 10px;
        }
        .search-box input {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-right: none;
            border-radius: 6px 0 0 6px;
            outline: none;
            font-size: 14px;
        }
        .search-box button {
            width: 42px;
            border-radius: 0 6px 6px 0;
            border: 1px solid #ccc;
            background-color: #fff;
            cursor: pointer;
        }
        .search-box button i { font-size: 15px; }
        .sidebar-desc {
            margin-top: 8px;
            font-size: 13px;
            color: #777;
        }

        .map-area {
            flex: 1;
            position: relative;
            background-color: #f0f0f0;
        }
        #map { width: 100%; height: 100%; }

        .map-pin-btn {
            position: absolute;
            top: 16px;
            right: 16px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: none;
            background-color: #ffffff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
            cursor: pointer;
        }
        .map-pin-btn i {
            color: #ff4b6a;
            font-size: 18px;
        }
        .map-zoom {
            position: absolute;
            right: 16px;
            bottom: 16px;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .map-zoom button {
            width: 32px;
            height: 32px;
            border-radius: 4px;
            border: 1px solid #ddd;
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
        <span>니인내조 님</span>
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="main-wrap">
    <aside class="sidebar">
        <h2 class="sidebar-title">대중교통 위치/시간표 - 첫 화면</h2>
        <div class="search-box">
            <input type="text" placeholder="장소, 주소, 정류장 검색">
            <button type="button"><i class="fas fa-search"></i></button>
        </div>
        <p class="sidebar-desc">장소, 주소, 정류장을 검색해 주세요.</p>
    </aside>

    <section class="map-area">
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
