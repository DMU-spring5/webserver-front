<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 아이디 찾기 로직에서 넘겨준 userid
    String userid = request.getParameter("userid");
    if (userid == null) {
        Object attr = request.getAttribute("userid");
        if (attr != null) userid = attr.toString();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 완료</title>
    <link rel="stylesheet" type="text/css" href="find_id.css">

    <!-- 존재하지 않는 아이디 처리 -->
    <%
        if (userid == null || userid.trim().equals("")) {
    %>
    <script>
        alert("존재하지 않는 아이디입니다.\n회원가입 진행 후 로그인해주세요.");
        location.href = "<%=request.getContextPath()%>/signup/signupAgree.jsp";
    </script>
    <%
            return;
        }
    %>

</head>
<body>

<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>

<form id="findIdForm">

    <!-- 닉네임 -->
    <div class="nickname-box">
        <label for="nickname">닉네임</label><br>
        <input type="text" id="nickname" name="nickname"
               placeholder="닉네임을 입력해 주세요.">
    </div>

    <!-- 비밀번호 -->
    <div class="pw-box">
        <label for="password">비밀번호</label><br>
        <div class="pw-input-wrap">
            <input type="password" id="password" name="password"
                   placeholder="비밀번호를 입력해 주세요.">
            <img class="eyeoff" id="togglePw" src="../img/eye.png">
        </div>
        <p id="pwError" class="error-msg"></p>
    </div>

    <!-- 찾은 아이디 안내 -->
    <p style="text-align:center; margin:16px 0;">
        회원님의 아이디는 <b><%= userid %></b> 입니다.
    </p>

    <!-- 로그인 -->
    <button type="button" id="findIdBtn" class="active"
            onclick="location.href='login.jsp'">
        로그인하기
    </button>
</form>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const pwInput  = document.getElementById("password");
        const togglePw = document.getElementById("togglePw");

        if (togglePw && pwInput) {
            togglePw.addEventListener("click", () => {
                if (pwInput.type === "password") {
                    pwInput.type = "text";
                    togglePw.src = "../img/eyeoff.png";
                } else {
                    pwInput.type = "password";
                    togglePw.src = "../img/eye.png";
                }
            });
        }
    });
</script>

</body>
</html>
