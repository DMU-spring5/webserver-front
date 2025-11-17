<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>비밀번호 찾기</title>
        <!-- find_pw.css 대신 find_id.css를 재사용해도 됨 -->
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
                <p id="nickError" style="color:red; margin:4px 0 10px 2px;"></p>
            </div>
            <!-- 아이디 -->
            <div class="id-box">
                <label for="userid">아이디</label><br>
                <input type="text" id="userid" name="userid"
                       placeholder="아이디를 입력해 주세요.">
                <p id="idError" style="color:red; margin:4px 0 10px 2px;"></p>
            </div>
            <button type="submit" id="findPwBtn">비밀번호 찾기</button>
        </form>

        <script>
            const nickname   = document.getElementById("nickname");
            const userid     = document.getElementById("userid");
            const nickError  = document.getElementById("nickError");
            const idError    = document.getElementById("idError");
            const findPwBtn  = document.getElementById("findPwBtn");
            const findPwForm = document.getElementById("findPwForm");

            // 버튼 색만 바꾸는 함수 (항상 클릭 가능)
            function updateFindBtnState() {
                if (nickname.value.trim() !== "" && userid.value.trim() !== "") {
                    findPwBtn.classList.add("active");   // 초록색 (CSS에서 .active 스타일)
                }
                else {
                    findPwBtn.classList.remove("active"); // 회색
                }
            }
            // 입력 시 에러 제거 + 버튼 색 갱신
            nickname.addEventListener("input", () => {
                nickError.textContent = "";
                updateFindBtnState();
            });
            userid.addEventListener("input", () => {
                idError.textContent = "";
                updateFindBtnState();
            });

            // 초기 상태
            nickError.textContent = "";
            idError.textContent   = "";
            updateFindBtnState();

            // 제출 시 최종 검사
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
        </script>
    </body>
</html>
