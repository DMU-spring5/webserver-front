<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="militaryInfo.css">
</head>
<body>
<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>

<!-- 입대 정보 입력 폼 -->
<form id="militaryInfoForm" action="militaryInfo_ok.jsp" method="post" class="info-form">

    <!-- 사단 -->
    <div class="form-box">
        <label for="division">사단</label><br>
        <input type="text" id="division" name="division" placeholder="사단을 입력해 주세요.">
        <p id="divisionError" class="error-msg"></p>
    </div>

    <!-- 부대 -->
    <div class="form-box">
        <label for="unit">부대</label><br>
        <input type="text" id="unit" name="unit" placeholder="부대를 입력해 주세요.">
        <p id="unitError" class="error-msg"></p>
    </div>

    <!-- 입대 날짜 -->
    <div class="form-box">
        <label for="armyDate">입대 날짜</label><br>
        <input type="text" id="armyDate" name="armyDate" readonly placeholder="입대 날짜를 선택해 주세요.">
        <p id="dateError" class="error-msg"></p>
    </div>

    <!-- 다음 버튼 -->
    <button type="submit" id="nextBtn">다음</button>
</form>


<!-- 입대 날짜 -->
<div id="dateModal" class="date-modal" style="display:none;">
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
            <button type="button" id="okBtn">완료</button>
        </div>
    </div>
</div>


<script>
    document.addEventListener("DOMContentLoaded", () => {

        /* 입력 요소 */
        const divisionInput = document.getElementById("division");
        const unitInput     = document.getElementById("unit");
        const armyDateInput = document.getElementById("armyDate");
        const nextBtn       = document.getElementById("nextBtn");
        const form          = document.getElementById("militaryInfoForm");

        /* 에러 표시 */
        const divisionError = document.getElementById("divisionError");
        const unitError     = document.getElementById("unitError");
        const dateError     = document.getElementById("dateError");

        /* 날짜 선택 모달 */
        const dateModal = document.getElementById("dateModal");
        const yearList  = document.getElementById("yearList");
        const monthList = document.getElementById("monthList");
        const dayList   = document.getElementById("dayList");

        let selectedYear  = null;
        let selectedMonth = null;
        let selectedDay   = null;

        /* ----------- 버튼 활성화/비활성 함수 ----------- */
        function updateNextBtnState() {
            if (
                divisionInput.value.trim() !== "" &&
                unitInput.value.trim() !== "" &&
                armyDateInput.value.trim() !== ""
            ) {
                nextBtn.classList.add("active");
            } else {
                nextBtn.classList.remove("active");
            }
        }

        /* 입력 시 에러 제거 */
        divisionInput.addEventListener("input", () => {
            divisionError.textContent = "";
            updateNextBtnState();
        });

        unitInput.addEventListener("input", () => {
            unitError.textContent = "";
            updateNextBtnState();
        });


        /* ------------------------ 날짜 선택 모달 ------------------------ */

        /* 날짜 입력창 클릭 → 모달 열기 */
        armyDateInput.addEventListener("click", () => {
            dateModal.style.display = "flex";
        });

        /* 연/월 리스트 생성 */
        function createDateList() {
            const currentYear = new Date().getFullYear();

            /* 연도 (1950 ~ 현재) */
            for (let y = 1950; y <= currentYear; y++) {
                const p = document.createElement("p");
                p.textContent = y;
                p.style.cursor = "pointer";

                p.addEventListener("click", () => {
                    selectedYear = y;
                    updateDays();
                });

                yearList.appendChild(p);
            }

            /* 월 */
            for (let m = 1; m <= 12; m++) {
                const p = document.createElement("p");
                p.textContent = String(m).padStart(2, "0");
                p.style.cursor = "pointer";

                p.addEventListener("click", () => {
                    selectedMonth = m;
                    updateDays();
                });

                monthList.appendChild(p);
            }
        }

        /* 일수 생성 */
        function updateDays() {
            dayList.innerHTML = "";
            if (!selectedYear || !selectedMonth) return;

            const lastDay = new Date(selectedYear, selectedMonth, 0).getDate();

            for (let d = 1; d <= lastDay; d++) {
                const p = document.createElement("p");
                p.textContent = String(d).padStart(2, "0");
                p.style.cursor = "pointer";

                p.addEventListener("click", () => {
                    selectedDay = d;
                });

                dayList.appendChild(p);
            }
        }

        /* 완료 클릭 → 입력창에 날짜 적용 */
        document.getElementById("okBtn").addEventListener("click", () => {

            if (!selectedYear || !selectedMonth || !selectedDay) {
                alert("연, 월, 일을 모두 선택해 주세요!");
                return;
            }

            armyDateInput.value =
                selectedYear + "." +
                String(selectedMonth).padStart(2, '0') + "." +
                String(selectedDay).padStart(2, '0');

            dateModal.style.display = "none";
            dateError.textContent = "";

            updateNextBtnState();
        });

        /* 취소 */
        document.getElementById("cancelBtn").addEventListener("click", () => {
            dateModal.style.display = "none";
        });

        createDateList();
        updateNextBtnState();


        /* ------------------------ 제출 시 유효성 검사 ------------------------ */
        form.addEventListener("submit", (e) => {
            let hasError = false;

            divisionError.textContent = "";
            unitError.textContent = "";
            dateError.textContent = "";

            if (divisionInput.value.trim() === "") {
                divisionError.textContent = "사단 정보를 입력해 주세요.";
                hasError = true;
            }
            if (unitInput.value.trim() === "") {
                unitError.textContent = "부대명을 입력해 주세요.";
                hasError = true;
            }
            if (armyDateInput.value.trim() === "") {
                dateError.textContent = "입대 날짜를 선택해 주세요.";
                hasError = true;
            }

            if (hasError) {
                e.preventDefault();
            }
        });

    });
</script>

</body>
</html>
