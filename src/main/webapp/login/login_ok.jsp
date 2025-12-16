<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.net.*, javax.net.ssl.HttpsURLConnection" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userid");
    String userPw = request.getParameter("userpw");

    String apiUrl = "https://webserver-backend.onrender.com/api/v1/auth/login";

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

        // JSON 전송
        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonInput.getBytes("UTF-8"));
        }

        int responseCode = conn.getResponseCode();

        if (responseCode == 200) {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8")
            );
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            br.close();

            // 세션 저장
            session.setAttribute("userId", userId);

            // 로그인 성공
            response.sendRedirect("../main/mainpage.jsp");

        } else {
            // 로그인 실패
            response.sendRedirect("login.jsp?idError=아이디 또는 비밀번호가 올바르지 않습니다.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        // 예외
        response.sendRedirect("login.jsp?idError=서버 오류가 발생했습니다.");
    }
%>
