<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body {
            background-color: #BDECB6;
            overflow: hidden; /* 화면을 넘어가는 요소들을 숨기기 위한 설정 */
            position: relative; /* 원의 위치를 상대적으로 설정하기 위함 */
        }

        .button-container {
            text-align: center;
            margin-top: 150px;
        }

        .button {
            display: inline-block;
            text-decoration: none;
            margin-right: 100px;
            margin-left: 100px;
            margin-bottom: 100px;
            text-align: center;
            font-size: 70px;
            color: white;
            font-weight: bold;
        }

        .button img {
            width: 250px;
            height: 250px;
            vertical-align: middle;
        }

        .button span {
            display: inline-block;
            vertical-align: middle;
        }

        .circle1 {
            position: absolute;
            width: 1000px;
            height: 1000px;
            border-radius: 50%;
            background-color: #31AC66; /* 첫 번째 원의 색상 */
            opacity: 0.5;
        }
        .circle2 {
            position: absolute;
            width: 800px;
            height: 800px;
            border-radius: 50%;
            background-color: #5EC75E; /* 첫 번째 원의 색상 */
            opacity: 0.5;
        }
        .circle3 {
            position: absolute;
            width: 600px;
            height: 600px;
            border-radius: 50%;
            background-color: #6DD66D; /* 첫 번째 원의 색상 */
            opacity: 0.5;
        }
    </style>
</head>
<body>
<div>
    <c:if test="${isLoggedIn}">
        <!-- 로그인 되어 있을 때: 로그아웃과 사진 찍기 버튼만 표시 -->
        <a href="/logout">로그아웃</a>
        <a href="/webcam">사진 찍기</a>
    </c:if>
    <c:if test="${not isLoggedIn}">
        <!-- 로그인 되어 있지 않을 때: 로그인 버튼만 표시 -->
        <a href="/login">로그인</a>
        <!-- 로그인 되어 있지 않을 때도 사진 찍기 버튼 표시 -->
        <a href="/webcam">사진 찍기</a>
    </c:if>
</div>

<form action="/login" method="post">
    <label for="phoneNumber">전화번호:</label>
    <input type="text" id="phoneNumber" name="phoneNumber" required="true" />
    <br><br>
    <input type="submit" value="로그인" />

<!-- 자유로운 움직임을 가진 세 개의 원 -->
<div class="circle1" id="circle1"></div>
<div class="circle2" id="circle2"></div>
<div class="circle3" id="circle3"></div>

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

    function moveCircles() {
        // 화면 테두리에 닿았을 때 반대 방향으로 이동하도록 설정
        if (circle1X <= 0 || circle1X >= screenWidth) {
            circle1SpeedX *= -1;
        }
        if (circle1Y <= 0 || circle1Y >= screenHeight) {
            circle1SpeedY *= -1;
        }
        if (circle2X <= 0 || circle2X >= screenWidth) {
            circle2SpeedX *= -1;
        }
        if (circle2Y <= 0 || circle2Y >= screenHeight) {
            circle2SpeedY *= -1;
        }
        if (circle3X <= 0 || circle3X >= screenWidth) {
            circle3SpeedX *= -1;
        }
        if (circle3Y <= 0 || circle3Y >= screenHeight) {
            circle3SpeedY *= -1;
        }

        // 원의 위치 업데이트
        circle1X += circle1SpeedX;
        circle1Y += circle1SpeedY;
        circle2X += circle2SpeedX;
        circle2Y += circle2SpeedY;
        circle3X += circle3SpeedX;
        circle3Y += circle3SpeedY;

        // 원의 위치 설정
        document.getElementById('circle1').style.left = circle1X + 'px';
        document.getElementById('circle1').style.top = circle1Y + 'px';
        document.getElementById('circle2').style.left = circle2X + 'px';
        document.getElementById('circle2').style.top = circle2Y + 'px';
        document.getElementById('circle3').style.left = circle3X + 'px';
        document.getElementById('circle3').style.top = circle3Y + 'px';

        // 다음 프레임으로 이동
        requestAnimationFrame(moveCircles);
    }

    // 초기 호출
    moveCircles();
</script>
</body>
</html>

