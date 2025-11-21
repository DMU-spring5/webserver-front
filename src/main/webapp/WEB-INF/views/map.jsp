<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 지도</title>
    <style>
        /* 기존 스타일 상속 및 지도 컨테이너 스타일 */
        body { margin: 0; font-family: Arial, sans-serif; }
        header { background-color: #78866B; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .header-nav a { color: white; margin: 0 15px; text-decoration: none; font-weight: 500; }
        .header-right span { margin-right: 15px; }

        /* 🚨 지도 영역을 감싸는 컨테이너 스타일 */
        .map_wrap {
            width: 100%;
            height: 800px; /* 전체 화면 높이에 맞게 조정 */
            display: flex;
        }
        /* 🚨 실제 지도가 로드될 영역 스타일 */
        #map {
            flex-grow: 1; /* 남은 공간을 모두 채움 */
            width: 100%;
        }
        /* 🚨 검색 사이드바 영역 스타일 (퍼블리싱을 위해 임시로 추가) */
        .sidebar {
            width: 300px;
            background: #fcfcfc;
            border-right: 1px solid #ddd;
            padding: 20px;
        }
    </style>

    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=YOUR_NAVER_CLIENT_ID"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var mapOptions = {
                // 초기 중심 좌표 (예: 구일역 근처)
                center: new naver.maps.LatLng(37.4950, 126.8776),
                zoom: 15
            };

            // map 이라는 ID를 가진 div에 지도를 생성합니다.
            var map = new naver.maps.Map('map', mapOptions);
        });
    </script>
</head>
<body>
<header>
    <div class="header-left">
        <h1 style="display: flex; align-items: center; gap: 10px;">
            <img src="https://via.placeholder.com/30/FFFFFF/78866B?text=M" alt="M" style="height: 30px; border-radius: 5px; background: white;"> MILLI ROAD
        </h1>
    </div>
    <nav class="header-nav">
        <a href="#">뉴스</a> |
        <a href="/social/board">소셜</a> |
        <a href="#">건강</a> |
        <a href="/" style="font-weight: bold;">지도</a>
    </nav>
    <div class="header-right">
        <span>니인내조 님</span>
        <button class="logout-button">로그아웃</button>
    </div>
</header>

<div class="map_wrap">
    <div class="sidebar">
        <h3 style="margin-top: 0;">장소, 주소 검색</h3>
        <input type="text" placeholder="장소, 주소, 정류장 검색" style="width: 100%; padding: 8px; box-sizing: border-box; margin-bottom: 15px;">
        <p style="color: #666; font-size: 0.9em;">장소, 주소, 정류장을 검색해 주세요.</p>
    </div>

    <div id="map">
    </div>
</div>

</body>
</html>