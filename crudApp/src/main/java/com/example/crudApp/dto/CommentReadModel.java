package com.example.crudApp.dto;

import com.example.crudApp.model.Comment;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class CommentReadModel {
    private int id;
    private int productId;
    private String description;
    private LocalDateTime creationDate;
    private boolean isDeleted;
    private int creatorUserId;

    public CommentReadModel(Comment source) {
        this.id = source.getId();
        this.productId = source.getProduct().getId();
        this.description = source.getDescription();
        this.creationDate = source.getCreationDate();
        this.isDeleted = source.isDeleted();
        this.creatorUserId = source.getCreatorUserId();
    }
}
