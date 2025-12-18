<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - MILLI ROAD</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body class="login-body">

<!-- 로고 영역 -->
<img src="${pageContext.request.contextPath}/img/WebServerLogo.png" alt="Logo">

<!-- 로그인 폼 -->
<form id="loginForm" action="${pageContext.request.contextPath}/login/login_ok.jsp" method="post">

    <div class="id-box">
        <label for="userid">아이디</label>
        <input type="text" id="userid" name="userid" placeholder="아이디를 입력하세요" required>
    </div>

    <div class="pw-box">
        <label for="userpw">비밀번호</label>
        <div class="pw-input-wrap">
            <input type="password" id="userpw" name="userpw" placeholder="비밀번호를 입력하세요" required>

            <img
                    id="togglePw"
                    src="${pageContext.request.contextPath}/img/eye.png"
                    class="eyeoff"
                    alt=""
                    style="cursor:pointer;"
            >
        </div>
    </div>

    <% if(request.getParameter("msg") != null) { %>
    <div id="errorMsg"><%= java.net.URLDecoder.decode(request.getParameter("msg"), "UTF-8") %></div>
    <% } %>

    <label>
        <input type="checkbox" name="autoLogin"> 자동 로그인
    </label>

    <button type="submit" id="loginBtn">로그인</button>

    <div class="link-box">
        <a href="${pageContext.request.contextPath}/login/find_id.jsp">아이디 찾기</a> |
        <a href="${pageContext.request.contextPath}/login/find_pw.jsp">비밀번호 찾기</a> |
        <a href="${pageContext.request.contextPath}/signup/signupAgree.jsp">회원가입</a>
    </div>
</form>

<script>
    // 버튼 색상 변경
    const uid = document.getElementById("userid");
    const upw = document.getElementById("userpw");
    const btn = document.getElementById("loginBtn");

    function checkInput() {
        if(uid.value.length > 0 && upw.value.length > 0) {
            btn.classList.add("active");
            btn.style.backgroundColor = "#78866B";
        } else {
            btn.classList.remove("active");
            btn.style.backgroundColor = "#A1A49D";
        }
    }
    uid.addEventListener("keyup", checkInput);
    upw.addEventListener("keyup", checkInput);

    const togglePw = document.getElementById("togglePw");
    const CTX = "${pageContext.request.contextPath}";

    togglePw.addEventListener("click", () => {
        const isPw = upw.type === "password";
        upw.type = isPw ? "text" : "password";
        togglePw.src = isPw ? (CTX + "/img/eyeoff.png") : (CTX + "/img/eye.png");
    });
</script>

</body>
</html>
