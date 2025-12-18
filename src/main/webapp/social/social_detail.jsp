<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.net.*" %>

<%!
    static class ApiResp {
        int code; String body;
        ApiResp(int c, String b){ code=c; body=b; }
    }
    static String readAll(InputStream is) throws Exception {
        if(is==null) return "";
        BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while((line=br.readLine())!=null) sb.append(line);
        return sb.toString();
    }
    static ApiResp http(String method, String urlStr, String token, String bodyJson) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod(method);
        conn.setConnectTimeout(7000);
        conn.setReadTimeout(7000);
        conn.setRequestProperty("Accept", "application/json");
        if(token!=null && token.trim().length()>0){
            conn.setRequestProperty("Authorization", "Bearer " + token.trim());
        }
        if(bodyJson!=null){
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            try(OutputStream os = conn.getOutputStream()){
                os.write(bodyJson.getBytes("UTF-8"));
            }
        }
        int code = conn.getResponseCode();
        String resp = readAll(code>=200 && code<400 ? conn.getInputStream() : conn.getErrorStream());
        return new ApiResp(code, resp);
    }
    static String esc(String s){
        if(s==null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
%>

<%
    String contextPath = request.getContextPath();

    String token = null;
    Object t1 = session.getAttribute("accessToken");
    Object t2 = session.getAttribute("token");
    if(t1!=null) token = String.valueOf(t1);
    else if(t2!=null) token = String.valueOf(t2);

    // 세션 userId (가능한 키 여러개 대응)
    Integer sessionUserId = null;
    try{
        Object u1 = session.getAttribute("userId");
        Object u2 = session.getAttribute("userid");
        if(u1!=null) sessionUserId = Integer.parseInt(String.valueOf(u1));
        else if(u2!=null) sessionUserId = Integer.parseInt(String.valueOf(u2));
    }catch(Exception ignore){}

    String postIdStr = request.getParameter("postId");
    int postId = -1;
    try{ postId = Integer.parseInt(postIdStr); }catch(Exception ignore){}

    // 삭제 요청 처리
    if("POST".equalsIgnoreCase(request.getMethod()) && "delete".equals(request.getParameter("action"))){
        try{
            ApiResp dr = http("DELETE",
                    "https://webserver-backend.onrender.com/api/v1/community/" + postId,
                    token, null);
            response.sendRedirect(contextPath + "/social/board");
            return;
        }catch(Exception e){
            request.setAttribute("deleteErr", e.getMessage());
        }
    }

    // 글 데이터: 목록에서 찾아서 표시 (단일조회 API가 없어서)
    String title = "";
    String content = "";
    Integer writerId = null;
    String loadErr = null;

    try{
        ApiResp r = http("GET", "https://webserver-backend.onrender.com/api/v1/community", token, null);
        if(r.code>=200 && r.code<300 && r.body!=null){
            String json = r.body.trim();
            // 단순 탐색: "post_id":<postId> 블록에서 title/content/user_id 추출 (JSON 라이브러리 없이 최소)
            int idx = json.indexOf("\"post_id\":" + postId);
            if(idx<0) idx = json.indexOf("\"post_id\": " + postId);
            if(idx<0) idx = json.indexOf("\"postId\":" + postId);
            if(idx<0){
                loadErr = "게시글을 찾을 수 없습니다. postId=" + postId;
            }else{
                // post object 범위 대충 잡기
                int objStart = json.lastIndexOf("{", idx);
                int objEnd = json.indexOf("}", idx);
                if(objStart>=0 && objEnd>objStart){
                    String obj = json.substring(objStart, objEnd+1);

                    // title
                    int t = obj.indexOf("\"title\"");
                    if(t>=0){
                        int q1 = obj.indexOf("\"", obj.indexOf(":", t)+1);
                        int q2 = obj.indexOf("\"", q1+1);
                        if(q1>=0 && q2>q1) title = obj.substring(q1+1, q2);
                    }
                    // content
                    int c = obj.indexOf("\"content\"");
                    if(c>=0){
                        int q1 = obj.indexOf("\"", obj.indexOf(":", c)+1);
                        int q2 = obj.indexOf("\"", q1+1);
                        if(q1>=0 && q2>q1) content = obj.substring(q1+1, q2);
                    }
                    // user_id
                    int u = obj.indexOf("\"user_id\"");
                    if(u<0) u = obj.indexOf("\"userId\"");
                    if(u>=0){
                        int colon = obj.indexOf(":", u);
                        if(colon>0){
                            String tail = obj.substring(colon+1).replaceAll("[^0-9].*$","");
                            try{ writerId = Integer.parseInt(tail.trim()); }catch(Exception ignore){}
                        }
                    }
                }
            }
        }else{
            loadErr = "조회 실패(" + r.code + ")";
        }
    }catch(Exception e){
        loadErr = "예외: " + e.getMessage();
    }

    boolean isOwner = (sessionUserId!=null && writerId!=null && sessionUserId.intValue()==writerId.intValue());
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 게시글 상세</title>

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: "Noto Sans KR", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }
        header {
            height: 64px;
            background-color: #78866B;
            color: #fff;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header-left{display:flex;align-items:center;gap:12px;}
        .header-logo-box{
            width:30px;height:30px;border-radius:6px;background:#fff;
        }
        .header-title{font-size:20px;font-weight:700;letter-spacing:.08em;}
        .header-nav{display:flex;align-items:center;gap:24px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{font-size:14px;}

        .page-wrap{
            max-width:900px;margin:24px auto 40px;padding:0 16px;
        }
        table.detail-table{
            width:100%;border-collapse:collapse;background:#fff;
        }
        .detail-table th,.detail-table td{
            border:1px solid #ddd;padding:10px 12px;font-size:14px;
        }
        .detail-table th{
            width:120px;background:#f4f4f4;text-align:center;
        }
        .detail-table td.content{
            min-height:200px;white-space:pre-wrap;
        }
        .comment-box{
            margin-top:16px;background:#fff;border-radius:6px;
            padding:10px 12px;border:1px solid #ddd;
        }
        .comment-box input{
            width:90%;border:none;outline:none;font-size:14px;
        }
        .comment-box button{
            float:right;border:none;background:#78866B;color:#fff;
            padding:4px 10px;border-radius:4px;cursor:pointer;
        }
        .btn-area{
            margin-top:16px;text-align:right;
        }
        .btn-area a, .btn-area button{
            display:inline-block;margin-left:6px;padding:6px 14px;
            border-radius:4px;text-decoration:none;font-size:13px;
            border:1px solid #ccc;background:#f5f5f5;color:#333;
            cursor:pointer;
        }
    </style>
</head>
<body>

<header>
    <div class="header-left">
        <div class="header-logo-box"></div>
        <div class="header-title">MILLI ROAD</div>
    </div>
    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/main/mainpage.jsp">뉴스</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social/board" class="active">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health/health.jsp">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/map/map.jsp">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
    </div>
</header>

<div class="page-wrap">
    <table class="detail-table">
        <tr>
            <th>제목</th>
            <td><%= (loadErr!=null? esc(loadErr) : esc(title)) %></td>
        </tr>
        <tr>
            <th>내용</th>
            <td class="content"><%= (loadErr!=null? "" : esc(content)) %></td>
        </tr>
    </table>

    <div class="comment-box">
        <span>댓글 달기 : </span>
        <input id="commentInput" type="text" placeholder="댓글을 입력해 주세요.">
        <button id="commentSendBtn" type="button">▶</button>
    </div>

    <div class="btn-area">
        <a href="${pageContext.request.contextPath}/social/board">목록</a>

        <% if(isOwner){ %>
        <form id="delForm" method="post" action="${pageContext.request.contextPath}/social/detail" style="display:inline;">
            <input type="hidden" name="postId" value="<%=postId%>">
            <input type="hidden" name="action" value="delete">
            <button type="submit">삭제하기</button>
        </form>
        <% } %>
    </div>
</div>

<script>
    (function(){
        const btn = document.getElementById('commentSendBtn');
        btn.addEventListener('click', function(){
            // 댓글 API(생성/목록)가 아직 확정이 안 됨 → 일단 화면 오류 없이 막아둠
            alert('댓글 API 엔드포인트가 아직 확정되지 않았습니다. (지금은 화면만 유지)');
        });
    })();
</script>

</body>
</html>
