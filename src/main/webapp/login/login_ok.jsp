<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.io.*, java.net.*, java.nio.charset.StandardCharsets" %>
<%
    request.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();

    String userid = request.getParameter("userid");
    String userpw = request.getParameter("userpw");
    if (userid == null) userid = "";
    if (userpw == null) userpw = "";
    userid = userid.trim();
    userpw = userpw.trim();

// 최종 이동할 곳(여기만 바꾸면 됨)
    String redirectTo = contextPath + "/main/mainpage.jsp";

// 로그인 실패시 이동
    String failTo = contextPath + "/login/login.jsp?msg=fail";

// 입력 체크
    if (userid.length() == 0 || userpw.length() == 0) {
        redirectTo = contextPath + "/login/login.jsp?msg=empty";
    } else {

        // ✅ 백엔드 로그인 API (필요하면 여기만 수정)
        final String LOGIN_URL = "https://webserver-backend.onrender.com/api/v1/auth/login";

        HttpURLConnection conn = null;
        BufferedReader br = null;

        try {
            URL url = new URL(LOGIN_URL);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(15000);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            // JSON 안전 처리
            String safeId = userid.replace("\\", "\\\\").replace("\"", "\\\"");
            String safePw = userpw.replace("\\", "\\\\").replace("\"", "\\\"");

            // 백엔드 스펙: userId/password
            String body = "{"
                    + "\"userId\":\"" + safeId + "\","
                    + "\"password\":\"" + safePw + "\""
                    + "}";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int code = conn.getResponseCode();
            InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();

            br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            String resp = sb.toString();

            if (!(code >= 200 && code < 300)) {
                redirectTo = failTo;
            } else {

                // ===== 아주 단순 파싱: accessToken/token =====
                String accessToken = null;
                {
                    String key1 = "\"accessToken\":\"";
                    String key2 = "\"token\":\"";
                    int p = resp.indexOf(key1);
                    int klen = key1.length();
                    if (p < 0) { p = resp.indexOf(key2); klen = key2.length(); }
                    if (p >= 0) {
                        int s = p + klen;
                        int e = resp.indexOf("\"", s);
                        if (e > s) accessToken = resp.substring(s, e);
                    }
                }

                // nickname (optional)
                String nickname = null;
                {
                    String key = "\"nickname\":\"";
                    int p = resp.indexOf(key);
                    if (p >= 0) {
                        int s = p + key.length();
                        int e = resp.indexOf("\"", s);
                        if (e > s) nickname = resp.substring(s, e);
                    }
                }

                // 숫자 PK(optional): "id":11 또는 "userId":11
                Integer userPk = null;
                {
                    String[] keys = new String[] { "\"id\":", "\"userId\":" };
                    for (int i=0;i<keys.length;i++){
                        String key = keys[i];
                        int p = resp.indexOf(key);
                        if (p >= 0) {
                            int s = p + key.length();
                            while (s < resp.length() && Character.isWhitespace(resp.charAt(s))) s++;
                            int e = s;
                            while (e < resp.length() && Character.isDigit(resp.charAt(e))) e++;
                            if (e > s) {
                                try { userPk = Integer.parseInt(resp.substring(s, e)); } catch(Exception ignore){}
                            }
                            break;
                        }
                    }
                }

                if (accessToken == null || accessToken.trim().length() == 0) {
                    redirectTo = failTo;
                } else {
                    // ✅ 세션 저장 (main.jsp는 accessToken을 보고 로그인 표시함)
                    session.setAttribute("accessToken", accessToken);
                    session.setAttribute("userid", userid);
                    session.setAttribute("nickname", (nickname != null && nickname.trim().length() > 0) ? nickname : userid);

                    // social_write.jsp가 숫자 PK를 요구하면 여기 세팅
                    if (userPk != null && userPk.intValue() > 0) {
                        session.setAttribute("userId", userPk.intValue());
                    }

                    // next 파라미터 있으면 그쪽으로(옵션)
                    String next = request.getParameter("next");
                    if (next != null && next.startsWith(contextPath)) {
                        redirectTo = next;
                    } else {
                        redirectTo = contextPath + "/main/mainpage.jsp";
                    }
                }
            }

        } catch (Exception e) {
            redirectTo = contextPath + "/login/login.jsp?msg=error";
        } finally {
            try { if (br != null) br.close(); } catch(Exception ignore) {}
            try { if (conn != null) conn.disconnect(); } catch(Exception ignore) {}
        }
    }

// ✅ 여기서만 딱 한번 이동 (return 안 씀 → Unreachable 컴파일 에러 제거)
    try { out.clearBuffer(); } catch(Exception ignore) {}
    response.sendRedirect(redirectTo);
%>
