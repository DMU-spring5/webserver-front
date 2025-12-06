<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MyPage</title>
    <link rel="stylesheet" type="text/css" href="change_pw.css">
    <script>
        // 페이지 로드 시 오류 메시지 숨기기
        window.onload = function() {
            const originalInput = document.getElementById("original");
            const newInput = document.getElementById("new");
            const passwordInput = document.getElementById("password");

            // 오류 메시지 숨기기
            document.getElementById("originalPw-Error").style.display = 'none';
            document.getElementById("newPw-Error").style.display = 'none';
            document.getElementById("checkPw-Error").style.display = 'none';

            // 입력 필드에 값이 입력되면 오류 메시지 숨기기
            originalInput.addEventListener("input", function() {
                if (originalInput.value !== "") {
                    document.getElementById("originalPw-Error").style.display = 'none';
                }
            });
            newInput.addEventListener("input", function() {
                if (newInput.value !== "") {
                    document.getElementById("newPw-Error").style.display = 'none';
                }
            });
            passwordInput.addEventListener("input", function() {
                if (passwordInput.value !== "") {
                    document.getElementById("checkPw-Error").style.display = 'none';
                }
            });
        };

        // 폼 제출 시 유효성 검사
        function validateForm(event) {
            const original = document.getElementById("original").value;
            const newPw = document.getElementById("new").value;
            const password = document.getElementById("password").value;

            let isValid = true;

            // 기존 비밀번호가 비어있으면 오류 메시지 표시
            if (original === "") {
                document.getElementById("originalPw-Error").textContent = "기존 비밀번호를 입력해 주세요.";
                document.getElementById("originalPw-Error").style.display = 'block';
                isValid = false;
            }

            // 새 비밀번호가 비어있으면 오류 메시지 표시
            if (newPw === "") {
                document.getElementById("newPw-Error").textContent = "새 비밀번호를 입력해 주세요.";
                document.getElementById("newPw-Error").style.display = 'block';
                isValid = false;
            }

            // 비밀번호 확인이 비어있으면 오류 메시지 표시
            if (password === "") {
                document.getElementById("checkPw-Error").textContent = "비밀번호를 다시 입력해 주세요.";
                document.getElementById("checkPw-Error").style.display = 'block';
                isValid = false;
            }

            // 비밀번호 변경을 막고, 유효성 검사에 실패했을 경우
            if (!isValid) {
                event.preventDefault();
            }
        }

    </script>
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
    <form id="infoForm" action="pwCheck.jsp" method="post" onsubmit="validateForm(event)">
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
        <button type="submit" class="change-btn">비밀번호 변경</button>
    </form>
</div>
</body>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const pwInputs = document.querySelectorAll('.password-input');
        const togglePwIcons = document.querySelectorAll('.togglePw');
        const form = document.getElementById('infoForm');
        const changeBtn = document.getElementById('change-Btn');

        /* 비밀번호 보기/숨기기 */
        togglePwIcons.forEach((icon, index) => {
            const input = pwInputs[index];

            input.type = "password";

            icon.addEventListener("click", () => {
                if (input.type === "password") {
                    input.type = "text";
                    icon.src = "../img/eyeoff.png";
                } else {
                    input.type = "password";
                    icon.src = "../img/eye.png";
                }
            });
        });

        pwInputs.forEach(input => {
            input.addEventListener("input", checkInputs);
        });

        function checkInputs() {
            const allFilled = [...pwInputs].every(input => input.value !== "");

            if (allFilled) {
                form.classList.add('all-filled');
                changeBtn.classList.add('active');
            } else {
                form.classList.remove('all-filled');
                changeBtn.classList.remove('active');
            }
        }
    });
</script>
</html>
