<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>건강 페이지 - 스포츠</title>

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

        .workout-list{
            max-width:650px;
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
        <a href="${pageContext.request.contextPath}/main/mainpage.jsp">뉴스</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social/board">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health/health.jsp" class="active">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/map/map.jsp">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <!-- 상단 탭 -->
    <div class="top-tabs">
        <a class="tab-link" href="${pageContext.request.contextPath}/health_main">
            <span class="tab-text-main">운동 칼로리 검색</span>
        </a>
        <span>|</span>
        <a class="tab-link" href="${pageContext.request.contextPath}/health_calculator">
            <span class="tab-text-sub">칼로리 계산기</span>
        </a>
    </div>

    <div class="section-title">스포츠</div>

    <div class="workout-list">
        <a class="workout-btn"
           href="${pageContext.request.contextPath}/health_exercise_detail?part=스포츠&type=&name=족구">
            족구
        </a>

        <a class="workout-btn"
           href="${pageContext.request.contextPath}/health_exercise_detail?part=스포츠&type=&name=연병장%20축구">
            연병장 축구
        </a>

        <a class="workout-btn"
           href="${pageContext.request.contextPath}/health_exercise_detail?part=스포츠&type=&name=탁구">
            탁구
        </a>

        <a class="workout-btn"
           href="${pageContext.request.contextPath}/health_exercise_detail?part=스포츠&type=&name=풋살">
            풋살
        </a>
    </div>

</div>

</body>
</html>