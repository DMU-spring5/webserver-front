<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 게시글 상세</title>
    <style>
        /* 기존 스타일 상속 및 상세 페이지용 추가 */
        body { margin: 0; font-family: Arial, sans-serif; background-color: #f4f4f4; }
        header { background-color: #78866B; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .header-left h1 { margin: 0; font-size: 1.5em; display: flex; align-items: center; gap: 10px; }
        .header-nav a { color: white; margin: 0 15px; text-decoration: none; font-weight: 500; }
        .header-nav a:hover { text-decoration: underline; }
        .header-right { display: flex; align-items: center; }
        .header-right span { margin-right: 15px; }
        .logout-button { background-color: white; color: #78866B; border: none; padding: 8px 15px; cursor: pointer; border-radius: 5px; font-weight: bold; }

        .detail-container { padding: 40px 20px; max-width: 800px; margin: 20px auto; background-color: white; border: 1px solid #ddd; border-radius: 8px; }
        .post-header h2 { font-size: 1.8em; color: #333; margin-bottom: 5px; }
        .post-info { border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px; color: #666; font-size: 0.9em; display: flex; justify-content: space-between; }
        .post-info span { margin-right: 15px; }
        .post-content { min-height: 200px; padding: 15px 0; border-bottom: 1px solid #ddd; line-height: 1.6; white-space: pre-wrap; }

        .action-buttons { text-align: right; margin-top: 20px; }
        .action-buttons button, .action-buttons a { padding: 8px 15px; border: none; cursor: pointer; border-radius: 5px; font-weight: bold; margin-left: 10px; text-decoration: none; display: inline-block;}
        .list-button { background-color: #ccc; color: #333; }
        .edit-button { background-color: #556b2f; color: white; }
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

<div class="detail-container">
    <c:choose>
        <c:when test="${not empty post}">
            <div class="post-header">
                <h2><c:out value="${post.title}" /></h2>
            </div>
            <div class="post-info">
                <div>
                    <span>번호: ${post.postId}</span>
                    <span>
                        글쓴이:
                        <c:choose>
                            <c:when test="${post.publicOption eq 'anonymous'}">
                                익명
                            </c:when>
                            <c:otherwise>
                                ${post.writer}
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span>작성일: ${post.date}</span>
                </div>
                <div>
                    <span>조회: ${post.views}</span>
                    <span>추천: ${post.recommends}</span>
                </div>
            </div>
            <div class="post-content">
                <c:out value="${post.content}" />
            </div>
        </c:when>
        <c:otherwise>
            <div style="text-align: center; padding: 50px;">
                <h2>게시글을 찾을 수 없습니다.</h2>
                <p>삭제되었거나 존재하지 않는 게시글입니다.</p>
            </div>
        </c:otherwise>
    </c:choose>


    <div class="action-buttons">
        <a href="/social/board" class="list-button">목록으로</a>
    </div>
</div>

</body>
</html>