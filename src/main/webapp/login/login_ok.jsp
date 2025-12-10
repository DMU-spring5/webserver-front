<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.net.*, javax.net.ssl.HttpsURLConnection" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 폼에서 넘어온 값
    String userId = request.getParameter("userid");
    String userPw = request.getParameter("userpw");

    if (userId == null) userId = "";
    if (userPw == null) userPw = "";

    String apiUrl = "https://webserver-backend.onrender.com/api/v1/auth/login";

    try {
        String jsonInput =
                "{"
                        + "\"userId\":\"" + userId + "\","
                        + "\"password\":\"" + userPw + "\""
                        + "}";

        System.out.println("[login_ok] request JSON = " + jsonInput);

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

        System.out.println("[login_ok] responseCode = " + responseCode);
        System.out.println("[login_ok] body         = " + body);

        if (responseCode == 200) {
            String accessToken = null;
            String key = "\"accessToken\"";
            int idx = body.indexOf(key);
            if (idx != -1) {
                int start = body.indexOf("\"", idx + key.length());
                if (start != -1) {
                    start++;
                    int end = body.indexOf("\"", start);
                    if (end != -1) {
                        accessToken = body.substring(start, end);
                    }
                }
            }
            System.out.println("[login_ok] parsed accessToken = " + accessToken);

            // 세션 저장
            session.setAttribute("userId", userId);
            if (accessToken != null && !accessToken.trim().isEmpty()) {
                session.setAttribute("accessToken", accessToken);
            }

            // 로그인 성공 → 메인 페이지로 이동
            response.sendRedirect("../main/mainpage.jsp");

        } else {
            // 로그인 실패
            response.sendRedirect("login.jsp?idError=아이디 또는 비밀번호가 올바르지 않습니다.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?idError=서버 오류가 발생했습니다.");
    }
%>
