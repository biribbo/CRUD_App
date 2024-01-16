package com.example.crudApp.repository;

import com.example.crudApp.model.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Integer> {
    List<Category> findAllByDeletedIsFalse(Pageable page);
    Page<Category> findAll(Pageable page);
    Optional<Category> existsById(int id);
    Category save();
}