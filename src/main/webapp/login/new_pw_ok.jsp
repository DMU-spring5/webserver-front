<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.net.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userid   = request.getParameter("userid");
    String nickname = request.getParameter("nickname");

    String newPassword     = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    int minLen = 8;
    boolean success = false;
    String errorMsg = "";

    // 아이디 / 닉네임이 없으면 절차가 잘못된 것
    if (userid == null || userid.trim().isEmpty()
            || nickname == null || nickname.trim().isEmpty()) {

        errorMsg = "비밀번호 찾기 정보가 없습니다.\n처음 화면에서 다시 시도해 주세요.";
    }
    // 새 비밀번호 검증만 수행
    else if (newPassword == null || confirmPassword == null
            || newPassword.trim().length() < minLen
            || confirmPassword.trim().length() < minLen
            || !newPassword.equals(confirmPassword)) {

        errorMsg = "비밀번호는 최소 " + minLen + "자리 이상이며,\n두 칸이 서로 일치해야 합니다.";
    }
    else {
        String API_BASE = "https://webserver-backend.onrender.com";
        String apiUrl   = API_BASE + "/api/v1/auth/find-password";

        System.out.println("[pw-reset] userId   = " + userid);
        System.out.println("[pw-reset] nickname = " + nickname);
        System.out.println("[pw-reset] apiUrl   = " + apiUrl);

        try {
            String jsonInput =
                    "{"
                            + "\"userId\":\""   + userid   + "\","
                            + "\"nickname\":\"" + nickname + "\""
                            + "}";

            System.out.println("[pw-reset] request JSON = " + jsonInput);

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

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
            System.out.println("[pw-reset] responseCode = " + responseCode);

            StringBuilder sb = new StringBuilder();
            InputStream is = (conn.getErrorStream() != null)
                    ? conn.getErrorStream()
                    : conn.getInputStream();

            if (is != null) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(is, "UTF-8")
                )) {
                    String line;
                    while ((line = br.readLine()) != null) sb.append(line);
                }
            }
            String body = sb.toString();
            System.out.println("[pw-reset] body = " + body);

            if (responseCode >= 200 && responseCode < 300) {
                success = true;
            } else {
                if (!body.isEmpty()) {
                    errorMsg = body;
                } else {
                    errorMsg = "비밀번호 변경에 실패했습니다. (status: " + responseCode + ")";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();

            String exc = e.getClass().getSimpleName() + ": " +
                    (e.getMessage() != null ? e.getMessage() : "");
            errorMsg = "서버 통신 중 오류가 발생했습니다.\n[" + exc + "]";
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
    alert("새 비밀번호로 변경이 완료되었습니다.\n변경된 비밀번호로 다시 로그인해 주세요.");
    location.href = "login.jsp";
    <% } else { %>
    alert("<%= errorMsg.replace("\n", "\\n").replace("\"", "\\\"") %>");
    history.back();
    <% } %>
</script>
</body>
</html>
