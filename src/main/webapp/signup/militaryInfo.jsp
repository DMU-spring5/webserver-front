<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <title>회원가입 - 입대정보</title>
    </head>
    <body>
        <h3>입대 정보 입력</h3>
        <form id="signupInfo" onsubmit="return false">
            <!--사단-->
            <div>
                <label for="division">사단</label><br>
                <input type="text" id="division" placeholder="사단을 입력해 주세요.">
            </div><br>
            <!--부대-->
            <div>
                <label for="unit">부대</label><br>
                <input type="text" id="unit" placeholder="부대를 입력해 주세요.">
            </div><br>
            <!-- 입대 날짜 -->
            <div>
                <label for="armyDate">입대 날짜</label><br>
                <input type="text" id="armyDate" placeholder="입대 날짜를 선택해 주세요." readonly>
            </div><br>
            <button type="button" id="nextBtn">다음</button>
        </form>
        <!-- 날짜 선택 모달 -->
        <div id="dateModal" style="display:none; border:1px solid #000; padding:10px; margin-top:20px;">
            <!-- 연/월/일 가로 배치 -->
            <div id="dateWrapper" style="display:flex; gap:20px;">
                <div>
                    <strong>연도</strong>
                    <div id="yearList"></div>
                </div>
                <div>
                    <strong>월</strong>
                    <div id="monthList"></div>
                </div>
                <div>
                    <strong>일</strong>
                    <div id="dayList"></div>
                </div>
            </div><br>
            <button id="cancelBtn">취소</button>
            <button id="okBtn">완료</button>
            </div>
        </div>
    </body>

    <script>
        /*입력 요소*/
        const divisionInput   = document.getElementById("division");
        const unitInput       = document.getElementById("unit");
        const armyDateInput   = document.getElementById("armyDate");
        const nextBtn         = document.getElementById("nextBtn");

        const divisionError = document.getElementById("divisionError");
        const unitError     = document.getElementById("unitError");
        const dateError     = document.getElementById("dateError");

        /*날짜 선택 모달 요소*/
        const dateModal = document.getElementById("dateModal");
        const yearList  = document.getElementById("yearList");
        const monthList = document.getElementById("monthList");
        const dayList   = document.getElementById("dayList");

        let selectedYear  = null;
        let selectedMonth = null;
        let selectedDay   = null;
        /*입대 날짜 입력칸 클릭 → 모달 열기*/
        armyDateInput.addEventListener("click", () => {
            dateModal.style.display = "block";
        });
        /*연, 월 리스트*/
        function createDateList() {
            // 연도
            for (let y = 2020; y <= 2030; y++) {
                const p = document.createElement("p");
                p.textContent = y;
                p.style.cursor = "pointer";
                p.addEventListener("click", () => {
                    selectedYear = y;
                    console.log("연도 선택:", y);
                    updateDays();
                });
                yearList.appendChild(p);
            }
            // 월
            for (let m = 1; m <= 12; m++) {
                const p = document.createElement("p");
                p.textContent = m.toString().padStart(2, "0");
                p.style.cursor = "pointer";
                p.addEventListener("click", () => {
                    selectedMonth = m;
                    console.log("월 선택:", m);
                    updateDays();
                });
                monthList.appendChild(p);
            }
        }
        /* 선택한 연/월에 맞는 일수 생성 */
        function updateDays() {
            dayList.innerHTML = ""; // 기존 일수 제거
            if (!selectedYear || !selectedMonth) return;

            const lastDay = new Date(selectedYear, selectedMonth, 0).getDate();
            for (let d = 1; d <= lastDay; d++) {
                const p = document.createElement("p");
                p.textContent = d.toString().padStart(2, "0");
                p.style.cursor = "pointer";
                p.addEventListener("click", () => {
                    selectedDay = d;
                    console.log("일 선택:", d);
                });
                dayList.appendChild(p);
            }
        }
        /* 완료 → 입력칸에 날짜 적용 */
        document.getElementById("okBtn").addEventListener("click", () => {
            if (!selectedYear || !selectedMonth || !selectedDay) {
                alert("연, 월, 일을 모두 선택해주세요!");
                return;
            }
            armyDateInput.value =
                `\${selectedYear}.\${String(selectedMonth).padStart(2,'0')}.\${String(selectedDay).padStart(2,'0')}`;
            dateModal.style.display = "none";
        });
        /* 취소 → 모달 닫기 */
        document.getElementById("cancelBtn").addEventListener("click", () => {
            dateModal.style.display = "none";
        });
        /* 초기 실행: 연/월 목록 생성 */
        createDateList();
        /*다음 버튼 클릭 시 유효성 검사*/
        nextBtn.addEventListener("click", () => {
            let isValid = true;
            // 기존 오류 메시지 초기화
            divisionError.textContent = "";
            unitError.textContent     = "";
            dateError.textContent     = "";
            if (divisionInput.value.trim() === "") {
                divisionError.textContent = "사단 정보를 입력해 주세요.";
                isValid = false;
            }
            if (unitInput.value.trim() === "") {
                unitError.textContent = "부대명을 입력해 주세요.";
                isValid = false;
            }
            if (armyDateInput.value.trim() === "") {
                dateError.textContent = "입대 날짜를 선택해 주세요.";
                isValid = false;
            }
            if (isValid) {
                alert("모든 값이 정상 입력되었습니다.");
            }
        });
    </script>
</html>