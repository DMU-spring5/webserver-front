<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="info.css">
</head>
<body>

<div class="signup-wrap">

    <div class="profile-box">
        <div class="profile-img">
            <img id="previewImg" src="../img/profile.png" alt="profile">
            <input type="file" id="profileInput" accept="image/*" style="display: none;">
        </div>
    </div>

    <!-- 폼 시작 -->
    <form id="infoForm" action="info_ok.jsp" method="post">

        <!-- 아이디 -->
        <div class="form-box">
            <label>아이디</label>
            <div class="id-area">
                <input type="text" id="userId" name="userId" placeholder="3~15자 영대소문자, 숫자 사용 가능">
                <button type="button" class="check-btn">중복확인</button>
            </div>
            <p id="userIdError" class="error-msg"></p>
        </div>

        <!-- 닉네임 -->
        <div class="form-box">
            <label>닉네임</label>
            <input type="text" id="nickname" name="nickname" placeholder="2~8자 영대소문자, 한글, 숫자 사용 가능">
            <p id="nicknameError" class="error-msg"></p>
        </div>

        <!-- 비밀번호 -->
        <div class="form-box">
            <label>비밀번호</label>
            <div class="pw-area">
                <input type="password" id="password" name="password" placeholder="8~16자 영대소문자, 숫자, 특수문자 사용 가능">
                <img class="togglePw" src="../img/eye.png">
            </div>
            <p id="passwordError" class="error-msg"></p>
        </div>

        <!-- 비밀번호 확인 -->
        <div class="form-box">
            <label>비밀번호 확인</label>
            <div class="pw-area">
                <input type="password" id="passwordCheck" placeholder="비밀번호를 다시 입력해 주세요.">
                <img class="togglePw" src="../img/eye.png">
            </div>
            <p id="passwordCheckError" class="error-msg"></p>
        </div>

        <!-- 버튼 -->
        <button type="submit" class="submit-btn">회원가입</button>

    </form>
</div>

<script>
    // 프로필 이미지 미리보기
    const profileInput = document.getElementById("profileInput");
    const previewImg = document.getElementById("previewImg");

    profileInput.addEventListener("change", () => {
        const file = profileInput.files[0];
        if (file) {
            previewImg.src = URL.createObjectURL(file);
        }
    });

    // 비밀번호 보이기/숨기기
    document.querySelectorAll(".togglePw").forEach(icon => {
        icon.addEventListener("click", () => {
            const input = icon.previousElementSibling;
            if (input.type === "password") {
                input.type = "text";
                icon.src = "../img/eyeoff.png";
            } else {
                input.type = "password";
                icon.src = "../img/eye.png";
            }
        });
    });

    // 폼 검증
    document.getElementById("infoForm").addEventListener("submit", (e) => {
        let ok = true;

        const userId = document.getElementById("userId").value.trim();
        const nickname = document.getElementById("nickname").value.trim();
        const pw = document.getElementById("password").value.trim();
        const pw2 = document.getElementById("passwordCheck").value.trim();

        // 초기화
        document.getElementById("userIdError").textContent = "";
        document.getElementById("nicknameError").textContent = "";
        document.getElementById("passwordError").textContent = "";
        document.getElementById("passwordCheckError").textContent = "";

        if (userId === "") {
            document.getElementById("userIdError").textContent = "아이디를 입력해 주세요.";
            ok = false;
        }
        if (nickname === "") {
            document.getElementById("nicknameError").textContent = "닉네임을 입력해 주세요.";
            ok = false;
        }
        if (pw === "") {
            document.getElementById("passwordError").textContent = "비밀번호를 입력해 주세요.";
            ok = false;
        }
        if (pw2 === "") {
            document.getElementById("passwordCheckError").textContent = "비밀번호 확인을 입력해 주세요.";
            ok = false;
        }
        if (pw !== "" && pw2 !== "" && pw !== pw2) {
            document.getElementById("passwordCheckError").textContent = "비밀번호가 일치하지 않습니다.";
            ok = false;
        }

        if (!ok) e.preventDefault();
    });
</script>

</body>
</html>
