package com.example.crudApp.controller;

import com.example.crudApp.logic.CommentService;
import com.example.crudApp.logic.ProductService;
import com.example.crudApp.model.projections.CommentReadModel;
import com.example.crudApp.model.projections.CommentWriteModel;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
public class CommentController {
    private final CommentService service;

    @Autowired
    public CommentController(CommentService service, ProductService productService) {
        this.service = service;
    }

    @GetMapping(path = "/products/{id}/comments")
    public ResponseEntity<List<CommentReadModel>> readAllComments(@PathVariable int id) {
        List<CommentReadModel> comments = service.getAllCommentsFromProduct(id);
        return ResponseEntity.ok(comments);
    }

    @GetMapping(path = "products/{pId}/comments/{cId}")
    public ResponseEntity<CommentReadModel> getSingleComment(@PathVariable int pId, @PathVariable int cId) {
        CommentReadModel comment = service.getCommentById(cId, pId);
        return comment != null
                ? ResponseEntity.ok(comment)
                : ResponseEntity.notFound().build();
    }

    @PostMapping(path = "/products/{id}/comments")
    public ResponseEntity<CommentReadModel> createComment(@RequestBody @Valid CommentWriteModel toCreate, @PathVariable int id) {
        CommentReadModel createdComment = service.createComment(toCreate, id);
        return ResponseEntity.created(URI.create("/products/{id}/comments/" + createdComment.getId())).body(createdComment);
    }

    @DeleteMapping(path = "/products/{pId}/comments/{cId}")
    public ResponseEntity<?> deleteComment(@PathVariable int cId, @PathVariable int pId) {
        service.deleteComment(cId);
        return ResponseEntity.ok().build();
    }
}