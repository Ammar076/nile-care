package com.nilecare.dto;

import lombok.Data;

@Data
public class AppointmentResponseDTO {
    private Long id;
    private Long counselorId;
    private String counselorName; // "Dr. Sarah Williams"
    private String date;          // "2025-12-15"
    private String time;          // "10:00 AM"
    private String type = "video";
    private String status;        // "upcoming", "completed", "cancel_requested"
    
    // New fields for Join button logic
    private String meetingLink;   // The video call link (set by counselor)
    private String startTime;     // ISO format: "2025-01-15T10:00:00"
    private String endTime;       // ISO format: "2025-01-15T11:00:00"

    // Constructor to make mapping easier
    public AppointmentResponseDTO(Long id, Long counselorId, String counselorName, 
                                  String date, String time, String status,
                                  String meetingLink, String startTime, String endTime) {
        this.id = id;
        this.counselorId = counselorId;
        this.counselorName = counselorName;
        this.date = date;
        this.time = time;
        this.status = status;
        this.meetingLink = meetingLink;
        this.startTime = startTime;
        this.endTime = endTime;
    }
}