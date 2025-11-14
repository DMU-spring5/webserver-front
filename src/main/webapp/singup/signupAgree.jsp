<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입 - 약관 동의</title>
    <!-- [추가] 모달과 날짜 리스트를 보기 좋게 하기 위한 최소 스타일 -->
    <style>
        /* [추가] 모달 전체 배경 */
        #dateModal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.3);
            justify-content: center;
            align-items: center;
        }
        /* [추가] 모달 안 박스 */
        .date-modal-inner {
            background: #fff;
            padding: 16px;
            border-radius: 8px;
            min-width: 420px;
        }
        /* [추가] 연/월/일 리스트 영역 */
        .date-modal-body {
            display: flex;
            gap: 12px;
            max-height: 220px;
            overflow-y: auto;
        }
        .date-col {
            flex: 1;
            border: 1px solid #ddd;
            padding: 8px;
            box-sizing: border-box;
        }
        .date-col h4 {
            margin: 0 0 6px 0;
            font-size: 13px;
        }
        .date-col p {
            margin: 0;
            padding: 3px 4px;
            cursor: pointer;
        }
        .date-modal-footer {
            margin-top: 10px;
            text-align: right;
        }
    </style>
</head>
<body>
<h2>회원가입</h2>
<form id="termsForm" action="militaryType.jsp" method="post">
    <h3>서비스 약관 동의</h3>
    <p>서비스 약관 동의 (필수)</p>
    <textarea rows="8" cols="60" readonly style="resize:none;">
제1조 (목적)
이 약관은 웹서비스 5조(이하 "운영자"라 한다)이 운영하는 Milli Road(이하 "웹사이트"라 한다)에서
제공하는 인터넷 기반의 군대 관련 AI 뉴스 크롤링(이하 "서비스"라 한다)을 이용과 관련하여, 운영자와
회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제2조 (용어의 정의)
① "회원"이라 함은 회사의 서비스에 접속하여 이 약관에 따라 회사와 이용계약을 체결하고,
   회사가 제공하는 서비스를 이용하는 자를 말합니다.
② "아이디(ID)"라 함은 회원의 식별과 서비스 이용을 위하여 회원이 정하고 회사가 승인하는
   문자와 숫자의 조합을 말합니다.
③ "비밀번호"라 함은 회원이 부여받은 아이디와 일치되는 회원임을 확인하고, 회원의
   개인정보 보호를 위하여 회원 자신이 정한 문자와 숫자의 조합을 말합니다.

제3조 (약관의 명시 및 변경)
① 회사는 이 약관의 내용을 회원이 쉽게 알 수 있도록 서비스 초기 화면 또는 연결화면에 게시합니다.
② 회사는 관련 법령을 위배하지 않는 범위에서 이 약관을 변경할 수 있습니다.
            </textarea>
    <br>
    <!-- 체크박스, 에러 메시지 -->
    <label>
        <input type="checkbox" id="chkService" name="chkService">
        서비스 약관에 동의합니다.
    </label>
    <span id="serviceError"></span>
    <br><br>
    <h3>위치기반 서비스 약관 동의</h3>
    <p>위치기반 서비스 약관 동의 (필수)</p>
    <textarea rows="8" cols="60" readonly style="resize:none;">
제1조 (목적)
본 약관은 위치정보를 이용하여 제공되는 Milli Road의 위치기반 서비스(이하 "위치기반서비스"라 한다)를
이용함에 있어, 운영자와 회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제2조 (위치정보의 수집 및 이용)
① 회사는 다음과 같은 목적을 위하여 회원의 위치정보를 수집, 이용할 수 있습니다.
   1. 날씨 및 위치 기반 맞춤 정보 제공
   2. 위치 기반 코디 추천 서비스 제공
② 회사는 서비스 제공을 위해서 필요한 최소한의 범위 내에서 위치정보를 수집합니다.

제3조 (회원의 권리)
① 회원은 위치정보 이용·제공에 대한 동의를 철회할 수 있습니다.
② 회원은 회사에 대하여 보유하고 있는 자신의 위치정보에 대한 열람 또는 오류정정을
   요구할 수 있습니다.
            </textarea>
    <br>
    <label>
        <input type="checkbox" id="chkLocation" name="chkLocation">
        위치 기반 서비스 약관에 동의합니다.
    </label>
    <span id="locationError"></span>
    <br><br>

    <!-- [추가] 입대일 입력 필드 -->
    <h3>입대일 선택</h3>
    <input type="text"
           id="armyDate"
           name="armyDate"
           readonly
           placeholder="입대일을 선택하세요">

    <!-- [추가] 날짜 선택 모달 -->
    <div id="dateModal">
        <div class="date-modal-inner">
            <div class="date-modal-body">
                <div class="date-col">
                    <h4>연도</h4>
                    <div id="yearList"></div>
                </div>
                <div class="date-col">
                    <h4>월</h4>
                    <div id="monthList"></div>
                </div>
                <div class="date-col">
                    <h4>일</h4>
                    <div id="dayList"></div>
                </div>
            </div>
            <div class="date-modal-footer">
                <button type="button" id="okBtn">확인</button>
                <button type="button" id="cancelBtn">취소</button>
            </div>
        </div>
    </div>

    <br><br>
    <button type="submit">다음</button>
</form>

<script>
    const armyDateInput = document.getElementById("armyDate");
    const dateModal = document.getElementById("dateModal");

    const yearList = document.getElementById("yearList");
    const monthList = document.getElementById("monthList");
    const dayList   = document.getElementById("dayList");

    let selectedYear = null;
    let selectedMonth = null;
    let selectedDay = null;

    // [추가] 요소가 제대로 잡히는지 콘솔 확인용
    console.log("armyDateInput =", armyDateInput);
    console.log("dateModal =", dateModal);
    console.log("yearList, monthList, dayList =", yearList, monthList, dayList);

    /*폼 클릭 → 모달 오픈*/
    armyDateInput.addEventListener("click", () => {
        dateModal.style.display = "flex"; // [수정] block → flex (모달 중앙 정렬용)
    });

    /*특정 div 안의 모든 p 스타일 초기화*/
    function clearSelection(listDiv) {
        const items = listDiv.querySelectorAll("p");
        items.forEach(i => i.style.background = "none");
    }

    /*input에 미리보기 값 넣음*/ // [추가] 네 주석은 그대로 두고, 함수 내용만 구현
    function updateInputPreview() {
        if (!armyDateInput) return;

        const y = selectedYear ? String(selectedYear) : "----";
        const m = selectedMonth ? String(selectedMonth).padStart(2, "0") : "--";
        const d = selectedDay ? String(selectedDay).padStart(2, "0") : "--";

        armyDateInput.value = `${y}.${m}.${d}`;
    }

    /*연, 월 생성*/
    function createDateList() {
        const currentYear = new Date().getFullYear();
        /*연도*/
        for (let y = 1950; y <= currentYear; y++) {
            const p = document.createElement("p");
            p.textContent = y;
            p.style.cursor = "pointer";

            p.addEventListener("click", () => {
                clearSelection(yearList);
                p.style.background = "#eee";

                selectedYear = y;
                updateDays();
                updateInputPreview();   // [추가] 연 클릭 시 입력폼 바로 반영
            });
            yearList.appendChild(p);
        }
        /*월*/
        for (let m = 1; m <= 12; m++) {
            const p = document.createElement("p");
            p.textContent = m.toString().padStart(2, "0");
            p.style.cursor = "pointer";

            p.addEventListener("click", () => {
                clearSelection(monthList);
                p.style.background = "#eee";
                selectedMonth = m;
                updateDays();
                updateInputPreview();   // [추가] 월 클릭 시 입력폼 바로 반영
            });
            monthList.appendChild(p);
        }
    }

    /*일(연 + 월 선택 후)*/
    function updateDays() {
        dayList.innerHTML = "";
        if (!selectedYear || !selectedMonth) return;

        const last = new Date(selectedYear, selectedMonth, 0).getDate();
        for (let d = 1; d <= last; d++) {
            const p = document.createElement("p");
            p.textContent = d.toString().padStart(2, "0");
            p.style.cursor = "pointer";
            p.addEventListener("click", () => {
                clearSelection(dayList);
                p.style.background = "#eee";
                selectedDay = d;
                updateInputPreview();   // [추가] 일 클릭 시 입력폼 바로 반영
            });
            dayList.appendChild(p);
        }
    }

    /*완료*/
    document.getElementById("okBtn").addEventListener("click", () => {
        if (!selectedYear || !selectedMonth || !selectedDay) {
            alert("날짜를 모두 선택하세요!");
            return;
        }
        /*날짜 적용*/
        const result =
            selectedYear + "."
            + String(selectedMonth).padStart(2, '0') + "."
            + String(selectedDay).padStart(2, '0');

        armyDateInput.value =
            selectedYear + "." +
            String(selectedMonth).padStart(2, '0') + "." +
            String(selectedDay).padStart(2, '0');

        dateModal.style.display = "none";
    })
    /*취소 버튼*/
    document.getElementById("cancelBtn").addEventListener("click", () => {
        dateModal.style.display = "none";
    });
    /*실행*/
    createDateList();
</script>
</body>
</html>
