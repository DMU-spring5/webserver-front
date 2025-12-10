<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 대중교통 위치/시간표 (지하철)</title>

    <style>
        <%-- walk.jsp 와 동일 스타일 사용 --%>
    </style>
</head>
<body>

<header>
    <%-- header 동일 --%>
</header>

<div class="page-wrap">

    <div class="title">대중교통 위치/시간표</div>
    <div class="sub">장소, 주소, 정류장을 검색해 주세요.</div>

    <div class="layout">

        <div class="left-box">

            <!-- 출발 / 도착 입력 동일 -->
            <!-- ... -->

            <div class="tab-row">
                <button class="tab-btn"
                        onclick="location.href='${pageContext.request.contextPath}/map_walk'">도보</button>
                <button class="tab-btn"
                        onclick="location.href='${pageContext.request.contextPath}/map_bus'">버스</button>
                <button class="tab-btn active"
                        onclick="location.href='${pageContext.request.contextPath}/map_subway'">지하철</button>
                <button class="tab-btn">종합</button>
            </div>

            <div class="info-head">지하철 경로</div>

            <div class="route-list">
                <div class="route-item">
                    <div class="route-title">구일역 1호선 → 동양미래대학교</div>
                    <div class="route-sub">죄송합니다. 해당 구간은 지하철 경로를 계산할 수 없습니다.</div>
                </div>
            </div>
        </div>

        <div id="map"></div>

    </div>

</div>

</body>
</html>
