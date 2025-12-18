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

            String body = "{"
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

    <!-- 네가 원래 쓰던 링크(유지) -->
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/css/social.css">

    <!-- social.css가 없어도 화면 안 깨지게 CSS를 “포함” (기능/URL/흐름은 건드리지 않음) -->
    <style>
        * { box-sizing: border-box; margin:0; padding:0; }
        body {
            font-family: "Noto Sans KR", system-ui, -apple-system, "Segoe UI", sans-serif;
            background: #f5f5f5;
            color: #222;
        }
        a { color: inherit; text-decoration: none; }

        .header{
            height:64px;
            background:#78866B;
            color:#fff;
            padding:0 40px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:20px;
        }
        .header-left{ display:flex; align-items:center; gap:12px; }
        .header-logo-box{
            width:34px; height:34px;
            border-radius:10px;
            background:rgba(255,255,255,0.92);
        }
        .header-title{ font-weight:900; letter-spacing:0.4px; }

        .header-nav{ display:flex; align-items:center; gap:16px; }
        .header-nav a{
            color:#fff;
            opacity:0.9;
            padding:8px 6px;
            border-bottom:2px solid transparent;
        }
        .header-nav a:hover{ opacity:1; }
        .header-nav a.active{
            opacity:1;
            border-bottom-color:#fff;
            font-weight:800;
        }

        .header-right{ display:flex; align-items:center; gap:10px; white-space:nowrap; }
        .header-right span{ font-size:14px; opacity:0.95; }
        .header-right button{
            border:1px solid rgba(255,255,255,0.45);
            background:transparent;
            color:#fff;
            padding:8px 12px;
            border-radius:12px;
            cursor:pointer;
        }
        .header-right button:hover{ background:rgba(255,255,255,0.12); }

        .container{
            max-width: 980px;
            margin: 0 auto;
            padding: 26px 20px 60px;
        }
        .write-wrap{
            background:#fff;
            border-radius:16px;
            box-shadow:0 8px 20px rgba(0,0,0,0.08);
            padding:28px;
        }
        .write-wrap h2{ font-size:22px; margin-bottom:8px; }
        .sub{ color:#666; font-size:14px; margin-bottom:22px; }

        .box{
            border:1px solid #eee;
            border-radius:14px;
            background:#fafafa;
            padding:18px;
        }
        .row{
            display:flex;
            gap:14px;
            align-items:flex-start;
            margin-bottom:14px;
        }
        .label{
            width:90px;
            font-weight:800;
            color:#333;
            padding-top:10px;
        }
        .field{ flex:1; }
        input[type="radio"]{ accent-color:#78866B; }

        .input, .textarea{
            width:100%;
            border:1px solid #ddd;
            border-radius:12px;
            padding:12px;
            font-size:14px;
            background:#fff;
            outline:none;
        }
        .input:focus, .textarea:focus{
            border-color:#78866B;
            box-shadow:0 0 0 3px rgba(120,134,107,0.18);
        }
        .textarea{
            min-height:180px;
            resize:vertical;
            line-height:1.55;
        }

        .btns{
            display:flex;
            justify-content:flex-end;
            gap:10px;
            margin-top:18px;
        }
        .btn{
            padding:10px 14px;
            border-radius:12px;
            border:1px solid #d9d9d9;
            background:#fff;
            cursor:pointer;
            font-weight:800;
        }
        .btn:hover{ background:#f3f3f3; }
        .btn.primary{
            border:none;
            background:#78866B;
            color:#fff;
        }
        .btn.primary:hover{ filter:brightness(0.96); }

        @media (max-width:640px){
            .header{ padding:0 16px; }
            .row{ flex-direction:column; }
            .label{ width:auto; padding-top:0; }
            .write-wrap{ padding:18px; }
        }
    </style>
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

        <!-- 네 action 그대로 유지 -->
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
