package com.nilecare.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping("/dashboard")
    public String dashboard() {
        return "admin/dashboard"; // Looks for views/admin/dashboard.html
    }

    @GetMapping("/users")
    public String manageUsers() {
        return "admin/users";
    }

    @GetMapping("/roles")
    public String setRoles() {
        return "admin/roles";
    }

    @GetMapping("/reports")
    public String reports() {
        // You might want to create views/admin/reports.html later
        return "admin/reports"; 
    }
}