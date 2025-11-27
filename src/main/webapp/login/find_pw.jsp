<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" type="text/css" href="find_pw.css">
</head>
<body>
<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>

<form id="findPwForm" action="find_pw_ok.jsp" method="post">
    <!-- 닉네임 -->
    <div class="nickname-box">
        <label for="nickname">닉네임</label><br>
        <input type="text" id="nickname" name="nickname"
               placeholder="닉네임을 입력해 주세요.">
        <p id="nickError" class="error-msg" style="margin:4px 0 10px 2px;"></p>
    </div>

    <!-- 아이디 (비밀번호칸과 동일 구조/클래스 사용) -->
    <div class="pw-box">
        <label for="userid">아이디</label><br>
        <div class="pw-input-wrap">
            <input type="text" id="userid" name="userid"
                   placeholder="아이디를 입력해 주세요.">
        </div>
        <p id="idError" class="error-msg" style="margin:4px 0 10px 2px;"></p>
    </div>

    <!-- 버튼 -->
    <button type="submit" id="findPwBtn">비밀번호 찾기</button>
</form>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const nickname   = document.getElementById("nickname");
        const userid     = document.getElementById("userid");
        const nickError  = document.getElementById("nickError");
        const idError    = document.getElementById("idError");
        const findPwBtn  = document.getElementById("findPwBtn");
        const findPwForm = document.getElementById("findPwForm");

        function updateFindBtnState() {
            if (nickname.value.trim() !== "" && userid.value.trim() !== "") {
                findPwBtn.classList.add("active");
            } else {
                findPwBtn.classList.remove("active");
            }
        }

        nickname.addEventListener("input", () => {
            nickError.textContent = "";
            updateFindBtnState();
        });

        userid.addEventListener("input", () => {
            idError.textContent = "";
            updateFindBtnState();
        });

        nickError.textContent = "";
        idError.textContent   = "";
        updateFindBtnState();
        findPwForm.addEventListener("submit", (e) => {
            let hasError = false;

            nickError.textContent = "";
            idError.textContent   = "";

            if (nickname.value.trim() === "") {
                nickError.textContent = "닉네임을 입력해 주세요.";
                hasError = true;
            }
            if (userid.value.trim() === "") {
                idError.textContent = "아이디를 입력해 주세요.";
                hasError = true;
            }
            if (hasError) {
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>
