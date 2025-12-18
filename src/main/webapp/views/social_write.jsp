<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.net.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    String accessToken = (String)session.getAttribute("accessToken");
    if (accessToken == null) accessToken = "";

    String method = request.getMethod();

    // ====== POST(작성완료) 처리 ======
    if ("POST".equalsIgnoreCase(method)) {

        if (accessToken.trim().length() == 0) {
            out.println("<script>alert('로그인이 필요합니다.'); location.href='" + ctx + "/login/login.jsp';</script>");
            return;
        }

        String openOpt = request.getParameter("openOpt"); // "open" or "anon"
        if (openOpt == null) openOpt = "open";

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        if (title == null) title = "";
        if (content == null) content = "";
        title = title.trim();
        content = content.trim();

        if (title.length() == 0 || content.length() == 0) {
            out.println("<script>alert('제목/내용을 입력하세요.'); history.back();</script>");
            return;
        }

        String writer = (String)session.getAttribute("userid");
        if (writer == null) writer = "익명";
        if ("anon".equals(openOpt)) writer = "익명";

        String apiUrl = "https://webserver-backend.onrender.com/api/v1/community/create";

        HttpURLConnection conn = null;
        BufferedReader br = null;

        try {
            URL url = new URL(apiUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            conn.setDoOutput(true);
            conn.setConnectTimeout(7000);
            conn.setReadTimeout(7000);

            String safeWriter = writer.replace("\\", "\\\\").replace("\"", "\\\"");
            String safeTitle = title.replace("\\", "\\\\").replace("\"", "\\\"");
            String safeContent = content.replace("\\", "\\\\").replace("\"", "\\\"");

            String body =
                    "{"
                            + "\"user_id\":\"" + safeWriter + "\","
                            + "\"title\":\"" + safeTitle + "\","
                            + "\"content\":\"" + safeContent + "\""
                            + "}";

            OutputStream os = conn.getOutputStream();
            os.write(body.getBytes("UTF-8"));
            os.flush();
            os.close();

            int code = conn.getResponseCode();
            InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();

            br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);

            if (code >= 200 && code < 300) {
                out.println("<script>alert('작성 완료'); location.href='" + ctx + "/social/board';</script>");
                return;
            } else {
                out.println("<script>alert('작성 실패 (HTTP " + code + ")'); history.back();</script>");
                return;
            }

        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg == null) msg = "";
            msg = msg.replace("'", " ").replace("\n", " ").replace("\r", " ");
            out.println("<script>alert('작성 예외: " + msg + "'); history.back();</script>");
            return;
        } finally {
            try { if (br != null) br.close(); } catch(Exception ignore){}
            try { if (conn != null) conn.disconnect(); } catch(Exception ignore){}
        }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>새 게시글 작성</title>
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/css/social.css">
</head>
<body>

<header class="header">
    <div class="header-left">
        <div class="header-logo-box"></div>
        <div class="header-title">MILLI ROAD</div>
    </div>

    <nav class="header-nav">
        <a href="<%=ctx%>/main/main.jsp">뉴스</a>
        <a href="<%=ctx%>/social/board" class="active">소셜</a>
        <a href="<%=ctx%>/health/health.jsp">건강</a>
        <a href="#">지도</a>
    </nav>

    <div class="header-right">
        <span><%= (session.getAttribute("nickname")!=null ? session.getAttribute("nickname") : "") %> 님</span>
        <button onclick="location.href='<%=ctx%>/login/login_out.jsp'">로그아웃</button>
    </div>
</header>

<div class="container">
    <div class="write-wrap">
        <h2>새 게시글 작성</h2>
        <p class="sub">군 생활에 대한 솔직한 후기를 작성해 주세요.</p>

        <form method="post" action="<%=ctx%>/views/social_write.jsp">
            <div class="box">
                <div class="row">
                    <div class="label">공개 옵션</div>
                    <div class="field">
                        <label><input type="radio" name="openOpt" value="open" checked> 아이디 공개</label>
                        &nbsp;&nbsp;
                        <label><input type="radio" name="openOpt" value="anon"> 아이디 비공개(익명)</label>
                    </div>
                </div>

                <div class="row">
                    <div class="label">제목</div>
                    <div class="field">
                        <input type="text" name="title" class="input" />
                    </div>
                </div>

                <div class="row">
                    <div class="label">내용</div>
                    <div class="field">
                        <textarea name="content" class="textarea"></textarea>
                    </div>
                </div>

                <div class="btns">
                    <button type="button" class="btn" onclick="history.back()">취소</button>
                    <button type="submit" class="btn primary">작성 완료</button>
                </div>
            </div>
        </form>
    </div>
</div>

</body>
</html>
