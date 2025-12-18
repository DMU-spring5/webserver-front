<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ page import="java.io.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.nio.charset.StandardCharsets"%>
<%@ page import="java.util.*"%>

<%!
    private String safeJsonScript(String s) {
        if (s == null) return "";
        return s.replace("</", "<\\/");
    }

    private String escapeForJsonString(String s) {
        if (s == null) return "";
        s = s.replace("\\", "\\\\");
        s = s.replace("\"", "\\\"");
        s = s.replace("\r", "\\r");
        s = s.replace("\n", "\\n");
        s = s.replace("\t", "\\t");
        s = s.replace("\u2028", "\\u2028");
        s = s.replace("\u2029", "\\u2029");
        return s;
    }

    // { "code":200, "body":"{...}", "error":"..." }
    private String httpGetJsonPack(String urlStr, Map<String,String> headers) {
        HttpURLConnection conn = null;
        BufferedReader br = null;
        int code = -1;

        try {
            URL url = new URL(urlStr);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(15000);

            // 기본 헤더
            conn.setRequestProperty("User-Agent",
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36");
            conn.setRequestProperty("Accept", "application/json, text/plain, */*");
            conn.setRequestProperty("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7");
            conn.setRequestProperty("Referer", "https://webserver-backend.onrender.com/");
            conn.setRequestProperty("Connection", "close");

            if (headers != null) {
                for (Map.Entry<String,String> e : headers.entrySet()) {
                    conn.setRequestProperty(e.getKey(), e.getValue());
                }
            }

            code = conn.getResponseCode();
            InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
            if (is == null) {
                return "{\"code\":" + code + ",\"body\":\"\",\"error\":\"empty_stream\"}";
            }

            br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }

            String body = escapeForJsonString(sb.toString());
            return "{\"code\":" + code + ",\"body\":\"" + body + "\",\"error\":\"\"}";

        } catch(Exception e) {
            String msg = (e.getMessage() == null) ? "" : e.getMessage();
            msg = escapeForJsonString(msg);
            return "{\"code\":" + code + ",\"body\":\"\",\"error\":\"" + msg + "\"}";
        } finally {
            try { if (br != null) br.close(); } catch(Exception ignore) {}
            try { if (conn != null) conn.disconnect(); } catch(Exception ignore) {}
        }
    }

    private String emptyItems() { return "{\"items\":[]}"; }
%>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");

    String ctx = request.getContextPath();

    String accessToken = (String) session.getAttribute("accessToken");
    if (accessToken == null) accessToken = "";
    accessToken = accessToken.trim();

    boolean loggedIn = accessToken.length() > 0;

    // ===== 뉴스 API (서버에서 직접 호출) =====
    String initPack = "{\"code\":-1,\"body\":\"" + escapeForJsonString(emptyItems()) + "\",\"error\":\"\"}";
    String sokboPack   = initPack;
    String guninPack   = initPack;
    String economyPack = initPack;
    String sportPack   = initPack;

    try {
        String base = "https://webserver-backend.onrender.com/api/v1/naver/news?query=";

        // ✅ 로그인 상태면 뉴스 호출에도 Authorization 헤더 붙이기
        Map<String,String> newsH = null;
        if (loggedIn) {
            newsH = new HashMap<>();
            newsH.put("Authorization", "Bearer " + accessToken);
        }

        sokboPack   = httpGetJsonPack(base + URLEncoder.encode("속보", "UTF-8"), newsH);
        guninPack   = httpGetJsonPack(base + URLEncoder.encode("군인", "UTF-8"), newsH);
        economyPack = httpGetJsonPack(base + URLEncoder.encode("경제", "UTF-8"), newsH);
        sportPack   = httpGetJsonPack(base + URLEncoder.encode("스포츠", "UTF-8"), newsH);
    } catch(Exception ignore) {}

    // ===== 로그인 상태면 메인페이지(사단/계급) =====
    String mainpagePack = "{\"code\":-1,\"body\":\"{}\",\"error\":\"\"}";
    if (loggedIn) {
        Map<String,String> h = new HashMap<>();
        h.put("Authorization", "Bearer " + accessToken);
        mainpagePack = httpGetJsonPack("https://webserver-backend.onrender.com/api/v1/mainpage", h);
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD</title>
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/css/index.css">
</head>
<body>

<header class="header">
    <div class="header-inner">
        <div class="logo">
            <img src="<%=ctx%>/img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

        <div class="header-center">
            <div class="search-box">
                <span class="search-icon"><img src="<%=ctx%>/img/search.png" alt="검색"></span>
                <input type="text" placeholder="검색어를 입력하세요">
            </div>

            <nav class="nav">
                <a href="<%=ctx%>/main/main.jsp" class="active">뉴스</a>
                <span class="divider">|</span>
                <a href="<%=ctx%>/social/board">소셜</a>
                <span class="divider">|</span>
                <a href="<%=ctx%>/health/health.jsp">건강</a>
                <span class="divider">|</span>
                <a href="<%=ctx%>/map">지도</a>
            </nav>
        </div>
    </div>
</header>

<div class="container">

    <aside class="left-box">
        <div class="profile-box">
            <div class="profile-image">
                <img src="<%=ctx%>/img/profile.png" alt="프로필 이미지">
            </div>

            <div class="profile-info-text">
                <p>사단 : <span id="division">-</span></p>
                <p>부대명 : <span id="unit">-</span></p>
                <p>이름 : <span id="nickname">-</span></p>
                <p>계급 : <span id="rank">-</span></p>
            </div>

            <div class="profile-dday" id="dday">D - -</div>

            <% if (loggedIn) { %>
            <button class="logout-btn" onclick="location.href='<%=ctx%>/login/login_out.jsp'">로그아웃</button>
            <% } else { %>
            <button class="logout-btn" onclick="location.href='<%=ctx%>/login/login.jsp'">로그인</button>
            <% } %>
        </div>

        <div class="calendar">
            <div class="calendar-header">
                <button class="cal-nav" id="prevMonth">&lt;</button>
                <p class="calendar-month" id="currentMonth"></p>
                <button class="cal-nav" id="nextMonth">&gt;</button>
            </div>

            <table>
                <thead>
                <tr>
                    <th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th>
                    <th>Thu</th><th>Fri</th><th>Sat</th>
                </tr>
                </thead>
                <tbody id="calendarBody"></tbody>
            </table>
        </div>
    </aside>

    <main class="main-news">
        <div class="main-news-left">
            <h4 class="news-date" id="newsDate"></h4>

            <h4 style="margin-top:10px;">[ 속보 ]</h4>
            <div id="news-container">
                <p>뉴스 로딩 중...</p>
            </div>

            <h4 style="margin-top:18px;">[ 군대 뉴스 ]</h4>
            <div id="army-news-container">
                <p>뉴스 로딩 중...</p>
            </div>
        </div>

        <div class="main-news-right">

            <section class="side-section" id="sports-section">
                <div class="side-header">[ 맞춤 뉴스 : 스포츠 ]</div>
                <div class="side-news-item">
                    <div>
                        <div class="side-news-title">스포츠 뉴스 로딩 중...</div>
                        <div class="side-news-meta">-</div>
                    </div>
                </div>
            </section>

            <section class="side-section" id="economy-section">
                <div class="side-header">[ 맞춤 뉴스 : 경제 ]</div>
                <div class="side-news-item">
                    <div>
                        <div class="side-news-title">경제 뉴스 로딩 중...</div>
                        <div class="side-news-meta">-</div>
                    </div>
                </div>
            </section>

            <section class="side-section weather-box">
                <div class="weather-inner">
                    <div class="weather-location" id="weather-location">서울, 한국</div>
                    <div class="weather-icon" id="weather-icon">☀</div>
                    <div class="weather-temp" id="weather-temp">--℃</div>
                    <div class="weather-desc" id="weather-desc">날씨 API 미연동</div>
                </div>
            </section>
        </div>
    </main>
</div>

<!-- ✅ 서버에서 가져온 패킷(코드/바디/에러) -->
<script type="application/json" id="pack-sokbo"><%= safeJsonScript(sokboPack) %></script>
<script type="application/json" id="pack-gunin"><%= safeJsonScript(guninPack) %></script>
<script type="application/json" id="pack-economy"><%= safeJsonScript(economyPack) %></script>
<script type="application/json" id="pack-sport"><%= safeJsonScript(sportPack) %></script>
<script type="application/json" id="pack-mainpage"><%= safeJsonScript(mainpagePack) %></script>

<script>
    const CTX = "<%=ctx%>";
    const LOGGED_IN = <%= loggedIn %>;
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        function getKstToday() {
            const now = new Date();
            const utc = now.getTime() + now.getTimezoneOffset() * 60000;
            return new Date(utc + 9 * 60 * 60000);
        }

        const kstToday = getKstToday();
        let currentYear = kstToday.getFullYear();
        let currentMonth = kstToday.getMonth();

        const newsMonth = kstToday.getMonth() + 1;
        const newsDay = kstToday.getDate();
        const newsTitleEl = document.getElementById("newsDate");
        if (newsTitleEl) newsTitleEl.innerText = newsMonth + "월 " + newsDay + "일 뉴스";

        function renderCalendar(year, month) {
            const monthNames = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"];
            document.getElementById("currentMonth").textContent = monthNames[month] + " " + year;

            const firstDay = new Date(year, month, 1);
            const lastDay = new Date(year, month + 1, 0);

            let startDay = firstDay.getDay();
            let totalDays = lastDay.getDate();
            let html = "<tr>";
            let count = 0;

            for (let i = 0; i < startDay; i++) { html += "<td></td>"; count++; }

            for (let d = 1; d <= totalDays; d++) {
                const isToday =
                    year === kstToday.getFullYear() &&
                    month === kstToday.getMonth() &&
                    d === kstToday.getDate();

                html += isToday ? '<td class="today-cell">' + d + '</td>' : '<td>' + d + '</td>';
                count++;
                if (count % 7 === 0 && d !== totalDays) html += "</tr><tr>";
            }
            html += "</tr>";
            document.getElementById("calendarBody").innerHTML = html;
        }

        renderCalendar(currentYear, currentMonth);

        document.getElementById("prevMonth").onclick = () => {
            currentMonth--;
            if (currentMonth < 0) { currentMonth = 11; currentYear--; }
            renderCalendar(currentYear, currentMonth);
        };
        document.getElementById("nextMonth").onclick = () => {
            currentMonth++;
            if (currentMonth > 11) { currentMonth = 0; currentYear++; }
            renderCalendar(currentYear, currentMonth);
        };
    });
</script>

<script>
    function readPack(id){
        try{
            const el = document.getElementById(id);
            const txt = (el && el.textContent) ? el.textContent.trim() : "{}";
            return JSON.parse(txt);
        }catch(e){
            return {code:-1, body:"{}", error:"parse_failed"};
        }
    }

    function parseBody(pack){
        try{
            if (!pack || pack.code < 200 || pack.code >= 300) return {items:[]};
            return JSON.parse(pack.body || "{}");
        }catch(e){
            return {items:[]};
        }
    }

    function unwrapMain(obj){
        if (!obj || typeof obj !== "object") return {};
        if (obj.data && typeof obj.data === "object") return obj.data;
        if (obj.result && typeof obj.result === "object") return obj.result;
        if (obj.response && typeof obj.response === "object") return obj.response;
        return obj;
    }

    const P_SOKBO = readPack("pack-sokbo");
    const P_GUNIN = readPack("pack-gunin");
    const P_ECON  = readPack("pack-economy");
    const P_SPORT = readPack("pack-sport");
    const P_MAIN  = readPack("pack-mainpage");

    const SOKBO_DATA = parseBody(P_SOKBO);
    const GUNIN_DATA = parseBody(P_GUNIN);
    const ECON_DATA  = parseBody(P_ECON);
    const SPORT_DATA = parseBody(P_SPORT);

    const MAIN_RAW  = parseBody(P_MAIN);
    const MAIN_DATA = unwrapMain(MAIN_RAW);

    const esc = (s) => String(s ?? "")
        .replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")
        .replace(/"/g,"&quot;").replace(/'/g,"&#39;");

    const stripTags = (s) => String(s ?? "").replace(/<[^>]*>/g, "");

    const decodeHtml = (s) => {
        const ta = document.createElement("textarea");
        ta.innerHTML = String(s ?? "");
        return ta.value;
    };
    const cleanText = (s) => decodeHtml(stripTags(s));

    const domainOf = (url) => { try { return new URL(url).hostname.replace(/^www\./,""); } catch(e){ return ""; } };
    const formatKst = (pubDateStr) => {
        const d = new Date(pubDateStr);
        if (isNaN(d.getTime())) return "";
        const mm = String(d.getMonth()+1).padStart(2,"0");
        const dd = String(d.getDate()).padStart(2,"0");
        const hh = String(d.getHours()).padStart(2,"0");
        const mi = String(d.getMinutes()).padStart(2,"0");
        return mm + "." + dd + " " + hh + ":" + mi;
    };

    function failHtml(pack){
        const code = (pack && pack.code !== undefined) ? pack.code : "-";
        const err  = (pack && pack.error) ? (" / " + esc(pack.error)) : "";
        return "<p>뉴스 정보를 불러올 수 없습니다. (HTTP " + esc(code) + err + ")</p>";
    }

    function renderNewsList(containerId, items, packForFail) {
        const box = document.getElementById(containerId);
        if (!box) return;

        box.innerHTML = "";
        if (!items || items.length === 0) {
            box.innerHTML = failHtml(packForFail);
            return;
        }

        const max = Math.min(items.length, 6);
        for (let i=0;i<max;i++){
            const it = items[i];
            const title = cleanText(it.title);
            const desc  = cleanText(it.description);
            const meta  = domainOf(it.originallink || it.link) + (it.pubDate ? (" | " + formatKst(it.pubDate)) : "");
            const link  = it.link || it.originallink || "#";
            const imgSrc = CTX + "/img/default_news.png";

            const a = document.createElement("a");
            a.className = "news-item";
            a.href = link;
            a.target = "_blank";
            a.rel = "noopener noreferrer";

            const wrap = document.createElement("div");

            const metaDiv = document.createElement("div");
            metaDiv.className = "news-meta";
            metaDiv.textContent = meta;

            const titleDiv = document.createElement("div");
            titleDiv.className = "news-title";
            titleDiv.textContent = title;

            const descDiv = document.createElement("div");
            descDiv.className = "news-desc";
            descDiv.textContent = desc;

            wrap.appendChild(metaDiv);
            wrap.appendChild(titleDiv);
            wrap.appendChild(descDiv);

            const img = document.createElement("img");
            img.className = "news-img";
            img.src = imgSrc;
            img.onerror = function(){ this.style.display = "none"; };

            a.appendChild(wrap);
            a.appendChild(img);
            box.appendChild(a);
        }
    }

    function renderSide(sectionId, items, packForFail, failText) {
        const section = document.getElementById(sectionId);
        if (!section) return;

        const headerEl = section.querySelector(".side-header");
        const headerClone = headerEl ? headerEl.cloneNode(true) : null;

        section.innerHTML = "";
        if (headerClone) section.appendChild(headerClone);

        if (!items || items.length === 0) {
            const code = (packForFail && packForFail.code !== undefined) ? packForFail.code : "-";
            const err  = (packForFail && packForFail.error) ? (" / " + packForFail.error) : "";
            const item = document.createElement("div");
            item.className = "side-news-item";
            const inner = document.createElement("div");
            const t = document.createElement("div");
            t.className = "side-news-title";
            t.textContent = failText + " (HTTP " + code + err + ")";
            inner.appendChild(t);
            item.appendChild(inner);
            section.appendChild(item);
            return;
        }

        const max = Math.min(items.length, 3);
        for (let i=0;i<max;i++){
            const it = items[i];
            const title = cleanText(it.title);
            const meta  = domainOf(it.originallink || it.link) + (it.pubDate ? (" | " + formatKst(it.pubDate)) : "");
            const link  = it.link || it.originallink || "#";

            const a = document.createElement("a");
            a.className = "side-news-item";
            a.href = link;
            a.target = "_blank";
            a.rel = "noopener noreferrer";

            const wrap = document.createElement("div");

            const t = document.createElement("div");
            t.className = "side-news-title";
            t.textContent = title;

            const m = document.createElement("div");
            m.className = "side-news-meta";
            m.textContent = meta;

            wrap.appendChild(t);
            wrap.appendChild(m);
            a.appendChild(wrap);
            section.appendChild(a);
        }
    }

    renderNewsList("news-container", Array.isArray(SOKBO_DATA.items) ? SOKBO_DATA.items : [], P_SOKBO);
    renderNewsList("army-news-container", Array.isArray(GUNIN_DATA.items) ? GUNIN_DATA.items : [], P_GUNIN);
    renderSide("economy-section", Array.isArray(ECON_DATA.items) ? ECON_DATA.items : [], P_ECON, "경제 뉴스 실패");
    renderSide("sports-section", Array.isArray(SPORT_DATA.items) ? SPORT_DATA.items : [], P_SPORT, "스포츠 뉴스 실패");

    if (LOGGED_IN) {
        const data = MAIN_DATA || {};
        const setText = (id, v) => {
            const el = document.getElementById(id);
            if (!el) return;
            el.innerText = (v !== null && v !== undefined && v !== "") ? v : "-";
        };

        setText("division", data.division);
        setText("unit", data.unit);
        setText("nickname", data.nickname);
        setText("rank", data.militaryProgress ? data.militaryProgress.nowRank : null);

        const ddayEl = document.getElementById("dday");
        const dday = data.militaryProgress ? data.militaryProgress.daysToDischarge : null;
        if (ddayEl) ddayEl.innerText = (dday !== null && dday !== undefined) ? ("D - " + dday) : "D - -";
    }
</script>

</body>
</html>
