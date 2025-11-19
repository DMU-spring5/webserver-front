<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입 - 복무 타입</title>
    <link rel="stylesheet" type="text/css" href="militaryType.css">
</head>
<body>

<div class="logo-wrap">
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" class="main-logo">
</div>

<form id="serviceTypeForm" action="militaryInfo.jsp" method="post" class="type-form">

    <h3 class="form-title">복무 타입</h3>
    <hr>
    <div class="type-select-box">

        <!-- 육군 -->
        <label class="type-option" data-type="ARMY">
            <input type="radio" name="serviceType" value="ARMY" hidden>
            <div class="type-btn">육군</div>
        </label>

        <!-- 해군 -->
        <label class="type-option" data-type="NAVY">
            <input type="radio" name="serviceType" value="NAVY" hidden>
            <div class="type-btn">해군</div>
        </label>

        <!-- 공군 -->
        <label class="type-option" data-type="AIRFORCE">
            <input type="radio" name="serviceType" value="AIRFORCE" hidden>
            <div class="type-btn">공군</div>
        </label>

    </div>

    <button type="submit" id="nextBtn" disabled>다음</button>
</form>


<script>
    const options = document.querySelectorAll(".type-option");
    const nextBtn = document.getElementById("nextBtn");

    options.forEach(option => {
        option.addEventListener("click", () => {

            // 기존 선택 제거
            options.forEach(o => o.classList.remove("selected"));

            // 현재 선택 표시
            option.classList.add("selected");

            // 라디오 버튼 체크
            option.querySelector("input[type='radio']").checked = true;

            // 다음 버튼 활성화
            nextBtn.disabled = false;
        });
    });

    // 제출 시 선택했는지 체크
    document.getElementById("serviceTypeForm").addEventListener("submit", function (e) {
        const selected = document.querySelector('input[name="serviceType"]:checked');
        if (!selected) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>
