<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MyPage</title>
    <link rel="stylesheet" type="text/css" href="myinfo.css">
</head>
<body>
<%
    HttpSession userSession = request.getSession();
    String nickname = (String) session.getAttribute("nickname"); // 세션에서 닉네임 가져오기
%>
<header class="header">
    <div class="header-inner">
        <!-- 로고 -->
        <div class="logo">
            <img src="../img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

        <div class="header-center">
            <!-- 메뉴 -->
            <nav class="nav">
                <a href="index.jsp" class="active">뉴스</a>
                <span class="divider">|</span>
                <a href="#">소셜</a>
                <span class="divider">|</span>
                <a href="health/health.jsp">건강</a>
                <span class="divider">|</span>
                <a href="#">지도</a>
            </nav>
        </div>

        <!-- 닉네임 + 로그아웃 -->
        <div class="user-info">
            <span><%= nickname %> &nbsp &nbsp님</span>
            <form action="logout/logout.jsp" method="post">
                <button type="submit" class="logout-btn">로그아웃</button>
            </form>
        </div>
    </div>
</header>

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
            <label for="password">사단</label>
            <div class="pw-area">
                <input type="password" id="password" name="password"
                       class="height-48"
                       placeholder="8~16자 영대소문자, 숫자, 특수문자 사용 가능">
            </div>
            <p id="passwordError" class="error-msg"></p>
        </div>

        <div class="form-box">
            <label for="army">부대</label>
            <input type="text" id="army" name="army"
                   class="height-48"
                   placeholder="2~8자 영대소문자, 한글, 숫자 사용 가능">
            <p id="armyError" class="error-msg"></p>
        </div>

        <div class="form-box">
            <label for="joinDateText">입대 날짜</label><br>

            <input type="hidden" id="joinDate" name="joinDate" value="">

            <input type="text"
                   id="joinDateText"
                   name="joinDateText"
                   placeholder="입대 날짜를 선택해 주세요."
                   readonly
                   autocomplete="off"
                   value="">

            <p id="joinDateError" class="error-msg"></p>
        </div>

        <!-- 회원가입 버튼 -->
        <button type="submit" class="submit-btn">수정하기</button>
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

    // 아이디 중복확인
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
        fetch("<%= request.getContextPath() %>/idCheck.jsp?userId=" + encodeURIComponent(userId))
            .then(res => res.text())
            .then(result => {
                const available = result.trim() === "true";  // 'true'인 경우 사용 가능

                if (available) {
                    userIdError.textContent = "사용할 수 있는 아이디예요.";
                    userIdError.classList.add("ok-msg");  // 초록색 (CSS에 정의)
                } else {
                    userIdError.textContent = "사용할 수 없는 아이디예요.";
                    userIdError.classList.remove("ok-msg");
                }
            })
    });

    // 입력 시 에러메시지 즉시 제거
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

    // 폼 최종 검증
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

<script>
    // 전역 변수 초기화
    let selectedYear = null;
    let selectedMonth = null;
    let selectedDay = null;

    const today = new Date();
    const THIS_YEAR = today.getFullYear();
    const THIS_MONTH = today.getMonth() + 1;
    const THIS_DAY = today.getDate();

    document.addEventListener("DOMContentLoaded", () => {
        const joinDateHidden = document.getElementById("joinDate");
        const joinDateText = document.getElementById("joinDateText");

        const dateModal = document.getElementById("dateModal");
        const yearList = document.getElementById("yearList");
        const monthList = document.getElementById("monthList");
        const dayList = document.getElementById("dayList");
        const okBtn = document.getElementById("okBtn");
        const cancelBtn = document.getElementById("cancelBtn");

        // 날짜 입력 필드 클릭 처리
        function handleDateInputClick(e) {
            e.preventDefault();
            e.stopPropagation();
            joinDateText.blur();
            openDateModal();
        }

        joinDateText.addEventListener("click", handleDateInputClick);
        joinDateText.addEventListener("mousedown", handleDateInputClick);

        // 모달 열기
        function openDateModal() {
            dateModal.style.display = "flex";
            console.log("Modal Opened");

            // 기존 값 파싱 시도
            const currentDate = joinDateHidden.value;
            if (currentDate && currentDate.indexOf('-') > -1) {
                const parts = currentDate.split('-');
                selectedYear = parseInt(parts[0], 10);
                selectedMonth = parseInt(parts[1], 10);
                selectedDay = parseInt(parts[2], 10);
            } else {
                selectedYear = null;
                selectedMonth = null;
                selectedDay = null;
            }

            buildYearMonthList();
            updateDayList();

            // UI 하이라이트와 스크롤을 DOM 갱신 후 실행 (필수)
            setTimeout(() => {
                if (selectedYear) highlightAndScroll(yearList, selectedYear);
                if (selectedMonth) highlightAndScroll(monthList, selectedMonth);
                if (selectedDay) highlightAndScroll(dayList, selectedDay);
            }, 0);
        }

        function closeDateModal() {
            dateModal.style.display = "none";
        }

        // --- 수정된 부분: 하이라이트 및 스크롤 로직 추가 ---
        function highlightAndScroll(listElement, value) {
            let targetElement = null;
            listElement.querySelectorAll("p").forEach(p => {
                const pValue = parseInt(p.textContent, 10);
                if (pValue === value) {
                    p.style.background = "#e8e8e8";
                    p.style.fontWeight = "bold";
                    targetElement = p;
                } else {
                    p.style.background = "transparent";
                    p.style.fontWeight = "normal";
                }
            });
            // 선택된 요소가 있으면 그 위치로 스크롤 이동 (중앙 정렬)
            if (targetElement) {
                targetElement.scrollIntoView({ block: "center", behavior: "auto" });
            }
        }
        // --- 수정된 부분 끝 ---

        // 연, 월 리스트 생성
        function buildYearMonthList() {
            yearList.innerHTML = "";
            monthList.innerHTML = "";

            const startYear = 1999;
            for (let y = startYear; y <= THIS_YEAR; y++) {
                const p = document.createElement("p");
                p.textContent = y;
                p.style.cursor = "pointer";
                p.onclick = () => selectYear(y, p);
                yearList.appendChild(p);
            }

            for (let m = 1; m <= 12; m++) {
                const p = document.createElement("p");
                p.textContent = m;
                p.style.cursor = "pointer";
                p.onclick = () => selectMonth(m, p);
                monthList.appendChild(p);
            }
        }

        function selectYear(y, element) {
            selectedYear = y;
            selectedDay = null;
            highlightAndScroll(yearList, y);
            updateDayList();
        }

        function selectMonth(m, element) {
            selectedMonth = m;
            selectedDay = null;
            highlightAndScroll(monthList, m);
            updateDayList();
        }

        function updateDayList() {
            dayList.innerHTML = "";
            if (!selectedYear || !selectedMonth) return;

            // 해당 연/월의 마지막 날짜 계산
            let lastDay = new Date(selectedYear, selectedMonth, 0).getDate();

            // 미래 날짜 제한 로직
            if (selectedYear === THIS_YEAR && selectedMonth === THIS_MONTH) {
                lastDay = THIS_DAY;
            }
            if (selectedYear > THIS_YEAR || (selectedYear === THIS_YEAR && selectedMonth > THIS_MONTH)) {
                lastDay = 0;
            }

            for (let d = 1; d <= lastDay; d++) {
                const p = document.createElement("p");
                p.textContent = d;
                p.style.cursor = "pointer";
                p.onclick = () => selectDay(d, p);
                dayList.appendChild(p);
            }

            if (selectedDay) {
                highlightAndScroll(dayList, selectedDay);
            }
        }

        function selectDay(d, element) {
            selectedDay = d;
            highlightAndScroll(dayList, d);
        }

        // 확인 버튼
        okBtn.addEventListener("click", () => {
            if (!selectedYear || !selectedMonth || !selectedDay) {
                alert("연, 월, 일을 모두 선택해 주세요.");
                return;
            }

            // 2. 날짜 문자열 조합
            const year = parseInt(selectedYear, 10);
            const mm = String(selectedMonth).padStart(2, "0");
            const dd = String(selectedDay).padStart(2, "0");
            const dateStr = year + "-" + mm + "-" + dd;

            // 3. 값 대입
            joinDateText.value = dateStr;
            joinDateHidden.value = dateStr;

            // setAttribute로 HTML 속성 자체도 변경 (화면 갱신 유도)
            joinDateText.setAttribute('value', dateStr);

            // 4. CSS 및 스타일 강제 적용
            joinDateText.removeAttribute('placeholder');
            joinDateText.style.color = "black";
            joinDateText.style.visibility = "visible";
            joinDateText.style.opacity = "1";

            // 5. 정리
            closeDateModal();
        });

        cancelBtn.addEventListener("click", () => {
            closeDateModal();
        });

        dateModal.addEventListener("click", (e) => {
            if (e.target === dateModal) {
                closeDateModal();
            }
        });
    });
</script>

</body>
</html>
