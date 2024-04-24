package com.example.crudApp.dto;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CommentWriteModel {
    @NotBlank
    private String description;
    public Comment toComment() {
        return new Comment(description);
    }
}