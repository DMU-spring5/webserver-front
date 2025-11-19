<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String userid = (String) request.getAttribute("userid");
    String nickname = (String) request.getAttribute("nickname");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 비밀번호 설정</title>
    <link rel="stylesheet" type="text/css" href="new_pw.css">
</head>

<body>

<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>

<form id="resetPwForm" action="new_pw_ok.jsp" method="post">

    <!-- userid hidden 전송 -->
    <input type="hidden" name="userid" value="<%= userid %>">

    <!-- 새 비밀번호 -->
    <div class="pw-box">
        <label for="newPassword">새 비밀번호</label><br>
        <div class="pw-input-wrap">
            <input type="password" id="newPassword" name="newPassword"
                   placeholder="새 비밀번호를 입력해 주세요.">
            <img class="toggle-eye" id="toggleNewPw" src="../img/eye.png">
        </div>
        <p id="newPwError" class="error-msg"></p>
    </div>

    <!-- 비밀번호 확인 -->
    <div class="pw-box">
        <label for="confirmPassword">비밀번호 확인</label><br>
        <div class="pw-input-wrap">
            <input type="password" id="confirmPassword" name="confirmPassword"
                   placeholder="비밀번호를 다시 입력해 주세요.">
            <img class="toggle-eye" id="toggleConfirmPw" src="../img/eye.png">
        </div>
        <p id="confirmPwError" class="error-msg"></p>
    </div>

    <!-- 로그인하기 버튼 -->
    <button type="submit" id="findIdPwBtn">로그인하기</button>
</form>

<script>
    // 눈 아이콘 토글 (새 비밀번호)
    const newPwInput  = document.getElementById("newPassword");
    const toggleNewPw = document.getElementById("toggleNewPw");

    toggleNewPw.addEventListener("click", () => {
        if (newPwInput.type === "password") {
            newPwInput.type = "text";
            toggleNewPw.src = "../img/eyeoff.png";
        } else {
            newPwInput.type = "password";
            toggleNewPw.src = "../img/eye.png";
        }
    });

    // 눈 아이콘 토글 (비밀번호 확인)
    const confirmPwInput  = document.getElementById("confirmPassword");
    const toggleConfirmPw = document.getElementById("toggleConfirmPw");

    toggleConfirmPw.addEventListener("click", () => {
        if (confirmPwInput.type === "password") {
            confirmPwInput.type = "text";
            toggleConfirmPw.src = "../img/eyeoff.png";
        } else {
            confirmPwInput.type = "password";
            toggleConfirmPw.src = "../img/eye.png";
        }
    });

    const resetPwForm     = document.getElementById("resetPwForm");
    const newPassword     = document.getElementById("newPassword");
    const confirmPassword = document.getElementById("confirmPassword");
    const resetBtn        = document.getElementById("findIdPwBtn");

    const newPwError      = document.getElementById("newPwError");
    const confirmPwError  = document.getElementById("confirmPwError");

    // 버튼 활성/비활성 상태 갱신
    function updateResetBtnState() {
        const newPwVal     = newPassword.value.trim();
        const confirmPwVal = confirmPassword.value.trim();

        // 두 칸 다 채워져 있고, 값이 서로 같을 때만 활성화
        if (newPwVal !== "" && confirmPwVal !== "" && newPwVal === confirmPwVal) {
            resetBtn.classList.add("active");
            resetBtn.disabled = false;
        } else {
            resetBtn.classList.remove("active");
            resetBtn.disabled = true;
        }
    }

    // 입력할 때마다 에러 지우고 버튼 상태 갱신
    newPassword.addEventListener("input", () => {
        newPwError.textContent = "";
        updateResetBtnState();
    });

    confirmPassword.addEventListener("input", () => {
        confirmPwError.textContent = "";
        updateResetBtnState();
    });

    // 최종 제출 시 검사
    resetPwForm.addEventListener("submit", (e) => {
        let valid = true;
        const newPwVal     = newPassword.value.trim();
        const confirmPwVal = confirmPassword.value.trim();

        if (newPwVal === "") {
            newPwError.textContent = "새 비밀번호를 입력해 주세요.";
            valid = false;
        }

        if (confirmPwVal === "") {
            confirmPwError.textContent = "비밀번호 확인을 입력해 주세요.";
            valid = false;
        }

        if (newPwVal !== "" && confirmPwVal !== "" && newPwVal !== confirmPwVal) {
            confirmPwError.textContent = "비밀번호가 서로 일치하지 않습니다.";
            valid = false;
        }

        if (!valid) {
            e.preventDefault(); // 잘못되면 전송 막기
        }
    });

    // 처음 로드될 때 비활성화 상태로 시작
    updateResetBtnState();
</script>

</body>
</html>
