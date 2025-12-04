<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 새 게시글 작성</title>

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
        .header-left { display: flex; align-items: center; gap: 12px; }
        .header-logo-box {
            width: 30px; height: 30px;
            border-radius: 6px;
            background-color: #fff;
        }
        .header-title { font-size: 20px; font-weight: 700; letter-spacing: .08em; }
        .header-nav { display: flex; align-items: center; gap: 24px; font-size: 15px; }
        .header-nav a { color: #fff; text-decoration: none; }
        .header-nav a:hover { text-decoration: underline; }
        .header-nav a.active { font-weight: 700; text-decoration: underline; }
        .header-right { display: flex; align-items: center; gap: 16px; font-size: 14px; }
        .logout-button {
            padding: 6px 14px;
            border-radius: 6px;
            border: none;
            background-color: #fff;
            color: #78866B;
            font-weight: 600;
            cursor: pointer;
        }

        .page-wrap {
            max-width: 900px;
            margin: 24px auto 40px;
            padding: 0 16px;
        }
        h2 { font-size: 24px; margin-bottom: 6px; }
        .subtitle { font-size: 13px; color: #777; margin-bottom: 20px; }

        form {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px 24px 22px 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .form-row { margin-bottom: 16px; }
        .form-row label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .radio-group {
            display: flex;
            gap: 18px;
            font-size: 14px;
        }
        .radio-group label { font-weight: 400; }
        .form-row input[type="text"],
        .form-row textarea {
            width: 100%;
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
            outline: none;
        }
        .form-row textarea {
            resize: vertical;
            min-height: 160px;
        }

        .button-group {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            margin-top: 12px;
        }
        .btn-cancel,
        .btn-submit {
            padding: 8px 18px;
            border-radius: 6px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-cancel { background-color: #e0e0e0; color: #333; }
        .btn-submit { background-color: #78866B; color: #fff; }

        /* 보안 경고 모달 */
        .modal-backdrop {
            position: fixed;
            inset: 0;
            background-color: rgba(0,0,0,0.25);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 999;
        }
        .modal-box {
            width: 380px;
            max-width: 90%;
            background-color: #fffaf0;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            padding: 24px 26px 20px 26px;
            text-align: center;
        }
        .modal-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 12px;
        }
        .modal-message {
            font-size: 14px;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        .modal-button {
            padding: 8px 22px;
            border-radius: 4px;
            border: none;
            background-color: #c9a36a;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
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
    <h2>새 게시글 작성</h2>
    <p class="subtitle">군 생활에 대한 솔직한 후기를 작성해 주세요.</p>

    <form id="writeForm" action="${pageContext.request.contextPath}/social/write" method="post">
        <div class="form-row">
            <label>공개 옵션</label>
            <div class="radio-group">
                <label><input type="radio" name="openType" value="PUBLIC" checked> 아이디 공개</label>
                <label><input type="radio" name="openType" value="ANON"> 아이디 비공개 (익명)</label>
            </div>
        </div>

        <div class="form-row">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" required>
        </div>

        <div class="form-row">
            <label for="content">내용</label>
            <textarea id="content" name="content" required></textarea>
        </div>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/social/board" class="btn-cancel">취소</a>
            <button type="button" id="submitBtn" class="btn-submit">작성 완료</button>
        </div>
    </form>
</div>

<!-- 보안 경고 모달 -->
<div id="securityModal" class="modal-backdrop">
    <div class="modal-box">
        <div class="modal-title">경고!</div>
        <div class="modal-message">
            보안에 위배되는 단어 또는 글을 작성하였습니다.<br>
            자동으로 게시글은 삭제 됩니다.
        </div>
        <button type="button" id="modalOkBtn" class="modal-button">확인</button>
    </div>
</div>

<script>
    (function () {
        const form       = document.getElementById('writeForm');
        const submitBtn  = document.getElementById('submitBtn');
        const titleInput = document.getElementById('title');
        const contentInp = document.getElementById('content');

        const modal      = document.getElementById('securityModal');
        const modalOkBtn = document.getElementById('modalOkBtn');

        const bannedWords = [
            '보안', '안보', '암구호',
            '알파', '브라보',
            '부대기밀', '군사기밀', '작전명령',
            '좌표', '진지위치'
        ];

        function containsBannedWord(text) {
            const lower = text.toLowerCase();
            return bannedWords.some(w => lower.includes(w.toLowerCase()));
        }

        submitBtn.addEventListener('click', function () {
            const title   = titleInput.value.trim();
            const content = contentInp.value.trim();
            const combined = title + ' ' + content;

            if (!title || !content) {
                alert('제목과 내용을 모두 입력해 주세요.');
                return;
            }

            if (containsBannedWord(combined)) {
                modal.style.display = 'flex';
                titleInput.value = '';
                contentInp.value = '';
                return;
            }

            // 화면만 보여주는 버전이므로 실제 전송은 막고 소셜 목록으로 이동만 시킴
            window.location.href = '<%= request.getContextPath() %>/social/board';
        });

        modalOkBtn.addEventListener('click', function () {
            modal.style.display = 'none';
        });
    })();
</script>

</body>
</html>
