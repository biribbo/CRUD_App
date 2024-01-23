package com.example.crudApp.controller;

import com.example.crudApp.logic.ProductService;
import com.example.crudApp.dto.ProductReadModel;
import com.example.crudApp.dto.ProductWriteModel;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/products")
public class ProductController {
    final private ProductService service;

    @Autowired
    public ProductController(ProductService service) {
        this.service = service;
    }

    @GetMapping
    ResponseEntity<List<ProductReadModel>> readAll(@RequestParam int page) {
        List<ProductReadModel> products = service.readAll(page);
        return ResponseEntity.ok(products);
    }

    @GetMapping(path = "/all")
    ResponseEntity<List<ProductReadModel>> readAllWithDeleted(@RequestParam int page) {
        List<ProductReadModel> products = service.readAllWithDeleted(page);
        return ResponseEntity.ok(products);
    }

    @GetMapping(path = "/{id}")
    ResponseEntity<ProductReadModel> readSingleProduct(@PathVariable int id) {
        ProductReadModel product = service.readSingleProduct(id);
        return product != null
                ? ResponseEntity.ok(product)
                : ResponseEntity.notFound().build();
    }

    @GetMapping(path = "/search/{keyword}")
    ResponseEntity<List<ProductReadModel>> readAllByName(@PathVariable String keyword) {
        return ResponseEntity.ok(service.readProductsByName(keyword));
    }

    @PostMapping
    ResponseEntity<ProductReadModel> CreateProduct(@RequestBody @Valid ProductWriteModel toCreate) {
        ProductReadModel createdProduct = service.createProduct(toCreate);
        return ResponseEntity.created(URI.create("/products/" + createdProduct.getId())).body(createdProduct);
    }

    @DeleteMapping(path = "/{id}")
    ResponseEntity<?> DeleteProduct(@PathVariable int id) {
        service.deleteProduct(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping(path = "/{id}")
    ResponseEntity<ProductReadModel> UpdateProduct(@RequestBody @Valid ProductWriteModel toUpdate, @PathVariable int id) {
        ProductReadModel product = service.updateProduct(toUpdate, id);
        return product != null
                ? ResponseEntity.ok(product)
                : ResponseEntity.notFound().build();
    }
}