<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String part = request.getParameter("part");   // 부위: 어깨 & 팔, 가슴, 등, 하체, 유산소, 스포츠
    String type = request.getParameter("type");   // 기구: 덤벨, 바벨, 맨몸, 밴드, 볼 등
    String name = request.getParameter("name");   // 운동 이름

    if (part == null)  part = "";
    if (type == null)  type = "";
    if (name == null)  name = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>운동 칼로리 계산 - <%= name %></title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            font-family:"Noto Sans KR",system-ui,-apple-system,
            BlinkMacSystemFont,"Segoe UI",sans-serif;
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
            background:#fff;
            border-radius:4px;
            box-shadow:0 1px 3px rgba(0,0,0,0.06);
        }

        /* 상단 탭 */
        .top-tabs{
            font-size:18px;
            margin-bottom:24px;
        }
        .tab-link{text-decoration:none;margin-right:16px;}
        .tab-text-main{font-weight:700;color:#000;}
        .tab-text-sub{font-weight:400;color:#b6b6b6;}

        /* 선택된 운동 정보 */
        .info-box{
            width:100%;
            padding:18px 24px;
            border-radius:2px;
            border:1px solid #d7d7cf;
            background:#f3f2ea;
            margin-bottom:26px;
            text-align:center;
            line-height:1.6;
        }
        .info-path{font-size:14px;color:#777;}
        .info-name{font-size:18px;font-weight:700;}

        .row{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:18px;
        }
        .label{
            width:120px;
            font-size:15px;
        }
        .input-box{
            flex:1;
            max-width:260px;
            height:40px;
            border:1px solid #d7d7cf;
            background:#f3f2ea;
            display:flex;
            align-items:center;
            justify-content:space-between;
            padding:0 14px;
            font-size:15px;
        }
        .input-box input{
            width:90px;
            border:none;
            outline:none;
            background:transparent;
            text-align:right;
            font-size:15px;
        }

        .intensity-row{display:flex;gap:10px;}
        .intensity-btn{
            min-width:72px;
            height:32px;
            border-radius:2px;
            border:1px solid #d7d7cf;
            background:#f3f2ea;
            font-size:14px;
            cursor:pointer;
        }
        .intensity-btn.active{
            background:#d4c09f;
            border-color:#d4c09f;
            font-weight:600;
        }

        .result-box{
            margin:36px auto 28px;
            max-width:620px;
            background:#e9e7dd;
            padding:22px 40px;
            display:flex;
            justify-content:space-between;
            font-size:15px;
        }
        .result-box strong{font-size:20px;}

        .btn-confirm{
            width:200px;
            height:44px;
            border-radius:2px;
            border:none;
            background:#d4c09f;
            font-size:15px;
            cursor:pointer;
            display:block;
            margin:0 auto 10px;
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
        <a class="tab-link" href="${pageContext.request.contextPath}/health_main">
            <span class="tab-text-main">운동 칼로리 검색</span>
        </a>
        <span>|</span>
        <a class="tab-link" href="${pageContext.request.contextPath}/health_calculator">
            <span class="tab-text-sub">칼로리 계산기</span>
        </a>
    </div>

    <!-- 선택된 운동 표시 -->
    <div class="info-box">
        <div class="info-path">
            <%= part %>
            <% if (!type.isEmpty()) { %> / <%= type %><% } %>
        </div>
        <div class="info-name"><%= name %></div>
    </div>

    <!-- 운동 시간 -->
    <div class="row">
        <div class="label">운동 시간</div>
        <div class="input-box">
            <input type="text" value="100">
            <span>분</span>
        </div>
    </div>

    <!-- 운동 강도 -->
    <div class="row">
        <div class="label">운동 강도</div>
        <div class="intensity-row">
            <button class="intensity-btn active" type="button">가볍게</button>
            <button class="intensity-btn" type="button">적당히</button>
            <button class="intensity-btn" type="button">강하게</button>
        </div>
    </div>

    <!-- 현재 체중 -->
    <div class="row">
        <div class="label">현재 체중</div>
        <div class="input-box">
            <input type="text" value="100">
            <span>KG</span>
        </div>
    </div>

    <!-- 결과 박스 (지금은 고정값) -->
    <div class="result-box">
        <div>예상 소모 칼로리</div>
        <div><strong>100kcal</strong></div>
    </div>

    <button class="btn-confirm" type="button" onclick="history.back();">
        뒤로 가기
    </button>

</div>

<script>
    (function () {
        const btns = document.querySelectorAll('.intensity-btn');
        btns.forEach(b => {
            b.addEventListener('click', function () {
                btns.forEach(x => x.classList.remove('active'));
                this.classList.add('active');
            });
        });
    })();
</script>

</body>
</html>
