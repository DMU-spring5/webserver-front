<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 소셜 커뮤니티</title>
    <style>
        /* CSS 스타일은 이전과 동일 */
        body { margin: 0; font-family: Arial, sans-serif; }
        header { background-color: #78866B; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .header-left h1 { margin: 0; font-size: 1.5em; display: flex; align-items: center; gap: 10px; }
        .header-nav a { color: white; margin: 0 15px; text-decoration: none; font-weight: 500; }
        .header-nav a:hover { text-decoration: underline; }
        .header-right { display: flex; align-items: center; }
        .header-right span { margin-right: 15px; }
        .logout-button { background-color: white; color: #78866B; border: none; padding: 8px 15px; cursor: pointer; border-radius: 5px; font-weight: bold; }

        .social-container { padding: 20px; max-width: 1000px; margin: 0 auto; }
        .board-header { display: flex; justify-content: flex-end; align-items: center; margin-bottom: 10px; }
        .write-button { padding: 10px 15px; background-color: #556b2f; color: white; border: none; cursor: pointer; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .board-table { width: 100%; border-collapse: collapse; border-top: 2px solid #556b2f; }
        .board-table th, .board-table td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        .board-table th { background-color: #f2f2f2; }
        .board-table .title { text-align: left; }
        .pagination-area { text-align: center; margin-top: 30px; }
        .pagination-area .page-link { display: inline-block; padding: 5px 10px; margin: 0 2px; border: 1px solid #ccc; text-decoration: none; color: #333; border-radius: 3px; }
        .pagination-area .page-link.active { background-color: #78866B; color: white; border-color: #78866B; font-weight: bold; }
        .pagination-area .page-link:hover:not(.active) { background-color: #f0f0f0; }
    </style>
</head>
<body>
<header>
    <div class="header-left">
        <h1 style="display: flex; align-items: center; gap: 10px;">
            <img src="https://via.placeholder.com/30/FFFFFF/78866B?text=M" alt="M" style="height: 30px; border-radius: 5px; background: white;"> MILLI ROAD
        </h1>
    </div>
    <nav class="header-nav">
        <a href="#">뉴스</a> |
        <a href="/social/board" style="font-weight: bold;">소셜</a> |
        <a href="#">건강</a> |
        <a href="/">지도</a>
    </nav>
    <div class="header-right">
        <span>니인내조 님</span>
        <button class="logout-button">로그아웃</button>
    </div>
</header>

<div class="social-container">
    <h2>소셜 커뮤니티 | 부대별 평가</h2>

    <div class="board-header">
        <a href="/social/write" class="write-button">글쓰기</a>
    </div>

    <table class="board-table">
        <thead>
        <tr>
            <th style="width: 10%;">번호</th>
            <th style="width: 50%;">제목</th>
            <th style="width: 15%;">글쓴이</th>
            <th style="width: 10%;">작성일</th>
            <th style="width: 5%;">조회</th>
            <th style="width: 5%;">추천</th>
        </tr>
        </thead>
        <tbody id="post-list-body">
        <c:choose>
            <c:when test="${empty posts}">
                <tr>
                    <td colspan="6">게시글이 없습니다. 첫 게시글을 작성해보세요!</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="post" items="${posts}">
                    <tr>
                        <td style="font-weight: bold; color: green;">${post.postId}</td>
                        <td class="title">
                            <a href="/social/detail?id=${post.postId}">
                                <c:out value="${post.title}" />
                            </a>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${post.publicOption eq 'anonymous'}">
                                    익명
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${post.writer}" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${post.date}" /></td>
                        <td><c:out value="${post.views}" /></td>
                        <td><c:out value="${post.recommends}" /></td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <div class="pagination-area">
        <a href="#" class="page-link">&lt;</a>
        <a href="#" class="page-link active">1</a>
        <a href="#" class="page-link">2</a>
        <a href="#" class="page-link">3</a>
        <a href="#" class="page-link">&gt;</a>
    </div>
</div>

</body>
</html>