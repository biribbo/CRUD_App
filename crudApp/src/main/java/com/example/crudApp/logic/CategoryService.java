package com.example.crudApp.logic;

import com.example.crudApp.model.Category;
import com.example.crudApp.repository.CategoryRepository;
import com.example.crudApp.dto.CategoryReadModel;
import com.example.crudApp.dto.CategoryWriteModel;
import com.example.crudApp.dto.ProductReadModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CategoryService {

    public static final int PAGE_SIZE = 10;
    private final CategoryRepository repository;
    private final ProductService productService;

    @Autowired
    public CategoryService(CategoryRepository repository, ProductService productService) {
        this.repository = repository;
        this.productService = productService;
    }

    public List<CategoryReadModel> findAll(int page) {
        List<Category> categories = repository.findAllByDeletedIsFalse(PageRequest.of(page, PAGE_SIZE));
        return categories.stream()
                .map(CategoryReadModel::new)
                .collect(Collectors.toList());
    }

    public List<CategoryReadModel> finAllWithDeleted(int page) {
        Page<Category> categories = repository.findAll(PageRequest.of(page, PAGE_SIZE));
        return categories.stream()
                .map(CategoryReadModel::new)
                .collect(Collectors.toList());
    }

    public List<ProductReadModel> findById(int id, int page) {
        Category category = repository.findById(id)
                .orElse(null);
        if (category == null) {
            return null;
        }
        return productService.readAllFromCategory(category, page);
    }

    public CategoryReadModel createCategory(CategoryWriteModel toCreate) {
        Category newCategory = toCreate.toCategory();
        repository.save(newCategory);
        return new CategoryReadModel(newCategory);
    }

    public void deleteCategory(int id) {
        repository.findById(id).ifPresent(Category::delete);
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
