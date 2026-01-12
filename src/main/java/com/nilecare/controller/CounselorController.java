package com.nilecare.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Counselor View Controller
 * Handles view rendering for counselor-specific pages
 */
@Controller
@RequestMapping("/counselor")
public class CounselorController {

    /**
     * Counselor Dashboard - Shows Appointments Management (Upcoming/Pending/Completed)
     * GET /counselor/dashboard
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        return "counselor/dashboard";
    }

    /**
     * Counselor Availability - Shows Slot Manager (Add/Delete availability slots)
     * GET /counselor/availability
     */
    @GetMapping("/availability")
    public String availability(Model model) {
        return "counselor/availability";
    }
}
