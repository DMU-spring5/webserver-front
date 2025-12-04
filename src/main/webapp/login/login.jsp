<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" type="text/css" href="login.css">
</head>
<%
    String idErrorParam = request.getParameter("idError");
    String pwErrorParam = request.getParameter("pwError");
%>
<body>
<!-- 로고 영역 (아이디 찾기와 동일 구조로 div 감싸기) -->
<div class="logo-wrap">
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png" alt="MILLI ROAD 로고">
</div>

<form id="loginForm" action="login_ok.jsp" method="post">
    <!-- 아이디 -->
    <div class="id-box">
        <input type="text" id="userid" name="userid" placeholder="아이디" autocomplete="off">
        <p id="idError"><%= (idErrorParam != null ? idErrorParam : "") %></p>
    </div>

    <!-- 비밀번호 -->
    <div class="pw-box">
        <div class="pw-input-wrap"><!-- 입력창 + 아이콘 래퍼 -->
            <input type="password" id="userpw" name="userpw"
                   placeholder="비밀번호" autocomplete="off">
            <img class="eyeoff" id="togglePw" src="../img/eye.png">
        </div>
        <p id="pwError" class="error-msg">
            <%= (pwErrorParam != null ? pwErrorParam : "") %>
        </p>
    </div>

    <!-- 자동 로그인 -->
    <label>
        <input type="checkbox" name="autoLogin" value="N">
        자동 로그인
    </label><br>

    <!-- 로그인 버튼 -->
    <button type="submit" id="loginBtn">로그인</button>

    <!-- 링크 -->
    <div class="link-box">
        <a href="find_id.jsp">아이디 찾기</a> |
        <a href="find_pw.jsp">비밀번호 찾기</a> |
        <a href="<%=request.getContextPath()%>/signup/signupAgree.jsp">회원가입</a>
    </div><br>
</form>
</body>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const pwInput   = document.getElementById("userpw");
        const userid    = document.getElementById("userid");
        const togglePw  = document.getElementById("togglePw");
        const loginBtn  = document.getElementById("loginBtn");
        const loginForm = document.getElementById("loginForm");

        const idError = document.getElementById("idError");
        const pwError = document.getElementById("pwError");

        /* 페이지 돌아왔을 때 값 비우기 */
        userid.value = "";
        pwInput.value = "";

        /* 비밀번호 보기/숨기기 */
        togglePw.addEventListener("click", () => {
            if (pwInput.type === "password") {
                pwInput.type = "text";
                togglePw.src = "../img/eyeoff.png";
            } else {
                pwInput.type = "password";
                togglePw.src = "../img/eye.png";
            }
        });

        /* 버튼 색상 변경 */
        function checkInputs() {
            if (userid.value.trim() !== "" && pwInput.value.trim() !== "") {
                loginBtn.classList.add("active");
            } else {
                loginBtn.classList.remove("active");
            }
        }

        userid.addEventListener("input", () => {
            idError.textContent = "";
            checkInputs();
        });

        pwInput.addEventListener("input", () => {
            pwError.textContent = "";
            checkInputs();
        });

        checkInputs(); // 초기 상태 설정

        /* 제출 시 아이디/비밀번호 미입력 체크 */
        loginForm.addEventListener("submit", (e) => {
            let hasError = false;

            // 기존 서버에서 내려온 문구 초기화
            idError.textContent = "";
            pwError.textContent = "";

            if (userid.value.trim() === "") {
                idError.textContent = "아이디를 입력해 주세요.";
                hasError = true;
            }
            if (pwInput.value.trim() === "") {
                pwError.textContent = "비밀번호를 입력해 주세요.";
                hasError = true;
            }

            if (hasError) {
                e.preventDefault(); // 전송 막기
            }
        });
    });
</script>
</html>
