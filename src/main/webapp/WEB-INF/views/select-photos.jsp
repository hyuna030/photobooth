<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
<meta charset="UTF-8">
    <title>사진 선택</title>
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
        position: absolute;
        top: 20px;
        right: 20px;
    }
        .photo {
            cursor: pointer;
            opacity: 0.6;
            margin: 5px;
        }
        .selected {
            opacity: 1;
            border: 2px solid green;
        }
        .photo-container {
    background-color: rgba(255, 255, 255, 0.8); /* 투명한 흰색 배경 */
    border-radius: 10px; /* 둥근 테두리를 위한 속성 */
    padding: 20px; /* 안쪽 여백 설정 */
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5); /* 그림자 효과 추가 */
    display: flex; /* 사진들을 가로로 정렬하기 위해 Flex 사용 */
    flex-wrap: wrap; /* 사진들이 가로로 넘칠 경우 줄 바꿈 */
    justify-content: center; /* 사진들을 가운데 정렬 */
    align-items: center; /* 사진들을 세로로 가운데 정렬 */
    margin-bottom: 20px; /* 아래 여백 추가 */
    width: 1000px;
}
    </style>
</head>
<body>
<div class="whitecontainer">
    <div id="photoSelections" class="photo-container"></div>
    <div id="countdown" class="big-text" ></div>
    <button onclick="submitSelectedPhotos()" style="background-color: #31AC66; color: white; font-weight: 600; border-radius: 20px; padding: 10px 20px; font-size: 20px; cursor: pointer; border: none;">사진 제출</button>
    </div>
    
    <div class="circle1" id="circle1"></div>
<div class="circle2" id="circle2"></div>
<div class="circle3" id="circle3"></div>

    <script type="text/javascript">
        // 세션 스토리지에서 촬영한 사진 데이터 불러오기
        var takenPhotos = JSON.parse(sessionStorage.getItem('takenPhotos')) || [];
        var selectedPhotos = [];

        // 사진을 화면에 표시
        var photoSelections = document.getElementById('photoSelections');
var row = null;

takenPhotos.forEach(function(photoUri, index) {
    if (index % 3 === 0) {
        row = document.createElement('div'); // 새로운 줄 생성
        row.classList.add('row'); // 새로운 줄에 대한 클래스 추가
        photoSelections.appendChild(row); // 새로운 줄을 부모 요소에 추가
    }

    var img = document.createElement('img');
    img.src = photoUri;
    img.classList.add('photo');
    img.style.width = '240px'; // 이미지를 작게 보이도록 너비를 조정
    img.style.height = '180px'; // 이미지를 작게 보이도록 높이를 조정
    img.style.margin = '15px';
    img.onclick = function() { selectPhoto(this, index); };

    row.appendChild(img); // 이미지를 현재 줄에 추가
});

// 카운트다운 시간
var countdownTime = 60;
var countdownElement = document.getElementById('countdown');
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
            autoSelectPhotos(); // 자동 선택 함수 호출
        }
    }, 1000); // 1초마다 갱신
}

// 자동으로 사진 선택하는 함수
function autoSelectPhotos() {
    var remainingPhotos = takenPhotos.filter(function(_, index) {
        return !selectedPhotos.includes(index);
    });

    var additionalSelections = 4 - selectedPhotos.length;
    for (var i = 0; i < additionalSelections; i++) {
        var index = i % remainingPhotos.length;
        selectedPhotos.push(index);
        var imgElements = document.getElementsByClassName('photo');
        imgElements[index].classList.add('selected');
    }

    submitSelectedPhotos(); // 선택 완료 후 제출
}

// 카운트다운 시작
startCountdown();


        // 사진 선택 함수
        function selectPhoto(imgElement, index) {
            var photoUri = takenPhotos[index];
            if (selectedPhotos.includes(index)) {
                var selectedIdx = selectedPhotos.indexOf(index);
                selectedPhotos.splice(selectedIdx, 1);
                imgElement.classList.remove('selected');
            } else {
                selectedPhotos.push(index);
                imgElement.classList.add('selected');
            }
        }

        // 선택된 사진 제출 함수
        function submitSelectedPhotos() {
            if (selectedPhotos.length === 4) {
                var selectedImages = selectedPhotos.map(index => takenPhotos[index]);
                sessionStorage.setItem('selectedPhotos', JSON.stringify(selectedImages));
                // 결과 페이지로 리디렉션
                window.location.href = '/results';
            } else {
                alert("정확히 4장의 사진을 선택해주세요.");
            }
        }
        
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
