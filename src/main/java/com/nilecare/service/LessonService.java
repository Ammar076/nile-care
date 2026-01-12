package com.nilecare.service;

import com.nilecare.model.Lesson;
import java.util.List;

public interface LessonService {
    List<Lesson> getLessonsByModuleId(Long moduleId);

    Lesson getLessonById(Long id);

    Lesson saveLesson(Lesson lesson);

    void deleteLesson(Long id);
}
