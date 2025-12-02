package com.nilecare.model;

import lombok.Data;
import javax.persistence.*;

@Entity
@Table(name = "appointments")
@Data
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "appointment_id")
    private Long appointmentId;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    // Links to the Counselor's Available Slot
    @OneToOne
    @JoinColumn(name = "slot_id", nullable = false, unique = true)
    private CounselorAvailability slot;

    @Enumerated(EnumType.STRING)
    private Status status = Status.CONFIRMED;

    @Column(columnDefinition = "TEXT")
    private String notes;

    public enum Status {
        CONFIRMED, CANCELLED, COMPLETED
    }
}