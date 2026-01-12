package com.nilecare.controller;

import com.nilecare.dto.AssessmentSubmissionDTO;
import com.nilecare.model.Assessment;
import com.nilecare.model.AssessmentSubmission;
import com.nilecare.model.User;
import com.nilecare.repository.AssessmentRepository;
import com.nilecare.repository.AssessmentSubmissionRepository;
import com.nilecare.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/assessment")
@Slf4j
@CrossOrigin(origins = "*")
public class AssessmentAPIController {

    @Autowired
    private AssessmentSubmissionRepository submissionRepository;

    @Autowired
    private AssessmentRepository assessmentRepository;

    @Autowired
    private UserService userService;

    @PostMapping("/submit")
    public ResponseEntity<?> submitAssessment(@RequestBody AssessmentSubmissionDTO dto, Principal principal) {
        try {
            if (principal == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not authenticated");
            }

            User user = userService.findByEmail(principal.getName());
            if (user == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not found");
            }

            // Find or create the assessment
            String title = dto.getAssessmentId().equals("phq9") ? "PHQ-9 Depression Assessment"
                    : "GAD-7 Anxiety Assessment";
            Assessment assessment = assessmentRepository.findByTitle(title).orElseGet(() -> {
                Assessment newAssessment = new Assessment();
                newAssessment.setTitle(title);
                newAssessment.setType("SELF_ASSESSMENT");
                newAssessment.setModuleId(1L); // Default to module 1
                return assessmentRepository.save(newAssessment);
            });

            AssessmentSubmission submission = new AssessmentSubmission();
            submission.setUser(user);
            submission.setAssessment(assessment);
            submission.setScore(dto.getScore());
            submission.setMaxScore(dto.getMaxScore());
            submission.setStatus(dto.getStatus());

            submissionRepository.save(submission);

            log.info("Assessment submitted by user {}: {} with score {}", user.getUserId(), title, dto.getScore());
            return ResponseEntity.ok("Assessment submitted successfully");

        } catch (Exception e) {
            log.error("Error submitting assessment", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
        }
    }

    @GetMapping("/history")
    public ResponseEntity<?> getHistory(Principal principal) {
        try {
            if (principal == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not authenticated");
            }

            User user = userService.findByEmail(principal.getName());
            if (user == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not found");
            }

            List<AssessmentSubmission> history = submissionRepository.findByUserOrderBySubmissionDateDesc(user);
            return ResponseEntity.ok(history);

        } catch (Exception e) {
            log.error("Error fetching assessment history", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
        }
    }
}
