package com.example.crudApp.dto;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;

public class CommentWriteModel {
    private String description;
    private Product product;

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public Product getProduct() {
        return product;
    }
    public void setProduct(Product product) {
        if (this.product == null) {
            this.product = product;
        }
    }

    public Comment toComment() {
        return new Comment(description, product);
    }
}
