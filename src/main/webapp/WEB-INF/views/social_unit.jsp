<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부대 별 평가 | 소셜 커뮤니티</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,
            "Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;
            color:#333;
        }

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
            width:34px;height:34px;border-radius:4px;
            background:url('${pageContext.request.contextPath}/img/KakaoTalk_20251204_101657760.png')
            center / contain no-repeat;
        }
        .header-title{font-size:22px;font-weight:700;letter-spacing:.10em;}
        .header-nav{display:flex;align-items:center;gap:26px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{display:flex;align-items:center;gap:16px;font-size:14px;}
        .btn-logout{
            padding:6px 16px;border-radius:4px;border:none;
            background:#fff;color:#78866B;font-weight:600;cursor:pointer;
        }

        .page-wrap{
            max-width:1200px;
            margin:40px auto 80px;
            padding:0 40px;
        }

        .top-title{
            font-size:22px;
            font-weight:700;
            margin-bottom:6px;
        }
        .top-sub{
            font-size:13px;
            color:#777;
            margin-bottom:22px;
        }

        .path-row{
            font-size:14px;
            margin-bottom:22px;
        }
        .path-row strong{
            margin-right:6px;
        }
        .path-row span{
            margin-left:6px;
            color:#b3b3b3;
        }
        .path-row a{
            color:#b3b3b3;
            text-decoration:none;
        }
        .path-row a:hover{text-decoration:underline;}

        .card{
            max-width:860px;
            background:#fff;
            border-radius:10px;
            box-shadow:0 4px 12px rgba(0,0,0,0.06);
            padding:26px 30px 28px;
        }
        .section-title{
            font-size:16px;
            font-weight:700;
            margin-bottom:12px;
        }

        .search-wrap{margin-top:6px;}
        .search-box{
            width:100%;
            height:50px;
            border-radius:4px;
            border:1px solid #ddd;
            background:#fbfbf6;
            display:flex;
            align-items:center;
            padding:0 14px;
        }
        .search-input{
            flex:1;
            border:none;
            outline:none;
            background:transparent;
            font-size:14px;
        }
        .search-btn{
            width:26px;height:26px;
            border:none;
            cursor:pointer;
            background:url('${pageContext.request.contextPath}/img/search.png')
            center / 16px no-repeat;
        }
        .search-help{
            margin-top:8px;
            font-size:12px;
            color:#999;
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
        <a href="${pageContext.request.contextPath}/social/board" class="active">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/map">지도</a>
    </nav>
    <div class="header-right">
        니인내조 님
        <button class="btn-logout">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <div class="top-title">부대 별 평가 | 소셜 커뮤니티</div>
    <div class="top-sub">
        군부대, 훈련소, 자대 생활 등에 대한 솔직한 후기를 사단별로 검색해 보세요.
    </div>

    <div class="path-row">
        <strong>부대 별 평가</strong>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social/board">소셜 커뮤니티</a>
    </div>

    <div class="card">
        <div class="section-title">부대 별 평가</div>

        <form action="${pageContext.request.contextPath}/social_unit_list" method="get">
            <div class="search-wrap">
                <div class="search-box">
                    <input type="text" name="unitName" class="search-input"
                           placeholder="사단을 검색하세요.">
                    <button type="submit" class="search-btn"></button>
                </div>
                <p class="search-help">
                    예: 육군 00사단, 공군 0비행단, 해병 0여단 …
                </p>
            </div>
        </form>
    </div>

</div>

</body>
</html>
