package com.nilecare.controller;

import com.nilecare.model.User;
import com.nilecare.security.CustomUserDetails;
import com.nilecare.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

/**
 * ProfileController handles all user profile-related routing
 * Manages user preferences and settings
 */
@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private UserService userService;

    /**
     * Display user profile page
     * Shows personal details, account settings, and privacy options
     * 
     * @param principal Spring Security Principal containing authenticated user info
     * @param model Spring MVC model
     * @return profile view
     */
    @GetMapping
    public String showProfile(Principal principal, Model model) {
        if (principal != null) {
            String email = principal.getName();
            User user = userService.findByEmail(email);
            if (user != null) {
                model.addAttribute("user", user);
                model.addAttribute("currentUser", user);
            }
        }
        return "profile/profile";
    }

    /**
     * Display user preferences page
     * Allows users to customize general, learning, counseling, and accessibility settings
     * 
     * @param principal Spring Security Principal containing authenticated user info
     * @param model Spring MVC model
     * @return preferences view
     */
    @GetMapping("/preferences")
    public String showPreferences(Principal principal, Model model) {
        if (principal != null) {
            String email = principal.getName();
            User user = userService.findByEmail(email);
            if (user != null) {
                model.addAttribute("user", user);
                model.addAttribute("currentUser", user);
            }
        }
        return "profile/user-preferences";
    }

    /**
     * Update user profile information
     * Updates editable fields: fullName, email, and phoneNumber
     * Smart verification: only resets verified status if email changes
     * 
     * @param user User object with updated fields from the form
     * @param principal Spring Security Principal containing authenticated user info
     * @param redirectAttributes Used to add flash attributes for success/error messages
     * @return redirect to /profile
     */
    @PostMapping("/update")
    public String updateProfile(@ModelAttribute User user, Principal principal, RedirectAttributes redirectAttributes) {
        if (principal != null) {
            String email = principal.getName();
            // Fetch the current user from DB
            User currentUser = userService.findByEmail(email);
            
            if (currentUser != null) {
                // Store current email before update
                String currentEmail = currentUser.getEmail();
                String newEmail = user.getEmail();
                
                // Set the ID on the form-submitted user object (so JPA knows to update, not create)
                user.setUserId(currentUser.getUserId());
                
                // Update name and phone
                currentUser.setFullName(user.getFullName());
                currentUser.setPhoneNumber(user.getPhoneNumber());
                
                // Check if email has changed - if so, reset verified status
                if (!currentEmail.equalsIgnoreCase(newEmail)) {
                    currentUser.setEmail(newEmail);
                    currentUser.setVerified(false);
                    
                    // Save the user to database first
                    userService.updateUser(currentUser);
                    
                    // CRITICAL: Update Spring Security Session to prevent crash
                    // Get current authentication
                    Authentication currentAuth = SecurityContextHolder.getContext().getAuthentication();
                    
                    // Create new UserDetails with the UPDATED user object
                    CustomUserDetails newUserDetails = new CustomUserDetails(currentUser, currentAuth.getAuthorities());
                    
                    // Create new Authentication Token with updated principal
                    UsernamePasswordAuthenticationToken newAuth = new UsernamePasswordAuthenticationToken(
                            newUserDetails, 
                            currentAuth.getCredentials(), 
                            newUserDetails.getAuthorities());
                    
                    // Update the Security Context with new authentication
                    SecurityContextHolder.getContext().setAuthentication(newAuth);
                    
                    redirectAttributes.addFlashAttribute("warning", 
                        "Email updated. Account status reset to 'Pending Approval'. Please wait for admin verification.");
                } else {
                    // Email unchanged - keep existing verified status
                    userService.updateUser(currentUser);
                    redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "User not found.");
            }
        }
        return "redirect:/profile";
    }

    /**
     * Change user password
     * Validates current password and updates to new password
     * 
     * @param currentPassword Current password for verification
     * @param newPassword New password to set
     * @param confirmPassword Confirmation of new password
     * @param principal Spring Security Principal containing authenticated user info
     * @param redirectAttributes Used to add flash attributes for success/error messages
     * @return redirect to /profile
     */
    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            Principal principal,
            RedirectAttributes redirectAttributes) {
        
        if (principal != null) {
            String email = principal.getName();
            User currentUser = userService.findByEmail(email);
            
            if (currentUser != null) {
                // Validation 1: Check if new password is the same as current password
                if (newPassword.equals(currentPassword)) {
                    redirectAttributes.addFlashAttribute("warning", "New password cannot be the same as current password.");
                    return "redirect:/profile";
                }
                
                // Validation 2: Check if new passwords match
                if (!newPassword.equals(confirmPassword)) {
                    redirectAttributes.addFlashAttribute("warning", "New passwords do not match.");
                    return "redirect:/profile";
                }
                
                // Validation 3: Check if current password is correct and change password
                boolean success = userService.changePassword(currentUser, currentPassword, newPassword);
                
                if (!success) {
                    redirectAttributes.addFlashAttribute("warning", "Current password is incorrect.");
                } else {
                    redirectAttributes.addFlashAttribute("success", "Password updated successfully.");
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "User not found.");
            }
        }
        return "redirect:/profile";
    }

    /**
     * Deactivate user account
     * Soft delete - sets enabled to false
     * Logs out the user after deactivation
     * 
     * @param principal Spring Security Principal containing authenticated user info
     * @param redirectAttributes Used to add flash attributes for success/error messages
     * @return redirect to /login?deactivated=true
     */
    @PostMapping("/delete")
    public String deleteAccount(Principal principal, RedirectAttributes redirectAttributes) {
        try {
            if (principal != null) {
                String email = principal.getName();
                userService.deactivateUser(email);
                
                // Clear the security context to log out the user
                org.springframework.security.core.context.SecurityContextHolder.clearContext();
                
                redirectAttributes.addFlashAttribute("message", "Your account has been deactivated.");
                return "redirect:/login?deactivated=true";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deactivating account: " + e.getMessage());
            return "redirect:/profile";
        }
        return "redirect:/login";
    }
}
