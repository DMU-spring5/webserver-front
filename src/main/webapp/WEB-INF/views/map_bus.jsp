<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 대중교통 위치/시간표 (버스)</title>

    <style>
        <%-- 위 walk.jsp 의 <style> 내용 전체를 그대로 복사해도 됨 --%>
        /* 여기서는 길어지지 않게 동일하다고 가정 */
    </style>
</head>
<body>

<header>
    <%-- header 부분도 walk.jsp 와 동일 --%>
</header>

<div class="page-wrap">

    <div class="title">대중교통 위치/시간표</div>
    <div class="sub">장소, 주소, 정류장을 검색해 주세요.</div>

    <div class="layout">

        <!-- 왼쪽 -->
        <div class="left-box">

            <!-- 출발 / 도착 입력 부분도 동일 -->
            <!-- ... -->

            <div class="tab-row">
                <button class="tab-btn"
                        onclick="location.href='${pageContext.request.contextPath}/map_walk'">도보</button>
                <button class="tab-btn active"
                        onclick="location.href='${pageContext.request.contextPath}/map_bus'">버스</button>
                <button class="tab-btn"
                        onclick="location.href='${pageContext.request.contextPath}/map_subway'">지하철</button>
                <button class="tab-btn">종합</button>
            </div>

            <div class="info-head">버스 경로</div>

            <div class="route-list">
                <div class="route-item">
                    <div class="route-title">버스 6613</div>
                    <div class="route-sub">2정거장 | 약 7분</div>
                </div>
                <div class="route-item">
                    <div class="route-title">버스 6614</div>
                    <div class="route-sub">3정거장 | 약 9분</div>
                </div>
            </div>
        </div>

        <div id="map"></div>

    </div>

</div>

</body>
</html>
