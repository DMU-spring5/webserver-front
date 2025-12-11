<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.net.ssl.HttpsURLConnection" %>

<%
    // 한글 파라미터 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    String ctx = request.getContextPath();

    // 로그인 폼에서 넘어온 값 (name="userid", name="userpw" 인지 확인!)
    String userId = request.getParameter("userid");
    String userPw = request.getParameter("userpw");

    if (userId == null) userId = "";
    if (userPw == null) userPw = "";

    System.out.println("===== [login_ok] 진입 =====");
    System.out.println("userId = " + userId);
    System.out.println("userPw = " + userPw);

    String apiUrl = "https://webserver-backend.onrender.com/api/v1/auth/login";

    int    responseCode = 0;
    String body         = "";

    try {
        // 요청 JSON 만들기
        String jsonInput =
                "{"
                        + "\"userId\":\"" + userId + "\","
                        + "\"password\":\"" + userPw + "\""
                        + "}";

        System.out.println("[login_ok] request JSON = " + jsonInput);

        // HTTP 연결 설정
        URL url = new URL(apiUrl);
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        // JSON 전송
        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonInput.getBytes("UTF-8"));
        }

        // 응답 코드
        responseCode = conn.getResponseCode();
        System.out.println("[login_ok] responseCode = " + responseCode);

        // 응답 바디 읽기 (성공/실패 공통)
        InputStream is = (conn.getErrorStream() != null)
                ? conn.getErrorStream()
                : conn.getInputStream();

        if (is != null) {
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(is, "UTF-8")
            )) {
                String line;
                while ((line = br.readLine()) != null) {
                    sb.append(line);
                }
            }
            body = sb.toString();
        }

        System.out.println("[login_ok] body = " + body);

    } catch (Exception e) {
        System.out.println("[login_ok] 예외 발생!");
        e.printStackTrace();
        // 예외가 나면 실패 처리
        responseCode = 500;
    }

    // 로그인 성공 / 실패 분기
    if (responseCode == 200) {
        System.out.println("[login_ok] 로그인 성공 → mainpage로 redirect");

        // 세션 저장
        session.setAttribute("userId", userId);

        // mainpage.jsp 위치가 /main/mainpage.jsp 라고 가정
        response.sendRedirect(ctx + "/main/mainpage.jsp");

    } else if (responseCode == 400 || responseCode == 401) {
        System.out.println("[login_ok] 로그인 실패 → login.jsp로 redirect");
        response.sendRedirect(ctx + "/login/login.jsp?idError=아이디 또는 비밀번호가 올바르지 않습니다.");

    } else {
        System.out.println("[login_ok] 서버 오류 → login.jsp로 redirect");
        response.sendRedirect(ctx + "/login/login.jsp?idError=서버 오류가 발생했습니다.");
    }
%>
