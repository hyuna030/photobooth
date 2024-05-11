package com.example.photoprogram;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import com.google.firebase.cloud.StorageClient;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.List;
import java.util.Map;
import java.util.Base64;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.ByteArrayInputStream;
import java.io.IOException;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import com.google.firebase.cloud.StorageClient;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.Map;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import java.util.HashMap;

@RestController
public class ImageController {
	
	

    @PostMapping("/submit-images")
    public ResponseEntity<?> submitImages(@RequestBody List<String> imageURIs) {
        for (String uri : imageURIs) {
            try {
                byte[] imageBytes = Base64.getDecoder().decode(uri.split(",")[1]);
                BufferedImage image = ImageIO.read(new ByteArrayInputStream(imageBytes));
                // 여기에서 BufferedImage 객체를 사용하여 이미지 처리
                // 예: 이미지 저장, 필터 적용 등

            } catch (IOException e) {
                e.printStackTrace();
                return ResponseEntity.internalServerError().body("이미지 처리 중 오류 발생");
            }
        }

        return ResponseEntity.ok("이미지가 성공적으로 처리되었습니다.");
    }
    
 // ImageController에서 이미지를 저장하는 메서드 예시
    @PostMapping("/saveImageAndURL")
    public ResponseEntity<String> saveImageAndURL(@RequestBody Map<String, String> imageData, HttpServletRequest request) {
        try {
            String base64Image = imageData.get("imageData").split(",")[1];
            byte[] imageBytes = Base64.getDecoder().decode(base64Image);

            // 세션에서 전화번호 가져오기
            HttpSession session = request.getSession();
            String phoneNumber = (String) session.getAttribute("phoneNumber");

            // 전화번호가 null이 아닌지 확인
            if (phoneNumber == null) {
                return new ResponseEntity<>("전화번호를 찾을 수 없습니다.", HttpStatus.BAD_REQUEST);
            }

            String fileName = "photoframe/" + phoneNumber + ".png"; // 프레임 이미지 파일 이름

            // 이미지 프레임에 저장
            ByteArrayInputStream inputStream = new ByteArrayInputStream(imageBytes);
            StorageClient.getInstance().bucket().create(fileName, inputStream, "image/png");

            // 프레임 이미지 URL
            String photoframeURL = "https://storage.cloud.google.com/" + StorageClient.getInstance().bucket().getName() + "/" + fileName;

            // Firestore에 URL 저장
            Firestore db = FirestoreClient.getFirestore();
            Map<String, Object> data = new HashMap<>();
            data.put("photoframeURL", photoframeURL);
            db.collection("results").document(phoneNumber).update(data);

            return new ResponseEntity<>("프레임 이미지가 성공적으로 저장되었습니다.", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("프레임 이미지 저장 중 오류 발생", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @PostMapping("/saveprintImageAndURL")
    public ResponseEntity<String> saveprintImageAndURL(@RequestBody Map<String, String> imageData, HttpServletRequest request) {
        try {
            String base64Image = imageData.get("imageData").split(",")[1];
            byte[] imageBytes = Base64.getDecoder().decode(base64Image);

            // 세션에서 전화번호 가져오기
            HttpSession session = request.getSession();
            String phoneNumber = (String) session.getAttribute("phoneNumber");

            // 전화번호가 null이 아닌지 확인
            if (phoneNumber == null) {
                return new ResponseEntity<>("전화번호를 찾을 수 없습니다.", HttpStatus.BAD_REQUEST);
            }

            String fileName = "photoframeprint/" + phoneNumber + ".png"; // 프레임 이미지 파일 이름

            // 이미지 프레임에 저장
            ByteArrayInputStream inputStream = new ByteArrayInputStream(imageBytes);
            StorageClient.getInstance().bucket().create(fileName, inputStream, "image/png");

            // 프레임 이미지 URL
            String photoframeURL = "https://storage.cloud.google.com/" + StorageClient.getInstance().bucket().getName() + "/" + fileName;

            // Firestore에 URL 저장
            Firestore db = FirestoreClient.getFirestore();
            Map<String, Object> data = new HashMap<>();
            data.put("photoframeprintURL", photoframeURL);
            db.collection("results").document(phoneNumber).update(data);

            return new ResponseEntity<>("프레임 이미지가 성공적으로 저장되었습니다.", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("프레임 이미지 저장 중 오류 발생", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


}