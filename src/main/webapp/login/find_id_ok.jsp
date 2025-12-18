<<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.net.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String nickname = request.getParameter("nickname");
    String password = request.getParameter("password");

    if (nickname == null) nickname = "";
    if (password == null) password = "";

    String userid = null;
    int responseCode = -1;
    String responseBody = "";

    String apiUrl = "https://webserver-backend.onrender.com/api/v1/auth/find-id";

    try {
        // JSON 요청 생성
        String jsonInput = String.format("{\"nickname\":\"%s\",\"password\":\"%s\"}",
                nickname, password);

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonInput.getBytes("UTF-8"));
        }

        responseCode = conn.getResponseCode();

        InputStream is = (conn.getErrorStream() != null) ? conn.getErrorStream() : conn.getInputStream();
        if (is != null) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                responseBody = sb.toString();
            }
        }

        // 200 OK면 userId 추출
        if (responseCode == 200 && responseBody != null && responseBody.contains("userId")) {
            int idx = responseBody.indexOf("userId");
            int colon = responseBody.indexOf(":", idx);
            int firstQuote = responseBody.indexOf("\"", colon);
            int secondQuote = responseBody.indexOf("\"", firstQuote + 1);
            if (firstQuote != -1 && secondQuote != -1) {
                userid = responseBody.substring(firstQuote + 1, secondQuote);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        userid = null;
    }

    // 결과 메시지 처리
    String msg = null;
    if (userid == null || userid.trim().isEmpty()) {
        if (responseCode == 404) {
            msg = "일치하는 계정을 찾을 수 없습니다.\n닉네임과 비밀번호를 다시 확인해 주세요.";
        } else if (responseCode >= 500 && responseCode != -1) {
            msg = "서버 내부 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.";
        } else if (responseCode == 200) {
            msg = "아이디 찾기 결과 처리 중 오류가 발생했습니다.\n관리자에게 문의해 주세요.";
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
        alert("<%= msg.replace("\n", "\\n").replace("\"","\\\"") %>");
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
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/login/find_id.css">
</head>
<body>
<div class="find-id-wrap">
    <div class="logo-wrap">
        <img src="<%=request.getContextPath()%>/img/WebServerLogo.png" alt="MILLI ROAD 로고" width="200">
    </div>

    <div class="find-id-card">
        <form id="findIdForm">
            <div class="nickname-box">
                <label for="nickname">닉네임</label><br>
                <input type="text" id="nickname" name="nickname" value="<%=nickname%>" readonly>
            </div>

            <div class="pw-box">
                <label for="password">비밀번호</label><br>
                <div class="pw-input-wrap">
                    <input type="password" id="password" name="password" value="<%=password%>" readonly>
                    <img class="eyeoff" id="togglePw" src="<%=request.getContextPath()%>/img/eye.png" alt="toggle password">
                </div>
            </div>

            <p class="result-text" style="text-align:center; margin:18px 0 24px;">
                회원님의 아이디는 <b><%=userid%></b> 입니다.
            </p>

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

        if(togglePw && pwInput){
            togglePw.addEventListener("click", () => {
                if(pwInput.type === "password"){
                    pwInput.type = "text";
                    togglePw.src = "<%=request.getContextPath()%>/img/eyeoff.png";
                } else {
                    pwInput.type = "password";
                    togglePw.src = "<%=request.getContextPath()%>/img/eye.png";
                }
            });
        }
    });
</script>
</body>
</html>
