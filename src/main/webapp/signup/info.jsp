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
            <img src="../img/camera.png" alt="camera">
        </label>

        <input type="file" id="profileInput" accept="image/*" style="display:none;">
    </div>

    <!-- 폼 시작 -->
    <form id="infoForm" action="info_ok.jsp" method="post">

        <!-- 아이디 -->
        <div class="form-box">
            <label>아이디</label>

            <div class="id-input-wrap">
                <input type="text" id="userId" name="userId"
                       placeholder="3~15자 영대소문자, 숫자 사용 가능">
                <button type="button" id="idCheckBtn" class="id-check-btn" disabled>
                    중복확인
                </button>
            </div>

            <p id="userIdError" class="error-msg"></p>
        </div>

        <!-- 닉네임 -->
        <div class="form-box">
            <label for="nickname">닉네임</label>
            <input type="text" id="nickname" name="nickname"
                   class="height-48"
                   placeholder="2~8자 영대소문자, 한글, 숫자 사용 가능">
            <p id="nicknameError" class="error-msg"></p>
        </div>

        <!-- 비밀번호 -->
        <div class="form-box">
            <label for="password">비밀번호</label>
            <div class="pw-area">
                <input type="password" id="password" name="password"
                       class="height-48"
                       placeholder="8~16자 영대소문자, 숫자, 특수문자 사용 가능">
                <img class="togglePw" src="../img/eye.png" alt="show pw">
            </div>
            <p id="passwordError" class="error-msg"></p>
        </div>

        <!-- 비밀번호 확인 -->
        <div class="form-box">
            <label for="passwordCheck">비밀번호 확인</label>
            <div class="pw-area">
                <input type="password" id="passwordCheck"
                       class="height-48"
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
    const profileInput       = document.getElementById("profileInput");
    const previewImg         = document.getElementById("previewImg");

    const userIdInput        = document.getElementById("userId");
    const nicknameInput      = document.getElementById("nickname");
    const passwordInput      = document.getElementById("password");
    const passwordCheckInput = document.getElementById("passwordCheck");

    const userIdError        = document.getElementById("userIdError");
    const nicknameError      = document.getElementById("nicknameError");
    const passwordError      = document.getElementById("passwordError");
    const passwordCheckError = document.getElementById("passwordCheckError");

    const idCheckBtn         = document.getElementById("idCheckBtn");
    const form               = document.getElementById("infoForm");

    // 프로필 이미지 미리보기
    if (profileInput) {
        profileInput.addEventListener("change", () => {
            const file = profileInput.files[0];
            if (file) {
                previewImg.src = URL.createObjectURL(file);
            }
        });
    }

    //비밀번호 보이기/숨기기
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

    //  아이디 중복확인
    let lastIdChecked = "";      // 마지막으로 중복확인한 아이디
    let isIdAvailable = false;   // 사용 가능 여부

    idCheckBtn.addEventListener("click", () => {
        const userId = userIdInput.value.trim();
            if (userId === "") {
                userIdError.textContent = "아이디를 입력해 주세요.";
                return;
            }

        // 메시지 초기화
        userIdError.textContent = "";
        userIdError.classList.remove("ok-msg");

        if (userId === "") {
            userIdError.textContent = "아이디를 입력해 주세요.";
            return;
        }

        const idPattern = /^[A-Za-z0-9]{3,15}$/;
        if (!idPattern.test(userId)) {
            userIdError.textContent = "아이디 형식이 올바르지 않습니다. (3~15자 영대소문자, 숫자)";
            return;
        }

        // idCheck.jsp가 "true" / "false" 텍스트를 반환한다고 가정
        fetch("<%=ctx%>/idCheck.jsp?userId=" + encodeURIComponent(userId))
            .then(res => res.text())
            .then(result => {
                const available = result.trim() === "true";

                if (available) {
                    userIdError.textContent = "사용할 수 있는 아이디예요.";
                    userIdError.classList.add("ok-msg");  // 초록색 (CSS에 정의)
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

    // ================== 입력 시 에러메시지 즉시 제거 ==================
    userIdInput.addEventListener("input", () => {
        userIdError.textContent = "";
        userIdError.classList.remove("ok-msg");
        if (userIdInput.value.trim() !== lastIdChecked) {
            isIdAvailable = false;  // 아이디 바꾸면 다시 중복확인 필요
        }
    });

    // 아이디 길이에 따라 중복확인 버튼 활성/비활성
    userIdInput.addEventListener("input", () => {
        const val = userIdInput.value.trim();
        const validLength = val.length >= 3 && val.length <= 15;

        if (validLength) {
            idCheckBtn.classList.add("active");
            idCheckBtn.disabled = false;
        } else {
            idCheckBtn.classList.remove("active");
            idCheckBtn.disabled = true;
        }
    });


    nicknameInput.addEventListener("input", () => {
        nicknameError.textContent = "";
    });

    passwordInput.addEventListener("input", () => {
        passwordError.textContent = "";
    });

    passwordCheckInput.addEventListener("input", () => {
        passwordCheckError.textContent = "";
    });

    // ================== 폼 최종 검증 ==================
    form.addEventListener("submit", (e) => {
        let ok = true;

        const userId = userIdInput.value.trim();
        const nickname = nicknameInput.value.trim();
        const pw = passwordInput.value.trim();
        const pw2 = passwordCheckInput.value.trim();

        // 에러 초기화
        userIdError.textContent        = "";
        userIdError.classList.remove("ok-msg");
        nicknameError.textContent      = "";
        passwordError.textContent      = "";
        passwordCheckError.textContent = "";

        if (userId === "") {
            userIdError.textContent = "아이디를 입력해 주세요.";
            ok = false;
        } else if (!isIdAvailable || userId !== lastIdChecked) {
            userIdError.textContent = "아이디 중복확인을 완료해 주세요.";
            ok = false;
        }

        if (nickname === "") {
            nicknameError.textContent = "닉네임을 입력해 주세요.";
            ok = false;
        }
        if (pw === "") {
            passwordError.textContent = "비밀번호를 입력해 주세요.";
            ok = false;
        }
        if (pw2 === "") {
            passwordCheckError.textContent = "비밀번호 확인을 입력해 주세요.";
            ok = false;
        }
        if (pw !== "" && pw2 !== "" && pw !== pw2) {
            passwordCheckError.textContent = "비밀번호가 일치하지 않습니다.";
            ok = false;
        }

        if (!ok) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>
