package com.nilecare.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CounselorAppointmentDTO {
    private Long id;
    private Long studentId;
    private String studentName;
    private String studentEmail;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startTime;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endTime;
    
    private String status;
    private String meetingLink;
    private String notes;
    
    // Formatted strings for display
    private String dateFormatted;
    private String timeFormatted;

    public CounselorAppointmentDTO(Long id, Long studentId, String studentName, String studentEmail,
                                   LocalDateTime startTime, LocalDateTime endTime, String status,
                                   String meetingLink, String notes) {
        this.id = id;
        this.studentId = studentId;
        this.studentName = studentName;
        this.studentEmail = studentEmail;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.meetingLink = meetingLink;
        this.notes = notes;
    }
}
