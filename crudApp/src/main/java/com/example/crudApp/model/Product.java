package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.security.core.context.SecurityContextHolder;

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
    @Setter
    private String title;
    @NotBlank(message = "Product description must not be empty.")
    @Setter
    private String description;
    private LocalDateTime creationDate;
    @CreatedBy
    private String creatorUserId;
    private boolean isDeleted;
    @Setter
    private String imageUrl;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "product", fetch = FetchType.EAGER)
    @Setter
    private Set<Comment> comments;
    @ManyToMany(mappedBy = "products", fetch = FetchType.EAGER)
    @Setter
    private Set<Category> categories;

    public boolean isDeleted() {
        return isDeleted;
    }

    public Product() {}

    public Product(String title, String description, String imageUrl) {
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    public void deleteAllComms() {
        comments.clear();
    }

    @PrePersist
    void PrePersist() {
        creationDate = LocalDateTime.now();
        isDeleted = false;
        //creatorUserId = SecurityContextHolder.getContext().getAuthentication().getName();
    }

    public void addComment(Comment comment) {
        comments.add(comment);
        comment.setProduct(this);
    }

    public void removeCategory(int cId) {
        for (Category category : categories) {
            if (category.getId() == id) {
                categories.remove(category);
                break;
            }
        }
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
    }
}