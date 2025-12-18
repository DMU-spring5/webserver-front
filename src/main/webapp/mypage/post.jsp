
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MyPage</title>
    <link rel="stylesheet" type="text/css" href="post.css">
</head>
<body>
<header class="header">
    <div class="header-inner">
        <div class="logo">
            <img src="../img/WebServerLogo2.png" alt="MILLI ROAD 로고">
        </div>

        <div class="header-center">
            <nav class="nav">
                <a href="index.jsp">뉴스</a>
                <span class="divider">|</span>
                <a href="#">소셜</a>
                <span class="divider">|</span>
                <a href="health/health.jsp">건강</a>
                <span class="divider">|</span>
                <a href="#">지도</a>
            </nav>
        </div>
    </div>
</header>

<!-- 본문 -->
<div class="mypage-wrap">
    <!-- 탭 -->
    <div class="tab-header">
        <button class="tab-btn active" data-target="tab-my">내가 쓴 글</button>
        <button class="tab-btn" data-target="tab-like">좋아요 한 글</button>
        <button class="tab-btn" data-target="tab-comment">댓글 단 글</button>
    </div>

    <!-- 내가 쓴 글 -->
    <section id="tab-my" class="tab-content active">
        <ul class="post-list">
            <li class="post-item">
                <div class="post-title">PX에 편지지 파나요?</div>
                <div class="post-content-preview">편지 쓰고 싶어요</div>
                <div class="post-meta-line">
                    <span>7</span>
                    <span class="post-meta-dot"></span>
                    <span>9/14</span>
                    <span class="post-meta-dot"></span>
                    <span>일병</span>
                </div>
                <div class="post-footer-line">
                    <div class="icon-wrap">
                        <span class="icon-box">👍</span>
                        <span>7</span>
                    </div>
                    <div class="icon-wrap">
                        <span class="icon-box">💬</span>
                        <span>11</span>
                    </div>
                </div>
            </li>

            <li class="post-item">
                <div class="post-title">휴가 나가고 싶다</div>
                <div class="post-content-preview">언제 나가눙...</div>
                <div class="post-meta-line">
                    <span>2</span>
                    <span class="post-meta-dot"></span>
                    <span>9/5</span>
                    <span class="post-meta-dot"></span>
                    <span>이사단</span>
                </div>
                <div class="post-footer-line">
                    <div class="icon-wrap">
                        <span class="icon-box">👍</span>
                        <span>2</span>
                    </div>
                    <div class="icon-wrap">
                        <span class="icon-box">💬</span>
                        <span>3</span>
                    </div>
                </div>
            </li>
        </ul>
    </section>

    <!-- 좋아요 한 글 -->
    <section id="tab-like" class="tab-content">
        <div class="empty-text">좋아요 한 글이 아직 없습니다.</div>
    </section>

    <!-- 댓글 단 글 -->
    <section id="tab-comment" class="tab-content">
        <div class="empty-text">댓글을 단 글이 아직 없습니다.</div>
    </section>
</div>

<script>
    const tabButtons = document.querySelectorAll(".tab-btn");
    const tabContents = document.querySelectorAll(".tab-content");

    tabButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            const targetId = btn.dataset.target;

            tabButtons.forEach(b => b.classList.remove("active"));
            tabContents.forEach(c => c.classList.remove("active"));

            btn.classList.add("active");
            document.getElementById(targetId).classList.add("active");
        });
    });
</script>

</body>
</html>
