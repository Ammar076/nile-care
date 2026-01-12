package com.nilecare.dto;

import lombok.Data;
import java.util.List;

@Data
public class StudentCounselorDTO {
    private Long id;
    private String name;
    private String title;
    private List<String> specialties;
    private String avatarUrl;

    // Constructor for easy mapping
    public StudentCounselorDTO(Long id, String name, String title, List<String> specialties, String avatarUrl) {
        this.id = id;
        this.name = name;
        this.title = title;
        this.specialties = specialties;
        this.avatarUrl = avatarUrl;
    }
}
