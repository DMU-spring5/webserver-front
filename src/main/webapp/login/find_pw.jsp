<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>비밀번호 찾기</title>
        <link rel="stylesheet" type="text/css" href="find_pw.css">
        <style>  /*일단 여기에 작성*/
            .error-msg {
                color: red;
                font-size: 13px;
                margin: 4px 0 10px 2px;
            }
        </style>
    </head>
    <body>
        <div>
            <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
                 alt="MILLI ROAD 로고" width="200">
        </div>
        <form id="findPwForm" action="find_pw_ok.jsp" method="post">
            <!-- 닉네임 -->
            <div class="id-box">
                <label for="nickname">닉네임</label><br>
                <input type="text" id="nickname" name="nickname"
                       placeholder="닉네임을 입력해 주세요.">
                <p id="nicknameError" class="error-msg"></p>
            </div>
            <!-- 아이디 -->
            <div class="id-box">
                <label for="userid">아이디</label><br>
                <input type="text" id="userid" name="userid"
                       placeholder="아이디를 입력해 주세요.">
                <p id="useridError" class="error-msg"></p>
            </div>
            <button type="submit" id="findIdPwBtn">비밀번호 찾기</button>
        </form>

        <script>
            const findPwForm   = document.getElementById("findPwForm");
            const nickname     = document.getElementById("nickname");
            const userid       = document.getElementById("userid");
            const submitBtn    = document.getElementById("findIdPwBtn");

            const nicknameError = document.getElementById("nicknameError");
            const useridError   = document.getElementById("useridError");

            // 버튼 활성화 함수 (두 칸 모두 입력되어야 활성화)
            function updateButtonState() {
                if (nickname.value.trim() !== "" && userid.value.trim() !== "") {
                    submitBtn.classList.add("active");
                } else {
                    submitBtn.classList.remove("active");
                }
            }

            // 입력 변화 발생 시: 에러 제거 + 버튼 활성화 갱신
            nickname.addEventListener("input", () => {
                nicknameError.textContent = "";
                updateButtonState();
            });

            userid.addEventListener("input", () => {
                useridError.textContent = "";
                updateButtonState();
            });

            // 제출 시 유효성 검사
            findPwForm.addEventListener("submit", (e) => {
                let valid = true;

                if (nickname.value.trim() === "") {
                    nicknameError.textContent = "닉네임을 입력해 주세요.";
                    valid = false;
                } else {
                    nicknameError.textContent = "";
                }

                if (userid.value.trim() === "") {
                    useridError.textContent = "아이디를 입력해 주세요.";
                    valid = false;
                } else {
                    useridError.textContent = "";
                }

                if (!valid) {
                    e.preventDefault(); // 화면 이동 막기
                }
            });
        </script>
    </body>
</html>
