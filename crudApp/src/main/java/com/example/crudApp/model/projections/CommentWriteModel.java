package com.example.crudApp.model.projections;

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
        this.product = product;
    }

    public Comment toComment() {
        return new Comment(description, product);
    }
}
