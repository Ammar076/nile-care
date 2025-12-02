package com.nilecare.controller;

import com.nilecare.model.User;
import com.nilecare.model.Role;
import com.nilecare.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    // --- LOGIN ---
    @GetMapping("/login")
    public String loginPage() {
        return "auth/auth"; // CHANGED: Points to auth.html
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email, 
                              @RequestParam String password, 
                              HttpSession session, 
                              Model model) {
        
        User user = userService.loginUser(email, password);
        
        if (user != null) {
            session.setAttribute("currentUser", user);
            
            if (user.getRoles().stream().anyMatch(r -> r.getName() == Role.RoleType.ROLE_ADMIN)) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/learning";
            }
        } else {
            model.addAttribute("error", "Invalid email or password");
            return "auth/auth"; // CHANGED: Return to auth.html on error
        }
    }

    // --- REGISTER ---
    // In AuthController.java

    @GetMapping("/register")
    public String registerPage() {
        // Instead of returning "auth/register", we return login with a flag
        return "redirect:/login?view=register";
    }

    @PostMapping("/register")
    public String handleRegister(@RequestParam String fullName, 
                                 @RequestParam String email, 
                                 @RequestParam String password, 
                                 @RequestParam String role,
                                 Model model) {
        
        if (userService.emailExists(email)) {
            model.addAttribute("error", "Email already registered!");
            // CRITICAL CHANGE: Return the unified auth page, NOT "auth/register"
            return "auth/auth"; 
        }

        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        
        Role.RoleType roleType = role.equals("ADMIN") ? Role.RoleType.ROLE_ADMIN : Role.RoleType.ROLE_STUDENT;
        
        userService.registerUser(newUser, password, roleType);
        
        return "redirect:/login?registered=true";
    }

    // --- LOGOUT ---
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // Kill session
        return "redirect:/login";
    }
}