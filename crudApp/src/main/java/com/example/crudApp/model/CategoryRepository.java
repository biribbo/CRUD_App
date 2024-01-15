package com.example.crudApp.model;

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