package com.nilecare.service;

import com.nilecare.dto.CounselorAppointmentDTO;
import com.nilecare.model.Appointment;
import com.nilecare.model.CounselorAvailability;
import com.nilecare.model.User;
import com.nilecare.repository.AppointmentRepository;
import com.nilecare.repository.CounselorAvailabilityRepository;
import com.nilecare.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@Service
public class CounselorService {

    @Autowired
    private CounselorAvailabilityRepository availabilityRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private AppointmentRepository appointmentRepository;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy", Locale.US);
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("h:mm a", Locale.US);

    /**
     * Add a new availability slot for a counselor
     * Validates that end time is after start time
     * 
     * @param counselorId The ID of the counselor
     * @param startTime The start time of the availability slot
     * @param endTime The end time of the availability slot
     * @throws RuntimeException if validation fails or counselor not found
     */
    @Transactional
    public CounselorAvailability addAvailability(Long counselorId, LocalDateTime startTime, LocalDateTime endTime) {
        // Validate end > start
        if (endTime.isBefore(startTime) || endTime.isEqual(startTime)) {
            throw new RuntimeException("End time must be after start time");
        }

        // Find counselor
        User counselor = userRepository.findById(counselorId)
                .orElseThrow(() -> new RuntimeException("Counselor not found"));

        // Check if counselor has COUNSELOR role
        boolean isCounselor = counselor.getRoles().stream()
                .anyMatch(role -> role.getName().name().equals("ROLE_COUNSELOR"));
        
        if (!isCounselor) {
            throw new RuntimeException("User is not a counselor");
        }

        // Create and save slot
        CounselorAvailability slot = new CounselorAvailability();
        slot.setCounselor(counselor);
        slot.setStartTime(startTime);
        slot.setEndTime(endTime);
        slot.setBooked(false);

        return availabilityRepository.save(slot);
    }

    /**
     * Get all future availability slots for a counselor
     * Returns slots where start_time > now
     * 
     * @param counselorId The ID of the counselor
     * @return List of future availability slots
     */
    public List<CounselorAvailability> getFutureAvailability(Long counselorId) {
        LocalDateTime now = LocalDateTime.now();
        return availabilityRepository.findFutureAvailabilityByCounselorId(counselorId, now);
    }

    /**
     * Delete an availability slot
     * Only allows deletion if the slot is not booked
     * 
     * @param slotId The ID of the slot to delete
     * @param counselorId The ID of the counselor (for validation)
     * @throws RuntimeException if slot is booked or not found
     */
    @Transactional
    public void deleteAvailability(Long slotId, Long counselorId) {
        // Find the slot and verify it belongs to this counselor
        CounselorAvailability slot = availabilityRepository.findBySlotIdAndCounselor_UserId(slotId, counselorId)
                .orElseThrow(() -> new RuntimeException("Availability slot not found or does not belong to you"));

        // Check if booked
        if (slot.isBooked()) {
            throw new RuntimeException("Cannot delete a booked slot");
        }

        // Delete the slot
        availabilityRepository.delete(slot);
    }

    // ==========================================
    // APPOINTMENT MANAGEMENT METHODS
    // ==========================================

    /**
     * Get all appointments for a counselor
     */
    public List<CounselorAppointmentDTO> getMyAppointments(Long counselorId) {
        List<Appointment> appointments = appointmentRepository.findByCounselorId(counselorId);
        return appointments.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    /**
     * Get appointments by status for a counselor
     */
    public List<CounselorAppointmentDTO> getMyAppointmentsByStatus(Long counselorId, Appointment.Status status) {
        List<Appointment> appointments = appointmentRepository.findByCounselorIdAndStatus(counselorId, status);
        return appointments.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    /**
     * Add a meeting link to an appointment
     */
    @Transactional
    public void addMeetingLink(Long appointmentId, Long counselorId, String link) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        // Verify counselor owns this appointment
        if (!appointment.getSlot().getCounselor().getUserId().equals(counselorId)) {
            throw new RuntimeException("You are not authorized to modify this appointment");
        }

        appointment.setMeetingLink(link);
        appointmentRepository.save(appointment);
    }

    /**
     * Approve a cancellation request
     * Sets status to CANCELLED and frees the slot for rebooking
     */
    @Transactional
    public void approveCancellation(Long appointmentId, Long counselorId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        // Verify counselor owns this appointment
        if (!appointment.getSlot().getCounselor().getUserId().equals(counselorId)) {
            throw new RuntimeException("You are not authorized to modify this appointment");
        }

        // Check if it's in CANCEL_REQUESTED status
        if (appointment.getStatus() != Appointment.Status.CANCEL_REQUESTED) {
            throw new RuntimeException("This appointment is not pending cancellation");
        }

        // Set status to CANCELLED
        appointment.setStatus(Appointment.Status.CANCELLED);
        appointmentRepository.save(appointment);

        // Free the slot for rebooking
        CounselorAvailability slot = appointment.getSlot();
        slot.setBooked(false);
        availabilityRepository.save(slot);
    }

    /**
     * Deny a cancellation request
     * Sets status back to CONFIRMED
     */
    @Transactional
    public void denyCancellation(Long appointmentId, Long counselorId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        // Verify counselor owns this appointment
        if (!appointment.getSlot().getCounselor().getUserId().equals(counselorId)) {
            throw new RuntimeException("You are not authorized to modify this appointment");
        }

        // Check if it's in CANCEL_REQUESTED status
        if (appointment.getStatus() != Appointment.Status.CANCEL_REQUESTED) {
            throw new RuntimeException("This appointment is not pending cancellation");
        }

        // Set status back to CONFIRMED
        appointment.setStatus(Appointment.Status.CONFIRMED);
        appointmentRepository.save(appointment);
    }

    /**
     * Mark a session as completed with notes
     */
    @Transactional
    public void completeSession(Long appointmentId, Long counselorId, String notes) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        // Verify counselor owns this appointment
        if (!appointment.getSlot().getCounselor().getUserId().equals(counselorId)) {
            throw new RuntimeException("You are not authorized to modify this appointment");
        }

        // Check if appointment can be completed
        if (appointment.getStatus() != Appointment.Status.CONFIRMED) {
            throw new RuntimeException("Only confirmed appointments can be marked as completed");
        }

        // Update status and notes
        appointment.setStatus(Appointment.Status.COMPLETED);
        if (notes != null && !notes.trim().isEmpty()) {
            appointment.setNotes(notes);
        }
        appointmentRepository.save(appointment);
    }

    /**
     * Convert Appointment entity to DTO
     */
    private CounselorAppointmentDTO convertToDTO(Appointment appointment) {
        CounselorAvailability slot = appointment.getSlot();
        User student = appointment.getStudent();

        CounselorAppointmentDTO dto = new CounselorAppointmentDTO(
                appointment.getAppointmentId(),
                student.getUserId(),
                student.getFullName(),
                student.getEmail(),
                slot.getStartTime(),
                slot.getEndTime(),
                appointment.getStatus().name().toLowerCase(),
                appointment.getMeetingLink(),
                appointment.getNotes()
        );

        // Add formatted date/time
        dto.setDateFormatted(slot.getStartTime().format(DATE_FORMATTER));
        dto.setTimeFormatted(slot.getStartTime().format(TIME_FORMATTER) + " - " + slot.getEndTime().format(TIME_FORMATTER));

        return dto;
    }
}
