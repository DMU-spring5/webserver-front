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
                <a href="#">대중교통</a>
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

<!--뉴스api-->
<script>
    const API_KEY = "YOUR_NEWS_API_KEY";
    const url = `https://newsapi.org/v2/top-headlines?country=kr&pageSize=10&apiKey=${API_KEY}`;

    fetch(url)
        .then(res => res.json())
        .then(data => {
            const box = document.getElementById("news-container");
            box.innerHTML = "";

            data.articles.forEach(article => {
                box.innerHTML += `
                <div class="news-item">
                    <div>
                        <div class="news-meta">${article.source.name}</div>
                        <div class="news-title">${article.title}</div>
                        <div class="news-desc">${article.description || ""}</div>
                    </div>
                    <img class="news-img" src="${article.urlToImage || 'img/default_news.png'}">
                </div>
            `;
            });
        })
        .catch(err => {
            document.getElementById("news-container").innerHTML =
                "<p>뉴스를 불러올 수 없습니다.</p>";
        });
</script>
<!-- 날씨 -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const API_KEY = "API_KEY";  // OpenWeatherMap API 키 넣기
        const CITY = "Seoul";                 // 도시 이름
        const URL =
            `https://api.openweathermap.org/data/2.5/weather?q=${CITY}&units=metric&lang=kr&appid=${API_KEY}`;

        fetch(URL)
            .then(res => res.json())
            .then(data => {
                // 위치
                const locationEl = document.getElementById("weather-location");
                locationEl.textContent = `${data.name}, 한국`;

                // 온도
                const tempEl = document.getElementById("weather-temp");
                const temp = Math.round(data.main.temp);
                tempEl.textContent = `${temp}℃`;

                // 설명
                const descEl = document.getElementById("weather-desc");
                descEl.textContent = data.weather[0].description; // 예: '맑음'

                // 아이콘 (간단하게 이모지 매핑)
                const iconEl = document.getElementById("weather-icon");
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
