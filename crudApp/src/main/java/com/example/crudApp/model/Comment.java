package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.context.SecurityContextHolder;

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
    @Setter
    private Product product;
    @NotBlank
    @Setter
    private String description;
    private LocalDateTime creationDate;
    private boolean isDeleted;
    private String creatorUserId;

    public Comment() {}
    public Comment(String description) {
        this.description = description;
    }

    @PrePersist
    void PrePersist() {
        creationDate = LocalDateTime.now();
        isDeleted = false;
        creatorUserId = SecurityContextHolder.getContext().getAuthentication().getName();
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
