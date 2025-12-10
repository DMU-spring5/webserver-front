<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String nickname = request.getParameter("nickname");
    String userId   = request.getParameter("userid");

    if (nickname == null) nickname = "";
    if (userId == null)   userId = "";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기 처리</title>
</head>
<body>

<script>
    const API_BASE = "https://webserver-backend.onrender.com";

    const nickname = "<%=nickname%>";
    const userId   = "<%=userId%>";

    console.log("전송할 데이터:", { nickname, userId });

    fetch(API_BASE + "/api/v1/auth/find-password", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            nickname: nickname,
            userId: userId
        })
    })
        .then(async (res) => {
            const text = await res.text();
            console.log("응답:", res.status, text);

            let data = {};
            try { data = JSON.parse(text); } catch (e) {}

            if (res.status === 200) {
                // 성공
                alert("회원 정보를 확인했습니다. 새 비밀번호를 설정해주세요.");

                // JSP로 값 전달
                window.location.href = "new_pw.jsp?userid=" + encodeURIComponent(userId)
                    + "&nickname=" + encodeURIComponent(nickname);
            }
            else if (res.status === 404) {
                alert("일치하는 회원 정보를 찾을 수 없습니다.");
                window.location.href = "find_pw.jsp";
            }
            else {
                alert(data.message || "서버 오류가 발생했습니다.");
                window.location.href = "find_pw.jsp";
            }
        })
        .catch((err) => {
            console.error("비밀번호 찾기 오류:", err);
            alert("서버 통신 중 오류가 발생했습니다.");
            window.location.href = "find_pw.jsp";
        });

</script>

</body>
</html>
