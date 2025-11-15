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
<img src="<%=request.getContextPath()%>/img/WebServerLogo.png">

<form id="loginForm" action="login_ok.jsp" method="post">
    <!-- 아이디 -->
    <div class="id-box">
        <input type="text" id="userid" name="userid" placeholder="아이디" autocomplete="off">
        <p id="idError"><%= (idErrorParam != null ? idErrorParam : "") %></p>
    </div>

    <!-- 비밀번호 -->
    <div class="pw-box">
        <input type="password" id="userpw" name="userpw" placeholder="비밀번호" autocomplete="off">
        <img class="eyeoff" id="togglePw" src="../img/eye.png">
    </div>
    <p id="pwError" class="error-msg">
        <%= (pwErrorParam != null ? pwErrorParam : "") %>
    </p>

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
        <a href="signup.jsp">회원가입</a>
    </div><br>
</form>

</body>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const pwInput = document.getElementById("userpw");
        const userid = document.getElementById("userid");
        const togglePw = document.getElementById("togglePw");
        const loginBtn = document.getElementById("loginBtn");

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

        /* 버튼 활성/비활성 */
        function checkInputs() {
            if (userid.value.trim() !== "" && pwInput.value.trim() !== "") {
                loginBtn.classList.add("active");
                loginBtn.disabled = false;
            } else {
                loginBtn.classList.remove("active");
                loginBtn.disabled = true;
            }
        }

        userid.addEventListener("input", checkInputs);
        pwInput.addEventListener("input", checkInputs);
        checkInputs();
    });
</script>

</html>
