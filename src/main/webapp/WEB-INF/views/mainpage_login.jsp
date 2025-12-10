<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 메인(로그인 후)</title>

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
            width:80px;height:34px;
            background:url('${pageContext.request.contextPath}/img/WebServerLogo2.png')
            left center / contain no-repeat;
        }
        .header-title{font-size:0;}
        .header-nav{
            display:flex;align-items:center;gap:26px;font-size:15px;
        }
        .header-nav a{color:#fff;text-decoration:none;}
        .header-nav a:hover{text-decoration:underline;}
        .header-nav a.active{font-weight:700;text-decoration:underline;}
        .header-right{
            display:flex;align-items:center;gap:16px;font-size:14px;
        }
        .btn-logout{
            padding:6px 16px;border-radius:4px;border:none;
            background:#fff;color:#78866B;font-weight:600;cursor:pointer;
        }

        .top-search-wrap{
            max-width:1200px;
            margin:16px auto 0;
            padding:0 40px;
        }
        .top-search-inner{
            width:100%;height:40px;border-radius:4px;background:#fff;
            border:1px solid #d0d0c8;display:flex;align-items:center;padding:0 12px;
        }
        .top-search-input{
            flex:1;border:none;outline:none;font-size:13px;color:#555;
        }
        .top-search-icon{
            width:18px;height:18px;
            background:url('${pageContext.request.contextPath}/img/search.png')
            center / 14px no-repeat;
        }

        .page-wrap{
            max-width:1200px;
            margin:12px auto 60px;
            padding:0 40px;
            display:grid;
            grid-template-columns:260px minmax(0,1fr) 260px;
            gap:20px;
        }

        /* 왼쪽: 프로필 */
        .profile-card{
            background:#fff;
            border-radius:6px;
            padding:14px 12px 14px;
            border:1px solid #ddd;
            font-size:12px;
        }
        .profile-top{margin-bottom:8px;}
        .profile-top div{line-height:1.4;}
        .profile-top strong{font-weight:700;}

        .bar-wrap{margin-top:4px;}
        .bar-label{margin-bottom:2px;font-size:11px;}
        .bar-bg{
            width:100%;height:6px;background:#eee;
            border-radius:3px;overflow:hidden;
        }
        .bar-fill{
            height:100%;background:#c7a674;
        }
        .profile-dday{
            margin-top:10px;
            font-size:12px;
        }

        /* 가운데: 뉴스 예시 */
        .center-col{
            background:#fff;
            border-radius:6px;
            padding:16px 18px 18px;
        }
        .news-date-title{font-size:18px;font-weight:700;margin-bottom:10px;}
        .news-item{padding:8px 0;border-bottom:1px solid #f0f0f0;font-size:13px;}
        .news-meta{font-size:11px;color:#777;margin-bottom:3px;}
        .news-title{font-weight:700;margin-bottom:3px;}
        .news-snippet{font-size:12px;color:#555;}

        /* 오른쪽: 기타 카드 */
        .right-col{
            display:flex;
            flex-direction:column;
            gap:16px;
        }
        .card{
            background:#fff;
            border-radius:6px;
            padding:10px 12px;
            font-size:12px;
        }
        .card-title{
            font-size:13px;
            font-weight:700;
            margin-bottom:6px;
        }
    </style>
</head>
<body>

<c:set var="info" value="${mainInfo}" />

<header>
    <div class="header-left">
        <div class="header-logo-box"></div>
        <div class="header-title">MILLI ROAD</div>
    </div>
    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/mainpage_login" class="active">뉴스</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/social/board">소셜</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/health">건강</a>
        <span>|</span>
        <a href="${pageContext.request.contextPath}/map">지도</a>
    </nav>
    <div class="header-right">
        <c:choose>
            <c:when test="${info ne null}">
                ${info.nickname} 님
            </c:when>
            <c:otherwise>
                사용자 님
            </c:otherwise>
        </c:choose>
        <button class="btn-logout"
                onclick="location.href='${pageContext.request.contextPath}/login/logout.jsp'">
            로그아웃
        </button>
    </div>
</header>

<div class="top-search-wrap">
    <div class="top-search-inner">
        <input type="text" class="top-search-input" placeholder="검색어를 입력해 주세요">
        <span class="top-search-icon"></span>
    </div>
</div>

<div class="page-wrap">

    <!-- 왼쪽: 프로필 / 전역 정보 -->
    <div class="profile-card">
        <c:choose>
            <c:when test="${info ne null}">
                <div class="profile-top">
                    <div>사단 : ${info.division}</div>
                    <div>부대명 : ${info.unit}</div>
                    <div>이름 : <strong>${info.nickname}</strong></div>
                    <div>계급 : ${info.militaryProgress.nowRank}</div>
                </div>

                <div class="bar-wrap">
                    <div class="bar-label">
                        전역까지 ${info.militaryProgress.dischargeProgress}%
                    </div>
                    <div class="bar-bg">
                        <div class="bar-fill"
                             style="width:${info.militaryProgress.dischargeProgress}%;"></div>
                    </div>
                </div>

                <div class="profile-dday">
                    D - ${info.militaryProgress.daysToDischarge}
                </div>

                <c:if test="${not empty enlistDateStr}">
                    <div style="margin-top:4px;font-size:11px;">
                        입대일 : ${enlistDateStr}
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                메인페이지 API 정보를 불러오지 못했습니다.
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 가운데: 뉴스 예시 -->
    <div class="center-col">
        <div class="news-date-title">9월 28일</div>
        <div class="news-item">
            <div class="news-meta">SBS · 34분 전</div>
            <div class="news-title">
                “우리 애 어떡하죠”…군대인가, 유치원인가? 간부들 한숨
            </div>
            <div class="news-snippet">
                실제로 요즘 초급 간부들은 부대 관련 업무를 하면서 부모들의 민원에
                시달리는 것으로 전해졌습니다...
            </div>
        </div>
    </div>

    <!-- 오른쪽: 맞춤 뉴스 / 날씨 자리 -->
    <div class="right-col">
        <div class="card">
            <div class="card-title">[ 맞춤 뉴스 ]</div>
            <div>사용자 정보 기반 맞춤 뉴스 영역입니다.</div>
        </div>
        <div class="card">
            <div class="card-title">[ 오늘 날씨 ]</div>
            <div>날씨 API 연동 시 이 영역에 날씨 정보를 표시하면 됩니다.</div>
        </div>
    </div>

</div>

</body>
</html>
