package com.example.crudApp.model.projections;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;

import java.time.LocalDateTime;
import java.util.Set;

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

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public int getCreatorUserId() {
        return creatorUserId;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public Set<Comment> getComments() {
        return comments;
    }
}