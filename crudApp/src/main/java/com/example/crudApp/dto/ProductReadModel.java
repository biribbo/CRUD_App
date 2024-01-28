package com.example.crudApp.dto;

import com.example.crudApp.model.Category;
import com.example.crudApp.model.Product;
import lombok.Getter;
import java.time.LocalDateTime;
import java.util.Set;

@Getter
public class ProductReadModel {
    private int id;
    private String title;
    private String description;
    private LocalDateTime creationDate;
    private String creatorUserId;
    private boolean isDeleted;
    private String imageUrl;
    public ProductReadModel(Product source) {
        id = source.getId();
        title = source.getTitle();
        description = source.getDescription();
        creationDate = source.getCreationDate();
        creatorUserId = source.getCreatorUserId();
        isDeleted = source.isDeleted();
        imageUrl = source.getImageUrl();
    }
}