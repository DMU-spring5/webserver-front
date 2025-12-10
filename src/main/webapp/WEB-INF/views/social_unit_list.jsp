<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부대 별 평가</title>

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

        .path-row{
            font-size:16px;
            margin-bottom:20px;
        }
        .path-row strong{font-weight:700;margin-right:6px;}
        .path-row span{color:#b3b3b3;margin-left:6px;}

        .unit-title{
            text-align:center;
            font-size:22px;
            font-weight:700;
            margin-bottom:18px;
        }

        .list-wrap{
            background:#fff;
            border:1px solid #d5d5d5;
        }
        .list-header{
            display:flex;
            justify-content:flex-end;
            padding:8px 10px;
            border-bottom:1px solid #d5d5d5;
        }
        .btn-eval{
            padding:6px 14px;
            border-radius:2px;
            border:1px solid #cccccc;
            background:#e5e5e5;
            font-size:13px;
            cursor:pointer;
        }

        table.unit-table{
            width:100%;
            border-collapse:collapse;
            font-size:13px;
        }
        table.unit-table thead{
            background:#f7f7f7;
        }
        table.unit-table th,
        table.unit-table td{
            padding:9px 10px;
            border-top:1px solid #e1e1e1;
            text-align:left;
        }
        table.unit-table th{font-weight:600;}
        .td-no{width:70px;text-align:center;}
        .td-writer,.td-score,.td-date{
            text-align:center;
            white-space:nowrap;
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

    <div class="path-row">
        <strong>부대 별 평가</strong>
        <span>| 소셜 커뮤니티</span>
    </div>

    <div class="unit-title">
        ${unitName}
    </div>

    <div class="list-wrap">
        <div class="list-header">
            <button class="btn-eval" type="button"
                    onclick="location.href='${pageContext.request.contextPath}/social_unit_write?unitName=${unitName}'">
                평가하기
            </button>
        </div>

        <table class="unit-table">
            <thead>
            <tr>
                <th style="width:70px;">번호</th>
                <th>요약</th>
                <th style="width:140px;">글쓴이</th>
                <th style="width:80px;">별점</th>
                <th style="width:120px;">작성일</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="row" items="${evalList}">
                <tr>
                    <td class="td-no">${row.no}</td>
                    <td>${row.summary}</td>
                    <td class="td-writer">${row.writer}</td>
                    <td class="td-score">${row.score}</td>
                    <td class="td-date">${row.date}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
