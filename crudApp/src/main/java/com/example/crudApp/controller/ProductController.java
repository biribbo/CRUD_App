package com.example.crudApp.controller;

import com.example.crudApp.logic.ProductService;
import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import com.example.crudApp.model.ProductRepository;
import com.example.crudApp.model.projections.ProductReadModel;
import com.example.crudApp.model.projections.ProductWriteModel;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;
import java.util.Optional;

@RestController
public class ProductController {
    final private ProductService service;

    @Autowired
    public ProductController(ProductService service) {
        this.service = service;
    }

    @GetMapping(path = "/products", params = {"!sort", "!page", "!size"})
    ResponseEntity<List<ProductReadModel>> readAll() {
        List<ProductReadModel> products = service.readAll();
        return ResponseEntity.ok(products);
    }

    @GetMapping(path = "/allproducts", params = {"!sort", "!page", "!size"})
    ResponseEntity<List<ProductReadModel>> readAllWithDeleted() {
        List<ProductReadModel> products = service.readAllWithDeleted();
        return ResponseEntity.ok(products);
    }

    @GetMapping(path = "/products/{id}")
    ResponseEntity<ProductReadModel> readSingleProduct(@PathVariable int id) {
        ProductReadModel product = service.readSingleProduct(id);
        return product != null
                ? ResponseEntity.ok(product)
                : ResponseEntity.notFound().build();
    }

    @PostMapping(path = "/products")
    ResponseEntity<ProductReadModel> CreateProduct(@RequestBody @Valid ProductWriteModel toCreate) {
        Product createdProduct = service.createProduct(toCreate);
        ProductReadModel responseModel = new ProductReadModel(createdProduct);
        return ResponseEntity.created(URI.create("/products/" + createdProduct.getId())).body(responseModel);
    }

    @DeleteMapping(path = "/products/{id}")
    ResponseEntity<?> DeleteProduct(@PathVariable int id) {
        service.deleteProduct(id);
        return ResponseEntity.ok().build();
    }

    //@PostMapping(path = "/products/{id}")
    //ResponseEntity<Product> CreateProduct(@RequestBody @Valid Comment toCreate, @PathVariable int id) {
        //Optional<Product> toComment = repository.findById(id);
        //Product toCommentProd = toComment.get();

        // TODO: forward to Comment controller
    //}
}