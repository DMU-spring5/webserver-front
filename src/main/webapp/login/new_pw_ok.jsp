<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.net.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userid          = request.getParameter("userid");
    String newPassword     = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    int minLen = 8;

    boolean success = false;
    String errorMsg = "";

    if (newPassword == null || confirmPassword == null
            || newPassword.trim().length() < minLen
            || confirmPassword.trim().length() < minLen
            || !newPassword.equals(confirmPassword)) {

        success = false;
        errorMsg = "비밀번호는 최소 " + minLen + "자리 이상이며,\n두 칸이 서로 일치해야 합니다.";

    } else {
        // 비밀번호 변경 API 호출
        String apiUrl = "https://webserver-backend.onrender.com/api/v1/mypage/password/change";

        try {
            String jsonInput =
                    "{"
                            + "\"userId\":\"" + userid + "\","
                            + "\"newPassword\":\"" + newPassword + "\""
                            + "}";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);

            // JSON 전송
            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonInput.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();

            if (responseCode >= 200 && responseCode < 300) {
                // 성공
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
                } else {
                    errorMsg = "비밀번호 변경에 실패했습니다. (status: " + responseCode + ")";
                }
                success = false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            success = false;
            errorMsg = "서버 통신 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.";
        }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경 결과</title>
</head>
<body>
<script>
    <% if (success) { %>
    alert("비밀번호 변경이 완료되었습니다\n새 비밀번호로 다시 로그인해 주세요");
    location.href = "login.jsp";
    <% } else { %>
    alert("<%=errorMsg.replace("\n", "\\n").replace("\"", "\\\"")%>");
    history.back();
    <% } %>
</script>
</body>
</html>
