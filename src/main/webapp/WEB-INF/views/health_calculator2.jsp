<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>건강 페이지 - 칼로리 계산기 2단계</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            font-family:"Noto Sans KR",system-ui,-apple-system,
            BlinkMacSystemFont,"Segoe UI",sans-serif;
            background:#f5f5f5;
            color:#333;
        }

        /* ===== 헤더 ===== */
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

        /* ===== 본문 ===== */
        .page-wrap{
            max-width:1000px;
            margin:40px auto 80px;
            padding:0 40px;
            background:#fff;
            border-radius:4px;
            box-shadow:0 1px 3px rgba(0,0,0,0.06);
        }

        /* 상단 탭 */
        .top-tabs{
            font-size:18px;
            margin-bottom:32px;
        }
        .tab-link{
            text-decoration:none;
            margin-right:16px;
        }
        .tab-text-main{font-weight:700;color:#000;}    /* 현재: 칼로리 계산기 */
        .tab-text-sub{font-weight:400;color:#b6b6b6;}

        /* 단계 인디케이터 */
        .step-row{
            display:flex;
            gap:24px;
            margin-bottom:32px;
        }
        .step-circle{
            width:32px;height:32px;
            border-radius:50%;
            border:2px solid #d0d0d0;
            display:flex;align-items:center;justify-content:center;
            font-size:14px;
            color:#999;
            background:#f5f5f5;
            cursor:pointer;
            text-decoration:none;
        }
        .step-circle.active{
            background:#000;
            border-color:#000;
            color:#fff;
        }

        .section-title{
            font-size:18px;
            font-weight:700;
            margin-bottom:10px;
        }
        .section-sub{
            font-size:14px;
            color:#666;
            margin-bottom:26px;
        }

        .row{
            display:flex;
            align-items:center;
            gap:40px;
            margin-bottom:24px;
        }
        .col{
            display:flex;
            align-items:center;
            gap:10px;
        }
        .label{
            font-size:15px;
            width:80px;
        }
        .input-box{
            width:140px;
            height:40px;
            border:1px solid #d7d7cf;
            background:#f3f2ea;
            display:flex;
            align-items:center;
            justify-content:space-between;
            padding:0 10px;
            font-size:15px;
        }
        .input-box input{
            width:70px;
            border:none;
            outline:none;
            background:transparent;
            text-align:right;
            font-size:15px;
        }

        .btn-next{
            width:200px;
            height:44px;
            border-radius:2px;
            border:none;
            background:#d4c09f;
            font-size:15px;
            cursor:pointer;
            display:block;
            margin:40px auto 10px;
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

    <!-- 상단 탭 -->
    <div class="top-tabs">
        <a class="tab-link"
           href="${pageContext.request.contextPath}/health_main">
            <span class="tab-text-sub">운동 칼로리 검색</span>
        </a>
        <span>|</span>
        <a class="tab-link"
           href="${pageContext.request.contextPath}/health_calculator">
            <span class="tab-text-main">칼로리 계산기</span>
        </a>
    </div>

    <!-- 단계 버튼: 전부 클릭 가능, 2번만 검정 -->
    <div class="step-row">
        <a class="step-circle"
           href="${pageContext.request.contextPath}/health_calculator">1</a>
        <a class="step-circle active"
           href="${pageContext.request.contextPath}/health_calculator2">2</a>
        <a class="step-circle"
           href="${pageContext.request.contextPath}/health_calculator3">3</a>
    </div>

    <!-- 내용 (스샷 기준) -->
    <div class="section-title">니인내조 님이 원하시는 체중과 현재 체중을 알려 주세요.</div>
    <div class="section-sub"></div>

    <div class="row">
        <div class="col">
            <div class="label">현재 체중</div>
            <div class="input-box">
                <input type="text" value="100">
                <span>kg</span>
            </div>
        </div>

        <div class="col">
            <div class="label">목표 체중</div>
            <div class="input-box">
                <input type="text" value="50">
                <span>kg</span>
            </div>
        </div>
    </div>

    <button class="btn-next" type="button"
            onclick="location.href='${pageContext.request.contextPath}/health_calculator3'">
        다음 단계
    </button>

</div>

</body>
</html>