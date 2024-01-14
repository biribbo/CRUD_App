package com.example.crudApp.model;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
    Optional<Comment> findById(Integer id);
    Comment save(Comment entity);
    List<Comment> findAllByDeletedIsFalse();
}
