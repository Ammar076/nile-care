package com.nilecare.controller;

import com.nilecare.dto.AvailabilitySlotDTO;
import com.nilecare.dto.StudentCounselorDTO;
import com.nilecare.model.CounselorAvailability;
import com.nilecare.model.Role;
import com.nilecare.model.User;
import com.nilecare.repository.CounselorAvailabilityRepository;
import com.nilecare.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/student")
public class StudentBookingAPIController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CounselorAvailabilityRepository availabilityRepository;

    /**
     * GET /api/student/counselors
     * Returns all users with ROLE_COUNSELOR
     * Maps them to StudentCounselorDTO with default title and specialties
     */
    @GetMapping("/counselors")
    public ResponseEntity<List<StudentCounselorDTO>> getAllCounselors() {
        // Find all users
        List<User> allUsers = userRepository.findAll();
        
        // Filter for counselors
        List<StudentCounselorDTO> counselors = allUsers.stream()
            .filter(user -> user.getRoles().stream()
                .anyMatch(role -> role.getName() == Role.RoleType.ROLE_COUNSELOR))
            .map(user -> {
                // Generate avatar URL using UI Avatars
                String encodedName = URLEncoder.encode(user.getFullName(), StandardCharsets.UTF_8);
                String avatarUrl = "https://ui-avatars.com/api/?name=" + encodedName + 
                                   "&background=3b82f6&color=fff&size=80";
                
                // Default values for missing fields
                String title = "NileCare Counselor";
                List<String> specialties = Arrays.asList("General Support", "Academic Stress");
                
                return new StudentCounselorDTO(
                    user.getUserId(),
                    user.getFullName(),
                    title,
                    specialties,
                    avatarUrl
                );
            })
            .collect(Collectors.toList());
        
        return ResponseEntity.ok(counselors);
    }

    /**
     * GET /api/student/counselors/{id}/availability
     * Returns all open (unbooked) future availability slots for a specific counselor
     */
    @GetMapping("/counselors/{id}/availability")
    public ResponseEntity<List<AvailabilitySlotDTO>> getCounselorAvailability(@PathVariable Long id) {
        LocalDateTime now = LocalDateTime.now();
        
        // Get all future availability slots for this counselor
        List<CounselorAvailability> slots = availabilityRepository
            .findFutureAvailabilityByCounselorId(id, now);
        
        // Filter for only unbooked slots and map to DTO
        List<AvailabilitySlotDTO> availableSlots = slots.stream()
            .filter(slot -> !slot.isBooked())
            .map(slot -> new AvailabilitySlotDTO(
                slot.getSlotId(),
                slot.getStartTime(),
                slot.getEndTime(),
                slot.isBooked()
            ))
            .collect(Collectors.toList());
        
        return ResponseEntity.ok(availableSlots);
    }
}
