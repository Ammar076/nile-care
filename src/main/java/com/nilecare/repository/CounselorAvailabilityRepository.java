package com.nilecare.repository;

import com.nilecare.model.CounselorAvailability;
import com.nilecare.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface CounselorAvailabilityRepository extends JpaRepository<CounselorAvailability, Long> {
    // Find a specific slot for a counselor at a specific time
    Optional<CounselorAvailability> findByCounselorAndStartTime(User counselor, LocalDateTime startTime);
    
    // Find all future availability slots for a counselor
    @Query("SELECT ca FROM CounselorAvailability ca WHERE ca.counselor.userId = :counselorId AND ca.startTime > :now ORDER BY ca.startTime ASC")
    List<CounselorAvailability> findFutureAvailabilityByCounselorId(@Param("counselorId") Long counselorId, @Param("now") LocalDateTime now);
    
    // Find a slot by ID and counselor (for deletion validation)
    Optional<CounselorAvailability> findBySlotIdAndCounselor_UserId(Long slotId, Long counselorId);
}