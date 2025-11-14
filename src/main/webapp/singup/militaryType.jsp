<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>회원가입 - 복무 타입</title>
    </head>
    <body>
        <img src="<%=request.getContextPath()%>/img/WebServerLogo.png" width="300px">
        <form id="serviceTypeForm" action="militaryInfo.jsp" method="post">
            <h3>복무 타입</h3>
            <label>
                <input type="radio" name="serviceType" value="ARMY">
                육군
            </label>
            &nbsp;&nbsp;&nbsp;
            <label>
                <input type="radio" name="serviceType" value="NAVY">
                해군
            </label>
            &nbsp;&nbsp;&nbsp;
            <label>
                <input type="radio" name="serviceType" value="AIRFORCE">
                공군
            </label>
            <br><br>
            <button type="submit">다음</button>
        </form>
        <script>
            const form = document.getElementById("serviceTypeForm");
            form.addEventListener("submit", function (e) {
                // 라디오 버튼 중 선택된 값 찾기
                const selected = document.querySelector('input[name="serviceType"]:checked');
                if (!selected) {
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>
