package com.example.photoprogram;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class MainController {

    @GetMapping("/")
    public String index(Model model, HttpSession session) {
        if (session.getAttribute("phoneNumber") != null) {
            String phoneNumber = (String) session.getAttribute("phoneNumber");
            model.addAttribute("isLoggedIn", true);
            model.addAttribute("phoneNumber", phoneNumber);
        } else {
            model.addAttribute("isLoggedIn", false);
        }
        return "index";
    }
}