<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그아웃</title>
    <script type="text/javascript">
        // 페이지 로드 후 바로 알림창을 띄움
        window.onload = function() {
            var result = confirm("로그아웃 하시겠습니까?");
            if (result) {
                window.location.href = "/index.jsp";
            } else {
                window.location.href = "/main/mainpage.jsp";
            }
        };
    </script>
</head>
<body>

</body>
</html>
