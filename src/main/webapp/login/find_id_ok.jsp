<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.net.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String nickname = request.getParameter("nickname");
    String password = request.getParameter("password");

    // 아이디 찾기 API URL
    String apiUrl = "https://webserver-backend.onrender.com/api/v1/auth/find-id";

    String userid = null;

    try {
        // JSON Body 만들기
        String jsonInput =
                "{"
                        + "\"nickname\":\"" + nickname + "\","
                        + "\"password\":\"" + password + "\""
                        + "}";

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

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

            String result = sb.toString();

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
    } catch (Exception e) {
        e.printStackTrace();
        userid = null;
    }

    // 아이디 못 찾은 경우 → 알림 후 회원가입 페이지로 이동
    if (userid == null || userid.trim().equals("")) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 실패</title>
    <script>
        alert("일치하는 계정을 찾을 수 없습니다.\n회원가입 진행 후 로그인해 주세요.");
        location.href = "<%=request.getContextPath()%>/signup/signupAgree.jsp";
    </script>
</head>
<body></body>
</html>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 완료</title>
    <link rel="stylesheet" type="text/css" href="find_id.css">
</head>
<body>

<div>
    <img src="<%=request.getContextPath()%>/img/WebServerLogo.png"
         alt="MILLI ROAD 로고" width="200">
</div>

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

    <!-- 찾은 아이디 안내 -->
    <p style="text-align:center; margin:16px 0;">
        회원님의 아이디는 <b><%= userid %></b> 입니다.
    </p>

    <!-- 로그인 버튼 -->
    <button type="button" id="findIdBtn" class="active"
            onclick="location.href='login.jsp'">
        로그인하기
    </button>
</form>

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