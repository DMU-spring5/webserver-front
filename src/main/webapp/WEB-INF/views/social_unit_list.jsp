<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부대 별 평가 - 첫 화면</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,
            "Segoe UI",system-ui,sans-serif;
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
        .header-logo-box{
            width:34px;height:34px;
            border-radius:4px;
            background:#fff;
        }
        .header-title{
            font-size:22px;
            font-weight:700;
            letter-spacing:.10em;
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
        .header-nav a:hover{text-decoration:underline;}
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

        /* ===== 본문 ===== */
        .page-wrap{
            max-width:1200px;
            margin:40px auto 80px;
            padding:0 32px;
        }

        .inner-box{
            width:760px;
            margin:0 auto;
            background:#fff;
            border-radius:4px;
            box-shadow:0 1px 3px rgba(0,0,0,0.06);
            padding:36px 40px 46px;
        }

        /* 상단 탭 (부대별 평가 / 커뮤니티) */
        .top-tabs{
            font-size:18px;
            margin-bottom:32px;
        }
        .tab-link{
            text-decoration:none;
            margin-right:16px;
        }
        .tab-text-main{      /* 현재 화면 */
            font-weight:700;
            color:#000;
        }
        .tab-text-sub{       /* 비활성 */
            font-weight:400;
            color:#b6b6b6;
        }

        .search-label{
            font-size:16px;
            font-weight:700;
            margin-bottom:12px;
        }

        .search-bar{
            width:100%;
            height:48px;
            border-radius:4px;
            border:1px solid #d7d7cf;
            background:#fdfdf8;
            display:flex;
            align-items:center;
            padding:0 16px;
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

        /* 자동완성 리스트 */
        .unit-suggestion {
            margin-top:4px;
            width:100%;
            max-height:220px;
            overflow-y:auto;
            border-radius:4px;
            border:1px solid #ddd;
            background:#fff;
            font-size:13px;
            display:none;
        }
        .unit-suggestion-item {
            padding:8px 12px;
            cursor:pointer;
        }
        .unit-suggestion-item:hover {
            background:#f3f3f3;
        }
    </style>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
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
        <a href="${pageContext.request.contextPath}/social/board" class="active">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health">건강</a>
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

        <!-- 탭: 부대별 평가(진하게) / 커뮤니티(흐리게) -->
        <div class="top-tabs">
            <a class="tab-link"
               href="${pageContext.request.contextPath}/social_unit">
                <span class="tab-text-main">부대별 평가</span>
            </a>
            <span>|</span>
            <a class="tab-link"
               href="${pageContext.request.contextPath}/social/board">
                <span class="tab-text-sub">커뮤니티</span>
            </a>
        </div>

        <!-- 검색 영역 -->
        <div class="search-label">부대별 평가</div>

        <div class="search-bar">
            <input id="unitSearchInput" class="search-input"
                   type="text" placeholder="사단을 검색하세요.">
            <button id="unitSearchBtn" class="search-btn" type="button">
                <i class="fas fa-search"></i>
            </button>
        </div>

        <div id="unitSuggestion" class="unit-suggestion"></div>

    </div>
</div>

<script>
    (function () {
        const ctx   = '<%= request.getContextPath() %>';
        const input = document.getElementById('unitSearchInput');
        const btn   = document.getElementById('unitSearchBtn');
        const box   = document.getElementById('unitSuggestion');

        const units = [
            '제 505보병여단',
            '제 97여단',
            '제 98여단',
            '제 99보병여단',
            '육군 00사단',
            '공군 0비행단'
        ];

        function render(keyword) {
            const k = keyword.replace(/\s+/g,'').toLowerCase();
            const matched = units.filter(u =>
                u.replace(/\s+/g,'').toLowerCase().includes(k)
            );

            box.innerHTML = '';
            if (!matched.length) {
                box.style.display = 'none';
                return;
            }
            matched.forEach(text => {
                const div = document.createElement('div');
                div.className = 'unit-suggestion-item';
                div.textContent = text;
                div.addEventListener('click', () => {
                    input.value = text;
                    box.style.display = 'none';
                    // 선택 후 바로 리스트 화면으로 이동
                    location.href = ctx + '/social_unit_list?unitName=' + encodeURIComponent(text);
                });
                box.appendChild(div);
            });
            box.style.display = 'block';
        }

        input.addEventListener('input', function () {
            const q = this.value.trim();
            if (!q) {
                box.style.display = 'none';
                box.innerHTML = '';
                return;
            }
            render(q);
        });

        input.addEventListener('blur', () => {
            setTimeout(() => { box.style.display = 'none'; }, 200);
        });

        function goList() {
            const q = (input.value || '').trim();
            if (!q) {
                alert('사단/부대 이름을 입력해 주세요.');
                input.focus();
                return;
            }
            location.href = ctx + '/social_unit_list?unitName=' + encodeURIComponent(q);
        }

        btn.addEventListener('click', goList);
        input.addEventListener('keydown', e => {
            if (e.key === 'Enter') goList();
        });
    })();
</script>

</body>
</html>
