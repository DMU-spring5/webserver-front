<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD</title>
    <link rel="stylesheet" type="text/css" href="mainpage.css">
</head>
<body>
<!-- 상단 헤더 -->
<header class="header">
    <div class="header-inner">
        <!-- 로고 -->
        <div class="logo">
            <img src="../img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

        <!-- 검색 + 메뉴 영역 -->
        <div class="header-center">
            <!-- 검색창 -->
            <div class="search-box">
                <span class="search-icon"><img src="../img/search.png"></span>
                <input type="text" placeholder="검색어를 입력하세요">
            </div>

            <!-- 메뉴 -->
            <nav class="nav">
                <a href="index.jsp" class="active">뉴스</a>
                <span class="divider">|</span>
                <a href="#">소셜</a>
                <span class="divider">|</span>
                <a href="health/health.jsp">건강</a>
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
        <!-- 로그인 박스 -->
        <div class="left-box">
            <div class="profile-box">
                <!-- 프로필 이미지 -->
                <div class="profile-image">
                    <img src="../img/profile.png" alt="프로필 이미지">
                </div>

                <!-- 회원 정보 -->
                <div class="profile-info-text">
                    <p>사단 : <%= session.getAttribute("division") %></p>
                    <p>부대명 : <%= session.getAttribute("unit") %></p>
                    <p>이름 : <%= session.getAttribute("name") %></p>
                    <p>계급 : <%= session.getAttribute("rank") %></p>
                </div>

                <div class="profile-dday">
                    D - <%= session.getAttribute("dDay") %>
                </div>

                <!-- 로그아웃 버튼 -->
                <button class="logout-btn" onclick="location.href='logout.jsp'">
                    로그아웃
                </button>
            </div>
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

        <!-- 오른쪽 : 맞춤 뉴스 + 군대 뉴스 + 날씨 -->
        <div class="main-news-right">

            <!-- 맞춤 뉴스 -->
            <section class="side-section">
                <div class="side-header">[ 맞춤 뉴스 ]</div>
                <div class="side-news-item">
                    <img src="../img/army.png">
                    <div>
                        <div class="side-news-title">군 복지 개선 정책 발표</div>
                        <div class="side-news-meta">연합뉴스 | 2일 전</div>
                    </div>
                </div>
            </section>

            <!-- 날씨 -->
            <section class="side-section weather-box">
                <div class="weather-inner">
                    <div class="weather-location" id="weather-location">서울, 한국</div>

                    <div class="weather-icon" id="weather-icon">☀</div>
                    <div class="weather-temp" id="weather-temp">--℃</div>
                    <div class="weather-desc" id="weather-desc">날씨 정보를 불러올 수 없어요.</div>
                </div>
            </section>

        </div>
    </main>
</div>

<!--캘린더-->
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

        // 뉴스 제목에 오늘 날짜 넣기
        const newsMonth = kstToday.getMonth() + 1;
        const newsDay = kstToday.getDate();

        const newsTitleEl = document.getElementById("newsDate");
        if (newsTitleEl) {
            newsTitleEl.innerText =
                newsMonth + "월 " + newsDay + "일 뉴스";
        }

        // 기존 캘린더 코드
        function renderCalendar(year, month) {

            const monthNames = [
                "Jan.","Feb.","Mar.","Apr.","May","Jun.",
                "Jul.","Aug.","Sept.","Oct.","Nov.","Dec."
            ];

            document.getElementById("currentMonth").textContent =
                monthNames[month] + " " + year;

            const firstDay = new Date(year, month, 1);
            const lastDay  = new Date(year, month + 1, 0);

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

                <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
                <!DOCTYPE html>
                <html lang="ko">
                    <head>
                    <meta charset="UTF-8">
                    <title>MILLI ROAD - 메인</title>

                <style>
                    * { box-sizing:border-box; margin:0; padding:0; }

                    body {
                    font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,
                    "Segoe UI",system-ui,sans-serif;
                    background:#f5f5f5;
                    color:#333;
                }

                    /* ===== 상단 공통 헤더 ===== */
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
                    width:90px;
                    height:36px;
                    background:url('${pageContext.request.contextPath}/img/KakaoTalk_20251204_101657760.png')
                    left center / contain no-repeat;
                }
                    .header-title{font-size:0;}
                    .header-nav{
                    display:flex;
                    align-items:center;
                    gap:26px;
                    font-size:15px;
                }
                    .header-nav a{
                    color:#fff;
                    text-decoration:none;
                }
                    .header-nav a:hover{text-decoration:underline;}
                    .header-nav a.active{
                    font-weight:700;
                    text-decoration:underline;
                }
                    .header-right{
                    display:flex;
                    align-items:center;
                    gap:16px;
                    font-size:14px;
                }
                    .btn-logout{
                    padding:6px 16px;
                    border-radius:4px;
                    border:none;
                    background:#fff;
                    color:#78866B;
                    font-weight:600;
                    cursor:pointer;
                }

                    /* ===== 상단 검색창 ===== */
                    .top-search-wrap{
                    max-width:1200px;
                    margin:16px auto 0;
                    padding:0 40px;
                }
                    .top-search-inner{
                    width:100%;
                    height:40px;
                    border-radius:4px;
                    background:#fff;
                    border:1px solid #d0d0c8;
                    display:flex;
                    align-items:center;
                    padding:0 12px;
                }
                    .top-search-input{
                    flex:1;
                    border:none;
                    outline:none;
                    font-size:13px;
                    color:#555;
                }
                    .top-search-icon{
                    width:18px;height:18px;
                    background:url('${pageContext.request.contextPath}/img/search.png')
                    center / 14px no-repeat;
                }

                    /* ===== 메인 3열 레이아웃 ===== */
                    .page-wrap{
                    max-width:1200px;
                    margin:12px auto 60px;
                    padding:0 40px;
                    display:grid;
                    grid-template-columns:260px minmax(0,1fr) 260px;
                    gap:20px;
                }

                    /* ===== 왼쪽: 프로필 + 캘린더 ===== */
                    .left-col{
                    display:flex;
                    flex-direction:column;
                    gap:16px;
                }

                    .profile-card{
                    background:#fff;
                    border-radius:6px;
                    padding:14px 12px 14px;
                    border:1px solid #ddd;
                }
                    .profile-top{
                    display:flex;
                    gap:10px;
                    margin-bottom:10px;
                }
                    .profile-avatar{
                    width:70px;height:70px;
                    border-radius:2px;
                    background:#e0e0e0
                    url('${pageContext.request.contextPath}/img/profile.png')
                    center / 60% no-repeat;
                }
                    .profile-info{
                    font-size:12px;
                    line-height:1.4;
                }
                    .profile-info strong{
                    font-weight:700;
                }
                    .profile-bar-wrap{
                    margin-top:8px;
                    font-size:11px;
                }
                    .bar-label{
                    margin-bottom:2px;
                }
                    .bar-bg{
                    width:100%;
                    height:6px;
                    background:#eee;
                    border-radius:3px;
                    overflow:hidden;
                }
                    .bar-fill{
                    height:100%;
                    background:#c7a674;
                }
                    .profile-dday{
                    margin-top:10px;
                    font-size:12px;
                }

                    .calendar-card{
                    background:#fff;
                    border-radius:6px;
                    border:1px solid #ddd;
                    padding:10px;
                    font-size:11px;
                }
                    .calendar-head{
                    display:flex;
                    justify-content:space-between;
                    align-items:center;
                    margin-bottom:6px;
                }
                    .calendar-nav button{
                    border:none;
                    background:none;
                    cursor:pointer;
                    font-size:14px;
                }
                    table.calendar{
                    width:100%;
                    border-collapse:collapse;
                    text-align:center;
                    font-size:11px;
                }
                    table.calendar th,
                    table.calendar td{
                    height:20px;
                    padding:2px 0;
                }
                    table.calendar th{
                    color:#777;
                }
                    .today-cell{
                    background:#78866B;
                    color:#fff;
                    border-radius:10px;
                }

                    /* ===== 가운데: 뉴스 리스트 ===== */
                    .center-col{
                    background:#fff;
                    border-radius:6px;
                    padding:16px 18px 18px;
                }
                    .news-date-title{
                    font-size:18px;
                    font-weight:700;
                    margin-bottom:10px;
                }
                    .news-list{
                    border-top:1px solid #e3e3e3;
                    font-size:13px;
                }
                    .news-row{
                    padding:10px 0;
                    border-bottom:1px solid #f0f0f0;
                }
                    .news-meta{
                    font-size:11px;
                    color:#777;
                    margin-bottom:2px;
                }
                    .news-title{
                    font-size:13px;
                    font-weight:700;
                    margin-bottom:3px;
                }
                    .news-snippet{
                    font-size:12px;
                    color:#555;
                }

                    /* ===== 오른쪽: 뉴스 썸네일 + 날씨 ===== */
                    .right-col{
                    display:flex;
                    flex-direction:column;
                    gap:16px;
                }
                    .card{
                    background:#fff;
                    border-radius:6px;
                    padding:10px 12px;
                }
                    .card-title{
                    font-size:13px;
                    font-weight:700;
                    margin-bottom:6px;
                }

                    .news-thumb-item{
                    display:flex;
                    gap:8px;
                    padding:8px 0;
                    border-top:1px solid #f0f0f0;
                }
                    .news-thumb-item:first-child{border-top:none;}
                    .news-thumb-img{
                    width:70px;height:50px;
                    background:#ddd
                    url('${pageContext.request.contextPath}/img/WebServerLogo2.png')
                    center / cover no-repeat;
                }
                    .news-thumb-text{
                    font-size:12px;
                }

                    .weather-box{
                    margin-top:4px;
                    padding:10px;
                    background:#f3f7ff;
                    border-radius:4px;
                    font-size:12px;
                }
                    .weather-header{
                    display:flex;
                    justify-content:space-between;
                    align-items:center;
                }
                    .weather-main{
                    margin-top:6px;
                    display:flex;
                    align-items:center;
                    gap:8px;
                }
                    .weather-icon{
                    font-size:20px;
                }

                    /* 뉴스 API 리스트용 */
                    #news-container .news-item{
                    display:flex;
                    justify-content:space-between;
                    gap:8px;
                    padding:6px 0;
                    border-bottom:1px solid #eee;
                    font-size:12px;
                }
                    #news-container .news-meta{color:#777;font-size:11px;}
                    #news-container .news-title{font-weight:600;margin:2px 0;}
                    #news-container .news-desc{color:#555;font-size:11px;}
                    .news-img{
                    width:80px;
                    height:60px;
                    object-fit:cover;
                    background:#ddd;
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
                        <a href="${pageContext.request.contextPath}/main" class="active">뉴스</a>
                        <span>|</span>
                        <a href="${pageContext.request.contextPath}/social/board">소셜</a>
                        <span>|</span>
                        <a href="${pageContext.request.contextPath}/health">건강</a>
                        <span>|</span>
                        <a href="${pageContext.request.contextPath}/map">지도</a>
                    </nav>
                    <div class="header-right">
                        니인내조 님
                        <button class="btn-logout"
                                onclick="location.href='${pageContext.request.contextPath}/login/login.jsp'">
                            로그아웃
                        </button>
                    </div>
                </header>

                <!-- 상단 검색창 -->
                <div class="top-search-wrap">
                    <div class="top-search-inner">
                        <input type="text" class="top-search-input" placeholder="검색어를 입력해 주세요">
                            <span class="top-search-icon"></span>
                    </div>
                </div>

                <div class="page-wrap">

                    <!-- 왼쪽 : 프로필 + 캘린더 -->
                    <div class="left-col">

                        <div class="profile-card">
                            <div class="profile-top">
                                <div class="profile-avatar"></div>
                                <div class="profile-info">
                                    <div>사단 : 1사단</div>
                                    <div>부대명 : 제11보병여단</div>
                                    <div>이름 : <strong>니인내조</strong></div>
                                    <div>계급 : 일병</div>
                                </div>
                            </div>

                            <div class="profile-bar-wrap">
                                <div class="bar-label">상병까지 34.3%</div>
                                <div class="bar-bg">
                                    <div class="bar-fill" style="width:34%;"></div>
                                </div>
                            </div>

                            <div class="profile-bar-wrap">
                                <div class="bar-label">전역까지 89.1%</div>
                                <div class="bar-bg">
                                    <div class="bar-fill" style="width:89%;"></div>
                                </div>
                            </div>

                            <div class="profile-dday">D - 443</div>
                        </div>

                        <div class="calendar-card">
                            <div class="calendar-head">
                                <button id="prevMonth">&lt;</button>
                                <div id="calendarTitle"></div>
                                <button id="nextMonth">&gt;</button>
                            </div>
                            <table class="calendar">
                                <thead>
                                <tr>
                                    <th>일</th><th>월</th><th>화</th><th>수</th>
                                    <th>목</th><th>금</th><th>토</th>
                                </tr>
                                </thead>
                                <tbody id="calendarBody">
                                <!-- JS로 생성 -->
                                </tbody>
                            </table>
                        </div>

                    </div>

                    <!-- 가운데 : 뉴스 리스트 (더미 + API 컨테이너) -->
                    <div class="center-col">
                        <div class="news-date-title">9월 28일</div>

                        <div class="news-list" id="news-container">
                            <!-- 뉴스 API 결과가 이 안에 들어옴 -->
                        </div>
                    </div>

                    <!-- 오른쪽 : 맞춤 뉴스 + 날씨 -->
                    <div class="right-col">
                        <div class="card">
                            <div class="card-title">[ 맞춤 뉴스 ]</div>
                            <div class="news-thumb-item">
                                <div class="news-thumb-img"></div>
                                <div class="news-thumb-text">
                                    군 훈련 늘어난다…“내가 군대에 있을 때와 뭐가 달라졌나?”
                                </div>
                            </div>
                            <div class="news-thumb-item">
                                <div class="news-thumb-img"></div>
                                <div class="news-thumb-text">
                                    ‘계속되는 잇병 논란’ 병역 이슈 모음
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-title">[ 오늘 날씨 ]</div>
                            <div class="weather-box">
                                <div class="weather-header">
                                    <div id="weather-location">-</div>
                                    <div id="weather-temp">-</div>
                                </div>
                                <div class="weather-main">
                                    <div class="weather-icon" id="weather-icon">☀</div>
                                    <div id="weather-desc">날씨 정보를 불러오는 중...</div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- ===== 달력 스크립트 ===== -->
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                    const today = new Date();
                    let currentYear = today.getFullYear();
                    let currentMonth = today.getMonth(); // 0~11

                    function renderCalendar(year, month) {
                    const firstDay = new Date(year, month, 1);
                    const lastDay = new Date(year, month + 1, 0);
                    const startDay = firstDay.getDay();
                    const totalDays = lastDay.getDate();

                    const title = document.getElementById("calendarTitle");
                    title.textContent = `${year}년 ${month + 1}월`;

                    let html = "<tr>";
                    let count = 0;

                    // 앞 공백
                    for (let i = 0; i < startDay; i++) {
                    html += "<td></td>";
                    count++;
                }

                    for (let d = 1; d <= totalDays; d++) {
                    const isToday =
                    year === today.getFullYear() &&
                    month === today.getMonth() &&
                    d === today.getDate();

                    if (isToday) {
                    html += '<td class="today-cell">' + d + '</td>';
                } else {
                    html += '<td>' + d + '</td>';
                }

                    count++;
                    if (count % 7 === 0 && d !== totalDays) html += "</tr><tr>";
                }

                    while (count % 7 !== 0) {
                    html += "<td></td>";
                    count++;
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

<!-- ===== 뉴스 API 스크립트 ===== -->
<script>
    // 실제 키로 교체해야 작동함
    const NEWS_API_KEY = "YOUR_NEWS_API_KEY";
    const newsUrl =
        `https://newsapi.org/v2/top-headlines?country=kr&pageSize=10&apiKey=${NEWS_API_KEY}`;

    fetch(newsUrl)
        .then(res => res.json())
        .then(data => {
            const box = document.getElementById("news-container");
            box.innerHTML = "";

            (data.articles || []).forEach(article => {
                box.innerHTML += `
                <div class="news-item">
                    <div>
                        <div class="news-meta">${article.source?.name || ""}</div>
                        <div class="news-title">${article.title || ""}</div>
                        <div class="news-desc">${article.description || ""}</div>
                    </div>
                    <img class="news-img"
                         src="${article.urlToImage || '${pageContext.request.contextPath}/img/WebServerLogo2.png'}">
                </div>`;
            });
        })
        .catch(err => {
            console.error(err);
            document.getElementById("news-container").innerHTML =
                "<p>뉴스를 불러올 수 없습니다.</p>";
        });
</script>

<!-- ===== 날씨 API 스크립트 ===== -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const API_KEY = "YOUR_WEATHER_API_KEY";  // OpenWeatherMap API 키
        const CITY = "Seoul";
        const URL =
            `https://api.openweathermap.org/data/2.5/weather?q=${CITY}&units=metric&lang=kr&appid=${API_KEY}`;

        fetch(URL)
            .then(res => res.json())
            .then(data => {
                const locationEl = document.getElementById("weather-location");
                const tempEl = document.getElementById("weather-temp");
                const descEl = document.getElementById("weather-desc");
                const iconEl = document.getElementById("weather-icon");

                locationEl.textContent = `${data.name}, 한국`;
                const temp = Math.round(data.main.temp);
                tempEl.textContent = `${temp}℃`;
                descEl.textContent = data.weather[0].description;

                const main = data.weather[0].main;
                let icon = "☀";
                if (main === "Clouds") icon = "☁";
                else if (main === "Rain") icon = "🌧";
                else if (main === "Snow") icon = "❄";
                else if (main === "Thunderstorm") icon = "⛈";
                else if (main === "Drizzle") icon = "🌦";
                else if (["Mist", "Fog", "Haze", "Smoke"].includes(main)) icon = "🌫";

                iconEl.textContent = icon;
            })
            .catch(err => {
                console.error(err);
                const descEl = document.getElementById("weather-desc");
                descEl.textContent = "날씨 정보를 불러올 수 없어요.";
            });
    });
</script>

</body>
</html>
