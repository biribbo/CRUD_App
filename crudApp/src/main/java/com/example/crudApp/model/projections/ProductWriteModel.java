package com.example.crudApp.model.projections;
import com.example.crudApp.model.Category;
import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import java.util.Set;

public class ProductWriteModel {
    private String title;
    private String description;
    private String imageUrl;
    private Set<Comment> comments;
    private Category category;

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Set<Comment> getComments() {
        return comments;
    }
    public void setComments(Set<Comment> comments) {
        this.comments = comments;
    }

    public Category getCategory() {
        return category;
    }
    public void setCategory(Category category) {
        this.category = category;
    }

    public Product toProduct() {
        return new Product(title, description, imageUrl, comments, category);
    }
}