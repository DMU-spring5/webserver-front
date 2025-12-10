<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.net.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String nickname = request.getParameter("nickname");
    String password = request.getParameter("password");

    // 아이디 찾기 API URL
    String apiUrl = "https://webserver-backend.onrender.com/api/v1/auth/find-id";

    String userid = null;
    int responseCode = -1;
    String responseBody = "";

    try {
        // JSON Body 만들기
        String jsonInput =
                "{"
                        + "\"nickname\":\"" + nickname + "\","
                        + "\"password\":\"" + password + "\""
                        + "}";

        System.out.println("[find-id] request JSON = " + jsonInput);

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

        responseCode = conn.getResponseCode();

        // 응답 본문 읽기 (성공/실패 모두)
        InputStream is = conn.getErrorStream() != null
                ? conn.getErrorStream()
                : conn.getInputStream();

        if (is != null) {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(is, "UTF-8")
            )) {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                responseBody = sb.toString();
            }
        }

        System.out.println("[find-id] response code = " + responseCode);
        System.out.println("[find-id] response body = " + responseBody);

        if (responseCode == 200) {
            // JSON 형식
            if (responseBody != null && responseBody.contains("userId")) {
                String result = responseBody;

                int idx = result.indexOf("userId");
                if (idx != -1) {
                    int colon = result.indexOf(":", idx);
                    int firstQuote = result.indexOf("\"", colon);
                    int secondQuote = result.indexOf("\"", firstQuote + 1);
                    if (firstQuote != -1 && secondQuote != -1) {
                        userid = result.substring(firstQuote + 1, secondQuote);
                    }
                }
            }

            if (userid == null || userid.trim().isEmpty()) {
                String msg = responseBody != null ? responseBody.trim() : "";
                String key = "회원님의 아이디는";
                int idx = msg.indexOf(key);
                if (idx != -1) {
                    int start = idx + key.length();
                    // 공백 건너뛰기
                    while (start < msg.length() &&
                            Character.isWhitespace(msg.charAt(start))) {
                        start++;
                    }
                    int end = start;
                    while (end < msg.length() &&
                            !Character.isWhitespace(msg.charAt(end)) &&
                            msg.charAt(end) != '입') {
                        end++;
                    }
                    if (end > start) {
                        userid = msg.substring(start, end);
                    }
                }

                if (userid == null || userid.trim().isEmpty()) {
                    userid = msg;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        userid = null;
    }

    // ===== 결과에 따른 처리 =====
    if (userid == null || userid.trim().equals("")) {
        // 상태 코드에 따라 다른 메시지
        String msg;
        if (responseCode == 404) {
            msg = "일치하는 계정을 찾을 수 없습니다.\n닉네임과 비밀번호를 다시 확인해 주세요.";
        } else if (responseCode >= 500 && responseCode != -1) {
            msg = "서버 내부 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.";
        } else if (responseCode == 200) {
            // 200인데도 userid 못 뽑은 경우 → 파싱 문제
            msg = "아이디 찾기 결과를 처리하는 중 오류가 발생했습니다.\n관리자에게 문의해 주세요.";
        } else if (responseCode == -1) {
            msg = "아이디 찾기 요청 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.";
        } else {
            msg = "아이디 찾기에 실패했습니다.\n(" + responseCode + ")";
        }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 실패</title>
    <script>
        alert("<%=msg.replace("\n", "\\n").replace("\"","\\\"")%>");
        location.href = "find_id.jsp";
    </script>
</head>
<body></body>
</html>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 완료</title>
    <link rel="stylesheet" type="text/css" href="find_id.css">
</head>
<body>

<div class="find-id-wrap">
    <!-- 로고 -->
    <div class="logo-wrap">
        <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
             alt="MILLI ROAD 로고" width="200">
    </div>
    <!-- 카드 -->
    <div class="find-id-card">
        <form id="findIdForm">

            <!-- 닉네임 -->
            <div class="nickname-box">
                <label for="nickname">닉네임</label><br>
                <input type="text" id="nickname" name="nickname"
                       value="<%= nickname %>" readonly>
            </div>

            <!-- 비밀번호 -->
            <div class="pw-box">
                <label for="password">비밀번호</label><br>
                <div class="pw-input-wrap">
                    <input type="password" id="password" name="password"
                           value="<%= password %>" readonly>
                    <img class="eyeoff" id="togglePw" src="../img/eye.png">
                </div>
                <p id="pwError" class="error-msg"></p>
            </div>

            <p class="result-text" style="text-align:center; margin:18px 0 24px;">
                회원님의 아이디는 <b><%= userid %></b> 입니다.
            </p>

            <!-- 로그인 버튼 -->
            <button type="button" id="findIdBtn" class="active"
                    onclick="location.href='login.jsp'">
                로그인하기
            </button>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const pwInput  = document.getElementById("password");
        const togglePw = document.getElementById("togglePw");

        if (togglePw && pwInput) {
            togglePw.addEventListener("click", () => {
                if (pwInput.type === "password") {
                    pwInput.type = "text";
                    togglePw.src = "../img/eyeoff.png";
                } else {
                    pwInput.type = "password";
                    togglePw.src = "../img/eye.png";
                }
            });
        }
    });
</script>

</body>
</html>
