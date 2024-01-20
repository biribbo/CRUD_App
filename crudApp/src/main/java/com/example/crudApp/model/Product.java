package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.Set;

@Entity
@Table
@Getter
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
    @OneToMany(mappedBy = "product")
    private Set<Comment> comments;
    @ManyToMany
    private Set<Category> categories;

    void setId(int id) {
        this.id = id;
    }

    void setTitle(String title) {
        this.title = title;
    }

    void setDescription(String description) {
        this.description = description;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    void setComments(Set<Comment> comments) {
        this.comments = comments;
    }

    public Product() {}
    public Product(String title, String description, String imageUrl) {
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    @PrePersist
    void PrePersist() {
        creationDate = LocalDateTime.now();
        isDeleted = false;
    }

    public void addComment(Comment comment) {
        comments.add(comment);
    }

    public void delete () {
        isDeleted = true;
        for (Comment comment : comments) {
            comment.remove();
        }
    }

    public void update (Product source) {
        this.title = source.title;
        this.description = source.description;
        this.imageUrl = source.imageUrl;
        this.categories = source.categories;
    }
}