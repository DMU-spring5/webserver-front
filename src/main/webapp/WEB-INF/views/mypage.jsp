<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MyPage</title>
    <link rel="stylesheet" type="text/css" href="mypage.css">
</head>
<body>
<!-- 상단 헤더 -->
<header class="header">
    <div class="header-inner">
        <!-- 로고 -->
        <div class="logo">
            <img src="../img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

        <!-- 검색 + 메뉴 영역 -->
        <div class="header-center">
            <!-- 메뉴 -->
            <nav class="nav">
                <a href="index.jsp" class="active">뉴스</a>
                <a href="index.jsp">뉴스</a>
                <span class="divider">|</span>
                <a href="#">소셜</a>
                <span class="divider">|</span>
                <a href="health/health.jsp">건강</a>
                <span class="divider">|</span>
                <a href="#">지도</a>
            </nav>
        </div>
    </div>
</header>

<!-- 메인 영역 -->
<main class="mypage-wrap">

    <!-- 상단 구분선 -->
    <div class="top-line"></div>

    <!-- 프로필 카드 -->
    <section class="profile-card">
        <!-- 프로필 영역 -->
        <div class="profile-img">
            <img src="../img/profile.png" id="previewImg" class="profile" alt="Profile Image">
        </div>
