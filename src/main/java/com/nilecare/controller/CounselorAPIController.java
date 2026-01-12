package com.nilecare.controller;

import com.nilecare.model.CounselorAvailability;
import com.nilecare.model.User;
import com.nilecare.service.CounselorService;
import com.nilecare.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/counselor")
public class CounselorAPIController {

    @Autowired
    private CounselorService counselorService;
    
    @Autowired
    private UserService userService;

    /**
     * Add a new availability slot
     * POST /api/counselor/availability
     * Body: { "startTime": "2026-01-15T10:00", "endTime": "2026-01-15T11:00" }
     */
    @PostMapping("/availability")
    public ResponseEntity<?> addAvailability(@RequestBody Map<String, String> request, Principal principal) {
        try {
            // Get current counselor
            User counselor = userService.findByEmail(principal.getName());
            if (counselor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "User not found"));
            }

            // Parse date-time strings
            String startTimeStr = request.get("startTime");
            String endTimeStr = request.get("endTime");
            
            if (startTimeStr == null || endTimeStr == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Start time and end time are required"));
            }

            LocalDateTime startTime = LocalDateTime.parse(startTimeStr);
            LocalDateTime endTime = LocalDateTime.parse(endTimeStr);

            // Add availability
            CounselorAvailability slot = counselorService.addAvailability(counselor.getUserId(), startTime, endTime);

            // Return success response
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Availability slot added successfully");
            response.put("slot", convertToResponse(slot));

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Get all future availability slots for the current counselor
     * GET /api/counselor/availability
     */
    @GetMapping("/availability")
    public ResponseEntity<?> getAvailability(Principal principal) {
        try {
            // Get current counselor
            User counselor = userService.findByEmail(principal.getName());
            if (counselor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "User not found"));
            }

            // Get future availability
            List<CounselorAvailability> slots = counselorService.getFutureAvailability(counselor.getUserId());

            // Convert to response format
            List<Map<String, Object>> response = slots.stream()
                    .map(this::convertToResponse)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Delete an availability slot
     * DELETE /api/counselor/availability/{id}
     */
    @DeleteMapping("/availability/{id}")
    public ResponseEntity<?> deleteAvailability(@PathVariable Long id, Principal principal) {
        try {
            // Get current counselor
            User counselor = userService.findByEmail(principal.getName());
            if (counselor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "User not found"));
            }

            // Delete availability
            counselorService.deleteAvailability(id, counselor.getUserId());

            return ResponseEntity.ok(Map.of("success", true, "message", "Availability slot deleted successfully"));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Convert CounselorAvailability entity to response format
     */
    private Map<String, Object> convertToResponse(CounselorAvailability slot) {
        Map<String, Object> response = new HashMap<>();
        response.put("slotId", slot.getSlotId());
        response.put("date", slot.getStartTime().toLocalDate().toString());
        response.put("startTime", slot.getStartTime().toLocalTime().toString());
        response.put("endTime", slot.getEndTime().toLocalTime().toString());
        response.put("isBooked", slot.isBooked());
        
        // Format for display
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a");
        
        response.put("dateFormatted", slot.getStartTime().toLocalDate().format(dateFormatter));
        response.put("startTimeFormatted", slot.getStartTime().toLocalTime().format(timeFormatter));
        response.put("endTimeFormatted", slot.getEndTime().toLocalTime().format(timeFormatter));
        
        return response;
    }

    // ==========================================
    // APPOINTMENT MANAGEMENT ENDPOINTS
    // ==========================================

    /**
     * Get all appointments for the current counselor
     * GET /api/counselor/appointments
     */
    @GetMapping("/appointments")
    public ResponseEntity<?> getAppointments(Principal principal) {
        try {
            User counselor = userService.findByEmail(principal.getName());
            if (counselor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "User not found"));
            }

            return ResponseEntity.ok(counselorService.getMyAppointments(counselor.getUserId()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Add meeting link to an appointment
     * PUT /api/counselor/appointments/{id}/link
     */
    @PutMapping("/appointments/{id}/link")
    public ResponseEntity<?> addMeetingLink(@PathVariable Long id, @RequestBody Map<String, String> request, Principal principal) {
        try {
            User counselor = userService.findByEmail(principal.getName());
            if (counselor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "User not found"));
            }

            String link = request.get("meetingLink");
            if (link == null || link.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Meeting link is required"));
            }

            counselorService.addMeetingLink(id, counselor.getUserId(), link.trim());

            return ResponseEntity.ok(Map.of("success", true, "message", "Meeting link added successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Approve a cancellation request
     * PUT /api/counselor/appointments/{id}/approve-cancel
     */
    @PutMapping("/appointments/{id}/approve-cancel")
    public ResponseEntity<?> approveCancellation(@PathVariable Long id, Principal principal) {
        try {
            User counselor = userService.findByEmail(principal.getName());
            if (counselor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "User not found"));
            }

            counselorService.approveCancellation(id, counselor.getUserId());

            return ResponseEntity.ok(Map.of("success", true, "message", "Cancellation approved. The slot is now available for rebooking."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Deny a cancellation request
     * PUT /api/counselor/appointments/{id}/deny-cancel
     */
    @PutMapping("/appointments/{id}/deny-cancel")
    public ResponseEntity<?> denyCancellation(@PathVariable Long id, Principal principal) {
        try {
            User counselor = userService.findByEmail(principal.getName());
            if (counselor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "User not found"));
            }

            counselorService.denyCancellation(id, counselor.getUserId());

            return ResponseEntity.ok(Map.of("success", true, "message", "Cancellation denied. The appointment remains confirmed."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /**
     * Mark session as completed
     * PUT /api/counselor/appointments/{id}/complete
     */
    @PutMapping("/appointments/{id}/complete")
    public ResponseEntity<?> completeSession(@PathVariable Long id, @RequestBody Map<String, String> request, Principal principal) {
        try {
            User counselor = userService.findByEmail(principal.getName());
            if (counselor == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "User not found"));
            }

            String notes = request.get("notes");
            counselorService.completeSession(id, counselor.getUserId(), notes);

            return ResponseEntity.ok(Map.of("success", true, "message", "Session marked as completed."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
}
