package com.nilecare.service.impl;

import com.nilecare.dto.LearningModuleDTO;
import com.nilecare.model.LearningModule;
import com.nilecare.repository.LearningModuleRepository;
import com.nilecare.repository.LessonRepository;
import com.nilecare.repository.StudentLessonProgressRepository;
import com.nilecare.service.LearningModuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class LearningModuleServiceImpl implements LearningModuleService {

    @Autowired
    private LearningModuleRepository learningModuleRepository;

    @Autowired
    private LessonRepository lessonRepository;

    @Autowired
    private StudentLessonProgressRepository lessonProgressRepo;

    @Override
    public List<LearningModule> getAllModules() {
        return learningModuleRepository.findAll();
    }

    @Override
    public List<LearningModuleDTO> getAllModulesWithProgress(Long userId) {
        List<LearningModule> modules = learningModuleRepository.findAll();
        return modules.stream()
                .map(module -> convertToDTO(module, userId))
                .collect(Collectors.toList());
    }

    @Override
    public LearningModule getModuleById(Long id) {
        Optional<LearningModule> module = learningModuleRepository.findById(id);
        return module.orElse(null);
    }

    @Override
    public LearningModuleDTO getModuleWithProgress(Long moduleId, Long userId) {
        LearningModule module = getModuleById(moduleId);
        if (module == null)
            return null;
        return convertToDTO(module, userId);
    }

    private LearningModuleDTO convertToDTO(LearningModule module, Long userId) {
        LearningModuleDTO dto = new LearningModuleDTO();
        dto.setId(module.getModuleId());
        dto.setTitle(module.getTitle());
        dto.setDescription(module.getDescription());
        dto.setContentUrl(module.getContentUrl());
        dto.setCategory(module.getCategory());
        dto.setDifficultyLevel(module.getDifficultyLevel());

        // Calculate Progress
        long totalLessons = lessonRepository.countTotalLessonsInModule(module.getModuleId());
        if (totalLessons == 0) {
            dto.setProgressPercentage(0);
        } else {
            long completedLessons = lessonProgressRepo.countByUserIdAndModuleId(userId, module.getModuleId());
            int percentage = (int) ((completedLessons * 100.0) / totalLessons);
            dto.setProgressPercentage(Math.min(percentage, 100));
        }

        return dto;
    }

    @Override
    public LearningModule saveModule(LearningModule module) {
        return learningModuleRepository.save(module);
    }

    @Override
    public void deleteModule(Long id) {
        learningModuleRepository.deleteById(id);
    }
}
