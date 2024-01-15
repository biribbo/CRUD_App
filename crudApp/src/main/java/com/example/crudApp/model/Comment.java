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
    @JoinColumn
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
    public void setProduct(Product product) {
        this.product = product;
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

    public Comment() {}
    public Comment(String description, Product product) {
        this.description = description;
        this.product = product;
    }

    @PrePersist
    void PrePersist() {
        creationDate = LocalDateTime.now();
        isDeleted = false;
    }

    public void remove() {
        isDeleted = true;
    }

    public void update(Comment source) {
        if (this.product != source.product) {
            throw new IllegalStateException("Existing comment can't be assigned to another product.");
        }
        this.description = source.description;
    }
}
