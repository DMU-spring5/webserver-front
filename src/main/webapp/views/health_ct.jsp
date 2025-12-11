<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>건강 페이지 - 하체</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            font-family:"Noto Sans KR",system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
            background:#f5f5f5;
            color:#333;
        }

        header{
            height:64px;background:#78866B;color:#fff;
            padding:0 40px;
            display:flex;align-items:center;justify-content:space-between;
        }
        .header-left{display:flex;align-items:center;gap:14px;}
        .header-logo-box{width:34px;height:34px;border-radius:4px;background:#fff;}
        .header-title{font-size:22px;font-weight:700;letter-spacing:.10em;}
        .header-nav{display:flex;align-items:center;gap:26px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{text-decoration:underline;font-weight:700;}
        .header-right{display:flex;align-items:center;gap:16px;font-size:14px;}
        .btn-logout{
            padding:6px 16px;border-radius:4px;border:none;
            background:#fff;color:#78866B;font-weight:600;cursor:pointer;
        }

        .page-wrap{
            max-width:1000px;
            margin:40px auto 80px;
            padding:0 40px;
        }

        .top-tabs{font-size:18px;margin-bottom:32px;}
        .tab-link{text-decoration:none;margin-right:16px;}
        .tab-text-main{font-weight:700;color:#000;}
        .tab-text-sub{font-weight:400;color:#b6b6b6;}

        .section-title{
            font-size:22px;
            font-weight:700;
            text-align:center;
            margin-bottom:32px;
        }

        .filter-row{
            display:flex;
            justify-content:center;
            gap:18px;
            margin-bottom:40px;
        }
        .filter-btn{
            min-width:80px;
            padding:10px 18px;
            border-radius:2px;
            border:1px solid #d6d2c5;
            background:#f5f4ec;
            font-size:14px;
            cursor:pointer;
        }
        .filter-btn-active{
            background:#d4c09f;
            border-color:#d4c09f;
            font-weight:600;
        }

        .workout-list{
            max-width:750px;
            margin:0 auto;
            display:flex;
            flex-direction:column;
            gap:18px;
        }
        .workout-btn{
            width:100%;
            padding:20px 24px;
            border-radius:2px;
            border:1px solid #ddd;
            background:#ecece4;
            font-size:18px;
            text-align:center;
            cursor:pointer;
            text-decoration:none;
            color:inherit;
        }
        .workout-btn:hover{background:#e2e2da;}
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

    <div class="top-tabs">
        <a class="tab-link" href="${pageContext.request.contextPath}/health_main">
            <span class="tab-text-main">운동 칼로리 검색</span>
        </a>
        <span>|</span>
        <a class="tab-link" href="${pageContext.request.contextPath}/health_calculator">
            <span class="tab-text-sub">칼로리 계산기</span>
        </a>
    </div>

    <div class="section-title">하체</div>

    <div class="filter-row">
        <button class="filter-btn filter-btn-active">덤벨</button>
        <button class="filter-btn">바벨</button>
        <button class="filter-btn">맨몸</button>
        <button class="filter-btn">밴드</button>
        <button class="filter-btn">볼</button>
    </div>

    <div class="workout-list">
        <a class="workout-btn"
           href="${pageContext.request.contextPath}/health_exercise_detail?part=하체&type=덤벨&name=덤벨%20데드리프트">
            덤벨 데드리프트
        </a>
        <a class="workout-btn"
           href="${pageContext.request.contextPath}/health_exercise_detail?part=하체&type=덤벨&name=고블릿%20스쿼트">
            고블릿 스쿼트
        </a>
        <a class="workout-btn"
           href="${pageContext.request.contextPath}/health_exercise_detail?part=하체&type=덤벨&name=덤벨%20스쿼트">
            덤벨 스쿼트
        </a>
    </div>

</div>

</body>
</html>
