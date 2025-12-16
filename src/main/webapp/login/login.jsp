String pwErrorParam = request.getParameter("pwError");
%>
<body>
<!-- 로고 영역 -->
<!-- 로고 영역 (아이디 찾기와 동일 구조로 div 감싸기) -->
<div class="logo-wrap">
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png" alt="MILLI ROAD 로고">
</div>
@@ -24,7 +24,7 @@

<!-- 비밀번호 -->
<div class="pw-box">
    <div class="pw-input-wrap">
        <div class="pw-input-wrap"><!-- 입력창 + 아이콘 래퍼 -->
            <input type="password" id="userpw" name="userpw"
                   placeholder="비밀번호" autocomplete="off">
            <img class="eyeoff" id="togglePw" src="../img/eye.png">
            @@ -99,27 +99,27 @@

            checkInputs(); // 초기 상태 설정

            // 제출 시 아이디/비밀번호 미입력 체크
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