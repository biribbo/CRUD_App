package com.example.crudApp.controller;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import com.example.crudApp.model.ProductRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;
import java.util.Optional;

@RestController
public class ProductController {
    final private ProductRepository repository;

    public ProductController(ProductRepository repository) {
        this.repository = repository;
    }

    @GetMapping(path = "/products", params = {"!sort", "!page", "!size"})
    ResponseEntity<List<Product>> readAll() {
        return ResponseEntity.ok(repository.findAllByIsDeletedIsFalse());
    }

    @GetMapping(path = "/allproducts", params = {"!sort", "!page", "!size"})
    ResponseEntity<List<Product>> readAllWithDeleted() {
        return ResponseEntity.ok(repository.findAll());
    }

    @GetMapping(path = "/products/{id}")
    ResponseEntity<Product> readSingleProduct(@PathVariable int id) {
        return repository.findById(id)
                .map(product -> ResponseEntity.ok().body(product))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping(path = "/products")
    ResponseEntity<Product> CreateProduct(@RequestBody @Valid Product toCreate) {
        Product newProduct = repository.save(toCreate);
        return ResponseEntity.created(URI.create("/" + newProduct.getId())).body(newProduct);
    }

    @DeleteMapping(path = "/products/{id}")
    ResponseEntity<?> DeleteProduct(@PathVariable int id) {
        Optional<Product> toDelete = repository.findById(id);
        if (toDelete.isPresent()) {
            Product toDeleteProd = toDelete.get();
            repository.delete(toDeleteProd);
            List<Product> remainingProducts = repository.findAllByIsDeletedIsFalse();
            return ResponseEntity.ok(remainingProducts);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    //@PostMapping(path = "/products/{id}")
    //ResponseEntity<Product> CreateProduct(@RequestBody @Valid Comment toCreate, @PathVariable int id) {
        //Optional<Product> toComment = repository.findById(id);
        //Product toCommentProd = toComment.get();

        // TODO: forward to Comment controller
    //}
}