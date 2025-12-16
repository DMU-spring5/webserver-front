<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String placeName = request.getParameter("placeName");
    String address = request.getParameter("address");
    String extra = request.getParameter("extra");
    if(placeName == null) placeName = "장소";
    if(address == null) address = "주소 정보 없음";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 위치 상세</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body { font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,"Segoe UI",system-ui,sans-serif; background:#f5f5f5; color:#333; }

        header{ height:64px; background:#78866B; color:#fff; padding:0 40px; display:flex; align-items:center; justify-content:space-between; }
        .header-left{display:flex;align-items:center;gap:14px;}
        .header-logo-box{ width:34px;height:34px;border-radius:4px;
            background:url('${pageContext.request.contextPath}/img/KakaoTalk_20251204_101657760.png') center/contain no-repeat; }
        .header-title{font-size:22px;font-weight:700;letter-spacing:.10em;}
        .header-nav{display:flex;align-items:center;gap:26px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{display:flex;align-items:center;gap:16px;font-size:14px;}
        .btn-logout{ padding:6px 16px;border-radius:4px;border:none;background:#fff;color:#78866B;font-weight:600;cursor:pointer; }

        .page-wrap{ max-width:1100px; margin:40px auto 80px; padding:0 40px; }
        .path{ font-size:16px; margin-bottom:18px; }
        .path strong{font-weight:700;margin-right:6px;}
        .path span{color:#b3b3b3;margin-left:6px;}

        .place-title{ font-size:22px; font-weight:700; margin-bottom:6px; }
        .place-sub{ font-size:13px; color:#777; margin-bottom:24px; }

        .detail-card{ background:#fff; border-radius:10px; box-shadow:0 4px 12px rgba(0,0,0,0.06); padding:22px 26px 26px; }
        .info-row{ margin-bottom:10px; font-size:14px; }
        .info-label{ display:inline-block; width:70px; color:#777; }
        .info-value{ font-weight:500; }

        .btn-row{ margin-top:24px; display:flex; justify-content:flex-end; gap:8px; }
        .btn{ min-width:90px; padding:7px 14px; border-radius:4px; border:none; font-size:13px; cursor:pointer; }
        .btn-back{ background:#e0e0e0; }
        .btn-route{ background:#78866B; color:#fff; }
    </style>

    <script>
        function goBack(){ history.back(); }
    </script>
</head>
<body>

<header>
    <div class="header-left">
        <div class="header-logo-box"></div>
        <div class="header-title">MILLI ROAD</div>
    </div>
    <nav class="header-nav">
        <a href="#">뉴스</a><span>|</span>
        <a href="${pageContext.request.contextPath}/social/board">소셜</a><span>|</span>
        <a href="${pageContext.request.contextPath}/health">건강</a><span>|</span>
        <a href="${pageContext.request.contextPath}/map" class="active">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">
    <div class="path">
        <strong>대중교통 위치/시간표</strong><span>| 지도</span>
    </div>

    <h1 class="place-title"><%= placeName %></h1>
    <p class="place-sub"><%= address %></p>

    <div class="detail-card">
        <div class="info-row">
            <span class="info-label">장소</span>
            <span class="info-value"><%= placeName %></span>
        </div>
        <div class="info-row">
            <span class="info-label">주소</span>
            <span class="info-value"><%= address %></span>
        </div>

        <% if(extra != null && !extra.trim().isEmpty()){ %>
        <div class="info-row">
            <span class="info-label">정보</span>
            <span class="info-value"><%= extra %></span>
        </div>
        <% } %>

        <div class="btn-row">
            <button type="button" class="btn btn-back" onclick="goBack()">돌아가기</button>
            <button type="button" class="btn btn-route">여기서 길찾기</button>
        </div>
    </div>
</div>

</body>
</html>
