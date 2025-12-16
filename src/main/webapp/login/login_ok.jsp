<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.io.*, java.net.*, javax.net.ssl.HttpsURLConnection" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userid");
    String userPw = request.getParameter("userpw");
    if (userId == null) userId = "";
    if (userPw == null) userPw = "";

    String ctx = request.getContextPath();
    String apiUrl = "https://webserver-backend.onrender.com/api/v1/auth/login";

    String redirectUrl = null;

    try {
        String jsonInput = "{"
                + "\"userId\":\"" + userId.replace("\\","\\\\").replace("\"","\\\"") + "\","
                + "\"password\":\"" + userPw.replace("\\","\\\\").replace("\"","\\\"") + "\""
                + "}";

        URL url = new URL(apiUrl);
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);

        conn.setConnectTimeout(15000);
        conn.setReadTimeout(60000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonInput.getBytes("UTF-8"));
        }

        int code = conn.getResponseCode();

        if (code >= 200 && code < 300) {
            session.setAttribute("userId", userId);
            redirectUrl = ctx + "/main/mainpage.jsp";
        } else {
            redirectUrl = ctx + "/login/login.jsp?idError="
                    + URLEncoder.encode("아이디 또는 비밀번호가 올바르지 않습니다.", "UTF-8");
        }

    } catch (java.net.SocketTimeoutException te) {
        te.printStackTrace();
        redirectUrl = ctx + "/login/login.jsp?idError="
                + URLEncoder.encode("서버 응답이 지연되고 있습니다. 잠시 후 다시 시도해 주세요.", "UTF-8");

    } catch (Exception e) {
        e.printStackTrace();
        redirectUrl = ctx + "/login/login.jsp?idError="
                + URLEncoder.encode("서버 오류가 발생했습니다.", "UTF-8");
    }

    response.sendRedirect(redirectUrl);
%>
