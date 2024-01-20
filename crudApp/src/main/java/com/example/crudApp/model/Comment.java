package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

import java.time.LocalDateTime;

@Entity
@Table
@Getter
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private int id;
    @ManyToOne
    @JoinColumn
    private Product product;
    @NotBlank
    private String description;
    private LocalDateTime creationDate;
    private boolean isDeleted;
    private int creatorUserId;

    void setId(int id) {
        this.id = id;
    }

    void setDescription(String description) {
        this.description = description;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public Comment() {}
    public Comment(String description) {
        this.description = description;
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
