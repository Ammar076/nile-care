package com.nilecare.controller;

import com.nilecare.model.Lesson;
import com.nilecare.model.LearningModule;
import com.nilecare.model.User;
import com.nilecare.service.LearningModuleService;
import com.nilecare.service.LessonService;
import com.nilecare.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    // Trusted email domains whitelist
    private static final List<String> TRUSTED_DOMAINS = Arrays.asList(
            "gmail.com",
            "yahoo.com",
            "outlook.com",
            "hotmail.com",
            "icloud.com",
            "utm.my", // University domain
            "graduate.utm.my", // University graduate domain
            "live.utm.my", // University live domain
            "nilecare.com" // Admin domain
    );

    @Autowired
    private UserService userService;

    @Autowired
    private LearningModuleService learningModuleService;

    @Autowired
    private LessonService lessonService;

    @GetMapping("/dashboard")
    @PreAuthorize("hasRole('ADMIN')")
    public String dashboard(Model model, Principal principal) {
        model.addAttribute("currentPage", "dashboard");
        addCurrentUser(model, principal);

        // Fetch total users
        long totalUsers = userService.countUsers();
        model.addAttribute("userCount", totalUsers);

        // Calculate weekly growth percentage
        LocalDateTime oneWeekAgo = LocalDateTime.now().minusDays(7);
        long lastWeekUsers = userService.countUsersBefore(oneWeekAgo);

        String userGrowth = "+0%";
        double growthPercentage = 0.0;

        if (lastWeekUsers == 0) {
            // If no users existed a week ago
            growthPercentage = totalUsers > 0 ? 100.0 : 0.0;
        } else {
            // Calculate growth: (current - last week) / last week * 100
            growthPercentage = ((double) (totalUsers - lastWeekUsers) / lastWeekUsers) * 100;
        }

        // Format to 0 decimal place with sign
        userGrowth = String.format("%+.0f%%", growthPercentage);
        model.addAttribute("userGrowth", userGrowth);
        model.addAttribute("growthPercentage", growthPercentage);

        // Fetch dashboard stats
        long pendingCount = userService.countPendingVerifications();
        long studentCount = userService.countActiveStudents();
        List<User> recentUsers = userService.getRecentlyRegisteredUsers();

        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("studentCount", studentCount);
        model.addAttribute("recentUsers", recentUsers);

        // Calculate JVM Memory Usage
        Runtime runtime = Runtime.getRuntime();
        long totalMemory = runtime.totalMemory() / (1024 * 1024); // Convert to MB
        long freeMemory = runtime.freeMemory() / (1024 * 1024); // Convert to MB
        long usedMemory = totalMemory - freeMemory;

        // Create formatted memory string
        String systemMemory = usedMemory + " MB / " + totalMemory + " MB";
        boolean isHighLoad = (double) usedMemory / totalMemory > 0.8;

        model.addAttribute("systemMemory", systemMemory);
        model.addAttribute("isHighLoad", isHighLoad);

        return "admin/dashboard";
    }

    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    public String manageUsers(@RequestParam(required = false) String search,
            @RequestParam(required = false) String role,
            Model model,
            Principal principal) {
        model.addAttribute("currentPage", "users");
        addCurrentUser(model, principal);

        // Fetch users with search and filter
        List<User> users = userService.searchUsers(search, role);
        model.addAttribute("users", users);

        // Keep search and filter values in form
        model.addAttribute("currentSearch", search != null ? search : "");
        model.addAttribute("currentRole", role != null ? role : "ALL");

        return "admin/users";
    }

    @PostMapping("/users/add")
    @PreAuthorize("hasRole('ADMIN')")
    public String addUser(@RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("role") String role,
            RedirectAttributes redirectAttributes) {
        try {
            // Validate inputs
            if (fullName == null || fullName.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Full name is required.");
                return "redirect:/admin/users";
            }
            if (email == null || email.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Email is required.");
                return "redirect:/admin/users";
            }
            if (role == null || role.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Role is required.");
                return "redirect:/admin/users";
            }

            // Check if email already exists
            if (userService.emailExists(email)) {
                redirectAttributes.addFlashAttribute("error", "Email already exists.");
                return "redirect:/admin/users";
            }

            // Create new user
            User newUser = new User();
            newUser.setFullName(fullName);
            newUser.setEmail(email);

            userService.createUserByAdmin(newUser, role);

            redirectAttributes.addFlashAttribute("success", "User created successfully.");
            return "redirect:/admin/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error creating user: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    @PostMapping("/users/delete")
    @PreAuthorize("hasRole('ADMIN')")
    public String toggleUserStatus(@RequestParam("userId") Long userId,
            RedirectAttributes redirectAttributes) {
        try {
            if (userId == null || userId <= 0) {
                redirectAttributes.addFlashAttribute("error", "Invalid user ID.");
                return "redirect:/admin/users";
            }

            User user = userService.findById(userId);
            if (user == null) {
                redirectAttributes.addFlashAttribute("error", "User not found.");
                return "redirect:/admin/users";
            }

            // Determine the new status message
            String statusMessage = user.isEnabled() ? "deactivated" : "activated";
            userService.toggleUserStatus(userId);
            redirectAttributes.addFlashAttribute("success", "User " + statusMessage + " successfully.");
            return "redirect:/admin/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating user status: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    @PostMapping("/users/role/update")
    @PreAuthorize("hasRole('ADMIN')")
    public String updateUserRole(@RequestParam("userId") Long userId,
            @RequestParam("role") String role,
            RedirectAttributes redirectAttributes) {
        try {
            if (userId == null || userId <= 0) {
                redirectAttributes.addFlashAttribute("error", "Invalid user ID.");
                return "redirect:/admin/users";
            }
            if (role == null || role.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Role is required.");
                return "redirect:/admin/users";
            }

            // Update user role using service method
            userService.updateUserRole(userId, role);

            redirectAttributes.addFlashAttribute("success", "User role updated successfully.");
            return "redirect:/admin/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating user role: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    @PostMapping("/users/verify")
    @PreAuthorize("hasRole('ADMIN')")
    public String verifyUser(@RequestParam("userId") Long userId,
            RedirectAttributes redirectAttributes) {
        try {
            if (userId == null || userId <= 0) {
                redirectAttributes.addFlashAttribute("error", "Invalid user ID.");
                return "redirect:/admin/users";
            }

            User user = userService.findById(userId);
            if (user == null) {
                redirectAttributes.addFlashAttribute("error", "User not found.");
                return "redirect:/admin/users";
            }

            // Email domain validation - whitelist approach
            String email = user.getEmail().toLowerCase();

            // Check if email has @ symbol
            if (!email.contains("@")) {
                redirectAttributes.addFlashAttribute("error", "Invalid email format.");
                return "redirect:/admin/users";
            }

            // Extract domain from email
            String domain = email.substring(email.lastIndexOf("@") + 1);

            // Check if domain is in trusted list
            if (!TRUSTED_DOMAINS.contains(domain)) {
                redirectAttributes.addFlashAttribute("error",
                        "Cannot verify: Domain '" + domain
                                + "' is not in the trusted list. Please contact user to update their email.");
                return "redirect:/admin/users";
            }

            // Domain is trusted, proceed with verification
            userService.verifyUser(userId);
            redirectAttributes.addFlashAttribute("success", "User verified successfully.");
            return "redirect:/admin/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error verifying user: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }

    @GetMapping("/help-requests")
    @PreAuthorize("hasRole('ADMIN')")
    public String helpRequests(Model model, Principal principal) {
        model.addAttribute("currentPage", "help-requests");
        addCurrentUser(model, principal);
        return "admin/help_requests";
    }

    @GetMapping("/feedback")
    @PreAuthorize("hasRole('ADMIN')")
    public String feedback(Model model, Principal principal) {
        model.addAttribute("currentPage", "feedback");
        addCurrentUser(model, principal);
        return "admin/feedback";
    }

    // Helper method to add current admin user to model
    private void addCurrentUser(Model model, Principal principal) {
        if (principal != null) {
            String email = principal.getName();
            User user = userService.findByEmail(email);
            if (user != null) {
                model.addAttribute("currentUser", user);
            }
        }
    }

    @GetMapping("/modules")
    @PreAuthorize("hasRole('ADMIN')")
    public String manageModules(Model model, Principal principal) {
        model.addAttribute("currentPage", "modules");
        addCurrentUser(model, principal);
        List<LearningModule> modules = learningModuleService.getAllModules();
        model.addAttribute("modules", modules);
        return "admin/modules";
    }

    @PostMapping("/modules/save")
    @PreAuthorize("hasRole('ADMIN')")
    public String saveModule(LearningModule module, RedirectAttributes redirectAttributes) {
        try {
            learningModuleService.saveModule(module);
            redirectAttributes.addFlashAttribute("success", "Module saved successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error saving module: " + e.getMessage());
        }
        return "redirect:/admin/modules";
    }

    @PostMapping("/modules/delete")
    @PreAuthorize("hasRole('ADMIN')")
    public String deleteModule(@RequestParam("moduleId") Long moduleId, RedirectAttributes redirectAttributes) {
        try {
            learningModuleService.deleteModule(moduleId);
            redirectAttributes.addFlashAttribute("success", "Module deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting module: " + e.getMessage());
        }
        return "redirect:/admin/modules";
    }

    @GetMapping("/modules/edit/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String editModulePage(@PathVariable("id") Long id, Model model, Principal principal) {
        model.addAttribute("currentPage", "modules");
        addCurrentUser(model, principal);

        LearningModule module = learningModuleService.getModuleById(id);
        if (module == null) {
            return "redirect:/admin/modules";
        }

        List<Lesson> lessons = lessonService.getLessonsByModuleId(id);
        model.addAttribute("module", module);
        model.addAttribute("lessons", lessons);
        return "admin/module_edit";
    }

    @PostMapping("/lessons/save")
    @PreAuthorize("hasRole('ADMIN')")
    public String saveLesson(Lesson lesson, RedirectAttributes redirectAttributes) {
        try {
            lessonService.saveLesson(lesson);
            redirectAttributes.addFlashAttribute("success", "Lesson saved successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error saving lesson: " + e.getMessage());
        }
        return "redirect:/admin/modules/edit/" + lesson.getModuleId();
    }

    @PostMapping("/lessons/delete")
    @PreAuthorize("hasRole('ADMIN')")
    public String deleteLesson(@RequestParam("lessonId") Long lessonId, @RequestParam("moduleId") Long moduleId,
            RedirectAttributes redirectAttributes) {
        try {
            lessonService.deleteLesson(lessonId);
            redirectAttributes.addFlashAttribute("success", "Lesson deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting lesson: " + e.getMessage());
        }
        return "redirect:/admin/modules/edit/" + moduleId;
    }
}