package com.example.crudApp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.util.Set;

@Entity
public class Category {
    @Id
    private int id;
    @NotBlank
    private String name;
    //@OneToMany(mappedBy = "category")
    //Set<Product> products;
}
