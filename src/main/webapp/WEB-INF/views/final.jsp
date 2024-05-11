<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <script src="https://cdn.rawgit.com/davidshimjs/qrcodejs/gh-pages/qrcode.min.js"></script>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #BDECB6;
            overflow: hidden;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .whitecontainer {
            position: absolute;
            width: 60%;
            height: 80%;
            background-color: white;
            border-radius: 30px;
            padding: 20px;
            display: flex;
            justify-content: space-between; /* 좌우 여백을 최대화하여 요소 사이의 공간을 균등 분할 */
            align-items: center;
            z-index: 2;
        }

        .circle1, .circle2, .circle3 {
            position: absolute;
            border-radius: 50%;
            opacity: 0.5;
            z-index: 1;
        }

        .circle1 {
            width: 1000px;
            height: 1000px;
            background-color: #31AC66;
        }

        .circle2 {
            width: 800px;
            height: 800px;
            background-color: #5EC75E;
        }

        .circle3 {
            width: 600px;
            height: 600px;
            background-color: #6DD66D;
        }

        .image-container {
            width: 40%; /* 이미지 컨테이너 너비 설정 */
            height: 100%; /* 이미지 컨테이너 높이 설정 */
        }

        .image-container img {
            max-width: 100%; /* 이미지 최대 너비 설정 */
            height: auto; /* 이미지 높이 자동 조정 */
            display: block; /* 인라인 요소를 블록 요소로 변경하여 가로 정렬 */
            margin: 0 auto; /* 가운데 정렬 */
            margin-top: 40px;
        }
        .vertical-center {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100%; /* 부모 요소의 높이를 100%로 설정하여 세로 가운데 정렬 */
            margin-right: 20px;
        }

        .vertical-center img {
            margin: 10px 0; /* 이미지 간의 위아래 여백 조정 */
        }

        /* 카운트다운 스타일 */
        #countdown {
            position: absolute;
            top: 20px;
            right: 40px;
            font-size: 80px;
            font-weight: bold;
            color: black;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
    </style>
</head>
<body>
<div class="whitecontainer">
<div id="countdown"></div>
    <div class="image-container">
        <img src="${photoframeURL}" alt="Selected Photo">
    </div>
    <div class="vertical-center">
        <div id="qrcode"></div>
        <div>
            <img src="images/text.png" alt="Text Image">
        </div>
        <div>
            <img src="images/logout.png" alt="Logout Image" onclick="logout()">
        </div>
    </div>
</div>
<div class="circle1" id="circle1"></div>
<div class="circle2" id="circle2"></div>
<div class="circle3" id="circle3"></div>

<!-- 카운트다운 엘리먼트 -->
<div id="countdown"></div>

<script>
    // 화면 크기 가져오기
    const screenWidth = window.innerWidth;
    const screenHeight = window.innerHeight;

    // 원 초기 위치 및 이동 속도 설정
    let circle1X = screenWidth / 4;
    let circle1Y = screenHeight / 2;
    let circle1SpeedX = 2;
    let circle1SpeedY = 3;

    let circle2X = screenWidth / 2;
    let circle2Y = screenHeight / 2;
    let circle2SpeedX = -3;
    let circle2SpeedY = 2;

    let circle3X = screenWidth * 3 / 4;
    let circle3Y = screenHeight / 2;
    let circle3SpeedX = 3;
    let circle3SpeedY = -2;

    // 카운트다운 변수 및 엘리먼트 가져오기
    var countdownTime = 30;
    var countdownElement = document.getElementById('countdown');

    // 카운트다운 스타일 설정
    countdownElement.style.position = 'absolute'; // 절대 위치 설정
    countdownElement.style.top = '20px'; // 위쪽 여백 설정
    countdownElement.style.right = '40px'; // 오른쪽 여백 설정
    countdownElement.style.fontSize = '80px'; // 텍스트 크기 설정
    countdownElement.style.fontWeight = 'bold'; // 글꼴 굵기 설정
    countdownElement.style.color = 'black'; // 텍스트 색상 설정
    countdownElement.style.textShadow = '2px 2px 4px rgba(0, 0, 0, 0.5)'; // 텍스트 그림자 설정

    // 카운트다운 함수
    function startCountdown() {
        var countdownInterval = setInterval(function() {
            countdownTime--; // 시간 감소
            countdownElement.textContent = countdownTime ;

            if (countdownTime <= 0) {
                clearInterval(countdownInterval); // 카운트다운 종료
                logout(); // 로그아웃 함수 호출
            }
        }, 1000); // 1초마다 갱신
    }

    // 초기 호출
    startCountdown();
    
    window.onload = function() {
        // photoframeURL 변수에 QR 코드로 변환하고 싶은 URL을 지정합니다.
        var photoframeURL = "${photoframeURL}"; // 서버 사이드 코드로부터 URL을 가져옵니다.
        
        // QRCode 생성자를 사용하여 QR 코드 생성
        new QRCode(document.getElementById("qrcode"), photoframeURL);
    };
    
    function logout() {
        window.location.href = "/logout";
    }
</script>
</body>
</html>
