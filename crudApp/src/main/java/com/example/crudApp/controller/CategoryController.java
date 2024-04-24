package com.example.crudApp.controller;

import com.example.crudApp.logic.CategoryService;
import com.example.crudApp.dto.CategoryReadModel;
import com.example.crudApp.dto.CategoryWriteModel;
import com.example.crudApp.dto.ProductReadModel;
import jakarta.annotation.security.RolesAllowed;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping(path = "/categories")
public class CategoryController {
    private final CategoryService service;

    @Autowired
    public CategoryController(CategoryService service) {
        this.service = service;
    }

    @GetMapping
    ResponseEntity<List<CategoryReadModel>> readAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping(path = "/all")
    ResponseEntity<List<CategoryReadModel>> readAllWithDeleted() {
        return ResponseEntity.ok(service.finAllWithDeleted());
    }

    @GetMapping(path = "/{id}")
    ResponseEntity<List<ProductReadModel>> readProductsFromCategory(@PathVariable int id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @PostMapping
    ResponseEntity<CategoryReadModel> CreateCategory(@RequestBody @Valid CategoryWriteModel toCreate) {
        CategoryReadModel createdCategory = service.createCategory(toCreate);
        return ResponseEntity.created(URI.create("/products/" + createdCategory.getId())).body(createdCategory);
    }

    @DeleteMapping(path = "/{id}")
    ResponseEntity<?> DeleteCategory(@PathVariable int id) {
        service.deleteCategory(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping(path = "/{id}")
    ResponseEntity<CategoryReadModel> UpdateProduct(@RequestBody @Valid CategoryWriteModel toUpdate, @PathVariable int id) {
        CategoryReadModel category = service.updateCategory(toUpdate, id);
        return category != null
                ? ResponseEntity.ok(category)
                : ResponseEntity.notFound().build();
    }
}