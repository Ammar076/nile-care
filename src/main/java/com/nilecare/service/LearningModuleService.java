package com.nilecare.service;

import com.nilecare.dto.LearningModuleDTO;
import com.nilecare.model.LearningModule;
import java.util.List;

public interface LearningModuleService {
    List<LearningModule> getAllModules();

    List<LearningModuleDTO> getAllModulesWithProgress(Long userId);

    LearningModule getModuleById(Long id);

    LearningModuleDTO getModuleWithProgress(Long moduleId, Long userId);

    LearningModule saveModule(LearningModule module);

    void deleteModule(Long id);
}
