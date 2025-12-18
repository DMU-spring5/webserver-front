<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부대 별 평가 - 평가하기</title>

    <style>
        * { box-sizing:border-box; margin:0; padding:0; }

        body {
            font-family:"Noto Sans KR",-apple-system,BlinkMacSystemFont,
            "Segoe UI",system-ui,sans-serif;
            background:#f5f5f5;
            color:#333;
        }

        /* ===== 공통 헤더 ===== */
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

        /* ===== 페이지 레이아웃 ===== */
        .page-wrap{
            max-width:1100px;
            margin:40px auto 80px;
            padding:0 40px;
        }

        .path{
            font-size:14px;
            margin-bottom:18px;
        }
        .path strong{
            font-weight:700;
            margin-right:6px;
        }
        .path a{
            margin-left:6px;
            color:#b3b3b3;
            text-decoration:none;
        }
        .path a:hover{
            text-decoration:underline;
        }

        .unit-title{
            text-align:center;
            font-size:22px;
            font-weight:700;
            margin:8px 0 26px;
        }

        .content-box{
            background:#fff;
            border-radius:4px;
            border:1px solid #d7d7cf;
            padding:30px 32px 26px;
            display:grid;
            grid-template-columns:240px 1fr;
            gap:0;
        }

        /* ===== 왼쪽 : 엠블럼 + 별점 ===== */
        .left-panel{
            border-right:1px solid #d7d7cf;
            padding-right:26px;
            display:flex;
            flex-direction:column;
            align-items:center;
        }

        .emblem{
            width:150px;
            height:190px;
            background:#1f57c8;
            border-radius:12px;
            display:flex;
            align-items:center;
            justify-content:center;
            margin-bottom:26px;
        }
        .emblem-inner{
            width:120px;
            height:160px;
            border-radius:10px;
            background:#fff url('${pageContext.request.contextPath}/img/army.png')
            center / 80% no-repeat;
        }

        .star-row{
            margin-top:16px;
            display:flex;
            gap:4px;
            font-size:28px;
            cursor:pointer;
        }
        .star{
            color:#d0d0d0;
        }
        .star.on{
            color:#f5c24f;
        }
        .rating-text{
            margin-top:8px;
            font-size:13px;
            color:#777;
        }

        /* ===== 오른쪽 : 평가 내용 ===== */
        .right-panel{
            padding-left:26px;
        }
        table.eval{
            width:100%;
            border-collapse:collapse;
            font-size:14px;
        }
        table.eval th,
        table.eval td{
            border:1px solid #d7d7cf;
            padding:10px 14px;
        }
        table.eval th{
            width:110px;
            background:#f1f0e6;
            text-align:left;
        }
        table.eval td input,
        table.eval td textarea{
            width:100%;
            border:none;
            outline:none;
            font-family:inherit;
            font-size:14px;
            background:transparent;
        }
        table.eval td textarea{
            resize:none;
            height:70px;
        }

        .btn-row{
            margin-top:26px;
            display:flex;
            justify-content:flex-end;
            gap:10px;
        }
        .btn{
            min-width:90px;
            padding:8px 18px;
            border-radius:4px;
            border:none;
            font-size:14px;
            cursor:pointer;
        }
        .btn-cancel{
            background:#e0e0e0;
        }
        .btn-submit{
            background:#cdb897;
            color:#fff;
        }
    </style>

    <script>
        function setStars(n) {
            const stars = document.querySelectorAll('.star');
            stars.forEach((s, i) => {
                if (i < n) s.classList.add('on');
                else       s.classList.remove('on');
            });
            document.getElementById('rating').value = n;

            const msg = ['', '별로예요.', '그럭저럭이에요.', '보통이에요.', '좋아요.', '최고예요!'];
            document.getElementById('ratingText').innerText = msg[n] || '';
        }

        function goBack() {
            history.back();
        }
    </script>
</head>
<body onload="setStars(0);">

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

    <div class="path">
        <strong>부대 별 평가</strong>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social/board">소셜 커뮤니티</a>
    </div>

    <div class="unit-title">
        ${param.unitName}
    </div>

    <!-- 작성 폼 : 올리기 누르면 /social_unit_list 로 돌아가게 (필요하면 바꿔 사용) -->
    <form action="${pageContext.request.contextPath}/social_unit_list" method="post">

        <input type="hidden" name="unitName" value="${param.unitName}">
        <input type="hidden" id="rating" name="rating" value="0">

        <div class="content-box">

            <!-- 왼쪽 -->
            <div class="left-panel">
                <div class="emblem">
                    <div class="emblem-inner"></div>
                </div>

                <div class="star-row">
                    <span class="star" onclick="setStars(1)">★</span>
                    <span class="star" onclick="setStars(2)">★</span>
                    <span class="star" onclick="setStars(3)">★</span>
                    <span class="star" onclick="setStars(4)">★</span>
                    <span class="star" onclick="setStars(5)">★</span>
                </div>
                <div id="ratingText" class="rating-text"></div>
            </div>

            <!-- 오른쪽 -->
            <div class="right-panel">
                <table class="eval">
                    <tbody>
                    <tr>
                        <th>업무 강도</th>
                        <td>
                            <input type="text" name="workLevel"
                                   placeholder="힘든 정도를 간략히 입력하세요.">
                        </td>
                    </tr>
                    <tr>
                        <th>하는 업무</th>
                        <td>
                            <input type="text" name="workContent"
                                   placeholder="주요 업무 내용을 간략히 입력하세요.">
                        </td>
                    </tr>
                    <tr>
                        <th>장점</th>
                        <td>
                            <textarea name="advantage"
                                      placeholder="이 부대나 보직의 좋은 점을 작성해 주세요."></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>단점</th>
                        <td>
                            <textarea name="disadvantage"
                                      placeholder="개선이 필요한 부분이나 어려움을 적어주세요."></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>바라는 점</th>
                        <td>
                            <textarea name="hope"
                                      placeholder="앞으로 개선되었으면 하는 점이나 건의사항을 작성해 주세요."></textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

        </div>

        <div class="btn-row">
            <button type="button" class="btn btn-cancel" onclick="goBack()">취소</button>
            <button type="submit" class="btn btn-submit">올리기</button>
        </div>

    </form>

</div>

</body>
</html>