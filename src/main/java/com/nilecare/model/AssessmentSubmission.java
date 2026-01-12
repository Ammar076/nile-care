package com.nilecare.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "assessment_submissions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AssessmentSubmission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "submission_id")
    private Long submissionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "assessment_id", nullable = false)
    private Assessment assessment;

    @Column(nullable = false)
    private Integer score;

    @Column(name = "max_score")
    private Integer maxScore;

    @Column(nullable = false)
    private String status; // e.g., "Minimal", "Mild", "Moderate", "Severe"

    @Column(columnDefinition = "TEXT")
    private String content;

    @CreationTimestamp
    @Column(name = "submission_date", nullable = false, updatable = false)
    private LocalDateTime submissionDate;
}
