package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.util.Set;

@Entity
@Table
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @NotBlank
    private String name;
    @OneToMany(targetEntity = Product.class)
    Set<Product> products;
    private boolean isDeleted;

    public int getId() {
        return id;
    }
    void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }
    void setName(String name) {
        this.name = name;
    }

    public Set<Product> getProducts() {
        return products;
    }
    void setProducts(Set<Product> products) {
        this.products = products;
    }

    @PrePersist
    void PrePersist() {
        isDeleted = false;
    }

    public void addProduct(Product product) {
        products.add(product);
    }
    public void removeProduct (Product product) {
        products.remove(product);
    }
}