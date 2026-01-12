package com.nilecare.repository;

import com.nilecare.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    // Student's appointments
    List<Appointment> findByStudent_UserId(Long studentId);
    
    // Counselor's appointments (via slot -> counselor)
    @Query("SELECT a FROM Appointment a WHERE a.slot.counselor.userId = :counselorId ORDER BY a.slot.startTime ASC")
    List<Appointment> findByCounselorId(@Param("counselorId") Long counselorId);
    
    // Counselor's appointments by status
    @Query("SELECT a FROM Appointment a WHERE a.slot.counselor.userId = :counselorId AND a.status = :status ORDER BY a.slot.startTime ASC")
    List<Appointment> findByCounselorIdAndStatus(@Param("counselorId") Long counselorId, @Param("status") Appointment.Status status);
}