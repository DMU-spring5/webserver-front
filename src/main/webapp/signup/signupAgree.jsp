<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="signupAgree.css">
</head>
<body>
<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>
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

    <button type="submit">다음</button>
</form>

<script>
    /* 체크박스 선택 시 오류 메시지 즉시 제거 */
    document.getElementById("chkService").addEventListener("change", () => {
        if (document.getElementById("chkService").checked) {
            document.getElementById("serviceError").textContent = "";
        }
    });

    document.getElementById("chkLocation").addEventListener("change", () => {
        if (document.getElementById("chkLocation").checked) {
            document.getElementById("locationError").textContent = "";
        }
    });

    /* 필수 약관 체크 확인 */
    document.getElementById("termsForm").addEventListener("submit", function(e) {

        let ok = true;

        // 초기화
        document.getElementById("serviceError").textContent = "";
        document.getElementById("locationError").textContent = "";

        // 서비스 약관 체크 확인
        if (!document.getElementById("chkService").checked) {
            document.getElementById("serviceError").textContent = "필수 약관에 동의해 주세요.";
            document.getElementById("serviceError").style.color = "#FF0000FF";
            ok = false;
        }

        // 위치 기반 서비스 체크 확인
        if (!document.getElementById("chkLocation").checked) {
            document.getElementById("locationError").textContent = "필수 약관에 동의해 주세요.";
            document.getElementById("locationError").style.color = "#FF0000FF";
            ok = false;
        }

        if (!ok) {
            e.preventDefault();
        }
    });

    /* 필수 약관 체크 확인 */
    document.getElementById("termsForm").addEventListener("submit", function(e) {

        let ok = true;

        // 초기화
        document.getElementById("serviceError").textContent = "";
        document.getElementById("locationError").textContent = "";

        // 서비스 약관 체크 확인
        if (!document.getElementById("chkService").checked) {
            document.getElementById("serviceError").textContent = "필수 약관에 동의해 주세요.";
            document.getElementById("serviceError").style.color = "#FF0000FF";  // 오류색 적용
            ok = false;
        }

        // 위치 기반 서비스 체크 확인
        if (!document.getElementById("chkLocation").checked) {
            document.getElementById("locationError").textContent = "필수 약관에 동의해 주세요.";
            document.getElementById("locationError").style.color = "#FF0000FF";  // 오류색 적용
            ok = false;
        }

        // 하나라도 미동의하면 제출 막기
        if (!ok) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>
