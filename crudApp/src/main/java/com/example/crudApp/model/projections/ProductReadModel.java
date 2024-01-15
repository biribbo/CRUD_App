package com.example.crudApp.model.projections;

import com.example.crudApp.model.Comment;
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
    private int creatorUserId;
    private boolean isDeleted;
    private String imageUrl;
    private Set<Comment> comments;
    public ProductReadModel(Product source) {
        id = source.getId();
        title = source.getTitle();
        description = source.getDescription();
        creationDate = source.getCreationDate();
        creatorUserId = source.getCreatorUserId();
        isDeleted = source.isDeleted();
        imageUrl = source.getImageUrl();
        comments = source.getComments();
    }
}