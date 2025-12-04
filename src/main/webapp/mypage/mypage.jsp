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

            <label for="profileInput" class="camera">
                <img src="../img/camera.png" alt="camera">
            </label>

            <input type="file" id="profileInput" accept="image/*" style="display:none;" onchange="previewImage();">
        </div>

            <div class="profile-text">
                <p class="profile-name"><strong>니인내조</strong> 님</p>
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

<script>
    // 프로필 이미지 미리보기 함수
    function previewImage() {
        const file = document.getElementById('profileInput').files[0];
        const reader = new FileReader();

        reader.onloadend = function () {
            document.getElementById('previewImg').src = reader.result;
        }

        if (file) {
            reader.readAsDataURL(file);
        }
    }
</script>

</body>
</html>
