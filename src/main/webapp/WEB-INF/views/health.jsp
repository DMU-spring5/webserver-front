<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>건강 페이지 - 카테고리 선택</title>

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Noto Sans KR", -apple-system, BlinkMacSystemFont,
            "Segoe UI", system-ui, sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }

        /* ===== 헤더 ===== */
        header {
            height: 64px;
            background-color: #78866B;
            color: #fff;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header-left { display:flex;align-items:center;gap:14px; }

        /* 여기만 로고 이미지로 변경 */
        .header-logo-box {
            width:34px;
            height:34px;
            border-radius:4px; /* 필요 없으면 지워도 됨 */
            background: url('${pageContext.request.contextPath}/img/KakaoTalk_20251204_101657760.png')
            center / cover no-repeat;
        }

        .header-title {
            font-size:22px;
            font-weight:700;
            letter-spacing:.10em;
        }
        .header-nav {
            display:flex;
            align-items:center;
            gap:26px;
            font-size:15px;
        }
        .header-nav a { color:#fff; text-decoration:none; }
        .header-nav a:hover { text-decoration:underline; }
        .header-nav a.active { font-weight:700; text-decoration:underline; }
        .header-right {
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

        /* ===== 본문 ===== */
        .page-wrap {
            max-width:1200px;
            margin:40px auto 80px;
            padding:0 32px;
        }

        .category-box-wrap {
            margin-top:60px;
            display:flex;
            flex-direction:column;
            gap:80px;
            align-items:center;
        }

        .category-box {
            width:480px;
            height:180px;
            border:1px solid #d7d7cf;
            background:#f5f3eb;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:20px;
            cursor:pointer;
        }
        .category-box:hover {
            background:#eee7d8;
        }
        a.category-link {
            display:block;
            text-decoration:none;
            color:inherit;
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
        <a href="#">뉴스</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social/board">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health" class="active">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/main">지도</a>
    </nav>

    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <div class="category-box-wrap">

        <!-- 운동 칼로리 검색 → health_main -->
        <a class="category-link"
           href="${pageContext.request.contextPath}/health_main">
            <div class="category-box">
                운동 칼로리 검색
            </div>
        </a>

        <!-- 칼로리 계산기 → health_calculator -->
        <a class="category-link"
           href="${pageContext.request.contextPath}/health_calculator">
            <div class="category-box">
                칼로리 계산기
            </div>
        </a>

    </div>
</div>

</body>
</html>