package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

import java.util.Set;

@Entity
@Table
@Getter
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @NotBlank
    private String name;
    @ManyToMany
    Set<Product> products;
    private boolean isDeleted;

    void setId(int id) {
        this.id = id;
    }
    void setName(String name) {
        this.name = name;
    }
    void setProducts(Set<Product> products) {
        this.products = products;
    }

    public Category() {
    }

    public Category(String name) {
        this.name = name;
    }

    @PrePersist
    void PrePersist() {
        isDeleted = false;
    }

    public void addProduct(Product product) {
        products.add(product);
        product.getCategories().add(this);
    }
    public void removeProduct (Product product) {
        products.remove(product);
        product.getCategories().remove(this);
    }
    public void delete() {
        this.isDeleted = true;
    }
    public void Update(Category source) {
        this.name = source.getName();
    }
}