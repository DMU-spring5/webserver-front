<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 글쓰기</title>
    <style>
        /* CSS 스타일은 이전과 동일 */
        body { margin: 0; font-family: Arial, sans-serif; background-color: #f4f4f4; }
        header { background-color: #78866B; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .header-left h1 { margin: 0; font-size: 1.5em; display: flex; align-items: center; gap: 10px; }
        .header-nav a { color: white; margin: 0 15px; text-decoration: none; font-weight: 500; }
        .header-nav a:hover { text-decoration: underline; }
        .header-right { display: flex; align-items: center; }
        .header-right span { margin-right: 15px; }
        .logout-button { background-color: white; color: #78866B; border: none; padding: 8px 15px; cursor: pointer; border-radius: 5px; font-weight: bold; }

        .write-container { padding: 40px 20px; max-width: 800px; margin: 20px auto; background-color: white; border: 1px solid #ddd; border-radius: 8px; }
        h2 { border-bottom: 2px solid #556b2f; padding-bottom: 10px; margin-bottom: 30px; color: #333; }

        .write-table { width: 100%; border-collapse: collapse; }
        .write-table th, .write-table td { border-bottom: 1px solid #eee; padding: 15px 10px; }
        .write-table th { width: 15%; background-color: #f9f9f9; text-align: left; font-weight: bold; color: #333; }

        /* name 속성에 맞춰 ID도 수정: post-title -> title, post-content -> content */
        #title { width: 95%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; font-size: 1.1em; }
        #content { width: 95%; min-height: 250px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; resize: vertical; font-size: 1em; line-height: 1.5; }

        .action-buttons { text-align: right; margin-top: 30px; }
        .action-buttons button { padding: 10px 20px; border: none; cursor: pointer; border-radius: 5px; font-weight: bold; margin-left: 10px; }
        .cancel-button { background-color: #ccc; color: #333; }
        .submit-button { background-color: #556b2f; color: white; }

        .col-input input[type="radio"] { margin-right: 5px; }
        .col-input label { margin-right: 15px; }
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
        <a href="/social/board" style="font-weight: bold;">소셜</a> | <a href="#">건강</a> |
        <a href="/">지도</a>
    </nav>
    <div class="header-right">
        <span>니인내조 님</span>
        <button class="logout-button">로그아웃</button>
    </div>
</header>

<div class="write-container">
    <h2>게시글 작성</h2>

    <form id="post-form" action="/social/write" method="POST">
        <table class="write-table">
            <tr>
                <th>공개여부</th>
                <td class="col-input">
                    <label><input type="radio" name="public_option" value="public" checked> 아이디 공개</label>
                    <label><input type="radio" name="public_option" value="anonymous"> 익명</label>
                </td>
            </tr>
            <tr>
                <th>제목</th>
                <td class="col-input">
                    <input type="text" id="title" name="title" placeholder="제목을 입력하세요" required>
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td class="col-input">
                    <textarea id="content" name="content" placeholder="내용을 입력하세요" required></textarea>
                </td>
            </tr>
        </table>

        <div class="action-buttons">
            <button type="button" class="cancel-button" onclick="window.location.href='/social/board'">취소</button>
            <button type="submit" class="submit-button">올리기</button>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('post-form');

        form.addEventListener('submit', (e) => {
            // ID를 name과 동일하게 수정했습니다.
            const title = document.getElementById('title').value.trim();
            const content = document.getElementById('content').value.trim();

            if (!title || !content) {
                e.preventDefault(); // 폼 전송을 막고 알림
                alert('제목과 내용을 모두 입력해 주세요.');
                return;
            }
            // 유효성 검사 통과 시 폼은 자동으로 서버로 데이터를 POST 전송합니다.
        });
    });
</script>
</body>
</html>

