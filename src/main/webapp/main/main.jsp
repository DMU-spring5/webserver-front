<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%
    String accessToken = (String) session.getAttribute("accessToken");
    if (accessToken == null) accessToken = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD</title>
    <!-- 통합 CSS 연결 -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body>

<!-- 상단 헤더 -->
<header class="header">
    <div class="header-inner">
        <!-- 로고 -->
        <div class="logo">
            <img src="${pageContext.request.contextPath}/img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

        <!-- 검색 + 메뉴 영역 -->
        <div class="header-center">
            <!-- 검색창 -->
            <div class="search-box">
                <span class="search-icon"><img src="${pageContext.request.contextPath}/img/search.png"></span>
                <input type="text" placeholder="검색어를 입력하세요">
            </div>

            <nav class="nav">
                <!-- .jsp 를 붙여서 직접 파일로 이동하게 수정 -->
                <a href="${pageContext.request.contextPath}/main.jsp" class="active">뉴스</a>
                <span class="divider">|</span>
                <a href="#">소셜</a>
                <span class="divider">|</span>
                <!-- .jsp 붙이기 -->
                <a href="${pageContext.request.contextPath}/health/health.jsp">건강</a>
                <span class="divider">|</span>
                <a href="#">지도</a>
            </nav>
        </div>
    </div>
</header>

<!-- 메인 레이아웃 -->
<div class="container">
    <!-- 로그인 + 캘린더 -->
    <aside class="left-box">
        <!-- 프로필 박스 -->
        <div class="profile-box">
            <!-- 프로필 이미지 -->
            <div class="profile-image">
                <img src="${pageContext.request.contextPath}/img/profile.png" alt="프로필 이미지">
            </div>

            <!-- 회원 정보 (API 연동 후 span에 값 채움) -->
            <div class="profile-info-text">
                <p>사단 : <span id="division"><%= session.getAttribute("division") != null ? session.getAttribute("division") : "-" %></span></p>
                <p>부대명 : <span id="unit"><%= session.getAttribute("unit") != null ? session.getAttribute("unit") : "-" %></span></p>
                <p>이름 : <span id="nickname"><%= session.getAttribute("name") != null ? session.getAttribute("name") : "-" %></span></p>
                <p>계급 : <span id="rank"><%= session.getAttribute("rank") != null ? session.getAttribute("rank") : "-" %></span></p>
            </div>

            <div class="profile-dday" id="dday">
                D - <%= session.getAttribute("dDay") != null ? session.getAttribute("dDay") : "-" %>
            </div>
            <!-- .jsp 붙이기 -->
            <button class="logout-btn" onclick="location.href='../login/login.jsp'">
                로그아웃
            </button>
        </div>

        <!-- 캘린더 -->
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

    <!-- 가운데 박스 : 뉴스 -->
    <main class="main-news">
        <!-- 왼쪽 메인 뉴스 영역 -->
        <div class="main-news-left">
            <h4 class="news-date" id="newsDate"></h4>
            <div id="news-container">
                <p>뉴스 로딩 중...</p>
            </div>
        </div>

        <!-- 오른쪽 : 맞춤 뉴스 + 날씨 -->
        <div class="main-news-right">
            <!-- 맞춤 뉴스 -->
            <section class="side-section">
                <div class="side-header">[ 맞춤 뉴스 ]</div>
                <div class="side-news-item">
                    <img src="${pageContext.request.contextPath}/img/army.png" onerror="this.style.display='none'">
                    <div>
                        <div class="side-news-title">군 복지 개선 정책 발표</div>
                        <div class="side-news-meta">연합뉴스 | 2일 전</div>
                    </div>
                </div>
            </section>

            <!-- 날씨 (HTML만 유지, API 호출 없음) -->
            <section class="side-section weather-box">
                <div class="weather-inner">
                    <div class="weather-location" id="weather-location">서울, 한국</div>
                    <div class="weather-icon" id="weather-icon">☀</div>
                    <div class="weather-temp" id="weather-temp">--℃</div>
                    <div class="weather-desc" id="weather-desc">날씨 정보 로딩...</div>
                </div>
            </section>
        </div>
    </main>
</div>

<!-- ======================= Script 영역 ======================= -->

<!-- 1. 캘린더 및 초기화 -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const prevMonth = document.getElementById("prevMonth");
        const nextMonth = document.getElementById("nextMonth");

        function getKstToday() {
            const now = new Date();
            const utc = now.getTime() + now.getTimezoneOffset() * 60000;
            return new Date(utc + 9 * 60 * 60000);
        }

        const kstToday = getKstToday();
        let currentYear = kstToday.getFullYear();
        let currentMonth = kstToday.getMonth();

        // 뉴스 제목 날짜
        const newsMonth = kstToday.getMonth() + 1;
        const newsDay = kstToday.getDate();
        const newsTitleEl = document.getElementById("newsDate");
        if (newsTitleEl) {
            newsTitleEl.innerText = newsMonth + "월 " + newsDay + "일 뉴스";
        }

        // 캘린더 렌더링
        function renderCalendar(year, month) {
            const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"];
            document.getElementById("currentMonth").textContent = monthNames[month] + " " + year;

            const firstDay = new Date(year, month, 1);
            const lastDay = new Date(year, month + 1, 0);

            let startDay = firstDay.getDay();
            let totalDays = lastDay.getDate();
            let html = "<tr>";
            let count = 0;

            for (let i = 0; i < startDay; i++) {
                html += "<td></td>";
                count++;
            }

            for (let d = 1; d <= totalDays; d++) {
                const isToday =
                    year === kstToday.getFullYear() &&
                    month === kstToday.getMonth() &&
                    d === kstToday.getDate();

                if (isToday) {
                    html += '<td class="today-cell">' + d + '</td>';
                } else {
                    html += '<td>' + d + '</td>';
                }

                count++;
                if (count % 7 === 0 && d !== totalDays) html += "</tr><tr>";
            }
            html += "</tr>";
            document.getElementById("calendarBody").innerHTML = html;
        }

        renderCalendar(currentYear, currentMonth);

        prevMonth.onclick = () => {
            currentMonth--;
            if (currentMonth < 0) { currentMonth = 11; currentYear--; }
            renderCalendar(currentYear, currentMonth);
        };

        nextMonth.onclick = () => {
            currentMonth++;
            if (currentMonth > 11) { currentMonth = 0; currentYear++; }
            renderCalendar(currentYear, currentMonth);
        };
    });
</script>

<!-- 2. 백엔드 데이터 및 뉴스 API만 사용 -->
<script>
    const BASE_URL = "https://webserver-backend.onrender.com";
    const accessToken = "<%= accessToken %>";
    const CTX = "<%= request.getContextPath() %>";

    // --- (1) 사용자 정보 가져오기 (메인페이지 API) ---
    if (accessToken && accessToken.trim().length > 0) {
        fetch(BASE_URL + "/api/v1/mainpage", {
            method: "GET",
            headers: { "Authorization": "Bearer " + accessToken }
        })
            .then(res => {
                if (res.status === 401 || res.status === 403) {
                    location.replace("${pageContext.request.contextPath}/login/login.jsp");
                    return Promise.reject("Unauthorized");
                }
                if (!res.ok) return Promise.reject("API Error: " + res.status);
                return res.json();
            })
            .then(data => {
                const setText = (id, value) => {
                    const el = document.getElementById(id);
                    if (!el) return;
                    el.innerText = (value !== null && value !== undefined && value !== "") ? value : "-";
                };

                setText("division", data.division);
                setText("unit", data.unit);
                setText("nickname", data.nickname);

                // 계급: militaryProgress.nowRank
                const nowRank = (data && data.militaryProgress) ? data.militaryProgress.nowRank : null;
                setText("rank", nowRank);

                // D-Day: militaryProgress.daysToDischarge (없으면 data.dDay fallback)
                const dDayVal = (data && data.militaryProgress && data.militaryProgress.daysToDischarge !== undefined)
                    ? data.militaryProgress.daysToDischarge
                    : data.dDay;

                const ddayEl = document.getElementById("dday");
                if (ddayEl) {
                    ddayEl.innerText = (dDayVal !== null && dDayVal !== undefined && dDayVal !== "")
                        ? ("D - " + dDayVal)
                        : "D - -";
                }
            })
            .catch(err => console.log("Mainpage User Info Load Error:", err));
    }

    // --- (2) 뉴스 API (백엔드 네이버 뉴스 API: 속보/군대) ---
    const esc = (s) => String(s ?? "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");

    const stripTags = (s) => String(s ?? "").replace(/<[^>]*>/g, "");

    const domainOf = (url) => {
        try { return new URL(url).hostname.replace(/^www\./, ""); }
        catch(e) { return ""; }
    };

    const formatKst = (pubDateStr) => {
        const d = new Date(pubDateStr);
        if (isNaN(d.getTime())) return "";
        const mm = String(d.getMonth() + 1).padStart(2, "0");
        const dd = String(d.getDate()).padStart(2, "0");
        const hh = String(d.getHours()).padStart(2, "0");
        const mi = String(d.getMinutes()).padStart(2, "0");
        return `${mm}.${dd} ${hh}:${mi}`;
    };

    const fetchNews = (query) => {
        const url = BASE_URL + `/api/v1/naver/news?query=${encodeURIComponent(query)}`;
        const headers = {};
        // 백엔드가 인증 걸어놨을 수도 있어서: 토큰 있으면 같이 보냄
        if (accessToken && accessToken.trim().length > 0) {
            headers["Authorization"] = "Bearer " + accessToken;
        }
        return fetch(url, { method: "GET", headers })
            .then(res => {
                if (!res.ok) return Promise.reject("News API Error: " + res.status);
                return res.json();
            });
    };

    // (2-1) 메인 뉴스: 속보 -> #news-container
    fetchNews("속보")
        .then(data => {
            const box = document.getElementById("news-container");
            if (!box) return;
            box.innerHTML = "";

            const items = Array.isArray(data && data.items) ? data.items : [];
            if (items.length === 0) {
                box.innerHTML = "<p>뉴스 정보를 불러올 수 없어요.</p>";
                return;
            }

            items.forEach(item => {
                const title = stripTags(item.title);
                const desc  = stripTags(item.description);
                const meta  = `${esc(domainOf(item.originallink || item.link))}${item.pubDate ? " | " + esc(formatKst(item.pubDate)) : ""}`;

                box.innerHTML += `
                    <div class="news-item">
                        <div>
                            <div class="news-meta">${meta}</div>
                            <div class="news-title">${esc(title)}</div>
                            <div class="news-desc">${esc(desc)}</div>
                        </div>
                        <img class="news-img"
                             src="${CTX}/img/default_news.png"
                             onerror="this.src='${CTX}/img/default_news.png'">
                    </div>
                `;
            });
        })
        .catch(err => {
            const box = document.getElementById("news-container");
            if (box) box.innerHTML = "<p>뉴스를 불러올 수 없습니다.</p>";
            console.log("News Load Error:", err);
        });

    // (2-2) 맞춤 뉴스: 군대 -> 오른쪽 첫 번째 .side-section (맞춤 뉴스)
    fetchNews("군대")
        .then(data => {
            const section = document.querySelector(".main-news-right .side-section"); // 첫번째 = 맞춤뉴스 섹션
            if (!section) return;

            const headerEl = section.querySelector(".side-header");
            if (!headerEl) return;

            const items = Array.isArray(data && data.items) ? data.items : [];
            if (items.length === 0) return;

            const max = Math.min(items.length, 3);
            let html = headerEl.outerHTML;

            for (let i = 0; i < max; i++) {
                const item = items[i];
                const title = stripTags(item.title);
                const meta  = `${esc(domainOf(item.originallink || item.link))}${item.pubDate ? " | " + esc(formatKst(item.pubDate)) : ""}`;

                html += `
                    <div class="side-news-item">
                        <img src="${CTX}/img/army.png" onerror="this.style.display='none'">
                        <div>
                            <div class="side-news-title">${esc(title)}</div>
                            <div class="side-news-meta">${meta}</div>
                        </div>
                    </div>
                `;
            }

            section.innerHTML = html;
        })
        .catch(err => console.log("Army News Load Error:", err));

    // 날씨 API는 요청하지 않음(요구사항: mainpage/속보/군대만)
    // 날씨 박스 문구만 '유지'
    const wDesc = document.getElementById("weather-desc");
    if (wDesc) wDesc.textContent = "날씨 API 미연동";
</script>

</body>
</html>
