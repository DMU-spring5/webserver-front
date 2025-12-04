<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 게시글 상세</title>

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: "Noto Sans KR", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }
        header {
            height: 64px;
            background-color: #78866B;
            color: #fff;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header-left{display:flex;align-items:center;gap:12px;}
        .header-logo-box{
            width:30px;height:30px;border-radius:6px;background:#fff;
        }
        .header-title{font-size:20px;font-weight:700;letter-spacing:.08em;}
        .header-nav{display:flex;align-items:center;gap:24px;font-size:15px;}
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{font-size:14px;}

        .page-wrap{
            max-width:900px;margin:24px auto 40px;padding:0 16px;
        }
        table.detail-table{
            width:100%;border-collapse:collapse;background:#fff;
        }
        .detail-table th,.detail-table td{
            border:1px solid #ddd;padding:10px 12px;font-size:14px;
        }
        .detail-table th{
            width:120px;background:#f4f4f4;text-align:center;
        }
        .detail-table td.content{
            min-height:200px;white-space:pre-wrap;
        }
        .comment-box{
            margin-top:16px;background:#fff;border-radius:6px;
            padding:10px 12px;border:1px solid #ddd;
        }
        .comment-box input{
            width:90%;border:none;outline:none;font-size:14px;
        }
        .comment-box button{
            float:right;border:none;background:#78866B;color:#fff;
            padding:4px 10px;border-radius:4px;cursor:pointer;
        }
        .btn-area{
            margin-top:16px;text-align:right;
        }
        .btn-area a{
            display:inline-block;margin-left:6px;padding:6px 14px;
            border-radius:4px;text-decoration:none;font-size:13px;
            border:1px solid #ccc;background:#f5f5f5;color:#333;
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
        니인내조 님
    </div>
</header>

<div class="page-wrap">
    <table class="detail-table">
        <tr>
            <th>제목</th>
            <td>나에게 수고했다고 해줄 수 있겠니..?</td>
        </tr>
        <tr>
            <th>내용</th>
            <td class="content">오늘 힘든 일이 있었는데 나에게 수고했다고 해줄 사람 없을까..</td>
        </tr>
    </table>

    <div class="comment-box">
        <span>댓글 달기 : </span>
        <input type="text" placeholder="댓글을 입력해 주세요.">
        <button type="button">▶</button>
    </div>

    <div class="btn-area">
        <a href="${pageContext.request.contextPath}/social/board">목록</a>
    </div>
</div>

</body>
</html>
