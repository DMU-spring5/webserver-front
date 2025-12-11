<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>건강 메인 페이지</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            font-family:"Noto Sans KR",system-ui,-apple-system,
            BlinkMacSystemFont,"Segoe UI",sans-serif;
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

        /* 로고 이미지 스타일 */
        .header-logo-img{
            width:34px;
            height:34px;
            border-radius:4px;
            object-fit:cover;
            /* 이미지 자체가 투명하지 않다면 background:#fff;는 제거하거나 유지할 수 있습니다. */
            /* background:#fff; */
        }

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
            max-width:1200px;
            margin:40px auto 80px;
            padding:0 32px;
        }
        .inner-box{
            background:#fff;
            border-radius:4px;
            box-shadow:0 1px 3px rgba(0,0,0,0.06);
            padding:40px 48px 56px;
        }

        /* 탭 */
        .top-tabs {
            font-size: 18px;
            margin-bottom: 32px;
        }
        .tab-link {
            text-decoration: none;
            margin-right: 16px;
        }
        .tab-text-main {
            font-weight: 700;
            color: #000;
        }
        .tab-text-sub {
            font-weight: 400;
            color: #b6b6b6;
        }

        .title-row{
            width:760px;
            margin:0 auto 40px;
        }
        .title-row h2{
            font-size:20px;
            font-weight:700;
            margin-bottom:16px;
        }

        .search-bar{
            width:100%;
            height:48px;
            border-radius:4px;
            border:1px solid #d7d7cf;
            display:flex;
            align-items:center;
            padding:0 16px;
            background:#fdfdf8;
        }
        .search-input{
            flex:1;
            border:none;
            outline:none;
            background:transparent;
            font-size:14px;
            color:#555;
        }
        .search-btn{
            width:32px;height:32px;
            border:none;background:transparent;
            cursor:pointer;
        }
        .search-btn i{
            font-size:18px;
            color:#888;
        }

        .category-wrap{
            width:760px;
            margin:40px auto 0;
        }
        .category-title{
            font-size:15px;
            font-weight:600;
            margin-bottom:20px;
        }

        .category-grid{
            display:grid;
            grid-template-columns:repeat(2, 260px);
            gap:28px 80px;
            justify-content:center;
        }
        .category-btn{
            width:260px;
            height:100px;
            border-radius:2px;
            border:1px solid #d7d7cf;
            background:#f0efe7;
            font-size:18px;
            display:flex;
            align-items:center;
            justify-content:center;
            cursor:pointer;
        }
        .category-btn:hover{
            background:#e6e3d6;
        }
        a.cat-link{
            display:block;
            text-decoration:none;
            color:inherit;
        }
    </style>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
</head>
<body>

<header>
    <div class="header-left">
        <img class="header-logo-img"
             src="${pageContext.request.contextPath}/img/WebServerLogo2.png"
             alt="MILLI ROAD Logo">

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
    <div class="inner-box">

        <div class="top-tabs">
            <a class="tab-link"
               href="${pageContext.request.contextPath}/health_main">
                <span class="tab-text-main">운동 칼로리 검색</span>
            </a>
            <span>|</span>
            <a class="tab-link"
               href="${pageContext.request.contextPath}/health_calculator">
                <span class="tab-text-sub">칼로리 계산기</span>
            </a>
        </div>

        <div class="title-row">
            <div class="search-bar">
                <input id="healthSearchInput" class="search-input"
                       type="text"
                       placeholder="니인내조 님, 오늘은 어떤 운동을 하셨나요? (예: 유산소, 하체, 스포츠)">
                <button id="healthSearchBtn" class="search-btn" type="button">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </div>

        <div class="category-wrap">
            <div class="category-title">카테고리 선택</div>

            <div class="category-grid">
                <a class="cat-link" href="${pageContext.request.contextPath}/health_shoulder">
                    <div class="category-btn">어깨 &amp; 팔</div>
                </a>
                <a class="cat-link" href="${pageContext.request.contextPath}/health_chest">
                    <div class="category-btn">가슴</div>
                </a>
                <a class="cat-link" href="${pageContext.request.contextPath}/health_back">
                    <div class="category-btn">등</div>
                </a>
                <a class="cat-link" href="${pageContext.request.contextPath}/health_leg">
                    <div class="category-btn">하체</div>
                </a>
                <a class="cat-link" href="${pageContext.request.contextPath}/health_ct">
                    <div class="category-btn">유산소</div>
                </a>
                <a class="cat-link" href="${pageContext.request.contextPath}/health_sports">
                    <div class="category-btn">스포츠</div>
                </a>
            </div>
        </div>

    </div>
</div>

<script>
    (function () {
        const ctx   = '<%= request.getContextPath() %>';
        const input = document.getElementById('healthSearchInput');
        const btn   = document.getElementById('healthSearchBtn');

        const routeMap = {
            '어깨':  '/health_shoulder',
            '팔':    '/health_shoulder',
            '가슴':  '/health_chest',
            '등':    '/health_back',
            '하체':  '/health_leg',
            '유산소': '/health_ct',
            '스포츠': '/health_sports'
        };

        function handleSearch() {
            const q = (input.value || '').trim();
            if (!q) {
                alert('어깨, 팔, 가슴, 등, 하체, 유산소, 스포츠 중 하나를 입력해 주세요.');
                input.focus();
                return;
            }
            // 검색어에 해당하는 경로를 찾을 때 대소문자나 띄어쓰기를 처리하지 않으므로,
            // 정확히 맵에 있는 키와 일치해야 합니다. (예: '유산소'만 가능, '유산소 운동' 불가)
            const url = routeMap[q];
            if (!url) {
                alert('어깨, 팔, 가슴, 등, 하체, 유산소, 스포츠 중 하나를 정확히 입력해 주세요.');
                input.focus();
                return;
            }
            location.href = ctx + url;
        }

        btn.addEventListener('click', handleSearch);
        input.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') handleSearch();
        });
    })();
</script>

</body>
</html>