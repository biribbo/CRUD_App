package com.example.crudApp.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {
    List<Product> findAll();
    List<Product> findAllByIsDeletedIsFalse();
    Product save(Product entity);
    Optional<Product> findById(Integer id);
}