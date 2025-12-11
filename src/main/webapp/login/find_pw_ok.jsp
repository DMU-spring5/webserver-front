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

            // 여기서 6자리 숫자만 추출
            const match  = text.match(/(\d{6})/);
            const tempPw = match ? match[1] : null;
            console.log("추출한 임시 비밀번호(tempPw):", tempPw);

            if (res.status === 200 && tempPw) {
                alert(
                    "임시 비밀번호가 발급되었습니다.\n\n" +
                    "[ 임시 비밀번호 ]  " + tempPw + "\n\n" +
                    "해당 번호로 로그인한 뒤, 마이페이지에서 비밀번호를 변경해 주세요."
                );

                // 로그인 화면으로 이동
                const url =
                    "login.jsp?userid=" + encodeURIComponent(userId);

                window.location.href = url;
            }
            else if (res.status === 404) {
                alert("일치하는 회원 정보를 찾을 수 없습니다.");
                window.location.href = "find_pw.jsp";
            }
            else {
                alert("비밀번호 재설정 정보를 가져오지 못했습니다.\n다시 시도해 주세요.");
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
