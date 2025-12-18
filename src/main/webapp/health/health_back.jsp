<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>건강 페이지 - 등</title>

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

        /* 로고 이미지를 표시하도록 스타일 이름은 유지 */
        .header-logo-box{
            width:34px;
            height:34px;
            border-radius:4px;
            object-fit:cover; /* 이미지 표시를 위해 추가 */
            /* 기존 background:#fff;는 이미지로 대체되므로 제거하거나 유지할 수 있습니다. */
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
        <img class="header-logo-box"
             src="${pageContext.request.contextPath}/img/WebServerLogo2.png"
             alt="MILLI ROAD Logo">
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

    <div class="top-tabs">
        <a class="tab-link" href="${pageContext.request.contextPath}/health_main">
            <span class="tab-text-main">운동 칼로리 검색</span>
        </a>
        <span>|</span>
        <a class="tab-link" href="${pageContext.request.contextPath}/health_calculator">
            <span class="tab-text-sub">칼로리 계산기</span>
        </a>
    </div>

    <div class="section-title">등</div>

    <div class="filter-row">
        <button class="filter-btn filter-btn-active" data-type="ALL">전체</button>
        <button class="filter-btn" data-type="DB">덤벨</button>
        <button class="filter-btn" data-type="BB">바벨</button>
        <button class="filter-btn" data-type="BW">맨몸</button>
        <button class="filter-btn" data-type="BD">밴드</button>
        <button class="filter-btn" data-type="BALL">볼</button>
    </div>

    <div id="workoutList" class="workout-list"></div>

</div>

<script>
    (function () {
        const ctx = '<%= request.getContextPath() %>';
        const buttons = document.querySelectorAll('.filter-btn');
        const listEl  = document.getElementById('workoutList');

        // 등 부위 운동 데이터
        const data = {
            DB: [ // 덤벨
                '벤트오버 덤벨로우',
                '벤트오버 리버스 플라이',
                '인클라인 덤벨로우'
            ],
            BB: [
                '바벨 로우',
                '바벨 데드리프트',
                'T바 로우'
            ],
            BW: [
                '풀업',
                '친업',
                '슈퍼맨 백 익스텐션'
            ],
            BD: [
                '밴드 풀어파트',
                '밴드 라트 풀다운',
                '밴드 로우'
            ],
            BALL: [
                '스위스볼 백 익스텐션',
                '스위스볼 힙 익스텐션'
            ]
        };
        data.ALL = [...data.DB, ...data.BB, ...data.BW, ...data.BD, ...data.BALL];

        // type 에 따라 리스트 다시 그리기
        function render(type) {
            const items = data[type] || [];
            listEl.innerHTML = '';
            if (!items.length) {
                listEl.innerHTML = '<div class="workout-btn">등록된 운동이 없습니다.</div>';
                return;
            }
            items.forEach(name => {
                const a = document.createElement('a');
                a.className = 'workout-btn';
                a.textContent = name;
                a.href = ctx + '/health_exercise_detail?part='
                    + encodeURIComponent('등')
                    + '&type=' + encodeURIComponent(mapType(type))
                    + '&name=' + encodeURIComponent(name);
                listEl.appendChild(a);
            });
        }

        // 화면에 보여줄 기구명 매핑
        function mapType(type) {
            switch (type) {
                case 'DB': return '덤벨';
                case 'BB': return '바벨';
                case 'BW': return '맨몸';
                case 'BD': return '밴드';
                case 'BALL': return '볼';
                default: return '';
            }
        }

        // 버튼 클릭 시 active 변경 + render
        buttons.forEach(btn => {
            btn.addEventListener('click', function () {
                const type = this.getAttribute('data-type');
                buttons.forEach(b => b.classList.remove('filter-btn-active'));
                this.classList.add('filter-btn-active');
                render(type);
            });
        });

        // 첫 로드시 전체 보기
        render('ALL');
    })();
</script>

</body>
</html>