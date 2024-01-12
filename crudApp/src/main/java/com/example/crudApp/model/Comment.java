package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDateTime;

@Entity
@Table
public class Comment {
    @Id
    private int id;
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;
    @NotBlank
    private String description;
    private LocalDateTime creationDate;
    private boolean isDeleted;
    private int creatorUserId;

    public int getId() {
        return id;
    }
    void setId(int id) {
        this.id = id;
    }
    public String getDescription() {
        return description;
    }
    void setDescription(String description) {
        this.description = description;
    }

    public Product getProduct() {
        return product;
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

    @PrePersist
    void PrePersist() {
        creationDate = LocalDateTime.now();
        isDeleted = false;
        product.addComment(this);
    }

    public void addCommentToProduct() {
        product.addComment(this);
    }

    public void remove() {
        isDeleted = true;
    }
}
