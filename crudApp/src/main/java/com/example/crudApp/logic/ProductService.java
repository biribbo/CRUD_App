package com.example.crudApp.logic;

import com.example.crudApp.exception.InvalidPageNumberException;
import com.example.crudApp.model.Category;
import com.example.crudApp.model.Product;
import com.example.crudApp.repository.CategoryRepository;
import com.example.crudApp.repository.CommentRepository;
import com.example.crudApp.repository.ProductRepository;
import com.example.crudApp.dto.ProductReadModel;
import com.example.crudApp.dto.ProductWriteModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ProductService {
    public static final int PAGE_SIZE = 10;
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final CommentRepository commentRepository;

    @Autowired
    public ProductService(ProductRepository productRepository, CategoryRepository categoryRepository, CommentRepository commentRepository) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
        this.commentRepository = commentRepository;
    }

    public Page<ProductReadModel> readAll(int page) {
        if (page < 0) {
            throw new InvalidPageNumberException("Page number must be non-negative.");
        }
        Page<Product> productPage = productRepository.findAllByIsDeletedIsFalse(PageRequest.of(page, PAGE_SIZE));
        if (page >= productPage.getTotalPages()) {
            throw new InvalidPageNumberException("Invalid page number.");
        }
        return productPage.map(ProductReadModel::new);
    }

    public List<ProductReadModel> readAllWithDeleted(int page) {
        Page<Product> products = productRepository.findAll(PageRequest.of(page, PAGE_SIZE));
        return products.stream()
                .map(ProductReadModel::new)
                .collect(Collectors.toList());
    }

    public ProductReadModel readSingleProduct(int id) {
        return productRepository.findById(id)
                .map(ProductReadModel::new)
                .orElse(null);
    }

    public List<ProductReadModel> readProductsByName(String keyword) {
        return productRepository.findAllByTitleContainingIgnoreCase(keyword)
                .stream()
                .map(ProductReadModel::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public ProductReadModel createProduct(ProductWriteModel toCreate) {
        Product newProduct = toCreate.toProduct();
        productRepository.save(newProduct);
        return new ProductReadModel(newProduct);
    }

    public void deleteProduct(int id) {
        Optional<Product> toDelete = productRepository.findById(id);
        toDelete.ifPresent(product -> {
            product.delete();
            commentRepository.saveAll(product.getComments());
            productRepository.save(product);
        });
    }

    @Transactional
    public ProductReadModel updateProduct(ProductWriteModel product, int id) {
        Product source = product.toProduct();
        Product destination = productRepository.findById(id)
                .orElse(null);
        if (destination == null) {
            return null;
        }
        destination.update(source);
        productRepository.save(destination);
        return new ProductReadModel(destination);
    }

    @Transactional
    public ProductReadModel manageCategories(Set<Category> added, Set<Category> deleted, int id) {
        Product product = productRepository.findById(id)
                .orElse(null);
        if (product == null) {
            return null;
        }
        for (Category category : added) {
            category.addProduct(product);
            categoryRepository.save(category);
        }
        for (Category category : deleted) {
            category.removeProduct(product);
            categoryRepository.save(category);
        }
        return new ProductReadModel(product);
    }
}