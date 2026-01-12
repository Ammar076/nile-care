package com.nilecare.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LearningModuleDTO {
    private Long id;
    private String title;
    private String description;
    private String contentUrl;
    private String category;
    private String difficultyLevel;
    private int progressPercentage;
}
