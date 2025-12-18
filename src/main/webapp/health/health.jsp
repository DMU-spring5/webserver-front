<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>건강 페이지</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }

        body {
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,
            "Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;
            color:#333;
        }

        /* ===== 상단 공통 헤더 (다른 페이지랑 동일) ===== */
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
            width:80px;
            height:34px;
            background:url('${pageContext.request.contextPath}/img/KakaoTalk_20251204_101657760.png')
            left center / contain no-repeat;
        }
        .header-title{
            font-size:0;
        }
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
        .header-nav a:hover{
            text-decoration:underline;
        }
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

        /* ===== 페이지 전체 레이아웃 ===== */
        .page-wrap{
            max-width:1200px;
            margin:40px auto 80px;
            padding:0 40px;
        }

        /* 가운데 큰 네모 두 개 */
        .menu-box{
            width:60%;
            max-width:700px;
            height:220px;
            border:1px solid #bfbfbf;
            background:#ffffff;
            margin:0 auto 60px;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:22px;
            cursor:pointer;
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
        <a href="${pageContext.request.contextPath}/social/board">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health" class="active">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/map">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <!-- 첫 번째 큰 박스 : 운동 칼로리 검색 -->
    <div class="menu-box"
         onclick="location.href='${pageContext.request.contextPath}/health_main'">
        운동 칼로리 검색
    </div>

    <!-- 두 번째 큰 박스 : 칼로리 계산기 -->
    <div class="menu-box"
         onclick="location.href='${pageContext.request.contextPath}/health_calculator'">
        칼로리 계산기
    </div>

</div>

</body>
</html>