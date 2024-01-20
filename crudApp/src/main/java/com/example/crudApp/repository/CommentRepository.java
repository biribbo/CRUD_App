package com.example.crudApp.repository;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
    Optional<Comment> findById(Integer id);
    Comment save(Comment entity);
    List<Comment> findAllByIsDeletedIsFalseAndProduct(Pageable page, Product product);
    List<Comment> findAllByProduct (Pageable page, Product product);
}