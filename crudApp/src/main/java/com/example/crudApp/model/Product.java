package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDateTime;

@Entity
@Table
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @NotBlank(message = "Product title must not be empty.")
    private String title;
    @NotBlank(message = "Product description must not be empty.")
    private String description;
    private LocalDateTime creationDate;
    private int creatorUserId;
    private boolean isDeleted;
    private String imageUrl;

    public int getId() {
        return id;
    }
    void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }
    void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }
    void setDescription(String description) {
        this.description = description;
    }

    public boolean isDeleted() {
        return isDeleted;
    }
    public LocalDateTime getCreationDate() {
        return creationDate;
    }
    public int getCreatorUserId() {
        return creatorUserId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @PrePersist
    void PrePersist() {
        creationDate = LocalDateTime.now();
        isDeleted = false;
    }

    public void delete (Product product) {
        product.isDeleted = true;
    }

    public void update (Product source) {
        this.title = source.title;
        this.description = source.description;
        this.imageUrl = source.imageUrl;
    }
}
