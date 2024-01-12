package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.Set;

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
    @OneToMany(mappedBy = "product_id")
    private Set<Comment> comments;
    @ManyToOne(targetEntity = Category.class)
    @NotNull
    private Category category;

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

    public Set<Comment> getComments() {
        return comments;
    }
    void setComments(Set<Comment> comments) {
        this.comments = comments;
    }

    public Category getCategory() {
        return category;
    }
    void setCategory(Category category) {
        this.category = category;
    }

    public Product() {}
    public Product(String title, String description, String imageUrl, Set<Comment> comments, Category category) {
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
        this.comments = comments;
        this.category = category;
    }

    @PrePersist
    void PrePersist() {
        creationDate = LocalDateTime.now();
        isDeleted = false;
        category.addProduct(this);
    }

    public void delete (Product product) {
        product.isDeleted = true;
    }

    public void update (Product source) {
        if (this.category != source.category) {
            this.category.removeProduct(this);
            source.category.addProduct(this);
        }
        this.title = source.title;
        this.description = source.description;
        this.imageUrl = source.imageUrl;
        this.category = source.category;
    }

    public void addComment (Comment comment) {
        comments.add(comment);
    }
}