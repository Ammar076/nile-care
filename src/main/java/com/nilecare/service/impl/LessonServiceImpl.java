package com.nilecare.service.impl;

import com.nilecare.model.Lesson;
import com.nilecare.repository.LessonRepository;
import com.nilecare.service.LessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class LessonServiceImpl implements LessonService {

    @Autowired
    private LessonRepository lessonRepository;

    @Override
    public List<Lesson> getLessonsByModuleId(Long moduleId) {
        return lessonRepository.findByModuleIdOrderByLessonOrder(moduleId);
    }

    @Override
    public Lesson getLessonById(Long id) {
        Optional<Lesson> lesson = lessonRepository.findById(id);
        return lesson.orElse(null);
    }

    @Override
    public Lesson saveLesson(Lesson lesson) {
        return lessonRepository.save(lesson);
    }

    @Override
    public void deleteLesson(Long id) {
        lessonRepository.deleteById(id);
    }
}
