package com.nilecare.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import javax.servlet.http.HttpSession;

@Controller
public class HomeController {

    @GetMapping("/")
    public String root(HttpSession session) {
        // 1. If User is already logged in, skip Home and go to their Dashboard
        if (session.getAttribute("currentUser") != null) {
            return "redirect:/learning";
        }
        
        // 2. If Guest, show the Landing Page
        return "home"; 
    }
}