<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    String userId = request.getParameter("userid");
    String userPw = request.getParameter("userpw");
    if (userId == null) userId = "";
    if (userPw == null) userPw = "";

    String redirectUrl = ctx + "/login/login.jsp?msg=" + URLEncoder.encode("로그인에 실패했습니다.", "UTF-8");

    if (userId.trim().isEmpty() || userPw.trim().isEmpty()) {
        redirectUrl = ctx + "/login/login.jsp?msg=" + URLEncoder.encode("아이디/비밀번호를 입력해주세요.", "UTF-8");
        response.sendRedirect(redirectUrl);
        return;
    }

    String baseUrl = "https://webserver-backend.onrender.com";
    String apiUrl  = baseUrl + "/api/v1/auth/login";

    String safeId = userId.replace("\\", "\\\\").replace("\"", "\\\"");
    String safePw = userPw.replace("\\", "\\\\").replace("\"", "\\\"");

    // 백엔드 스펙 불일치(400) 잡기 위해 여러 포맷 재시도
    String[] bodies = new String[] {
            "{"+ "\"userid\":\"" + safeId + "\"," + "\"userpw\":\"" + safePw + "\""+ "}",
            "{"+ "\"userId\":\"" + safeId + "\"," + "\"userPw\":\"" + safePw + "\""+ "}",
            "{"+ "\"userId\":\"" + safeId + "\"," + "\"password\":\"" + safePw + "\""+ "}"
    };

    int status = -1;
    String json = "";
    String accessToken = null;

    for (int i = 0; i < bodies.length; i++) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(apiUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(bodies[i].getBytes("UTF-8"));
            }

            status = conn.getResponseCode();
            InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();

            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            json = sb.toString();

            System.out.println("=== [login_ok] TRY#" + (i+1) + " STATUS=" + status);
            System.out.println("=== [login_ok] TRY#" + (i+1) + " BODY=" + bodies[i]);
            System.out.println("=== [login_ok] TRY#" + (i+1) + " RESP=" + json);

            if (status >= 200 && status < 300) {
                // accessToken 파싱(단순 문자열 탐색)
                int idx = json.indexOf("\"accessToken\"");
                if (idx >= 0) {
                    int colon = json.indexOf(":", idx);
                    int q1 = json.indexOf("\"", colon + 1);
                    int q2 = json.indexOf("\"", q1 + 1);
                    if (q1 >= 0 && q2 > q1) accessToken = json.substring(q1 + 1, q2);
                }

                if (accessToken == null) {
                    idx = json.indexOf("\"token\"");
                    if (idx >= 0) {
                        int colon = json.indexOf(":", idx);
                        int q1 = json.indexOf("\"", colon + 1);
                        int q2 = json.indexOf("\"", q1 + 1);
                        if (q1 >= 0 && q2 > q1) accessToken = json.substring(q1 + 1, q2);
                    }
                }

                break; // 성공이면 루프 종료
            }

        } catch (Exception e) {
            System.out.println("=== [login_ok] EXCEPTION: " + e.getMessage());
            json = "";
            status = 500;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    if (status >= 200 && status < 300) {
        if (accessToken != null && !accessToken.trim().isEmpty()) {
            session.setAttribute("accessToken", accessToken);
            session.setMaxInactiveInterval(60 * 60);
            redirectUrl = ctx + "/main/mainpage.jsp";
        } else {
            redirectUrl = ctx + "/login/login.jsp?msg=" + URLEncoder.encode("토큰을 받지 못했습니다.", "UTF-8");
        }
    } else {
        // 400이면 스펙 불일치 가능성이 매우 큼. 일단 status는 그대로 보여줌
        redirectUrl = ctx + "/login/login.jsp?msg=" + URLEncoder.encode("로그인 실패(" + status + ")", "UTF-8");
    }

    response.sendRedirect(redirectUrl);
%>
