package com.nilecare.repository;

import com.nilecare.model.AssessmentSubmission;
import com.nilecare.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AssessmentSubmissionRepository extends JpaRepository<AssessmentSubmission, Long> {
    List<AssessmentSubmission> findByUserOrderBySubmissionDateDesc(User user);
}
