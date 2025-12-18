<%@ page contentType="text/html; charset=UTF-8" language="java" isELIgnored="true" %>
<%
    String accessToken = (String) session.getAttribute("accessToken");
    if (accessToken == null) accessToken = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD</title>
    <link rel="stylesheet" type="text/css" href="mainpage.css">
</head>
<body>

<header class="header">
    <div class="header-inner">
        <div class="logo">
            <img src="../img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

        <div class="header-center">
            <div class="search-box">
                <span class="search-icon"><img src="../img/search.png"></span>
                <input type="text" placeholder="검색어를 입력하세요">
            </div>

            <nav class="nav">
                <a href="index.jsp" class="active">뉴스</a>
                <span class="divider">|</span>
                <a href="../social/social_board.jsp">소셜</a>
                <span class="divider">|</span>
                <a href="../health/health.jsp">건강</a>
                <span class="divider">|</span>
                <a href="../map/map.jsp">지도</a>
            </nav>
        </div>
    </div>
</header>

<div class="container">
    <aside class="left-box">
        <div class="left-box">
            <div class="profile-box">
                <div class="profile-image">
                    <img src="../img/profile.png" alt="프로필 이미지">
                </div>

                <div class="profile-info-text">
                    <p>사단 : <span id="division">-</span></p>
                    <p>부대명 : <span id="unit">-</span></p>
                    <p>이름 : <span id="nickname">-</span></p>
                    <p>계급 : <span id="rank">-</span></p>
                </div>

                <div class="profile-dday" id="dday">D -</div>

                <button class="my-btn" onclick="location.href='../mypage/mypage.jsp'">
                    마이페이지
                </button>
                <button class="logout-btn" onclick="location.href='../logout/logout.jsp'">
                    로그아웃
                </button>
            </div>
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
            <div id="news-container">
                <p>뉴스 로딩 중...</p>
            </div>
        </div>

        <div class="main-news-right">
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

<!-- 캘린더 스크립트 -->
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

        const newsMonth = kstToday.getMonth() + 1;
        const newsDay = kstToday.getDate();
        document.getElementById("newsDate").innerText =
            newsMonth + "월 " + newsDay + "일 뉴스";

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

                html += isToday
                    ? '<td class="today-cell">' + d + '</td>'
                    : '<td>' + d + '</td>';

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

<script>
    const BASE_URL = "https://webserver-backend.onrender.com";
    const accessToken = "<%= accessToken %>";

    if (!accessToken || accessToken.trim().length === 0) {
        location.replace("../login/login.jsp");
    }

    function getRank(type, days) {
        if (type === "army") return days < 100 ? "이병" : days < 270 ? "일병" : days < 450 ? "상병" : "병장";
        if (type === "navy") return days < 120 ? "이병" : days < 300 ? "일병" : days < 500 ? "상병" : "병장";
        if (type === "airforce") return days < 140 ? "이병" : days < 320 ? "일병" : days < 520 ? "상병" : "병장";
        return "-";
    }

    fetch(BASE_URL + "/api/v1/mainpage", {
        headers: { "Authorization": "Bearer " + accessToken }
    })
        .then(res => {
            if (res.status === 401 || res.status === 403) {
                location.replace("../login/login.jsp");
                return Promise.reject("Unauthorized");
            }
            if (!res.ok) {
                return res.text().then(t => Promise.reject("Mainpage API error: " + res.status + " / " + t));
            }
            return res.json();
        })
        .then(data => {
            document.getElementById("division").innerText = data.division ?? "-";
            document.getElementById("unit").innerText = data.unit ?? "-";
            document.getElementById("nickname").innerText = data.nickname ?? "-";

            if (data.enlistDate && data.serviceType) {
                const enlist = new Date(data.enlistDate);
                const today = new Date();

                const passed = Math.floor((today - enlist) / (1000 * 60 * 60 * 24));

                const months = { army:18, navy:20, airforce:21 };
                const discharge = new Date(enlist);
                discharge.setMonth(discharge.getMonth() + (months[data.serviceType] || 0));
                discharge.setDate(discharge.getDate() - 1);

                const dday = Math.ceil((discharge - today) / (1000 * 60 * 60 * 24));

                document.getElementById("rank").innerText =
                    getRank(data.serviceType, passed);
                document.getElementById("dday").innerText = "D - " + dday;
            }
        })
        .catch(err => {
            console.error(err);
        });
</script>

<!-- 뉴스  -->
<script>
    fetch("https://newsapi.org/v2/top-headlines?country=kr&pageSize=10&apiKey=YOUR_NEWS_API_KEY")
        .then(res => res.json())
        .then(data => {
            const box = document.getElementById("news-container");
            box.innerHTML = "";

            if (!data || !data.articles) {
                box.innerHTML = "<p>뉴스 정보를 불러올 수 없어요.</p>";
                return;
            }

            data.articles.forEach(article => {
                box.innerHTML += `
        <div class="news-item">
            <div>
                <div class="news-meta">${article.source?.name || ""}</div>
                <div class="news-title">${article.title || ""}</div>
                <div class="news-desc">${article.description || ""}</div>
            </div>
            <img class="news-img" src="${article.urlToImage || '../img/default_news.png'}">
        </div>`;
            });
        })
        .catch(err => {
            console.error(err);
            const box = document.getElementById("news-container");
            box.innerHTML = "<p>뉴스 정보를 불러올 수 없어요.</p>";
        });
</script>

<!-- 날씨 -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const API_KEY = "API_KEY";
        fetch(`https://api.openweathermap.org/data/2.5/weather?q=Seoul&units=metric&lang=kr&appid=${API_KEY}`)
            .then(res => res.json())
            .then(data => {
                if (!data || !data.main || !data.weather) return;

                document.getElementById("weather-location").textContent =
                    `${data.name}, 한국`;
                document.getElementById("weather-temp").textContent =
                    `${Math.round(data.main.temp)}℃`;
                document.getElementById("weather-desc").textContent =
                    data.weather[0].description;

                const main = data.weather[0].main;
                let icon = "☀";
                if (main === "Clouds") icon = "☁";
                else if (main === "Rain") icon = "🌧";
                else if (main === "Snow") icon = "❄";
                else if (main === "Thunderstorm") icon = "⛈";
                else if (main === "Drizzle") icon = "🌦";
                else if (["Mist","Fog","Haze","Smoke"].includes(main)) icon = "🌫";
                document.getElementById("weather-icon").textContent = icon;
            })
            .catch(err => {
                console.error(err);
            });
    });
</script>

</body>
</html>