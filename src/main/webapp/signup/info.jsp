<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="info.css">
</head>
<body>

<div class="signup-wrap">

    <!-- 프로필 영역 -->
    <div class="profile-img">
        <img src="../img/profile.png" id="previewImg" class="profile">

        <label for="profileInput" class="camera">
            <img src="../img/camera.png">
        </label>

        <input type="file" id="profileInput" accept="image/*" style="display:none;">
    </div>

    <!-- 폼 시작 -->
    <form id="infoForm" action="info_ok.jsp" method="post">

        <!-- 아이디 -->
        <div class="form-box">
            <label>아이디</label>
            <div class="id-area">
                <input type="text" id="userId" name="userId"
                       placeholder="3~15자 영대소문자, 숫자 사용 가능">
                <button type="button" id="idCheckBtn" class="check-btn">중복확인</button>
            </div>
            <p id="userIdError" class="error-msg"></p>
        </div>

        <!-- 닉네임 -->
        <div class="form-box">
            <label>닉네임</label>
            <input type="text" id="nickname" name="nickname"
                   placeholder="2~8자 영대소문자, 한글, 숫자 사용 가능">
            <p id="nicknameError" class="error-msg"></p>
        </div>

        <!-- 비밀번호 -->
        <div class="form-box">
            <label>비밀번호</label>
            <div class="pw-area">
                <input type="password" id="password" name="password"
                       placeholder="8~16자 영대소문자, 숫자, 특수문자 사용 가능">
                <img class="togglePw" src="../img/eye.png" alt="show pw">
            </div>
            <p id="passwordError" class="error-msg"></p>
        </div>

        <!-- 비밀번호 확인 -->
        <div class="form-box">
            <label>비밀번호 확인</label>
            <div class="pw-area">
                <input type="password" id="passwordCheck"
                       placeholder="비밀번호를 다시 입력해 주세요.">
                <img class="togglePw" src="../img/eye.png" alt="show pw">
            </div>
            <p id="passwordCheckError" class="error-msg"></p>
        </div>

        <!-- 회원가입 버튼 -->
        <button type="submit" class="submit-btn">회원가입</button>

    </form>
</div>

<script>
    const ctx = '<%=ctx%>';

    // 프로필 이미지 미리보기
    const profileInput = document.getElementById("profileInput");
    const previewImg = document.getElementById("previewImg");

    if (profileInput) {
        profileInput.addEventListener("change", () => {
            const file = profileInput.files[0];
            if (file) {
                previewImg.src = URL.createObjectURL(file);
            }
        });
    }

    // 비밀번호 보이기/숨기기
    document.querySelectorAll(".togglePw").forEach(icon => {
        icon.addEventListener("click", () => {
            const input = icon.previousElementSibling;
            if (input.type === "password") {
                input.type = "text";
                icon.src = ctx + "../img/eyeoff.png";
            } else {
                input.type = "password";
                icon.src = ctx + "../img/eye.png";
            }
        });
    });

    // 아이디 중복확인
    const idCheckBtn = document.getElementById("idCheckBtn");
    const userIdInput = document.getElementById("userId");
    const userIdError = document.getElementById("userIdError");

    let lastIdChecked = "";      // 마지막으로 중복확인한 아이디
    let isIdAvailable = false;   // 사용 가능 여부

    idCheckBtn.addEventListener("click", () => {
        const userId = userIdInput.value.trim();

        // 메시지 초기화
        userIdError.textContent = "";
        userIdError.classList.remove("ok-msg");

        if (userId === "") {
            userIdError.textContent = "아이디를 입력해 주세요.";
            return;
        }

        // 필요하면 정규식 체크도 가능 (예: 영문+숫자 3~15자)
        const idPattern = /^[A-Za-z0-9]{3,15}$/;
        if (!idPattern.test(userId)) {
            userIdError.textContent = "아이디 형식이 올바르지 않습니다. (3~15자 영대소문자, 숫자)";
            return;
        }

        fetch(ctx + "/idCheck.jsp?userId=" + encodeURIComponent(userId))
            .then(res => res.json())
            .then(data => {
                if (data.available) {
                    userIdError.textContent = "사용할 수 있는 아이디예요.";
                    userIdError.classList.add("ok-msg");  // 초록색
                    isIdAvailable = true;
                    lastIdChecked = userId;
                } else {
                    userIdError.textContent = "사용할 수 없는 아이디예요.";
                    userIdError.classList.remove("ok-msg");
                    isIdAvailable = false;
                    lastIdChecked = "";
                }
            })
            .catch(err => {
                console.error(err);
                userIdError.textContent = "아이디 확인 중 오류가 발생했어요. 잠시 후 다시 시도해 주세요.";
            });
    });

    // 아이디를 수정하면 다시 중복확인 하도록 상태 초기화
    userIdInput.addEventListener("input", () => {
        if (userIdInput.value.trim() !== lastIdChecked) {
            isIdAvailable = false;
        }
    });

    // 폼 검증
    document.getElementById("infoForm").addEventListener("submit", (e) => {
        let ok = true;

        const userId = userIdInput.value.trim();
        const nickname = document.getElementById("nickname").value.trim();
        const pw = document.getElementById("password").value.trim();
        const pw2 = document.getElementById("passwordCheck").value.trim();

        // 초기화
        userIdError.textContent = "";
        userIdError.classList.remove("ok-msg");
        document.getElementById("nicknameError").textContent = "";
        document.getElementById("passwordError").textContent = "";
        document.getElementById("passwordCheckError").textContent = "";

        if (userId === "") {
            userIdError.textContent = "아이디를 입력해 주세요.";
            ok = false;
        } else if (!isIdAvailable || userId !== lastIdChecked) {
            userIdError.textContent = "아이디 중복확인을 완료해 주세요.";
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
