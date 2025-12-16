<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - MILLI ROAD</title>
    <!-- 통합 CSS 연결 -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/index.css">
</head>
<!-- 중요: body에 login-body 클래스를 주어야 로그인용 CSS가 적용됩니다 -->
<body class="login-body">

<!-- 로고 영역 -->
<img src="${pageContext.request.contextPath}/img/WebServerLogo2.png" alt="Logo">

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
            <!-- 눈 아이콘 (이미지 경로 확인 필요) -->
            <img src="${pageContext.request.contextPath}/img/eye_off.png" class="eyeoff" alt="pw toggle">
        </div>
    </div>

    <!-- 에러 메시지 표시 (파라미터로 전달된 경우) -->
    <% if(request.getParameter("msg") != null) { %>
    <div id="errorMsg"><%= java.net.URLDecoder.decode(request.getParameter("msg"), "UTF-8") %></div>
    <% } %>

    <label>
        <input type="checkbox" name="autoLogin"> 자동 로그인
    </label>

    <button type="submit" id="loginBtn">로그인</button>

    <div class="link-box">
        <a href="#">아이디 찾기</a> | <a href="#">비밀번호 찾기</a> | <a href="#">회원가입</a>
    </div>
</form>

<script>
    // 간단한 버튼 색상 변경 스크립트
    const uid = document.getElementById("userid");
    const upw = document.getElementById("userpw");
    const btn = document.getElementById("loginBtn");

    function checkInput() {
        if(uid.value.length > 0 && upw.value.length > 0) {
            btn.classList.add("active");
            btn.style.backgroundColor = "#78866B"; // 활성 색상
        } else {
            btn.classList.remove("active");
            btn.style.backgroundColor = "#A1A49D"; // 비활성 색상
        }
    }

    uid.addEventListener("keyup", checkInput);
    upw.addEventListener("keyup", checkInput);
</script>
</body>
</html>
