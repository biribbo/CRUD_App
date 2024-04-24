package com.example.crudApp.model;

import com.example.crudApp.model.User;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;

import java.util.Set;

@Entity
public class Role {
    @Id
    private String name;
    private String description;
    @OneToMany
    private Set<User> users;

    public Role() {}
    public Role(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public Role(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return this.name;
    }
}