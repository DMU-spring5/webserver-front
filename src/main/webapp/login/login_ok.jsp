<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.io.*, java.net.*, javax.net.ssl.HttpsURLConnection" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 현재 컨텍스트 경로 가져오기 (예: /MyProject)
    String ctx = request.getContextPath();

    // 2. 파라미터 받기
    String userId = request.getParameter("userid"); // login.jsp의 input name="userid"
    String userPw = request.getParameter("userpw"); // login.jsp의 input name="userpw"

    if (userId == null) userId = "";
    if (userPw == null) userPw = "";

    String redirectUrl = null;

    // 3. 유효성 검사 (아이디/비번 비어있으면 돌려보냄)
    if (userId.trim().isEmpty() || userPw.trim().isEmpty()) {
        redirectUrl = ctx + "/login/login.jsp?idError=" + URLEncoder.encode("아이디를 입력해주세요.", "UTF-8");
        response.sendRedirect(redirectUrl);
        return;
    }

    // 4. API 요청 준비
    String baseUrl = "https://webserver-backend.onrender.com";
    String apiUrl  = baseUrl + "/api/v1/auth/login";

    // JSON 문자열 생성 (특수문자 이스케이프 처리)
    String safeId = userId.replace("\\", "\\\\").replace("\"", "\\\"");
    String safePw = userPw.replace("\\", "\\\\").replace("\"", "\\\"");

    // 백엔드 스펙에 맞게 여러 포맷 준비 (혹시 모를 필드명 불일치 대비)
    String[] bodies = new String[] {
            "{" + "\"userid\":\"" + safeId + "\"," + "\"userpw\":\"" + safePw + "\"" + "}",
            "{" + "\"userId\":\"" + safeId + "\"," + "\"userPw\":\"" + safePw + "\"" + "}",
            "{" + "\"userId\":\"" + safeId + "\"," + "\"password\":\"" + safePw + "\"" + "}"
    };

    int status = -1;
    String json = "";
    String accessToken = null;

    // 5. API 통신 시도 (재시도 로직 포함)
    for (int i = 0; i < bodies.length; i++) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(apiUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(15000); // 15초 타임아웃
            conn.setReadTimeout(60000);    // 60초 읽기 타임아웃
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");

            // 전송
            try (OutputStream os = conn.getOutputStream()) {
                os.write(bodies[i].getBytes("UTF-8"));
            }

            // 응답 코드 확인
            status = conn.getResponseCode();
            InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();

            // 응답 본문 읽기
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            json = sb.toString();

            // 디버깅용 로그 (서버 콘솔에서 확인 가능)
            System.out.println("=== [login_ok] TRY#" + (i+1) + " STATUS=" + status);

            // 성공 시 토큰 파싱
            if (status >= 200 && status < 300) {
                // "accessToken" 키 찾기
                int idx = json.indexOf("\"accessToken\"");
                if (idx >= 0) {
                    int colon = json.indexOf(":", idx);
                    int q1 = json.indexOf("\"", colon + 1);
                    int q2 = json.indexOf("\"", q1 + 1);
                    if (q1 >= 0 && q2 > q1) accessToken = json.substring(q1 + 1, q2);
                }

                // 만약 accessToken이 없으면 "token" 키로 재시도
                if (accessToken == null) {
                    idx = json.indexOf("\"token\"");
                    if (idx >= 0) {
                        int colon = json.indexOf(":", idx);
                        int q1 = json.indexOf("\"", colon + 1);
                        int q2 = json.indexOf("\"", q1 + 1);
                        if (q1 >= 0 && q2 > q1) accessToken = json.substring(q1 + 1, q2);
                    }
                }

                // 토큰을 찾았으면 반복문 종료
                if (accessToken != null) break;
            }

        } catch (Exception e) {
            System.out.println("=== [login_ok] EXCEPTION: " + e.getMessage());
            status = 500;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    // 6. 결과 처리 및 페이지 이동
    if (status >= 200 && status < 300) {
        // 로그인 성공
        if (accessToken != null && !accessToken.trim().isEmpty()) {
            session.setAttribute("accessToken", accessToken);
            session.setAttribute("userId", userId); // 필요 시 아이디도 세션에 저장
            session.setMaxInactiveInterval(60 * 60); // 세션 1시간 유지

            // ★★★ 성공 시 이동 경로 수정 (중요) ★★★
            // main.jsp 파일이 /WEB-INF/views/main.jsp 에 있다면:
            redirectUrl = ctx + "/main";  // (컨트롤러를 타야 함)

            // 만약 컨트롤러 없이 바로 JSP를 띄우려면 (경로가 webapp/main.jsp 인 경우):
            // redirectUrl = ctx + "/main.jsp";

            // ※ 일단 가장 안전하게 Spring Controller 주소인 "/main"으로 설정합니다.
            // (컨트롤러에서 return "main"; 해주면 main.jsp가 열립니다)
            redirectUrl = ctx + "/main";

        } else {
            // 성공은 했으나 토큰이 없는 경우
            redirectUrl = ctx + "/login/login.jsp?msg=" + URLEncoder.encode("토큰을 받지 못했습니다.", "UTF-8");
        }

    } else {
        // 로그인 실패 (비번 틀림 등)
        String failMsg = "아이디 또는 비밀번호가 올바르지 않습니다.";
        if(status == 400 || status == 401) {
            // 400, 401은 보통 인증 실패
        } else if (status >= 500) {
            failMsg = "서버 오류가 발생했습니다. (잠시 후 다시 시도해주세요)";
        }
        redirectUrl = ctx + "/login/login.jsp?idError=" + URLEncoder.encode(failMsg, "UTF-8");
    }

    // 7. 페이지 이동
    response.sendRedirect(redirectUrl);
%>
