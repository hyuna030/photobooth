<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>선택된 사진 결과</title>
    <style>
    #overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: white;
            z-index: 100; /* 확실히 모든 것 위에 있도록 */
        }
        #fullscreenGif {
            position: fixed; /* 전체 화면을 덮도록 고정 위치 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url("images/nocolorloading.gif") no-repeat center center; /* GIF 파일 경로 */
            background-size: cover; /* 전체 화면을 꽉 채우도록 */
            z-index: 101; /* 다른 모든 요소보다 높은 z-index */
        }
        #photoFrameContainer {
            position: relative;
            width: 600px;
            height: 900px;
            display: flex;
            justify-content: center; /* 수평 정렬 */
            align-items: center; /* 수직 정렬 */
        }
        #photoFrame {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: 5; /* 프레임이 사진 위에 오도록 z-index 설정 */
        }
        .backgroundContainer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex; /* flex 컨테이너 설정 */
            justify-content: space-between; /* 가로 간격을 동일하게 설정 */
        }
        .backgroundImage {
            width: 50%; /* 각 이미지가 전체 너비의 절반을 차지하도록 설정 */
            height: 100%;
            background-size: cover; /* 배경 이미지가 div 크기에 맞게 조정되도록 설정 */
            background-position: center; /* 배경 이미지 중앙 정렬 */
            z-index: 1;
        }
        .selectedPhoto {
            position: absolute;
            width: 260px;
            height: 190px;
            z-index: 10; /* 사진이 프레임 뒤에 오도록 z-index 설정 */
            object-fit: cover;
        }
        .photo1 { top: 20px; left: 17px; }
        .photo2 { top: 223px; left: 17px; }
        .photo3 { top: 426px; left: 17px; }
        .photo4 { top: 628px; left: 17px; }

        /* 복제된 사진의 위치 조정 */
        .photo1-duplicate { top: 20px; right: 16px; /* 오른쪽으로 30px 이동 */}
        .photo2-duplicate { top: 223px; right: 16px; }
        .photo3-duplicate { top: 426px; right: 16px; }
        .photo4-duplicate { top: 628px; right: 16px; }
    </style>
</head>
<body>
<div id="overlay"></div>
<div id="fullscreenGif"></div>
    <div id="photoFrameContainer">
    <c:if test="${not empty imageBase64}">
        <!-- 같은 이미지를 사용하여 두 개의 div 생성 -->
        <div class="backgroundContainer">
            <div class="backgroundImage" style="background-image: url('${imageBase64}');"></div>
            <div class="backgroundImage" style="background-image: url('${imageBase64}');"></div>
        </div>
    </c:if>
        <img id="photoFrame" src="/images/photoframe_final.png" alt="Photo Frame">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.5.0-beta4/html2canvas.min.js"></script>
        <script type="text/javascript">
        window.onload = function() {
            var selectedPhotos = JSON.parse(sessionStorage.getItem('selectedPhotos')) || [];
            var loadedImages = 0; // 로드된 이미지 수를 추적하기 위한 변수

            selectedPhotos.forEach(function(photoUri, index) {
                var img = new Image();
                img.onload = function() {
                    var canvas = document.createElement('canvas');
                    var ctx = canvas.getContext('2d');
                    canvas.width = this.width - 140;
                    canvas.height = this.height;
                    ctx.drawImage(this, 70, 0, this.width - 140, this.height, 0, 0, canvas.width, canvas.height);
                    var newImg = document.createElement('img');
                    newImg.src = canvas.toDataURL();
                    newImg.className = 'selectedPhoto photo' + (index + 1);
                    document.getElementById('photoFrameContainer').appendChild(newImg);

                    var duplicateImg = newImg.cloneNode(true);
                    duplicateImg.className = 'selectedPhoto photo' + (index + 1) + '-duplicate';
                    document.getElementById('photoFrameContainer').appendChild(duplicateImg);

                    loadedImages++; // 이미지가 로드될 때마다 카운트 증가

                    // 모든 이미지가 로드되면 html2canvas 실행
                    if (loadedImages === selectedPhotos.length) {
                        setTimeout(() => {
                            html2canvas(document.getElementById("photoFrameContainer")).then(function(canvas) {
                                var imgData = canvas.toDataURL('image/png');
                                var xhr = new XMLHttpRequest();
                                xhr.open('POST', '/saveImageAndURL', true); // 수정된 엔드포인트
                                xhr.setRequestHeader('Content-Type', 'application/json');
                                xhr.send(JSON.stringify({
                                    imageData: imgData,
                                    phoneNumber: sessionStorage.getItem('phoneNumber') // 예시로 sessionStorage 사용; 실제 구현에 맞게 조정 필요
                                }));
                                xhr.onload = function() {
                                    if (xhr.status === 200) {
                                        // 요청이 성공적으로 완료되면, final.jsp 페이지로 리디렉션
                                        window.location.href = 'printresult';
                                    } else {
                                        // 요청 실패 처리
                                        console.error("Failed to save image and URL.");
                                    }
                                };
                            });
                        }, 1000); // setTimeout을 사용해 모든 이미지 로드를 기다림
                    }
                };
                img.src = photoUri;
            });
        };
        </script>
    </div>
</body>
</html>