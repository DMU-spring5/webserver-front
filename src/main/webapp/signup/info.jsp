<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    // 앞 단계에서 넘어온 군 정보들
    String serviceType = request.getParameter("serviceType"); // army / navy / airforce
    String division    = request.getParameter("division");
    String unit        = request.getParameter("unit");
    String enlistDate  = request.getParameter("joinDate");    // yyyy-MM-dd

    if (serviceType == null) serviceType = "";
    if (division    == null) division    = "";
    if (unit        == null) unit        = "";
    if (enlistDate  == null) enlistDate  = "";
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
    const API_BASE = "https://webserver-backend.onrender.com";

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

    // 군 정보: JSP에서 받아온 값 JS로 넘기기
    const serviceTypeFromJsp = "<%=serviceType%>";
    const divisionFromJsp    = "<%=division%>";
    const unitFromJsp        = "<%=unit%>";
    const enlistDateFromJsp  = "<%=enlistDate%>";

    console.log("군 정보 from JSP:", {
        serviceTypeFromJsp,
        divisionFromJsp,
        unitFromJsp,
        enlistDateFromJsp
    });

    // 프로필 이미지 미리보기
    if (profileInput) {
        profileInput.addEventListener("change", function () {
            const file = profileInput.files[0];
            if (file) {
                previewImg.src = URL.createObjectURL(file);
            }
        });
    }

    // 비밀번호 보이기/숨기기
    document.querySelectorAll(".togglePw").forEach(function (icon) {
        icon.addEventListener("click", function () {
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

    // 아이디 중복확인
    var lastIdChecked = "";
    var isIdAvailable = false;

    idCheckBtn.addEventListener("click", function () {
        var userId = userIdInput.value.trim();

        userIdError.textContent = "";
        userIdError.classList.remove("ok-msg");

        if (userId === "") {
            userIdError.textContent = "아이디를 입력해 주세요.";
            return;
        }

        var idPattern = /^[A-Za-z0-9]{3,15}$/;
        if (!idPattern.test(userId)) {
            userIdError.textContent = "아이디 형식이 올바르지 않습니다. (3~15자 영대소문자, 숫자)";
            return;
        }

        fetch(API_BASE + "/api/v1/auth/check-id?userid=" + encodeURIComponent(userId))
            .then(function (res) {
                if (!res.ok) {
                    throw new Error("중복확인 요청이 거절되었습니다. (status: " + res.status + ")");
                }
                return res.json();
            })
            .then(function (data) {
                var available = data.available;
                if (available) {
                    userIdError.textContent = "사용 가능한 아이디예요.";
                    userIdError.classList.add("ok-msg");
                    isIdAvailable = true;
                    lastIdChecked = userId;
                } else {
                    userIdError.textContent = "이미 사용 중인 아이디예요.";
                    isIdAvailable = false;
                    lastIdChecked = "";
                }
            })
            .catch(function (err) {
                console.error(err);
                userIdError.textContent = "아이디 중복확인 중 오류가 발생했습니다.";
            });
    });

    // 아이디 입력 변화 시 상태 초기화 + 버튼 활성/비활성
    userIdInput.addEventListener("input", function () {
        userIdError.textContent = "";
        userIdError.classList.remove("ok-msg");

        if (userIdInput.value.trim() !== lastIdChecked) {
            isIdAvailable = false;
        }

        var val = userIdInput.value.trim();
        var validLength = val.length >= 3 && val.length <= 15;

        idCheckBtn.disabled = !validLength;
        if (validLength) {
            idCheckBtn.classList.add("active");
        } else {
            idCheckBtn.classList.remove("active");
        }
    });

    nicknameInput.addEventListener("input", function () {
        nicknameError.textContent = "";
    });
    passwordInput.addEventListener("input", function () {
        passwordError.textContent = "";
    });
    passwordCheckInput.addEventListener("input", function () {
        passwordCheckError.textContent = "";
    });

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        var ok = true;

        var userId   = userIdInput.value.trim();
        var nickname = nicknameInput.value.trim();
        var pw       = passwordInput.value.trim();
        var pw2      = passwordCheckInput.value.trim();

        userIdError.textContent        = "";
        nicknameError.textContent      = "";
        passwordError.textContent      = "";
        passwordCheckError.textContent = "";

        if (!userId) {
            userIdError.textContent = "아이디를 입력해 주세요.";
            ok = false;
        } else if (!isIdAvailable || userId !== lastIdChecked) {
            userIdError.textContent = "아이디 중복확인을 해주세요.";
            ok = false;
        }

        if (!nickname) {
            nicknameError.textContent = "닉네임을 입력해 주세요.";
            ok = false;
        }

        if (!pw) {
            passwordError.textContent = "비밀번호를 입력해 주세요.";
            ok = false;
        }

        if (!pw2) {
            passwordCheckError.textContent = "비밀번호 확인을 입력해 주세요.";
            ok = false;
        }

        if (pw && pw2 && pw !== pw2) {
            passwordCheckError.textContent = "비밀번호가 일치하지 않습니다.";
            ok = false;
        }

        // 군 정보가 JSP에서 제대로 들어왔는지 확인
        if (!serviceTypeFromJsp || !divisionFromJsp || !unitFromJsp || !enlistDateFromJsp) {
            alert("군 복무 정보가 누락되었습니다. 다시 시도해주세요.");
            return;
        }

        if (!ok) return;

        // 약관 동의 (checkbox)
        const serviceAgreeEl  = document.getElementById("serviceAgreed");
        const locationAgreeEl = document.getElementById("locationAgreed");

        const serviceAgreed  = serviceAgreeEl?.checked  ? "Y" : "N";
        const locationAgreed = locationAgreeEl?.checked ? "Y" : "N";

        // JSON payload 생성
        const payload = {
            userId: userId,
            password: pw,
            nickname: nickname,
            serviceType: serviceTypeFromJsp,
            division: divisionFromJsp,
            unit: unitFromJsp,
            enlistDate: enlistDateFromJsp,
            imgUrl: "default",
            serviceAgreed: serviceAgreed,
            locationAgreed: locationAgreed
        };

        console.log("최종 회원가입 payload:", payload);

        fetch(API_BASE + "/api/v1/auth/signup", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload)
        })
            .then(async (res) => {
                const data = await res.json().catch(() => ({}));

                if (!res.ok) {
                    throw new Error(data.message || "회원가입에 실패했습니다.");
                }
                return data;
            })
            .then(() => {
                alert("회원가입이 완료되었습니다!");
                window.location.href = "<%=ctx%>/login.jsp";
            })
            .catch((err) => {
                console.error("회원가입 에러:", err);
                alert(err.message || "서버 통신 중 오류가 발생했습니다.");
            });
    });
</script>
</body>
</html>