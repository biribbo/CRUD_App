package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.security.core.context.SecurityContextHolder;

import java.time.LocalDateTime;

@Entity
@Table
@Getter
@NoArgsConstructor
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private int id;
    @Setter
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;
    @NotBlank
    @Setter
    private String description;
    private LocalDateTime creationDate;
    private boolean isDeleted;
    @CreatedBy
    private String creatorUserId;

    public boolean isDeleted() {
        return isDeleted;
    }

    public Comment(String description) {
        this.description = description;
    }

    @PrePersist
    void PrePersist() {
        creationDate = LocalDateTime.now();
        isDeleted = false;
        //creatorUserId = SecurityContextHolder.getContext().getAuthentication().getName();
    }

    public void remove() {
        isDeleted = true;
    }

    public void update(Comment source) {
        this.description = source.description;
    }
}
