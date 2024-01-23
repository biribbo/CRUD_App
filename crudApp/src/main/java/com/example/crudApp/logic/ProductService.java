package com.example.crudApp.logic;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import com.example.crudApp.repository.ProductRepository;
import com.example.crudApp.dto.ProductReadModel;
import com.example.crudApp.dto.ProductWriteModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProductService {
    public static final int PAGE_SIZE = 10;
    private final ProductRepository productRepository;

    @Autowired
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductReadModel> readAll(int page) {
        List<Product> products = productRepository.findAllByDeletedIsFalse(PageRequest.of(page, PAGE_SIZE));
        return products.stream()
                .map(ProductReadModel::new)
                .collect(Collectors.toList());
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

    public ProductReadModel createProduct(ProductWriteModel toCreate) {
        Product newProduct = toCreate.toProduct();
        productRepository.save(newProduct);
        return new ProductReadModel(newProduct);
    }

    public void deleteProduct(int id) {
        Optional<Product> toDelete = productRepository.findById(id);
        toDelete.ifPresent(product -> {
            product.delete();
            productRepository.save(product);
        });
    }

    public void addCommentToSet(Comment comment, int id) {
        Product product = productRepository.findById(id)
                .orElse(null);
        if (product != null) {
            productRepository.findById(id).ifPresent(comment::setProduct);
            product.addComment(comment);
            productRepository.save(product);
        } else {
            throw new NullPointerException("Product not found");
        }
    }

    public ProductReadModel updateProduct(ProductWriteModel product, int id) {
        Product source = product.toProduct();
        Product destination = productRepository.findById(id)
                .orElse(null);
        if (destination == null) {
            return null;
        }
        destination.update(source);
        source.getCategories().stream()
                .filter(category -> !destination.getCategories().contains(category))
                .forEach(category -> category.removeProduct(source));
        destination.getCategories().stream()
                .filter(category -> !source.getCategories().contains(category))
                .forEach(category -> category.addProduct(destination));
        productRepository.save(destination);
        return new ProductReadModel(destination);
    }

    public Product getAllCommentsFromProduct(int id) {
        return productRepository.findById(id)
                .orElse(null);
    }
}