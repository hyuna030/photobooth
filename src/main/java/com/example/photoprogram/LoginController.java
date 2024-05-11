package com.example.photoprogram;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.ResponseEntity;

import java.util.Map;
import java.util.HashMap;
// 다른 import 구문들...


import java.util.concurrent.ExecutionException;

@Controller
public class LoginController {
	
	@GetMapping("/login")
	public String showLoginPage() {
	    return "login";
	}

	private final RestTemplate restTemplate = new RestTemplate();

	@PostMapping("/login")
	public String login(@RequestParam("phoneNumber") String phoneNumber, Model model, HttpSession session) {
	    Firestore db = FirestoreClient.getFirestore();
	    DocumentSnapshot doc;
	    try {
	        doc = db.collection("results").document(phoneNumber).get().get();
	        if (doc.exists()) {
	            String plantType = doc.getString("result");
	            String existingImageUrl = doc.getString("imageUrl"); // 기존 이미지 URL을 가져옵니다.

	            session.setAttribute("isLoggedIn", true);
	            session.setAttribute("phoneNumber", phoneNumber); // 세션에 전화번호 저장

	            // 이미 이미지 URL이 존재하지 않을 때만 이미지 생성 요청
	            if (existingImageUrl == null || existingImageUrl.isEmpty()) {
	                String nodeJsServerUrl = "http://localhost:3001/generate-image";
	                Map<String, Object> requestBody = new HashMap<>();
	                requestBody.put("result", plantType);
	                requestBody.put("phoneNumber", phoneNumber); // 요청 본문에 전화번호 추가
	                ResponseEntity<String> response = restTemplate.postForEntity(nodeJsServerUrl, requestBody, String.class);
	                existingImageUrl = response.getBody(); // 새로 생성된 이미지 URL
	            } 

	            // 모델에 이미지 URL 추가
	            model.addAttribute("imageUrl", existingImageUrl);
	            return "agree";
	        } else {
	        	model.addAttribute("errorMessage", "등록된 전화번호가 아닙니다.");
                return "index"; // 로그인 페이지로 이동
	        }
	    } catch (InterruptedException | ExecutionException e) {
	        e.printStackTrace();
	        return "error";
	    }
	}
	
	@PostMapping("/processAgreement")
	public String processAgreement(HttpSession session, @RequestParam(required = false) boolean agree) {
	    if (agree) {
	        // 사용자가 동의했다면 처리하는 로직
	        return "redirect:/explain"; // 동의 시 explain.jsp 페이지로 리다이렉트
	    } else {
	        // 동의하지 않았다면 처리하는 로직
	        return "redirect:/login"; // 비동의 시 다시 login 페이지로 리다이렉트
	    }
	}
	
	
	@GetMapping("/explain")
    public String showExplainPage(Model model) {
        // 여기에서 필요한 모델 속성을 추가할 수 있습니다.
        // 예: model.addAttribute("attributeName", value);

        return "explain"; // /WEB-INF/views/explain.jsp로 뷰 리졸빙
    }

    // POST 요청을 처리하며, explain.jsp 페이지 내의 양식 데이터를 제출받습니다.
    @PostMapping("/explain")
    public String processExplainForm(@RequestParam("someParameter") String someParameter, Model model) {
        // 처리 로직 구현
        // 예: model.addAttribute("processedData", someProcessedResult);

        // 처리가 끝난 후, 다른 페이지로 리다이렉트하거나 결과를 보여줄 수 있습니다.
        // return "redirect:/someOtherPage";
        // 혹은 결과를 같은 페이지에 보여주기 위해
        return "explain"; // 데이터 처리 후 explain.jsp로 다시 돌아가기
    }
    
    @GetMapping("/final")
    public String showFinalPage(HttpSession session, Model model) {
        String phoneNumber = (String) session.getAttribute("phoneNumber");
        if (phoneNumber != null) {
            Firestore db = FirestoreClient.getFirestore();
            DocumentSnapshot doc;
            try {
                doc = db.collection("results").document(phoneNumber).get().get();
                if (doc.exists()) {
                    String photoframeURL = doc.getString("photoframeURL"); // 수정된 부분
                    if (photoframeURL != null) {
                        model.addAttribute("photoframeURL", photoframeURL);
                        return "final"; // 추가된 부분
                    } else {
                        System.out.println("photoframeUrl이 null입니다."); // 디버깅을 위한 추가된 부분
                    }
                } else {
                    System.out.println("해당 전화번호에 해당하는 문서가 존재하지 않습니다."); // 디버깅을 위한 추가된 부분
                }
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
                System.out.println("문서를 가져오는 동안 예외가 발생했습니다: " + e.getMessage()); // 디버깅을 위한 추가된 부분
            }
        } else {
            System.out.println("세션에 전화번호가 없습니다."); // 디버깅을 위한 추가된 부분
        }
        return "final";
    }





    // POST 요청을 처리하며, explain.jsp 페이지 내의 양식 데이터를 제출받습니다.
    @PostMapping("/final")
    public String processFinalForm(@RequestParam("someParameter") String someParameter, Model model) {
        // 처리 로직 구현
        // 예: model.addAttribute("processedData", someProcessedResult);

        // 처리가 끝난 후, 다른 페이지로 리다이렉트하거나 결과를 보여줄 수 있습니다.
        // return "redirect:/someOtherPage";
        // 혹은 결과를 같은 페이지에 보여주기 위해
        return "final"; // 데이터 처리 후 explain.jsp로 다시 돌아가기
    }







    
    @GetMapping("/webcam")
    public String webcamForm() {
        return "webcam";
    }

    @PostMapping("/webcam")
    public String saveSnapshot(@RequestParam("photo") MultipartFile photoFile, HttpSession session) {
        // 현재 로그인한 사용자의 정보를 가져오는 코드
        

        // 여기에 추가로직: 파일 이름을 세션 또는 DB에 저장하거나 다른 작업 수행

        return "redirect:/myphotos";
    }
    
    @GetMapping("/select-photos")
    public String selectPhotos() {
        return "select-photos";
    }
    
    @GetMapping("/results")
    public String results(HttpSession session, Model model) {
        String phoneNumber = (String) session.getAttribute("phoneNumber");
        if (phoneNumber != null) {
            Firestore db = FirestoreClient.getFirestore();
            DocumentSnapshot doc;
            try {
                doc = db.collection("results").document(phoneNumber).get().get();
                if (doc.exists()) {
                    String imageUrl = doc.getString("imageUrl");
                    if (imageUrl != null) {
                        // ImageUtil 클래스의 정적 메서드 호출
                        String base64Image = ImageUtil.convertImageToBase64(imageUrl);
                        model.addAttribute("imageBase64", base64Image);
                    }
                }
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }
        return "results";
    }
    
    @GetMapping("/printresult")
    public String printresult(HttpSession session, Model model) {
        String phoneNumber = (String) session.getAttribute("phoneNumber");
        if (phoneNumber != null) {
            Firestore db = FirestoreClient.getFirestore();
            DocumentSnapshot doc;
            try {
                doc = db.collection("results").document(phoneNumber).get().get();
                if (doc.exists()) {
                    String imageUrl = doc.getString("imageUrl");
                    if (imageUrl != null) {
                        // ImageUtil 클래스의 정적 메서드 호출
                        String base64Image = ImageUtil.convertImageToBase64(imageUrl);
                        model.addAttribute("imageBase64", base64Image);
                    }
                }
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }
        return "printresult";
    }

    
    

    @GetMapping("/myphotos")
    public ModelAndView myPhotos(HttpSession session) {
        ModelAndView modelAndView = new ModelAndView("myphotos");
        // 세션 또는 DB에서 현재 로그인한 사용자의 이미지 목록을 가져오는 로직
        return modelAndView;
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
