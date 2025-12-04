<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 가입</title>
    <link rel="stylesheet" type="text/css" href="militaryInfo.css">
</head>
<body>

<!-- 로고 -->
<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>

<!-- 입대 정보 입력 폼 -->
<form id="militaryInfoForm" action="info.jsp" method="post" class="info-form">

    <!-- 사단 -->
    <div class="form-box">
        <label for="division">사단</label><br>
        <input type="text" id="division" name="division"
               placeholder="사단을 입력해 주세요.">
        <p id="divisionError" class="error-msg"></p>
    </div>

    <!-- 부대 -->
    <div class="form-box">
        <label for="unit">부대</label><br>
        <input type="text" id="unit" name="unit"
               placeholder="부대를 입력해 주세요.">
        <p id="unitError" class="error-msg"></p>
    </div>

    <!-- 입대 날짜 -->
    <div class="form-box">
        <label for="joinDate">입대 날짜</label><br>
        <input type="text"
               id="joinDate"
               name="joinDate"
               placeholder="입대 날짜를 선택해 주세요."
               readonly>
        <p id="joinDateError" class="error-msg"></p>
    </div>

    <!-- 다음 버튼 (disabled 안씀) -->
    <button type="submit" id="nextBtn">다음</button>
</form>

<!-- 날짜 선택 모달 -->
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
    document.addEventListener("DOMContentLoaded", () => {
        // ====== 입력 요소 ======
        const divisionInput = document.getElementById("division");
        const unitInput = document.getElementById("unit");
        const joinDateInput = document.getElementById("joinDate");
        const nextBtn = document.getElementById("nextBtn");
        const form = document.getElementById("militaryInfoForm");

        const divisionError = document.getElementById("divisionError");
        const unitError = document.getElementById("unitError");
        const joinDateError = document.getElementById("joinDateError");

        // ====== 모달 요소 ======
        const dateModal = document.getElementById("dateModal");
        const yearList = document.getElementById("yearList");
        const monthList = document.getElementById("monthList");
        const dayList = document.getElementById("dayList");
        const okBtn = document.getElementById("okBtn");
        const cancelBtn = document.getElementById("cancelBtn");

        const today = new Date();
        const thisYear = today.getFullYear();
        const thisMonth = today.getMonth() + 1;
        const thisDay = today.getDate();

        let selectedYear = null;
        let selectedMonth = null;
        let selectedDay = null;

        // ---------------------- 버튼 색만 토글 ----------------------
        function checkInputs() {
            const hasDivision = divisionInput.value.trim() !== "";
            const hasUnit = unitInput.value.trim() !== "";
            const hasJoinDate = joinDateInput.value.trim() !== "";

            if (hasDivision && hasUnit && hasJoinDate) {
                nextBtn.classList.add("active");
            } else {
                nextBtn.classList.remove("active");
            }
        }

        function clearError(input) {
            if (input === divisionInput) divisionError.textContent = "";
            if (input === unitInput) unitError.textContent = "";
            if (input === joinDateInput) joinDateError.textContent = "";
        }

        [divisionInput, unitInput].forEach(input => {
            input.addEventListener("input", () => {
                clearError(input);
                checkInputs();
            });
        });

        // ---------------------- 날짜 모달 열기 ----------------------
        joinDateInput.addEventListener("click", () => {
            dateModal.style.display = "flex";
        });

        function clearSelection(container) {
            container.querySelectorAll("p").forEach(p => {
                p.style.background = "transparent";
            });
        }

        // ---------------------- 날짜 생성 ----------------------
        function updateDays() {
            dayList.innerHTML = "";
            if (!selectedYear || !selectedMonth) return;

            let lastDay = new Date(selectedYear, selectedMonth, 0).getDate();

            if (selectedYear === thisYear && selectedMonth === thisMonth) {
                lastDay = thisDay;
            }
            if (selectedYear > thisYear ||
                (selectedYear === thisYear && selectedMonth > thisMonth)) {
                lastDay = 0;
            }

            for (let d = 1; d <= lastDay; d++) {
                const p = document.createElement("p");
                p.textContent = d;
                p.style.cursor = "pointer";
                p.addEventListener("click", () => {
                    clearSelection(dayList);
                    p.style.background = "#e8e8e8";
                    selectedDay = d;
                });
                dayList.appendChild(p);
            }
        }

        // 연/월 리스트 생성
        (function createDateList() {
            const startYear = 1999;
            for (let y = startYear; y <= thisYear; y++) {
                const p = document.createElement("p");
                p.textContent = y;
                p.style.cursor = "pointer";
                p.addEventListener("click", () => {
                    clearSelection(yearList);
                    p.style.background = "#e8e8e8";
                    selectedYear = y;
                    selectedDay = null;
                    updateDays();
                });
                yearList.appendChild(p);
            }

            for (let m = 1; m <= 12; m++) {
                const p = document.createElement("p");
                p.textContent = m;
                p.style.cursor = "pointer";
                p.addEventListener("click", () => {
                    clearSelection(monthList);
                    p.style.background = "#e8e8e8";
                    selectedMonth = m;
                    selectedDay = null;
                    updateDays();
                });
                monthList.appendChild(p);
            }
        })();

        // ---------------------- 모달 확인/취소 ----------------------
        okBtn.addEventListener("click", (e) => {
            e.stopPropagation();

            if (!selectedYear || !selectedMonth || !selectedDay) {
                alert("연, 월, 일을 모두 선택해 주세요.");
                return;
            }

            const mm = String(selectedMonth).padStart(2, "0");
            const dd = String(selectedDay).padStart(2, "0");
            const dateStr = `${selectedYear}-${mm}-${dd}`;

            // ★★ 선택한 날짜를 input에 *강제로* 세팅
            joinDateInput.value = dateStr;
            joinDateInput.setAttribute("value", dateStr); // 혹시 value 속성이 "--"였으면 덮어씀

            // 혹시 다른 스크립트가 "--"로 덮어써도 다시 되돌리기
            if (joinDateInput.value === "--") {
                joinDateInput.value = dateStr;
                joinDateInput.setAttribute("value", dateStr);
            }

            clearError(joinDateInput);
            dateModal.style.display = "none";
            checkInputs();
        });

        cancelBtn.addEventListener("click", () => {
            dateModal.style.display = "none";
        });

        dateModal.addEventListener("click", (e) => {
            if (e.target === dateModal) {
                dateModal.style.display = "none";
            }
        });

        // ---------------------- submit 검증 ----------------------
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
            if (joinDateInput.value.trim() === "") {
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
