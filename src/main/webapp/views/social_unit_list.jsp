<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    static String escJson(String s){
        if(s==null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\r","\\r").replace("\n","\\n");
    }
%>

<%
    String contextPath = request.getContextPath();

    String token = null;
    Object t1 = session.getAttribute("accessToken");
    Object t2 = session.getAttribute("token");
    if(t1!=null) token = String.valueOf(t1);
    else if(t2!=null) token = String.valueOf(t2);

    Integer sessionUserId = null;
    try{
        Object u1 = session.getAttribute("userId");
        Object u2 = session.getAttribute("userid");
        if(u1!=null) sessionUserId = Integer.parseInt(String.valueOf(u1));
        else if(u2!=null) sessionUserId = Integer.parseInt(String.valueOf(u2));
    }catch(Exception ignore){}

    // POST(평가 등록) 처리
    if("POST".equalsIgnoreCase(request.getMethod())){
        request.setCharacterEncoding("UTF-8");
        String unitName = request.getParameter("unitName");
        String rating   = request.getParameter("rating");
        String workLevel = request.getParameter("workLevel");
        String workContent = request.getParameter("workContent");
        String advantage = request.getParameter("advantage");
        String disadvantage = request.getParameter("disadvantage");
        String hope = request.getParameter("hope");

        if(unitName==null) unitName="";
        if(rating==null) rating="0";
        if(workLevel==null) workLevel="";
        if(workContent==null) workContent="";
        if(advantage==null) advantage="";
        if(disadvantage==null) disadvantage="";
        if(hope==null) hope="";

        int uid = (sessionUserId!=null? sessionUserId : 0);

        // unitId는 서버가 생성할 가능성이 높아서 0으로 보냄(예시 payload 형태 맞춤)
        String bodyJson =
                "{"
                        + "\"userId\":" + uid + ","
                        + "\"unitId\":0,"
                        + "\"star\":\"" + escJson(rating) + "\","
                        + "\"title\":\"" + escJson(unitName) + "\","
                        + "\"hard\":\"" + escJson(workLevel) + "\","
                        + "\"working\":\"" + escJson(workContent) + "\","
                        + "\"good\":\"" + escJson(advantage) + "\","
                        + "\"bad\":\"" + escJson(disadvantage) + "\","
                        + "\"hope\":\"" + escJson(hope) + "\""
                        + "}";

        try{
            ApiResp r = http("POST", "https://webserver-backend.onrender.com/api/v1/unit/create", token, bodyJson);
            // 성공/실패 상관없이 목록으로 이동(화면 깨짐 방지)
            response.sendRedirect(contextPath + "/social_unit_list?unitName=" + URLEncoder.encode(unitName, "UTF-8"));
            return;
        }catch(Exception e){
            response.sendRedirect(contextPath + "/social_unit_list?unitName=" + URLEncoder.encode(unitName, "UTF-8"));
            return;
        }
    }

    // GET(목록 조회)
    String unitName = request.getParameter("unitName");
    if(unitName==null) unitName="";

    String evalJson = "[]";
    String evalErr = null;

    try{
        String url = "https://webserver-backend.onrender.com/api/v1/unit/search?keyword=" + URLEncoder.encode(unitName, "UTF-8");
        ApiResp r = http("GET", url, token, null);
        if(r.code>=200 && r.code<300 && r.body!=null && r.body.trim().length()>0){
            evalJson = r.body.trim();
        }else{
            evalErr = "조회 실패(" + r.code + ")";
        }
    }catch(Exception e){
        evalErr = "예외: " + e.getMessage();
    }

    request.setAttribute("unitName", unitName);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부대 별 평가</title>

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

        .path-row{
            font-size:16px;
            margin-bottom:20px;
        }
        .path-row strong{font-weight:700;margin-right:6px;}
        .path-row span{color:#b3b3b3;margin-left:6px;}

        .unit-title{
            text-align:center;
            font-size:22px;
            font-weight:700;
            margin-bottom:18px;
        }

        .list-wrap{
            background:#fff;
            border:1px solid #d5d5d5;
        }
        .list-header{
            display:flex;
            justify-content:flex-end;
            padding:8px 10px;
            border-bottom:1px solid #d5d5d5;
        }
        .btn-eval{
            padding:6px 14px;
            border-radius:2px;
            border:1px solid #cccccc;
            background:#e5e5e5;
            font-size:13px;
            cursor:pointer;
        }

        table.unit-table{
            width:100%;
            border-collapse:collapse;
            font-size:13px;
        }
        table.unit-table thead{
            background:#f7f7f7;
        }
        table.unit-table th,
        table.unit-table td{
            padding:9px 10px;
            border-top:1px solid #e1e1e1;
            text-align:left;
        }
        table.unit-table th{font-weight:600;}
        .td-no{width:70px;text-align:center;}
        .td-writer,.td-score,.td-date{
            text-align:center;
            white-space:nowrap;
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
        <a href="${pageContext.request.contextPath}/main">뉴스</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social/board" class="active">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/map">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <div class="path-row">
        <strong>부대 별 평가</strong>
        <span>| 소셜 커뮤니티</span>
    </div>

    <div class="unit-title">
        ${unitName}
    </div>

    <div class="list-wrap">
        <div class="list-header">
            <button class="btn-eval" type="button"
                    onclick="location.href='${pageContext.request.contextPath}/social_unit_write?unitName=${unitName}'">
                평가하기
            </button>
        </div>

        <table class="unit-table">
            <thead>
            <tr>
                <th style="width:70px;">번호</th>
                <th>요약</th>
                <th style="width:140px;">글쓴이</th>
                <th style="width:80px;">별점</th>
                <th style="width:120px;">작성일</th>
            </tr>
            </thead>
            <tbody id="evalTbody">
            <c:forEach var="row" items="${evalList}">
                <tr>
                    <td class="td-no">${row.no}</td>
                    <td>${row.summary}</td>
                    <td class="td-writer">${row.writer}</td>
                    <td class="td-score">${row.score}</td>
                    <td class="td-date">${row.date}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</div>

<script>
    (function(){
        const tbody = document.getElementById('evalTbody');
        const raw = '<%=escJs(evalJson)%>';
        const err = '<%=escJs(evalErr)%>';

        function renderEmpty(msg){
            tbody.innerHTML = '';
            const tr = document.createElement('tr');
            const td = document.createElement('td');
            td.colSpan = 5;
            td.style.textAlign = 'center';
            td.style.padding = '16px';
            td.textContent = msg;
            tr.appendChild(td);
            tbody.appendChild(tr);
        }

        if(err && err !== 'null' && err.trim().length>0){
            renderEmpty(err);
            return;
        }

        let list = [];
        try{ list = JSON.parse(raw || '[]'); }catch(e){
            renderEmpty('JSON 파싱 실패');
            return;
        }

        if(!Array.isArray(list) || list.length===0){
            renderEmpty('평가 글이 없습니다.');
            return;
        }

        tbody.innerHTML = '';
        list.forEach((x, idx)=>{
            const tr = document.createElement('tr');

            const no = (x.unitId ?? x.unit_id ?? (idx+1)) + '';
            const title = (x.title ?? '') + '';
            const hard = (x.hard ?? '') + '';
            const summary = title ? title : (hard ? hard : '-');
            const writer = (x.userId ?? x.user_id ?? '-') + '';
            const score = (x.star ?? '-') + '';

            function td(cls, txt){
                const td = document.createElement('td');
                if(cls) td.className = cls;
                td.textContent = txt;
                return td;
            }

            tr.appendChild(td('td-no', no));
            tr.appendChild(td('', summary));
            tr.appendChild(td('td-writer', writer));
            tr.appendChild(td('td-score', score));
            tr.appendChild(td('td-date', '-'));
            tbody.appendChild(tr);
        });
    })();
</script>

</body>
</html>
