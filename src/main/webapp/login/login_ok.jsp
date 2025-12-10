<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.net.*, javax.net.ssl.HttpsURLConnection" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userid");
    String userPw = request.getParameter("userpw");

    if (userId == null || userPw == null ||
            userId.trim().isEmpty() || userPw.trim().isEmpty()) {
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>잘못된 접근</title>
</head>
<body>
<script>
    alert("로그인 정보가 없습니다.\n로그인 화면에서 다시 시도해 주세요.");
    location.href = "login.jsp";
</script>
</body>
</html>
<%
        return;
    }

    String apiUrl = "https://webserver-backend.onrender.com/api/v1/auth/login";

    boolean success = false;
    String errorMsg = "아이디 또는 비밀번호가 올바르지 않습니다.";

    try {
        String jsonInput =
                "{"
                        + "\"userId\":\"" + userId + "\","
                        + "\"password\":\"" + userPw + "\""
                        + "}";

        URL url = new URL(apiUrl);
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        // JSON 전송
        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonInput.getBytes("UTF-8"));
        }

        int responseCode = conn.getResponseCode();

        if (responseCode == 200) {
            session.setAttribute("userId", userId);

            success = true;
        } else {
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                            conn.getErrorStream() != null ? conn.getErrorStream() : conn.getInputStream(),
                            "UTF-8"
                    ))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            } catch (Exception ignore) {}

            if (sb.length() > 0) {
                errorMsg = sb.toString();
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        errorMsg = "로그인 서버와 통신 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.";
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 처리</title>
</head>
<body>
<script>
    <% if (success) { %>
    alert("로그인에 성공했습니다.");
    location.href = "../main/mainpage.jsp";
    <% } else { %>
    alert("<%=errorMsg.replace("\n", "\\n").replace("\"", "\\\"")%>");
    location.href = "login.jsp";
    <% } %>
</script>
</body>
</html>
