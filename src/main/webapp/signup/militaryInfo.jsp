<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String userId = request.getParameter("userId");
    String password = request.getParameter("password");
    String nickname = request.getParameter("nickname");
    String serviceType = request.getParameter("serviceType");

    if (userId == null) userId = "";
    if (password == null) password = "";
    if (nickname == null) nickname = "";
    if (serviceType == null) serviceType = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 가입</title>
    <link rel="stylesheet" type="text/css" href="militaryInfo.css">
</head>
<body>

<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>

<form id="militaryInfoForm"
      class="info-form"
      autocomplete="off"
      action="info.jsp"
      method="post">

    <!-- 이전 화면에서 받은 값들을 그대로 다음 화면으로 넘기기 -->
    <input type="hidden" name="userId" value="<%=userId%>">
    <input type="hidden" name="password" value="<%=password%>">
    <input type="hidden" name="nickname" value="<%=nickname%>">
    <input type="hidden" name="serviceType" value="<%=serviceType%>">

    <div class="form-box">
        <label for="division">사단</label><br>
        <input type="text" id="division" name="division"
               placeholder="사단을 입력해 주세요.">
        <p id="divisionError" class="error-msg"></p>
    </div>

    <div class="form-box">
        <label for="unit">부대</label><br>
        <input type="text" id="unit" name="unit"
               placeholder="부대를 입력해 주세요.">
        <p id="unitError" class="error-msg"></p>
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

    <button type="submit" id="nextBtn">다음</button>
</form>

<div id="dateModal">
    <div class="date-modal-inner">
        <div class="date-modal-body">
            <div class="date-col">
                <strong>연도</strong>
                <div id="yearList"></div>
            </div>
            <div class="date-col">
                <strong>월</strong>
                <div id="monthList"></div>
            </div>
            <div class="date-col">
                <strong>일</strong>
                <div id="dayList"></div>
            </div>
        </div>
        <div class="date-modal-footer">
            <button type="button" id="cancelBtn">취소</button>
            <button type="button" id="okBtn">확인</button>
        </div>
    </div>
</div>

<script>
    let selectedYear = null;
    let selectedMonth = null;
    let selectedDay = null;

    const today = new Date();
    const THIS_YEAR = today.getFullYear();
    const THIS_MONTH = today.getMonth() + 1;
    const THIS_DAY = today.getDate();

    document.addEventListener("DOMContentLoaded", () => {
        const divisionInput = document.getElementById("division");
        const unitInput = document.getElementById("unit");

        const joinDateHidden = document.getElementById("joinDate");
        const joinDateText = document.getElementById("joinDateText");

        const nextBtn = document.getElementById("nextBtn");
        const form = document.getElementById("militaryInfoForm");

        const divisionError = document.getElementById("divisionError");
        const unitError = document.getElementById("unitError");
        const joinDateError = document.getElementById("joinDateError");

        const dateModal = document.getElementById("dateModal");
        const yearList = document.getElementById("yearList");
        const monthList = document.getElementById("monthList");
        const dayList = document.getElementById("dayList");
        const okBtn = document.getElementById("okBtn");
        const cancelBtn = document.getElementById("cancelBtn");

        // 초기화
        joinDateText.value = "";
        joinDateHidden.value = "";

        // 인풋 체크
        function checkInputs() {
            const hasDivision = divisionInput.value.trim() !== "";
            const hasUnit = unitInput.value.trim() !== "";
            const hasJoinDate = joinDateHidden.value.trim() !== "";

            if (hasDivision && hasUnit && hasJoinDate) {
                nextBtn.classList.add("active");
            } else {
                nextBtn.classList.remove("active");
            }
        }

        function clearError(input) {
            if (input === divisionInput) divisionError.textContent = "";
            if (input === unitInput) unitError.textContent = "";
            if (input === joinDateText) joinDateError.textContent = "";
        }

        divisionInput.addEventListener("input", () => {
            clearError(divisionInput);
            checkInputs();
        });
        unitInput.addEventListener("input", () => {
            clearError(unitInput);
            checkInputs();
        });

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

            setTimeout(() => {
                if (selectedYear) highlightAndScroll(yearList, selectedYear);
                if (selectedMonth) highlightAndScroll(monthList, selectedMonth);
                if (selectedDay) highlightAndScroll(dayList, selectedDay);
            }, 0);
        }

        function closeDateModal() {
            dateModal.style.display = "none";
        }

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
            if (targetElement) {
                targetElement.scrollIntoView({ block: "center", behavior: "auto" });
            }
        }

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

            let lastDay = new Date(selectedYear, selectedMonth, 0).getDate();

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

        okBtn.addEventListener("click", () => {
            if (!selectedYear || !selectedMonth || !selectedDay) {
                alert("연, 월, 일을 모두 선택해 주세요.");
                return;
            }

            const year = parseInt(selectedYear, 10);
            const mm = String(selectedMonth).padStart(2, "0");
            const dd = String(selectedDay).padStart(2, "0");
            const dateStr = year + "-" + mm + "-" + dd;

            joinDateText.value = dateStr;
            joinDateHidden.value = dateStr;

            joinDateText.setAttribute('value', dateStr);

            joinDateText.removeAttribute('placeholder');
            joinDateText.style.color = "black";
            joinDateText.style.visibility = "visible";
            joinDateText.style.opacity = "1";

            clearError(joinDateText);
            closeDateModal();
            checkInputs();
        });

        cancelBtn.addEventListener("click", () => {
            closeDateModal();
        });

        dateModal.addEventListener("click", (e) => {
            if (e.target === dateModal) {
                closeDateModal();
            }
        });

        //검증만 하고 form submit → info.jsp
        form.addEventListener("submit", (e) => {
            e.preventDefault();

            let valid = true;
            if (divisionInput.value.trim() === "") {
                divisionError.textContent = "사단 정보를 입력해 주세요.";
                valid = false;
            }
            if (unitInput.value.trim() === "") {
                unitError.textContent = "부대 정보를 입력해 주세요.";
                valid = false;
            }
            if (joinDateHidden.value.trim() === "") {
                joinDateError.textContent = "입대 날짜를 선택해 주세요.";
                valid = false;
            }
            if (!valid) {
                return;
            }
            form.submit();
        });

        checkInputs();
    });
</script>
</body>
</html>
