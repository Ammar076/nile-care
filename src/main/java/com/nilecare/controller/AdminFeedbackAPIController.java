package com.nilecare.controller;

import com.nilecare.dto.AdminFeedbackDTO;
import com.nilecare.model.StudentFeedback;
import com.nilecare.service.FeedbackService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/feedback")
@CrossOrigin(origins = "*", maxAge = 3600)
public class AdminFeedbackAPIController {

    private static final Logger logger = LoggerFactory.getLogger(AdminFeedbackAPIController.class);

    @Autowired
    private FeedbackService feedbackService;

    /**
     * GET /api/admin/feedback - Fetch all feedback from all students
     */
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> getAllFeedback(Principal principal) {
        try {
            if (principal == null) {
                logger.warn("Unauthorized access to admin feedback endpoint");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(createErrorResponse("User not authenticated"));
            }

            logger.info("Admin fetching all feedback");
            List<AdminFeedbackDTO> feedbackList = feedbackService.getAllFeedback();
            
            return ResponseEntity.ok(feedbackList);

        } catch (Exception e) {
            logger.error("Error fetching all feedback: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(createErrorResponse("Error loading feedback: " + e.getMessage()));
        }
    }

    /**
     * POST /api/admin/feedback/{id}/reply - Reply to student feedback
     */
    @PostMapping("/{id}/reply")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> replyToFeedback(
            @PathVariable Long id,
            @RequestBody Map<String, String> requestBody,
            Principal principal) {
        try {
            if (principal == null) {
                logger.warn("Unauthorized access to reply feedback endpoint");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(createErrorResponse("User not authenticated"));
            }

            String response = requestBody.get("response");
            
            if (response == null || response.trim().isEmpty()) {
                logger.warn("Empty response from admin for feedback ID: {}", id);
                return ResponseEntity.badRequest()
                    .body(createErrorResponse("Response message is required"));
            }

            logger.info("Admin replying to feedback ID: {}", id);
            StudentFeedback updatedFeedback = feedbackService.replyToFeedback(id, response.trim());
            
            if (updatedFeedback == null) {
                logger.warn("Feedback not found with ID: {}", id);
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(createErrorResponse("Feedback not found"));
            }

            Map<String, Object> successResponse = new HashMap<>();
            successResponse.put("success", true);
            successResponse.put("message", "Reply sent successfully");
            
            return ResponseEntity.ok(successResponse);

        } catch (Exception e) {
            logger.error("Error replying to feedback: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(createErrorResponse("Error sending reply: " + e.getMessage()));
        }
    }

    /**
     * Helper method to create error response
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", message);
        return response;
    }
}
