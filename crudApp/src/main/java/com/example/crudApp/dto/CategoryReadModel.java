package com.example.crudApp.dto;
import com.example.crudApp.model.Category;
import lombok.Getter;

@Getter
public class CategoryReadModel {
    private int id;
    private String name;
    private boolean isDeleted;

    public CategoryReadModel(Category source) {
        this.id = source.getId();
        this.name = source.getName();
        this.isDeleted = source.isDeleted();
    }
}