<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 가입</title>
    <style>
        /* 입력 필드가 비어있지 않을 때 강제로 색상을 표시 */
        input#joinDateText:not(:placeholder-shown) {
            color: #000000 !important;
            opacity: 1 !important;
            -webkit-text-fill-color: #000000 !important;
            background-color: #ffffff !important;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="militaryInfo.css">
</head>
<body>

<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>

<form id="militaryInfoForm" action="info.jsp" method="post" class="info-form" autocomplete="off">

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

<div id="dateModal" style="display:none;">
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
            <button type="button" id="okBtn">날짜 적용 (Debug)</button>
        </div>
    </div>
</div>

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
            e.stopPropagation(); // 이벤트 전파 중단
            joinDateText.blur(); // 포커스 해제
            openDateModal();
        }

        joinDateText.addEventListener("click", handleDateInputClick);
        joinDateText.addEventListener("mousedown", handleDateInputClick);

        // 모달 열기
        function openDateModal() {
            dateModal.style.display = "flex";

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

            // UI 하이라이트
            if(selectedYear) highlightSelected(yearList, selectedYear);
            if(selectedMonth) highlightSelected(monthList, selectedMonth);
            if(selectedDay) highlightSelected(dayList, selectedDay);
        }

        function closeDateModal() {
            dateModal.style.display = "none";
        }

        function highlightSelected(listElement, value) {
            listElement.querySelectorAll("p").forEach(p => {
                if (parseInt(p.textContent, 10) === value) {
                    p.style.background = "#e8e8e8";
                } else {
                    p.style.background = "transparent";
                }
            });
        }

        // 연, 월 리스트 생성
        function buildYearMonthList() {
            yearList.innerHTML = "";
            monthList.innerHTML = "";

            const startYear = 1999;
            for (let y = startYear; y <= THIS_YEAR; y++) {
                const p = document.createElement("p");
                p.textContent = y;
                p.style.cursor = "pointer";
                // 클로저 문제 방지를 위해 값을 직접 전달
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
            highlightSelected(yearList, y);
            updateDayList();
        }

        function selectMonth(m, element) {
            selectedMonth = m;
            selectedDay = null;
            highlightSelected(monthList, m);
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
                highlightSelected(dayList, selectedDay);
            }
        }

        function selectDay(d, element) {
            selectedDay = d;
            highlightSelected(dayList, d);
        }

        // 확인 버튼 (가장 중요한 부분)
        okBtn.addEventListener("click", () => {
            // 1. 디버깅: 현재 선택된 값 확인 (팝업창)
            const debugMsg = "선택된 값 -> 연:" + selectedYear + ", 월:" + selectedMonth + ", 일:" + selectedDay;
            // alert(debugMsg); // 이 줄의 주석을 풀면 팝업으로 값을 확인할 수 있습니다.

            if (!selectedYear || !selectedMonth || !selectedDay) {
                alert("연, 월, 일을 모두 선택해 주세요.\n(" + debugMsg + ")");
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

            // 4. CSS 및 스타일 강제 적용 (화면에 --가 뜨는 문제 해결 시도)
            joinDateText.removeAttribute('placeholder');
            joinDateText.style.color = "black";
            joinDateText.style.visibility = "visible";
            joinDateText.style.opacity = "1";

            // 5. 정리
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

        form.addEventListener("submit", (e) => {
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
                e.preventDefault();
            }
        });

        checkInputs();
    });
</script>
</body>
</html>