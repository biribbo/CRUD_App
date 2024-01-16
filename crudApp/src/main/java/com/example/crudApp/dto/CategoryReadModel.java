package com.example.crudApp.dto;
import com.example.crudApp.model.Category;
import com.example.crudApp.model.Product;
import lombok.Getter;

import java.util.Set;

@Getter
public class CategoryReadModel {
    private int id;
    private String name;
    Set<Product> products;
    private boolean isDeleted;

    public CategoryReadModel(Category source) {
        this.id = source.getId();
        this.name = source.getName();
        this.products = source.getProducts();
        this.isDeleted = source.isDeleted();
    }
}