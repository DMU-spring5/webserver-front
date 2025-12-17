<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // 뒤로가기 캐시 방지 (권장)
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD</title>
    <link rel="stylesheet" type="text/css" href="../mypage/mypage.css">
</head>
<body>
<div id="logoutModal" class="modal-overlay" style="display:flex;">
    <div class="modal-box">
        <h2 class="modal-title">로그아웃 하시겠습니까?</h2>

        <p class="modal-desc">
            로그아웃 후에는 다시 로그인해야<br>
            서비스를 이용할 수 있습니다.
        </p>
        <div class="modal-buttons">
            <button id="cancelLogout" class="btn-cancel" type="button">
                취소
            </button>
            <button id="confirmLogout" class="btn-withdraw" type="button">
                로그아웃
            </button>
        </div>
    </div>
</div>

<script>
    const cancelLogout = document.getElementById("cancelLogout");
    const confirmLogout = document.getElementById("confirmLogout");

    cancelLogout.addEventListener("click", function () {
        history.back();
    });

    document.addEventListener("keydown", function(e) {
        if (e.key === "Escape") {
            history.back();
        }
    });

    confirmLogout.addEventListener("click", function () {
        fetch("logout_session.jsp", { method: "POST" })
            .then(() => {
                location.href = "<%=request.getContextPath()%>/login/login.jsp";
            });
    });
</script>

</body>
</html>
