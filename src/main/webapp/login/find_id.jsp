<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>아이디 찾기</title>
        <link rel="stylesheet" type="text/css" href="login.css"> <!-- 동일 CSS 사용 -->
    </head>

    <body>
        <div>
            <img src="<%=request.getContextPath()%>/img/WebServerLogo.png" alt="MILLI ROAD 로고" width="200">
        </div>
        <form id="findIdForm" action="find_id_ok.jsp" method="post">
            <!-- 닉네임 -->
            <div class="id-box">
                <label for="nickname">닉네임</label><br>
                <input type="text" id="nickname" name="nickname"
                       placeholder="닉네임을 입력해 주세요.">
            </div>
            <!-- 비밀번호 -->
            <div class="pw-box">
                <label for="password">비밀번호</label><br>
                <input type="password" id="password" name="password"
                       placeholder="비밀번호를 입력해 주세요.">
                <img class="eyeoff" id="togglePw" src="../img/eye.png">
            </div>
            <p id="errorMsg" style="color:red;"></p>
            <button type="submit">아이디 찾기</button>
        </form>

        <script>
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
            // 입력값 검증
            const findIdForm = document.getElementById("findIdForm");
            const nickname   = document.getElementById("nickname");
            const errorMsg   = document.getElementById("errorMsg");
            findIdForm.addEventListener("submit", (e) => {
                let msg = "";

                if (nickname.value.trim() === "") {
                    msg = "닉네임을 입력해 주세요.";
                }
                else if (pwInput.value.trim() === "") {
                    msg = "비밀번호를 입력해 주세요.";
                }
                if (msg !== "") {
                    e.preventDefault();
                    errorMsg.textContent = msg;
                }
                else {
                    errorMsg.textContent = "";
                }
            });
        </script>
    </body>
</html>