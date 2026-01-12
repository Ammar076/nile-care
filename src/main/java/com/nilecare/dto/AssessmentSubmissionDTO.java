package com.nilecare.dto;

import lombok.Data;

@Data
public class AssessmentSubmissionDTO {
    private String assessmentId;
    private Integer score;
    private Integer maxScore;
    private String status;
}
