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
    <link rel="stylesheet" type="text/css" href="myinfo.css">
</head>
<body>

<header class="header">
    <div class="header-inner">
        <!-- 로고 -->
        <div class="logo">
            <img src="../img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

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

        <!-- 닉네임 + 로그아웃 -->
        <div class="user-info">
            <span id="headerNickname">- 님</span>
            <form action="../logout/logout.jsp" method="get">
                <button type="submit" class="logout-btn">로그아웃</button>
            </form>
        </div>
    </div>
</header>

<div class="signup-wrap">
    <!-- 프로필 영역 -->
    <div class="profile-img">
        <img src="../img/profile.png" id="previewImg" class="profile">

        <label for="profileInput" class="camera">
            <img src="../img/camera.png" alt="camera">
        </label>

        <input type="file" id="profileInput" accept="image/*" style="display:none;">
    </div>

    <!-- 폼 시작 -->
    <form id="infoForm" action="info_ok.jsp" method="post">

        <!-- 아이디 -->
        <div class="form-box">
            <label>아이디</label>

            <div class="id-input-wrap">
                <input type="text" id="userId" name="userId"
                       placeholder="3~15자 영대소문자, 숫자 사용 가능">
            </div>

            <p id="userIdError" class="error-msg"></p>
        </div>

        <!-- 닉네임 -->
        <div class="form-box">
            <label for="nickname">닉네임</label>
            <input type="text" id="nickname" name="nickname"
                   class="height-48"
                   placeholder="2~8자 영대소문자, 한글, 숫자 사용 가능">
            <p id="nicknameError" class="error-msg"></p>
        </div>

        <!-- 사단 (원래 password였는데 정보 수정용이면 text가 맞음) -->
        <div class="form-box">
            <label for="division">사단</label>
            <div class="pw-area">
                <input type="text" id="division" name="division"
                       class="height-48"
                       placeholder="사단을 입력해 주세요.">
            </div>
            <p id="divisionError" class="error-msg"></p>
        </div>

        <!-- 부대 -->
        <div class="form-box">
            <label for="unit">부대</label>
            <input type="text" id="unit" name="unit"
                   class="height-48"
                   placeholder="부대명을 입력해 주세요.">
            <p id="unitError" class="error-msg"></p>
        </div>

        <div class="form-box">
            <label for="joinDateText">입대 날짜</label><br>

            <input type="hidden" id="joinDate" name="joinDate" value="">

            <input type="text"
                   id="joinDateText"
                   name="joinDateText"
                   placeholder="입대 날짜를 선택해 주세요."
                   readonly
                   autocomplete="off"
                   value="">

            <p id="joinDateError" class="error-msg"></p>
        </div>

        <!-- 수정하기 버튼 -->
        <button type="submit" class="submit-btn">수정하기</button>
    </form>
</div>

<script>
    // ====== API로 내 정보 불러와서 입력칸에 미리 채우기 ======
    const BASE_URL = "https://webserver-backend.onrender.com";
    const accessToken = "<%= accessToken %>";

    if (!accessToken || accessToken.trim().length === 0) {
        location.replace("../login/login.jsp");
    }

    document.addEventListener("DOMContentLoaded", function () {
        fetch(BASE_URL + "/api/v1/mainpage", {
            headers: { "Authorization": "Bearer " + accessToken }
        })
            .then(res => {
                if (res.status === 401 || res.status === 403) {
                    location.replace("../login/login.jsp");
                    return Promise.reject("Unauthorized");
                }
                if (!res.ok) {
                    return res.text().then(t => Promise.reject("MyInfo API error: " + res.status + " / " + t));
                }
                return res.json();
            })
            .then(data => {
                // 헤더 닉네임
                var nick = data.nickname ? data.nickname : "-";
                document.getElementById("headerNickname").textContent = nick + "  님";

                // 입력칸 채우기 (서버 키가 다를 수 있어 여러 후보로 받음)
                document.getElementById("userId").value =
                    (data.userId ? data.userId : (data.userid ? data.userid : (data.username ? data.username : "")));

                document.getElementById("nickname").value = (data.nickname ? data.nickname : "");
                document.getElementById("division").value = (data.division ? data.division : "");
                document.getElementById("unit").value = (data.unit ? data.unit : "");

                // 입대 날짜
                if (data.enlistDate) {
                    document.getElementById("joinDate").value = data.enlistDate;
                    document.getElementById("joinDateText").value = data.enlistDate;
                    document.getElementById("joinDateText").setAttribute("value", data.enlistDate);
                    document.getElementById("joinDateText").style.color = "black";
                }
            })
            .catch(err => {
                console.error(err);
            });
    });
</script>

<!-- ====== 프로필 이미지 미리보기 (기존 유지) ====== -->
<script>
    const profileInput = document.getElementById("profileInput");
    const previewImg   = document.getElementById("previewImg");

    if (profileInput) {
        profileInput.addEventListener("change", () => {
            const file = profileInput.files[0];
            if (file) {
                previewImg.src = URL.createObjectURL(file);
            }
        });
    }
</script>

</body>
</html>
