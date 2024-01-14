package com.example.crudApp.model.projections;

import com.example.crudApp.model.Comment;
import java.time.LocalDateTime;

public class CommentReadModel {
    private int id;
    private ProductReadModel product;
    private String description;
    private LocalDateTime creationDate;
    private boolean isDeleted;
    private int creatorUserId;

    public CommentReadModel(Comment source) {
        this.id = source.getId();
        this.product = new ProductReadModel(source.getProduct());
        this.description = source.getDescription();
        this.creationDate = source.getCreationDate();
        this.isDeleted = source.isDeleted();
        this.creatorUserId = source.getCreatorUserId();
    }

    public int getId() {
        return id;
    }

    public ProductReadModel getProduct() {
        return product;
    }

    public String getDescription() {
        return description;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public int getCreatorUserId() {
        return creatorUserId;
    }
}
