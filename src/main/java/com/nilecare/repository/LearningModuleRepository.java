package com.nilecare.repository;

import com.nilecare.model.LearningModule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LearningModuleRepository extends JpaRepository<LearningModule, Long> {
}