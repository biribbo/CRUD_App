package com.example.crudApp.logic;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import com.example.crudApp.model.ProductRepository;
import com.example.crudApp.model.projections.CommentWriteModel;
import com.example.crudApp.model.projections.ProductReadModel;
import com.example.crudApp.model.projections.ProductWriteModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProductService {
    private final ProductRepository productRepository;

    @Autowired
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductReadModel> readAll() {
        List<Product> products = productRepository.findAllByIsDeletedIsFalse();
        return products.stream()
                .map(ProductReadModel::new)
                .collect(Collectors.toList());
    }

    public List<ProductReadModel> readAllWithDeleted() {
        List<Product> products = productRepository.findAll();
        return products.stream()
                .map(ProductReadModel::new)
                .collect(Collectors.toList());
    }

    public ProductReadModel readSingleProduct(int id) {
        return productRepository.findById(id)
                .map(ProductReadModel::new)
                .orElse(null);
    }

    public Product createProduct(ProductWriteModel toCreate) {
        Product newProduct = toCreate.toProduct();
        return productRepository.save(newProduct);
    }

    public void deleteProduct(int id) {
        Optional<Product> toDelete = productRepository.findById(id);
        toDelete.ifPresent(product -> {
            product.delete();
            productRepository.save(product);
        });
    }

    public void assignComment(CommentWriteModel comment, int id) {
        productRepository.findById(id).ifPresent(comment::setProduct);
    }
}