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
    static String escJs(String s){
        if(s==null) return "";
        return s.replace("\\","\\\\")
                .replace("'","\\'")
                .replace("\r","\\r")
                .replace("\n","\\n")
                .replace("</script>","<\\/script>");
    }
%>

<%
    String contextPath = request.getContextPath();

    String token = null;
    Object t1 = session.getAttribute("accessToken");
    Object t2 = session.getAttribute("token");
    if(t1!=null) token = String.valueOf(t1);
    else if(t2!=null) token = String.valueOf(t2);

    String postsJson = "[]";
    String postsErr = null;

    try{
        ApiResp r = http("GET", "https://webserver-backend.onrender.com/api/v1/community", token, null);
        if(r.code>=200 && r.code<300 && r.body!=null && r.body.trim().length()>0){
            postsJson = r.body.trim();
        }else{
            postsErr = "목록 조회 실패 ("+r.code+")";
        }
    }catch(Exception e){
        postsErr = "목록 조회 예외: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>소셜 커뮤니티</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,
            "Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;
            color:#333;
        }

        header{
            height:64px;
            background:#78866B;
            color:#fff;
            padding:0 40px;
            display:flex;
            align-items:center;
            justify-content:space-between;
        }
        .header-left{display:flex;align-items:center;gap:14px;}
        .header-logo-box{
            width:34px;height:34px;border-radius:4px;
            background:url('${pageContext.request.contextPath}/img/KakaoTalk_20251204_101657760.png')
            center / contain no-repeat;
        }
        .header-title{font-size:22px;font-weight:700;letter-spacing:.10em;}
        .header-nav{display:flex;align-items:center;gap:26px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{display:flex;align-items:center;gap:16px;font-size:14px;}
        .btn-logout{
            padding:6px 16px;border-radius:4px;border:none;
            background:#fff;color:#78866B;font-weight:600;cursor:pointer;
        }

        .page-wrap{
            max-width:1200px;
            margin:40px auto 80px;
            padding:0 40px;
        }

        .title{
            font-size:22px;
            font-weight:700;
            margin-bottom:12px;
        }

        .tab-row{
            font-size:15px;
            margin-bottom:18px;
        }
        .tab-row strong{font-weight:700;}
        .tab-row span{
            margin-left:8px;
            color:#b3b3b3;
        }
        .tab-row a{
            color:#b3b3b3;
            text-decoration:none;
        }
        .tab-row a:hover{text-decoration:underline;}

        .table-wrap{
            background:#fff;
            border-radius:4px;
            border:1px solid #d7d7cf;
        }

        .board-header{
            padding:10px 16px;
            border-bottom:1px solid #e1e1e1;
            display:flex;
            justify-content:flex-end;
        }
        .btn-write{
            padding:6px 16px;
            border-radius:4px;
            border:none;
            background:#78866B;
            color:#fff;
            font-size:13px;
            cursor:pointer;
        }

        table.board{
            width:100%;
            border-collapse:collapse;
            font-size:13px;
        }
        table.board th,
        table.board td{
            padding:9px 10px;
            border-top:1px solid #f0f0f0;
        }
        table.board th{
            background:#f7f7f7;
            font-weight:600;
        }
        table.board td.num,
        table.board td.cnt{
            text-align:center;
            white-space:nowrap;
        }

        .pagination{
            margin-top:14px;
            display:flex;
            justify-content:center;
            gap:6px;
            font-size:12px;
        }
        .pagination a{
            text-decoration:none;
            color:#555;
            min-width:18px;
            text-align:center;
        }
        .pagination a.active{
            font-weight:700;
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
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <div class="title">소셜 커뮤니티</div>

    <div class="tab-row">
        <strong>소셜 커뮤니티</strong>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social_unit">부대 별 평가</a>
    </div>

    <div class="table-wrap">
        <div class="board-header">
            <button class="btn-write" type="button"
                    onclick="location.href='${pageContext.request.contextPath}/social/write'">
                글쓰기
            </button>
        </div>

        <table class="board">
            <thead>
            <tr>
                <th style="width:80px;">번호</th>
                <th>제목</th>
                <th style="width:120px;">글쓴이</th>
                <th style="width:120px;">작성일</th>
                <th style="width:80px;">조회</th>
                <th style="width:80px;">추천</th>
            </tr>
            </thead>
            <tbody id="postTbody">
            <!-- 예시 데이터: 진짜에선 JSTL forEach 로 채우면 됨 -->
            <tr>
                <td class="num">설문</td>
                <td>공개연애가 득보다 실한 것 같은 스타는?</td>
                <td>운영자</td>
                <td>2025.10.06</td>
                <td class="cnt">-</td>
                <td class="cnt">-</td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="pagination">
        <a href="#" class="active">1</a>
        <a href="#">2</a>
        <a href="#">3</a>
        <a href="#">&gt;</a>
    </div>

</div>

<script>
    (function(){
        const tbody = document.getElementById('postTbody');

        const raw = '<%=escJs(postsJson)%>';
        const err = '<%=escJs(postsErr)%>';

        function td(cls, text){
            const el = document.createElement('td');
            if(cls) el.className = cls;
            el.textContent = text;
            return el;
        }

        function renderEmpty(msg){
            tbody.innerHTML = '';
            const tr = document.createElement('tr');
            const td1 = document.createElement('td');
            td1.colSpan = 6;
            td1.style.textAlign = 'center';
            td1.style.padding = '16px';
            td1.textContent = msg;
            tr.appendChild(td1);
            tbody.appendChild(tr);
        }

        if(err && err !== 'null' && err.trim().length>0){
            renderEmpty(err);
            return;
        }

        let posts = [];
        try{
            posts = JSON.parse(raw || '[]');
        }catch(e){
            renderEmpty('JSON 파싱 실패');
            return;
        }

        if(!Array.isArray(posts) || posts.length === 0){
            renderEmpty('게시글이 없습니다.');
            return;
        }

        tbody.innerHTML = '';
        posts.forEach(p=>{
            const tr = document.createElement('tr');

            const postId = (p && (p.post_id ?? p.postId)) + '';
            const userId = (p && (p.user_id ?? p.userId)) + '';
            const title  = (p && (p.title ?? '')) + '';

            tr.appendChild(td('num', postId));
            const titleTd = document.createElement('td');
            titleTd.style.cursor = 'pointer';
            titleTd.textContent = title;
            titleTd.onclick = function(){
                location.href = '<%=contextPath%>/social/detail?postId=' + encodeURIComponent(postId);
            };
            tr.appendChild(titleTd);

            tr.appendChild(td('', userId));
            tr.appendChild(td('', '-'));
            tr.appendChild(td('cnt', '-'));
            tr.appendChild(td('cnt', '-'));

            tbody.appendChild(tr);
        });
    })();
</script>

</body>
</html>
