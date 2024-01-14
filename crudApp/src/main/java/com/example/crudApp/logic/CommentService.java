package com.example.crudApp.logic;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.CommentRepository;
import com.example.crudApp.model.Product;
import com.example.crudApp.model.projections.CommentReadModel;
import com.example.crudApp.model.projections.CommentWriteModel;
import com.example.crudApp.model.projections.ProductReadModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class CommentService {
    private final CommentRepository repository;
    private final ProductService productService;

    @Autowired
    public CommentService(CommentRepository repository, ProductService productService) {
        this.repository = repository;
        this.productService = productService;
    }

    public List<CommentReadModel> getAllCommentsFromProduct(int id) {
        ProductReadModel product = productService.readSingleProduct(id);
        if (product == null) {
            return null;
        }
        Set<Comment> s1 = new HashSet<>(repository.findAllByDeletedIsFalse());
        Set<Comment> s2 = product.getComments();
        s2.retainAll(s1);
        List<Comment> comments = new ArrayList<>(s2);
        return comments.stream()
                .map(CommentReadModel::new)
                .collect(Collectors.toList());
    }

    public CommentReadModel getCommentById(int id, int productId) {
        if (productService.readSingleProduct(productId) == null) {
            return null;
        }
        return repository.findById(id)
                .map(CommentReadModel::new)
                .orElse(null);
    }

    public CommentReadModel createComment(CommentWriteModel comment, int id) {
        productService.assignComment(comment, id);
        Comment newComment = comment.toComment();
        repository.save(newComment);
        return new CommentReadModel(newComment);
    }

    public void deleteComment(int id) {
        Optional<Comment> toDelete = repository.findById(id);
        toDelete.ifPresent(comment -> {
            comment.remove();
            repository.save(comment);
        });
    }
}