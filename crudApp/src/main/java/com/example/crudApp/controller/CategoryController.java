package com.example.crudApp.controller;

import com.example.crudApp.logic.CategoryService;
import com.example.crudApp.model.projections.CategoryReadModel;
import com.example.crudApp.model.projections.CategoryWriteModel;
import com.example.crudApp.model.projections.ProductReadModel;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
public class CategoryController {
    private final CategoryService service;

    @Autowired
    public CategoryController(CategoryService service) {
        this.service = service;
    }

    @GetMapping(path = "/categories")
    ResponseEntity<List<CategoryReadModel>> readAll(@RequestParam int page) {
        return ResponseEntity.ok(service.findAll(page));
    }

    @GetMapping(path = "/allcategories")
    ResponseEntity<List<CategoryReadModel>> readAllWithDeleted(@RequestParam int page) {
        return ResponseEntity.ok(service.finAllWithDeleted(page));
    }

    @GetMapping(path = "/categories/{id}")
    ResponseEntity<List<ProductReadModel>> readProductsFromCategory(@PathVariable int id, @RequestParam int page) {
        return ResponseEntity.ok(service.findById(id, page));
    }

    @PostMapping(path = "/categories")
    ResponseEntity<CategoryReadModel> CreateCategory(@RequestBody @Valid CategoryWriteModel toCreate) {
        CategoryReadModel createdCategory = service.createCategory(toCreate);
        return ResponseEntity.created(URI.create("/products/" + createdCategory.getId())).body(createdCategory);
    }

    @DeleteMapping(path = "/categories/{id}")
    ResponseEntity<?> DeleteCategory(@PathVariable int id) {
        service.deleteCategory(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping(path = "/categories/{id}")
    ResponseEntity<CategoryReadModel> UpdateProduct(@RequestBody @Valid CategoryWriteModel toUpdate, @PathVariable int id) {
        CategoryReadModel category = service.updateCategory(toUpdate, id);
        return category != null
                ? ResponseEntity.ok(category)
                : ResponseEntity.notFound().build();
    }
}