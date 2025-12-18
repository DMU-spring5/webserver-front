<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String userId   = request.getParameter("userId");
    String password = request.getParameter("password");
    String nickname = request.getParameter("nickname");

    if (userId == null)   userId = "";
    if (password == null) password = "";
    if (nickname == null) nickname = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="militaryType.css">
</head>
<body>

<div class="logo-wrap">
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" class="main-logo">
</div>

<!-- 다음 페이지로 값 넘기기 -->
<form id="serviceTypeForm" action="militaryInfo.jsp" method="post" class="type-form">

    <input type="hidden" name="userId"   value="<%=userId%>">
    <input type="hidden" name="password" value="<%=password%>">
    <input type="hidden" name="nickname" value="<%=nickname%>">

    <h3 class="form-title">복무 타입</h3>
    <hr>
    <div class="type-select-box">

        <!-- 육군 -->
        <label class="type-option" data-type="army">
            <!-- API가 기대하는 값에 맞게 소문자로 저장 -->
            <input type="radio" name="serviceType" value="army" hidden>
            <div class="type-btn">육군</div>
        </label>

        <!-- 해군 -->
        <label class="type-option" data-type="navy">
            <input type="radio" name="serviceType" value="navy" hidden>
            <div class="type-btn">해군</div>
        </label>

        <!-- 공군 -->
        <label class="type-option" data-type="airforce">
            <input type="radio" name="serviceType" value="airforce" hidden>
            <div class="type-btn">공군</div>
        </label>

    </div>

    <button type="submit" id="nextBtn" disabled>다음</button>
</form>

<script>
    const options = document.querySelectorAll(".type-option");
    const nextBtn = document.getElementById("nextBtn");
    const form = document.getElementById("serviceTypeForm");

    // 복무 타입 클릭하면 선택 표시 + 버튼 활성화
    options.forEach(option => {
        option.addEventListener("click", () => {
            options.forEach(o => o.classList.remove("selected"));
            option.classList.add("selected");
            option.querySelector("input[type='radio']").checked = true;
            nextBtn.disabled = false;
        });
    });

    // 복무 타입을 안 골랐으면 넘어가지 않게
    form.addEventListener("submit", function (e) {
        const selected = document.querySelector('input[name="serviceType"]:checked');
        if (!selected) {
            e.preventDefault();
            alert("복무 타입을 선택해 주세요.");
        }
    });
</script>

</body>
</html>
