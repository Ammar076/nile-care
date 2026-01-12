package com.nilecare.service;

import com.nilecare.dto.AppointmentRequestDTO;
import com.nilecare.dto.AppointmentResponseDTO;
import com.nilecare.model.*;
import com.nilecare.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@Service
public class CounselingService {

    @Autowired
    private AppointmentRepository appointmentRepository; // The one you provided
    @Autowired
    private CounselorAvailabilityRepository availabilityRepository;
    @Autowired
    private UserRepository userRepository;

    // Date Formatters (Shared constant to ensure consistency)
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("h:mm a", Locale.US);

    /**
     * 1. BOOKING LOGIC
     */
    @Transactional
    public void bookAppointment(User student, AppointmentRequestDTO request) {
        // Find Counselor
        User counselor = userRepository.findById(request.getCounselorId())
                .orElseThrow(() -> new RuntimeException("Counselor not found"));

        // Parse Strings to LocalDateTime
        LocalDate datePart = LocalDate.parse(request.getDate());
        LocalTime timePart = LocalTime.parse(request.getTime(), TIME_FORMATTER);
        LocalDateTime startDateTime = LocalDateTime.of(datePart, timePart);
        LocalDateTime endDateTime = startDateTime.plusHours(1);

        // Find or Create Slot (Lazy Creation)
        CounselorAvailability slot = availabilityRepository.findByCounselorAndStartTime(counselor, startDateTime)
                .orElseGet(() -> {
                    CounselorAvailability newSlot = new CounselorAvailability();
                    newSlot.setCounselor(counselor);
                    newSlot.setStartTime(startDateTime);
                    newSlot.setEndTime(endDateTime);
                    newSlot.setBooked(false);
                    return availabilityRepository.save(newSlot);
                });

        if (slot.isBooked()) {
            throw new RuntimeException("Slot already booked");
        }

        // Create Appointment
        Appointment appointment = new Appointment();
        appointment.setStudent(student);
        appointment.setSlot(slot);
        appointment.setNotes(request.getNotes());
        appointment.setStatus(Appointment.Status.CONFIRMED);

        // Save
        slot.setBooked(true);
        availabilityRepository.save(slot);
        appointmentRepository.save(appointment);
    }

    /**
     * 2. HISTORY LOGIC (Uses your Repository method)
     */
    public List<AppointmentResponseDTO> getStudentAppointments(Long studentId) {
        // Use the method you provided in the prompt
        List<Appointment> appointments = appointmentRepository.findByStudent_UserId(studentId);

        // Convert Entities to DTOs for the Frontend
        return appointments.stream().map(appt -> {
            CounselorAvailability slot = appt.getSlot();

            // Extract Date and Time separately from LocalDateTime
            String dateStr = slot.getStartTime().toLocalDate().toString(); // "2025-12-15"
            String timeStr = slot.getStartTime().toLocalTime().format(TIME_FORMATTER); // "10:00 AM"

            // Map Status (CONFIRMED -> upcoming)
            String statusStr;
            switch (appt.getStatus()) {
                case CONFIRMED:
                    statusStr = "upcoming";
                    break;
                case CANCELLED:
                    statusStr = "cancelled";
                    break;
                case CANCEL_REQUESTED:
                    statusStr = "cancel_requested";
                    break;
                case COMPLETED:
                default:
                    statusStr = "completed";
                    break;
            }

            // ISO format for time window calculations in frontend
            String startTimeISO = slot.getStartTime().toString(); // "2025-01-15T10:00:00"
            String endTimeISO = slot.getEndTime().toString();     // "2025-01-15T11:00:00"

            return new AppointmentResponseDTO(
                    appt.getAppointmentId(),
                    slot.getCounselor().getUserId(),
                    slot.getCounselor().getFullName(), // User has getFullName() not getName()
                    dateStr,
                    timeStr,
                    statusStr,
                    appt.getMeetingLink(),  // Meeting link (may be null if not set yet)
                    startTimeISO,
                    endTimeISO);
        }).collect(Collectors.toList());
    }

    /**
     * 3. CANCELLATION REQUEST LOGIC
     * Sets appointment status to CANCEL_REQUESTED for counselor approval
     */
    @Transactional
    public void requestCancellation(Long appointmentId, Long studentId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        // Verify the student owns this appointment
        if (!appointment.getStudent().getUserId().equals(studentId)) {
            throw new RuntimeException("You are not authorized to cancel this appointment");
        }

        // Check if appointment can be cancelled
        if (appointment.getStatus() == Appointment.Status.CANCELLED) {
            throw new RuntimeException("Appointment is already cancelled");
        }
        if (appointment.getStatus() == Appointment.Status.CANCEL_REQUESTED) {
            throw new RuntimeException("Cancellation already requested");
        }
        if (appointment.getStatus() == Appointment.Status.COMPLETED) {
            throw new RuntimeException("Cannot cancel a completed appointment");
        }

        // Update status to CANCEL_REQUESTED
        appointment.setStatus(Appointment.Status.CANCEL_REQUESTED);
        appointmentRepository.save(appointment);
    }
}