<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MILLI ROAD - 대중교통 위치/시간표</title>
    <style>
        /* ========================================= */
        /* 헤더(HEADER) 및 기본 스타일 통일 */
        /* ========================================= */
        body { margin: 0; font-family: Arial, sans-serif; display: flex; flex-direction: column; height: 100vh; }
        header {
            background-color: #78866B; /* 요청하신 색상 코드 적용 */
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-left h1 { margin: 0; font-size: 1.5em; display: flex; align-items: center; gap: 10px; }
        .header-nav a {
            color: white;
            margin: 0 15px; /* 메뉴 간 간격 조정 */
            text-decoration: none;
            font-weight: 500;
        }
        .header-nav a.active {
            text-decoration: underline;
            font-weight: bold;
        }
        .header-nav a:hover { text-decoration: underline; }
        .header-right { display: flex; align-items: center; }
        .header-right span { margin-right: 15px; }
        .logout-button {
            background-color: white;
            color: #78866B; /* 버튼 글자색을 헤더색과 통일 */
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 5px;
            font-weight: bold;
        }

        /* 메인 콘텐츠 레이아웃 */
        .main-content { display: flex; flex: 1; }
        .sidebar {
            width: 350px;
            background-color: #fff;
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            overflow-y: auto;
        }
        .map-area { flex: 1; background-color: #f0f0f0; position: relative; }

        /* 검색 폼 */
        .search-input-group { margin-bottom: 20px; display: flex; }
        .search-input-group input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px 0 0 5px;
            outline: none;
        }
        .search-input-group button {
            width: 40px;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #f8f8f8;
            cursor: pointer;
            border-radius: 0 5px 5px 0;
            border-left: none;
        }
        .desc-text { color: #777; font-size: 0.9em; margin-top: 10px; }

        /* 경로 입력 폼 (State 2) */
        .route-input { display: flex; flex-direction: column; gap: 10px; }
        .route-input-field { position: relative; display: flex; align-items: center; }
        .route-input-field input { border-radius: 5px 0 0 5px; }
        .route-input-field button { border-radius: 0 5px 5px 0; }

        .route-swap-button {
            position: absolute;
            top: 50%;
            left: -10px;
            transform: translate(0, -50%);
            background: #f0f0f0;
            color: #333;
            border: 1px solid #ccc;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            line-height: 28px;
            text-align: center;
            cursor: pointer;
            box-shadow: 0 0 5px rgba(0,0,0,0.2);
            z-index: 10;
            font-weight: bold;
        }

        /* 경로 옵션 버튼 (State 2 & 3) */
        .route-options { display: flex; margin: 15px 0; border: 1px solid #ccc; border-radius: 5px; overflow: hidden; }
        .route-options button {
            flex: 1;
            padding: 10px 5px;
            border: none;
            background-color: white;
            cursor: pointer;
            font-size: 1em;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            border-right: 1px solid #ccc;
        }
        .route-options button:last-child { border-right: none; }
        .route-options button.active { background-color: #8fbc8f; color: white; font-weight: bold; }
        .route-options button:not(.active):hover { background-color: #eee; }

        /* 경로 결과 (State 3) */
        .result-item { border: 1px solid #ccc; margin-bottom: 10px; padding: 15px; border-radius: 5px; cursor: pointer; }
        .result-item.expanded { border-color: #78866B; } /* 통일된 색상 적용 */
        .detail-row { display: flex; justify-content: space-between; font-weight: bold; }
        .sub-details { margin-top: 10px; padding-top: 10px; border-top: 1px dashed #eee; display: none; }
        .result-item.expanded .sub-details { display: block; }

        /* 상태별 UI 관리 */
        .state-1, .state-2, .state-3 { display: none; }

        /* 지도 버튼 */
        .map-location-btn { position: absolute; top: 15px; right: 15px; background: white; border: 1px solid #ccc; border-radius: 50%; width: 40px; height: 40px; line-height: 40px; text-align: center; font-size: 1.2em; cursor: pointer; box-shadow: 0 0 5px rgba(0,0,0,0.2); }
        .map-zoom-controls { position: absolute; bottom: 15px; right: 15px; display: flex; flex-direction: column; gap: 1px; }
        .map-zoom-controls button { width: 30px; height: 30px; background: white; border: 1px solid #ccc; cursor: pointer; font-size: 1.2em; }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
        <a href="/social">소셜</a> |
        <a href="#">건강</a> |
        <a href="/" class="active">지도</a>
    </nav>
    <div class="header-right">
        <span>니인내조 님</span>
        <button class="logout-button">로그아웃</button>
    </div>
</header>

<div class="main-content">
    <div class="sidebar">

        <div id="state-1" class="state-1" style="display: block;">
            <h3>대중교통 위치/시간표 - 첫 화면</h3>
            <div class="search-input-group">
                <input type="text" placeholder="장소, 주소, 정류장 검색">
                <button><i class="fas fa-search"></i></button>
            </div>
            <div class="desc-text">장소, 주소, 정류장을 검색해 주세요.</div>
        </div>

        <div id="state-2" class="state-2">
            <h3>대중교통 위치/시간표 - 출발지/도착지 입력</h3>
            <div class="route-input">
                <div class="route-input-field">
                    <input type="text" id="start-input" placeholder="출발지 (구일역 1호선)" value="구일역 1호선">
                    <button><i class="fas fa-search"></i></button>
                </div>
                <div class="route-swap-button">↓</div>
                <div class="route-input-field">
                    <input type="text" id="end-input" placeholder="도착지 (동양미래대학교 정문)" value="동양미래대학교 정문">
                    <button><i class="fas fa-search"></i></button>
                </div>
            </div>
            <div class="route-options">
                <button id="btn-walk" class="active"><i class="fas fa-walking"></i> 도보</button>
                <button id="btn-bus"><i class="fas fa-bus"></i> 버스</button>
                <button id="btn-subway"><i class="fas fa-subway"></i> 지하철</button>
                <button id="btn-total"><i class="fas fa-plus"></i> 종합</button>
            </div>
            <div id="result-message" style="margin-top: 20px; color: red; display: none;">
                죄송합니다. '구일역 1호선'에서 '동양미래대학교 정문'까지의 버스 경로를 계산할 수 없습니다.
            </div>
        </div>

        <div id="state-3" class="state-3">
            <h3>대중교통 위치/시간표 - 경로 결과</h3>
            <div class="route-input">
            </div>
            <div class="route-options">
            </div>
            <div class="route-result">
                <div style="font-size: 0.9em; margin-bottom: 10px;">오늘 오후 1:11 출발 ▾ (총 3건)</div>

                <div class="result-item expanded" onclick="toggleDetails(this)">
                    <div class="detail-row">
                        <span>최적</span>
                        <span>13분 | 706m | 1,500원</span>
                    </div>
                    <div class="sub-details">
                        <p style="font-size: 0.8em; color: #78866B;">* 도보 2회 | 계단 1회</p>
                        <p>구일역(동양미래대학) 2번 출구에서 87m 이동 후 ...</p>
                    </div>
                </div>

                <div class="result-item" onclick="toggleDetails(this)">
                    <div class="detail-row">
                        <span>큰 길 우선</span>
                        <span>13분 | 706m</span>
                    </div>
                    <div class="sub-details">
                        <p style="font-size: 0.8em; color: #78866B;">* 도보 2회 | 계단 1회</p>
                        <p>구일역(동양미래대학) 2번 출구에서 87m 이동 후 ...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="map-area" id="map">
        <div class="map-location-btn">📍</div>
        <div class="map-zoom-controls">
            <button>+</button>
            <button>-</button>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        updateState(1);
    });

    function updateState(state) {
        document.querySelectorAll('.state-1, .state-2, .state-3').forEach(el => {
            el.style.display = 'none';
        });
        document.getElementById('result-message').style.display = 'none';

        if (state === 1) {
            document.getElementById('state-1').style.display = 'block';
        } else if (state === 2) {
            document.getElementById('state-2').style.display = 'block';
            const routeInputs = document.querySelectorAll('#state-3 .route-input input');
            if (routeInputs.length >= 2) {
                routeInputs[0].value = document.getElementById('start-input').value;
                routeInputs[1].value = document.getElementById('end-input').value;
            }

            document.querySelectorAll('.route-options button').forEach(btn => {
                btn.onclick = () => {
                    document.querySelectorAll('.route-options button').forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');
                    if (btn.id === 'btn-walk' || btn.id === 'btn-total') {
                        updateState(3);
                    } else {
                        document.getElementById('state-2').style.display = 'block';
                        document.getElementById('result-message').style.display = 'block';
                    }
                };
            });
        } else if (state === 3) {
            document.getElementById('state-3').style.display = 'block';
        }
    }

    function toggleDetails(element) {
        element.classList.toggle('expanded');
    }

    document.querySelector('#state-1 button').onclick = () => {
        updateState(2);
    };

    document.querySelector('.route-swap-button').onclick = () => {
        const startInput = document.getElementById('start-input');
        const endInput = document.getElementById('end-input');
        const temp = startInput.value;
        startInput.value = endInput.value;
        endInput.value = temp;
    };

    // 초기 경로 옵션 버튼 이벤트 연결 (State 2)
    document.getElementById('btn-walk').click();
</script>
</body>
</html>