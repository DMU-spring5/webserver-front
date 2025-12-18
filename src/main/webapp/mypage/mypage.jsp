<%@ page contentType="text/html; charset=UTF-8" language="java" isELIgnored="true" %>
<%
    String accessToken = (String) session.getAttribute("accessToken");
    if (accessToken == null) accessToken = "";
%>
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
                <a href="../main/mainpage.jsp">뉴스</a>
                <span class="divider">|</span>
                <a href="../social/social_board.jsp">소셜</a>
                <span class="divider">|</span>
                <a href="../views/health.jsp">건강</a>
                <span class="divider">|</span>
                <a href="../map/map.jsp">지도</a>
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

        <div class="profile-text">
            <p class="profile-name" id="profileName"><strong>...</strong>&nbsp;&nbsp;님</p>
            <p id="division">사단 : ...</p>
            <p id="unit">부대명 : ...</p>
            <p id="rank">계급 : ...</p>
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
            <br />
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
            <a href="myinfo.jsp" class="menu-item">
                <span>내 정보</span>
                <span class="arrow">&gt;</span>
            </a>
            <a href="change_pw.jsp" class="menu-item">
                <span>비밀번호 변경</span>
                <span class="arrow">&gt;</span>
            </a>
        </div>

        <div class="menu-column">
            <a href="post.jsp" class="menu-item">
                <span>게시판 관리</span>
                <span class="arrow">&gt;</span>
            </a>
            <a class="menu-item" id="openWithdrawModal" style="cursor:pointer;">
                <span>회원탈퇴</span>
            </a>
        </div>
    </section>
</main>

<script>
    // 프로필 이미지 미리보기 함수
    function previewImage() {
        const fileInput = document.getElementById('profileInput');
        if (!fileInput) return;

        const file = fileInput.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onloadend = function () {
            document.getElementById('previewImg').src = reader.result;
        };
        reader.readAsDataURL(file);
    }
</script>

<!-- ✅ (수정) 메인페이지와 동일 API로 프로필 정보 채우기 -->
<script>
    const BASE_URL = "https://webserver-backend.onrender.com";
    const accessToken = "<%= accessToken %>";

    // 토큰 없으면 로그인으로
    if (!accessToken || accessToken.trim().length === 0) {
        location.replace("../login/login.jsp");
    }

    function getRank(type, days) {
        if (type === "army") return days < 100 ? "이병" : days < 270 ? "일병" : days < 450 ? "상병" : "병장";
        if (type === "navy") return days < 120 ? "이병" : days < 300 ? "일병" : days < 500 ? "상병" : "병장";
        if (type === "airforce") return days < 140 ? "이병" : days < 320 ? "일병" : days < 520 ? "상병" : "병장";
        return "-";
    }

    fetch(BASE_URL + "/api/v1/mainpage", {
        headers: { "Authorization": "Bearer " + accessToken }
    })
        .then(res => {
            if (res.status === 401 || res.status === 403) {
                location.replace("../login/login.jsp");
                return Promise.reject("Unauthorized");
            }
            if (!res.ok) {
                return res.text().then(t => Promise.reject("Mypage API error: " + res.status + " / " + t));
            }
            return res.json();
        })
        .then(data => {
            // 이름(닉네임) -> profileName
            const name = data.nickname ?? "-";
            document.getElementById('profileName').innerHTML = `<strong>${name}</strong>&nbsp;&nbsp;님`;

            // 사단/부대명
            document.getElementById("division").textContent =
                "사단 : " + (data.division ? data.division : "-");

            document.getElementById("unit").textContent =
                "부대명 : " + (data.unit ? data.unit : "-");


            // 계급 + D-day 계산 (메인페이지와 동일)
            if (data.enlistDate && data.serviceType) {
                const enlist = new Date(data.enlistDate);
                const today = new Date();

                const passed = Math.floor((today - enlist) / (1000 * 60 * 60 * 24));

                const months = { army:18, navy:20, airforce:21 };
                const discharge = new Date(enlist);
                discharge.setMonth(discharge.getMonth() + (months[data.serviceType] || 0));
                discharge.setDate(discharge.getDate() - 1);

                const dday = Math.ceil((discharge - today) / (1000 * 60 * 60 * 24));
                const rankText = getRank(data.serviceType, passed);

                document.getElementById("rank").textContent = `계급 : ${rankText}`;

                const ddayEl = document.querySelector(".d-day");
                if (ddayEl) ddayEl.textContent = "D - " + dday;
            } else {
                document.getElementById("rank").textContent = "계급 : -";
            }
        })
        .catch(err => {
            console.error(err);

            // 실패 시 기본값
            document.getElementById('profileName').innerHTML = `<strong>알 수 없음</strong>&nbsp;&nbsp;님`;
            document.getElementById("division").textContent = "사단 : 알 수 없음";
            document.getElementById("unit").textContent = "부대명 : 알 수 없음";
            document.getElementById("rank").textContent = "계급 : 알 수 없음";
        });
</script>

<div id="withdrawModal" class="modal-overlay">
    <div class="modal-box">
        <h2 class="modal-title">Milli Road를 탈퇴하시겠습니까?</h2>

        <p class="modal-desc">
            탈퇴 후에는 계정을 복구할 수 없으며,<br>
            더 이상 서비스를 이용할 수 없습니다.
        </p>

        <!-- 비밀번호 입력 + 눈 아이콘 -->
        <div class="pw-wrap">
            <input
                    type="password"
                    id="withdrawPw"
                    class="modal-input"
                    placeholder="비밀번호를 입력해 주세요."
            >
            <img src="<%=request.getContextPath()%>/img/eye.png" id="togglePw" class="pw-eye" alt="비밀번호 보기">
        </div>
        <!-- 오류 메시지 -->
        <p id="withdrawError" class="modal-error"></p>

        <div class="modal-buttons">
            <button id="cancelWithdraw" class="btn-cancel" type="button">취소</button>
            <button id="confirmWithdraw" class="btn-withdraw" type="button">탈퇴하기</button>
        </div>
    </div>
</div>

<script>
    const openWithdrawModal = document.getElementById("openWithdrawModal");
    const withdrawModal = document.getElementById("withdrawModal");
    const cancelWithdraw = document.getElementById("cancelWithdraw");
    const confirmWithdraw = document.getElementById("confirmWithdraw");
    const withdrawPw = document.getElementById("withdrawPw");
    const withdrawError = document.getElementById("withdrawError");
    const togglePw = document.getElementById("togglePw");

    // 세션에 저장된 실제 비밀번호 (예시)
    <%
        String realPw = (String) session.getAttribute("password");
        if (realPw == null) realPw = "";
    %>
    const realPassword = "<%= realPw %>";

    // 모달 열기
    openWithdrawModal.addEventListener("click", function(e) {
        e.preventDefault();
        withdrawModal.style.display = "flex";
        withdrawPw.value = "";
        withdrawError.textContent = "";
        withdrawPw.type = "password";
        togglePw.src = "../img/eye.png";
    });

    // 모달 닫기
    cancelWithdraw.addEventListener("click", function() {
        withdrawModal.style.display = "none";
    });

    // 모달 바깥 클릭 시 닫기
    withdrawModal.addEventListener("click", function(e) {
        if (e.target === withdrawModal) {
            withdrawModal.style.display = "none";
        }
    });

    // ESC로 닫기
    document.addEventListener("keydown", function(e) {
        if (e.key === "Escape") {
            withdrawModal.style.display = "none";
        }
    });

    // 눈 아이콘 클릭 시 비밀번호 보기/숨기기
    togglePw.addEventListener("click", function() {
        if (withdrawPw.type === "password") {
            withdrawPw.type = "text";
            togglePw.src = "<%=request.getContextPath()%>/img/eyeoff.png";
        } else {
            withdrawPw.type = "password";
            togglePw.src = "<%=request.getContextPath()%>/img/eye.png";
        }
    });

    // 탈퇴 버튼 클릭
    confirmWithdraw.addEventListener("click", function() {
        const inputPw = withdrawPw.value.trim();

        if (inputPw === "") {
            withdrawError.textContent = "비밀번호를 입력해 주세요.";
            return;
        }

        if (inputPw !== realPassword) {
            withdrawError.textContent = "비밀번호가 일치하지 않습니다.";
            return;
        }

        alert("탈퇴가 완료되었습니다.");
        window.location.href = "index.jsp";
    });
</script>
</body>
</html>
