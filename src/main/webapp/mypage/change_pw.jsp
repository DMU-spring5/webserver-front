<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MyPage</title>
    <link rel="stylesheet" type="text/css" href="change_pw.css">
</head>
<body>
<%
    HttpSession userSession = request.getSession();
    String nickname = (String) session.getAttribute("nickname"); // 세션에서 닉네임 가져오기
%>
<header class="header">
    <div class="header-inner">
        <!-- 로고 -->
        <div class="logo">
            <img src="../img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

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

        <!-- 닉네임 + 로그아웃 -->
        <div class="user-info">
            <span><%= nickname %> &nbsp &nbsp님</span>
            <form action="logout/logout.jsp" method="post">
                <button type="submit" class="logout-btn">로그아웃</button>
            </form>
        </div>
    </div>
</header>
<div class="wrap">
    <h3>비밀번호 변경</h3>
    <!-- 폼 시작 -->
    <form id="infoForm" action="pwCheck.jsp" method="post">
        <!-- 기존 비밀번호 -->
        <div class="form-box">
            <label>기존 비밀번호</label>
            <div class="pw-area">
                <input type="text" id="original" name="original" placeholder="기존 비밀번호를 입력해 주세요" class="password-input">
                <img class="togglePw" src="../img/eye.png" alt="Toggle Password Visibility">
            </div>
            <p id="originalPw-Error" class="error-msg"></p>
        </div>

        <!-- 새 비밀번호 -->
        <div class="form-box">
            <label for="new-pw">새 비밀번호</label>
            <div class="pw-area">
                <input type="text" id="new" name="new" placeholder="8-16자 영대소문자, 숫자, 특수문자 사용 가능" class="password-input">
                <img class="togglePw" src="../img/eye.png" alt="Toggle Password Visibility">
            </div>
            <p id="newPw-Error" class="error-msg"></p>
        </div>

        <!-- 비밀번호 확인 -->
        <div class="form-box">
            <label for="check-pw">비밀번호 확인</label>
            <div class="pw-area">
                <input type="password" id="password" name="password" placeholder="비밀번호를 다시 입력해 주세요" class="password-input">
                <img class="togglePw" src="../img/eye.png" alt="Toggle Password Visibility">
            </div>
            <p id="checkPw-Error" class="error-msg"></p>
        </div>

        <!-- 비밀번호 변경 버튼 -->
        <button type="submit" id="change-Btn" class="change-btn">비밀번호 변경</button>
    </form>
</div>

<!-- 모든 JS를 여기 한 곳에 통합 -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const originalInput = document.getElementById("original");
        const newInput = document.getElementById("new");
        const passwordInput = document.getElementById("password");
        const form = document.getElementById('infoForm');
        const pwInputs = document.querySelectorAll('.password-input');
        const togglePwIcons = document.querySelectorAll('.togglePw');
        const changeBtn = document.getElementById('change-Btn');

        // 초기화: 오류 메시지 숨기기
        const originalError = document.getElementById("originalPw-Error");
        const newError = document.getElementById("newPw-Error");
        const checkError = document.getElementById("checkPw-Error");

        originalError.style.display = 'none';
        newError.style.display = 'none';
        checkError.style.display = 'none';

        // 입력 필드에 값이 입력되면 해당 오류 메시지 숨기기
        originalInput.addEventListener("input", () => {
            if (originalInput.value !== "") originalError.style.display = 'none';
            checkInputs();
        });
        newInput.addEventListener("input", () => {
            if (newInput.value !== "") newError.style.display = 'none';
            checkInputs();
        });
        passwordInput.addEventListener("input", () => {
            if (passwordInput.value !== "") checkError.style.display = 'none';
            checkInputs();
        });

        // pwInputs 초기 타입을 password로 맞춤 (HTML이 text로 되어 있어도 안전하게 처리)
        pwInputs.forEach(input => {
            try { input.type = "password"; } catch (e) { /* ignore */ }
        });

        // 비밀번호 보기/숨기기 토글
        togglePwIcons.forEach((icon, index) => {
            const input = pwInputs[index];
            icon.addEventListener("click", () => {
                if (!input) return;
                if (input.type === "password") {
                    input.type = "text";
                    icon.src = "../img/eyeoff.png";
                } else {
                    input.type = "password";
                    icon.src = "../img/eye.png";
                }
            });
        });

        // 폼 제출 시 유효성 검사
        form.addEventListener("submit", function(event) {
            // call validateForm equivalent
            const original = originalInput.value.trim();
            const newPw = newInput.value.trim();
            const password = passwordInput.value.trim();

            let isValid = true;

            // 초기화 (숨김)
            originalError.style.display = 'none';
            newError.style.display = 'none';
            checkError.style.display = 'none';

            if (original === "") {
                originalError.textContent = "기존 비밀번호를 입력해 주세요";
                originalError.style.display = 'block';
                isValid = false;
            }

            if (newPw === "") {
                newError.textContent = "새 비밀번호를 입력해 주세요";
                newError.style.display = 'block';
                isValid = false;
            }

            if (password === "") {
                checkError.textContent = "비밀번호를 다시 입력해 주세요";
                checkError.style.display = 'block';
                isValid = false;
            }

            // 새 비밀번호와 확인 일치 검사
            if (newPw !== "" && password !== "" && newPw !== password) {
                checkError.textContent = "새 비밀번호와 일치하지 않습니다";
                checkError.style.display = 'block';
                isValid = false;
            }

            // 새 비밀번호가 기존 비밀번호와 같은지 검사
            if (newPw !== "" && original !== "" && newPw === original) {
                newError.textContent = "기존 비밀번호와 동일한 비밀번호는 사용할 수 없습니다";
                newError.style.display = 'block';
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
            // isValid면 폼은 서버로 전송됨 (pwCheck.jsp)
        });

        // 입력값 전부 채워졌는지 체크해 버튼 활성화/비활성화 처리
        function checkInputs() {
            const allFilled = [...pwInputs].every(input => input.value.trim() !== "");
            if (allFilled) {
                form.classList.add('all-filled');
                if (changeBtn) changeBtn.classList.add('active');
            } else {
                form.classList.remove('all-filled');
                if (changeBtn) changeBtn.classList.remove('active');
            }
        }

        checkInputs();
    });
</script>
</body>
</html>
