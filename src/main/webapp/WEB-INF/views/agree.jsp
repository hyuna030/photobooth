<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #BDECB6;
        overflow: hidden; /* 화면을 넘어가는 요소들을 숨기기 위한 설정 */
        position: relative; /* 원의 위치를 상대적으로 설정하기 위함 */
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
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

    .whitecontainer {
        position: absolute;
        width: 90%; /* 화면의 가로 60% 차지 */
        height: 80%; /* 화면의 세로 60% 차지 */
        background-color: white; /* 하얀색 배경 */
        border-radius: 30px; /* 둥근 사각형을 위한 border-radius */
        padding: 20px; /* 안쪽 여백 설정 */
        display: flex;
        flex-direction: column; /* 세로 정렬 */
        justify-content: center; /* 세로 가운데 정렬 */
        align-items: center; /* 가로 가운데 정렬 */
        z-index: 2; /* 원보다 위에 위치하도록 설정 */
    }

    .content {
        display: flex;
        flex-grow: 1;
        width: 70%; /* 오른쪽 70%를 차지 */
    }

    .content img {
        width: 25%; /* 왼쪽 30%를 차지 */
        margin-right: 5%; /* 이미지와 텍스트 사이 간격 */
        margin-left: 12%;
    }

    .content2 {
        flex-grow: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-right: 5%;
    }

    .circle1 {
        position: absolute;
        width: 1000px;
        height: 1000px;
        border-radius: 50%;
        background-color: #31AC66; /* 첫 번째 원의 색상 */
        opacity: 0.5;
        z-index: 1; /* 흰색 컨테이너 아래에 위치하도록 설정 */
    }
    .circle2 {
        position: absolute;
        width: 800px;
        height: 800px;
        border-radius: 50%;
        background-color: #5EC75E; /* 두 번째 원의 색상 */
        opacity: 0.5;
        z-index: 1; /* 흰색 컨테이너 아래에 위치하도록 설정 */
    }
    .circle3 {
        position: absolute;
        width: 600px;
        height: 600px;
        border-radius: 50%;
        background-color: #6DD66D; /* 세 번째 원의 색상 */
        opacity: 0.5;
        z-index: 1; /* 흰색 컨테이너 아래에 위치하도록 설정 */
    }

    /* 추가된 스타일 */
    p.big-text {
        font-size: 40px;
        font-weight: 900;
        margin-bottom: 30px; /* 작은 텍스트들 사이의 위아래 간격 */
    }

    .consent-container {
        margin-top: 20px; /* 개인정보 수집 동의와 아래 요소들 사이의 간격 설정 */
        display: flex;
        flex-direction: column;
        align-items: center;
        background-color: white; /* 입력 폼 배경색 */
        border-radius: 30px; /* 입력 폼 둥근 사각형 설정 */
        padding: 20px; /* 입력 폼 안쪽 여백 설정 */
    }

    #agreeButton {
        margin-top: 10px; /* 체크 버튼과 텍스트 사이 간격 설정 */
    }

</style>
</head>
<body>

<div class="whitecontainer">
    <form id="agreeForm" action="/processAgreement" method="post">
        <div class="consent-container">
            <p class="big-text">개인정보 수집 동의</p>
            <img src="images/agree.png" alt="Agree Image">
            <div>
                <input type="checkbox" id="agreeCheckbox" name="agree">
                <label for="agreeCheckbox">동의합니다</label>
            </div>
        </div>
    </form>
</div>

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
    
    
    document.getElementById('agreeCheckbox').addEventListener('change', function() {
        if (this.checked) {
            document.getElementById('agreeForm').submit(); // 체크박스 선택 시 폼 제출
        }
    });
</script>
</body>
</html>
