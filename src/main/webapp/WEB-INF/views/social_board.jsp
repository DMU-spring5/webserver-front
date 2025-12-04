<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 목록</title>

    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,"Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;color:#333;
        }

        /* ===== 헤더 ===== */
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
        .logout-button{
            padding:6px 16px;border-radius:4px;border:none;
            background:#fff;color:#78866B;font-weight:600;cursor:pointer;
        }

        /* ===== 본문 ===== */
        .page-wrap{
            max-width:1100px;
            margin:42px auto 60px;
            padding:0 24px;
        }

        /* 상단 탭 (부대별 평가 / 커뮤니티) */
        .top-tabs{
            font-size:18px;
            margin-bottom:24px;
        }
        .tab-link{
            text-decoration:none;
            margin-right:16px;
        }
        .tab-text-main{font-weight:700;color:#000;}
        .tab-text-sub{font-weight:400;color:#b6b6b6;}

        .board-header{
            display:flex;justify-content:flex-end;margin-bottom:10px;
        }
        .write-button{
            padding:8px 18px;border-radius:4px;border:none;
            background:#78866B;color:#fff;font-size:14px;font-weight:600;
            cursor:pointer;text-decoration:none;
        }

        table.board-table{
            width:100%;border-collapse:collapse;background:#fff;
            border-radius:8px;overflow:hidden;
            box-shadow:0 1px 3px rgba(0,0,0,0.08);
        }
        .board-table thead{background:#f3f3f3;}
        .board-table th,
        .board-table td{
            padding:10px 14px;
            font-size:14px;
            border-bottom:1px solid #e5e5e5;
            text-align:left;
        }
        .board-table th{font-weight:600;}
        .board-table tbody tr:hover{
            background:#fafafa;
            cursor:pointer;
        }
        .board-table td.title{font-weight:500;}

        .pagination{
            display:flex;justify-content:center;gap:6px;
            margin-top:18px;font-size:13px;
        }
        .pagination span,
        .pagination a{
            display:inline-block;min-width:24px;
            padding:4px 8px;border-radius:4px;
            border:1px solid #c4c4c4;
            text-align:center;
            text-decoration:none;
            color:#555;
        }
        .pagination .active{
            background:#78866B;border-color:#78866B;
            color:#fff;font-weight:600;
        }
        .pagination a:hover:not(.active){
            background:#e4e4e4;
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
        <a href="${pageContext.request.contextPath}/social/board" class="active">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/main">지도</a>
    </nav>
    <div class="header-right">
        <span>니인내조 님</span>
        <button class="logout-button">로그아웃</button>
    </div>
</header>

<div class="page-wrap">

    <!-- 탭: 부대별 평가(흐리게) / 커뮤니티(진하게) -->
    <div class="top-tabs">
        <a class="tab-link"
           href="${pageContext.request.contextPath}/social_unit">
            <span class="tab-text-sub">부대별 평가</span>
        </a>
        <span>|</span>
        <a class="tab-link"
           href="${pageContext.request.contextPath}/social/board">
            <span class="tab-text-main">커뮤니티</span>
        </a>
    </div>

    <div class="board-header">
        <a href="${pageContext.request.contextPath}/social/write" class="write-button">글쓰기</a>
    </div>

    <table class="board-table">
        <thead>
        <tr>
            <th style="width:80px;">번호</th>
            <th>제목</th>
            <th style="width:120px;">글쓴이</th>
            <th style="width:130px;">작성일</th>
            <th style="width:80px;">조회</th>
            <th style="width:80px;">추천</th>
        </tr>
        </thead>
        <tbody>
        <!-- 더미 데이터 3개 -->
        <tr onclick="location.href='${pageContext.request.contextPath}/social/detail?id=1'">
            <td>1</td>
            <td class="title">훈련소 생활 괜찮았어요</td>
            <td>이병 홍길동</td>
            <td>2025-11-25</td>
            <td>12</td>
            <td>3</td>
        </tr>
        <tr onclick="location.href='${pageContext.request.contextPath}/social/detail?id=2'">
            <td>2</td>
            <td class="title">PX 시설이 너무 좋아요</td>
            <td>상병 김훈련</td>
            <td>2025-11-24</td>
            <td>8</td>
            <td>1</td>
        </tr>
        <tr onclick="location.href='${pageContext.request.contextPath}/social/detail?id=3'">
            <td>3</td>
            <td class="title">식단은 조금 아쉬웠습니다</td>
            <td>일병 박자취</td>
            <td>2025-11-23</td>
            <td>5</td>
            <td>0</td>
        </tr>
        </tbody>
    </table>

    <div class="pagination">
        <span class="active">1</span>
        <!-- 나중에 글 많아지면 2,3… 동적으로 추가 -->
    </div>
</div>

</body>
</html>
