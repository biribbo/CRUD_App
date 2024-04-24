package com.example.crudApp.logic;

//import com.example.crudApp.dto.ProductWriteModel;
import com.example.crudApp.model.Category;
import com.example.crudApp.model.Product;
import com.example.crudApp.repository.CategoryRepository;
import com.example.crudApp.dto.CategoryReadModel;
import com.example.crudApp.dto.CategoryWriteModel;
import com.example.crudApp.dto.ProductReadModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CategoryService {

    public static final int PAGE_SIZE = 10;
    private final CategoryRepository repository;

    @Autowired
    public CategoryService(CategoryRepository repository) {
        this.repository = repository;
    }

    public List<CategoryReadModel> findAll() {
        List<Category> categories = repository.findAllByIsDeletedIsFalse();
        return categories.stream()
                .map(CategoryReadModel::new)
                .collect(Collectors.toList());
    }

    public List<CategoryReadModel> finAllWithDeleted() {
        List<Category> categories = repository.findAll();
        return categories.stream()
                .map(CategoryReadModel::new)
                .collect(Collectors.toList());
    }

    public List<ProductReadModel> findById(int id) {
        Category category = repository.findById(id)
                .orElse(null);
        if (category == null) {
            return null;
        }
        List<Product> rawList = new ArrayList<>(category.getProducts());
        return rawList.stream()
                .map(ProductReadModel::new)
                .collect(Collectors.toList());
    }

    public CategoryReadModel createCategory(CategoryWriteModel toCreate) {
        Category newCategory = toCreate.toCategory();
        repository.save(newCategory);
        return new CategoryReadModel(newCategory);
    }

    public void deleteCategory(int id) {
        repository.findById(id)
                .ifPresent(category -> {
                    category.delete();
                    repository.save(category);
                });
    }

    public CategoryReadModel updateCategory(CategoryWriteModel category, int id) {
        Category source = category.toCategory();
        Category destination = repository.findById(id)
                .orElse(null);
        if (destination == null) {
            return null;
        }
        destination.Update(source);
        repository.save(destination);
        return new CategoryReadModel(destination);
    }
}