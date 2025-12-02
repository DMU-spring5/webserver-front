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
            <!-- 실제 로고 이미지 경로로 변경 -->
            <img src="../img/WebServerLogo.png" alt="MILLI ROAD 로고">
        </div>

        <!-- 메뉴 -->
        <nav class="gnb">
            <a href="#">뉴스</a>
            <span class="divider">|</span>
            <a href="#">소셜</a>
            <span class="divider">|</span>
            <a href="#">건강</a>
            <span class="divider">|</span>
            <a href="#">대중교통 위치 / 시간표</a>
        </nav>

        <!-- 우측 사용자 정보 + 로그아웃 -->
        <div class="header-right">
            <span class="header-username">니인내죠 님</span>
            <button type="button" class="btn-logout">로그아웃</button>
        </div>
    </div>
</header>

<!-- 메인 영역 -->
<main class="mypage-wrap">

    <!-- 상단 구분선 -->
    <div class="top-line"></div>

    <!-- 프로필 카드 -->
    <section class="profile-card">
        <!-- 왼쪽: 프로필 -->
        <div class="profile-left">
            <div class="profile-img-wrap">
                <div class="profile-img"><!-- 아이콘 자리 --></div>
                <div class="profile-camera"><!-- 카메라 아이콘 자리 --></div>
            </div>

            <div class="profile-text">
                <p class="profile-name"><strong>니인내죠</strong> 님</p>
                <p>사단 : 1사단</p>
                <p>부대명 : 제11보병여단</p>
                <p>계급 : 일병</p>
            </div>
        </div>

        <!-- 오른쪽: D-day + 진행바 -->
        <div class="profile-right">
            <div class="d-day">D - 433</div>

            <div class="progress-row">
                <span class="progress-label">상병까지 34.3%</span>
                <div class="progress-bar">
                    <div class="progress-fill fill-green" style="width:34.3%;"></div>
                </div>
            </div>

            <div class="progress-row">
                <span class="progress-label">전역까지 89.1%</span>
                <div class="progress-bar">
                    <div class="progress-fill fill-gray" style="width:89.1%;"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- 중간 구분선 -->
    <div class="middle-line"></div>

    <!-- 마이페이지 메뉴 -->
    <section class="mypage-menu">
        <div class="menu-column">
            <a href="#" class="menu-item">
                <span>내 정보</span>
                <span class="arrow">&gt;</span>
            </a>
            <a href="#" class="menu-item">
                <span>비밀번호 변경</span>
                <span class="arrow">&gt;</span>
            </a>
        </div>

        <div class="menu-column">
            <a href="#" class="menu-item">
                <span>게시판 관리</span>
                <span class="arrow">&gt;</span>
            </a>
            <a href="#" class="menu-item">
                <span>회원탈퇴</span>
                <span class="arrow">&gt;</span>
            </a>
        </div>
    </section>

</main>

</body>
</html>
