<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <link rel="stylesheet" type="text/css" href="find_id.css">
</head>
<body>
<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>
<form id="findIdForm" action="find_id_ok.jsp" method="post">
    <!-- 닉네임 -->
    <div class="nickname-box">
        <label for="nickname">닉네임</label><br>
        <input type="text" id="nickname" name="nickname"
               placeholder="닉네임을 입력해 주세요.">
        <p id="nickError" style="color:red; margin:4px 0 10px 2px;"></p>
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
    <button type="submit" id="findIdBtn" class="active">아이디 찾기</button>
</form>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        // 비밀번호 보기/숨기기
        const pwInput  = document.getElementById("password");
        const togglePw = document.getElementById("togglePw");

        if (togglePw && pwInput) {
            togglePw.addEventListener("click", () => {
                if (pwInput.type === "password") {
                    pwInput.type = "text";
                    togglePw.src = "../img/eyeoff.png";
                }
                else {
                    pwInput.type = "password";
                    togglePw.src = "../img/eye.png";
                }
            });
        }

        // 요소 가져오기
        const nickname   = document.getElementById("nickname");
        const nickError  = document.getElementById("nickError");
        const pwError    = document.getElementById("pwError");
        const findIdBtn  = document.getElementById("findIdBtn");
        const findIdForm = document.getElementById("findIdForm");

        function updateFindBtnState() {
            if (nickname.value.trim() !== "" && pwInput.value.trim() !== "") {
                findIdBtn.classList.add("active");
            } else {
                findIdBtn.classList.remove("active");
            }
        }

        // 입력 변화 시: 에러는 지우고, 버튼 색만 갱신
        nickname.addEventListener("input", () => {
            nickError.textContent = "";
            updateFindBtnState();
        });

        pwInput.addEventListener("input", () => {
            pwError.textContent = "";
            updateFindBtnState();
        });

        // 첫 로드시 초기 설정
        nickError.textContent = "";
        pwError.textContent   = "";
        updateFindBtnState();

        // 제출 시 최종 검사 → 여기서 오류 메시지 띄움
        findIdForm.addEventListener("submit", (e) => {
            let hasError = false;

            nickError.textContent = "";
            pwError.textContent   = "";

            if (nickname.value.trim() === "") {
                nickError.textContent = "닉네임을 입력해 주세요.";
                hasError = true;
            }
            if (pwInput.value.trim() === "") {
                pwError.textContent = "비밀번호를 입력해 주세요.";
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
