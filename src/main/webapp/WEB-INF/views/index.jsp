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
<script src="https://cdnjs.cloudflare.com/ajax/libs/webcamjs/1.0.25/webcam.min.js"></script>
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
        justify-content: center;
        align-items: center;
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

    #loginForm {
        margin-top: 20px; /* 폼과 플라워 텍스트 사이 간격 설정 */
        display: flex;
        flex-direction: column;
        align-items: center;
        background-color: white; /* 입력 폼 배경색 */
        border-radius: 30px; /* 입력 폼 둥근 사각형 설정 */
        padding: 50px; /* 입력 폼 안쪽 여백 설정 */
    }

    #phoneNumber {
        margin-bottom: 10px;
        width: 600px; /* 입력 폼 가로 크기 조정 */
        height: 50px;
        border-radius: 30px; /* 입력 폼 둥근 사각형 설정 */
        padding: 10px;
        font-size: 24px; /* 입력 폼 폰트 크기 조정 */
        font-weight: 400;
    }

    input[type="submit"] {
        background-color: #31AC66; /* 로그인 버튼 배경색 */
        color: white;
        border: none;
        border-radius: 30px; /* 로그인 버튼 둥근 사각형 설정 */
        padding: 15px 40px; /* 로그인 버튼 내부 여백 설정 */
        font-size: 24px; /* 로그인 버튼 폰트 크기 조정 */
        width: 650px; /* 입력 폼 가로 크기 조정 */
        font-weight: 800;
        cursor: pointer;
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
        margin-bottom: 10px; /* 작은 텍스트들 사이의 위아래 간격 */
    }

    p.small-text {
        font-size: 28px;
        font-weight: 600;
        margin-bottom: 5px; /* 작은 텍스트들 사이의 위아래 간격 */
    }
    .error-message {
    color: red;
    font-size: 16px;
    text-align: center;
}
#my_camera {
        z-index: -11;
    }
</style>
</head>
<body>

<div class="whitecontainer">
<div id="my_camera" style="width:0.1px; height:0.1px;"></div>
    <div class="content">
        <img src="images/flowe.png" alt="flowe image">
        <div class="content2">
            <p class="big-text">플라위를 재밌게 즐기고 계신가요?</p>
            <p class="small-text">숭실대학교 글로벌미디어학부 졸업전시회에서만 느낄 수 있는</p>
            <p class="small-text">포토부스 이벤트에 참여해보세요!</p>
            <form id="loginForm" action="/login" method="post">
                <input type="text" id="phoneNumber" name="phoneNumber" placeholder="전화번호 입력" required="true" />
                <br>
                <c:if test="${not empty errorMessage}">
                    <p class="error-message">${errorMessage}</p>
                </c:if>
                <br>
                <input type="submit" value="로그인" />
            </form>
        </div>
    </div>
</div>

<!-- 로딩 GIF -->
<img id="loadingGif" src="images/loading.gif" style="display: none; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 9999;" alt="Loading...">

<!-- 자유로운 움직임을 가진 세 개의 원 -->
<div class="circle1" id="circle1"></div>
<div class="circle2" id="circle2"></div>
<div class="circle3" id="circle3"></div>

<script type="text/javascript">

Webcam.set({
    width: 0.1,
    height: 0.1,
    image_format: 'jpeg',
    jpeg_quality: 90
});
Webcam.attach('#my_camera');


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

    document.addEventListener('DOMContentLoaded', function() {
        var loginForm = document.getElementById('loginForm');
        loginForm.addEventListener('submit', function(event) {
            event.preventDefault(); // 폼의 기본 제출 방식을 막습니다.

            // 내용 요소들 숨기기
            document.querySelector('.content img').style.display = 'none';
            document.querySelector('.content2').style.display = 'none';

            // 로딩 GIF 표시
            document.getElementById('loadingGif').style.display = 'block';

            // AJAX 호출을 여기에 넣으시면 됩니다.
            // 예시를 위해 setTimeout을 사용하여 서버 응답을 시뮬레이션 해보겠습니다.
            setTimeout(function() {
                // 서버로부터의 응답을 시뮬레이션합니다.
                loginForm.submit(); // 실제로는 여기서 AJAX 호출을 하게 됩니다.
            }, 2000); // 서버 응답 시간으로 2초 지연을 시뮬레이션합니다.
        });
    });
</script>
</body>
</html>
