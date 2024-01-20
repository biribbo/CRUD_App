package com.example.crudApp.dto;
import com.example.crudApp.model.Category;
import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;

@Getter
@Setter
public class ProductWriteModel {
    @NotBlank
    private String title;
    @NotBlank
    private String description;
    private String imageUrl;

    public Product toProduct() {
        return new Product(title, description, imageUrl);
    }
}