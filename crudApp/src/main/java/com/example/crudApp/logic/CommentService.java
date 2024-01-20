package com.example.crudApp.logic;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import com.example.crudApp.repository.CommentRepository;
import com.example.crudApp.dto.CommentReadModel;
import com.example.crudApp.dto.CommentWriteModel;
import com.example.crudApp.dto.ProductReadModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class CommentService {
    public static final int PAGE_SIZE = 10;
    private final CommentRepository repository;
    private final ProductService productService;

    @Autowired
    public CommentService(CommentRepository repository, ProductService productService) {
        this.repository = repository;
        this.productService = productService;
    }

    public List<CommentReadModel> getAllCommentsFromProduct(int id, int page) {
        Product product = productService.getAllCommentsFromProduct(id);
        if (product == null) {
            return null;
        }
        List<Comment> comments = repository.findAllByIsDeletedIsFalseAndProduct(PageRequest.of(page, PAGE_SIZE), product);
        return comments.stream()
                .map(CommentReadModel::new)
                .collect(Collectors.toList());
    }

    public List<CommentReadModel> getAllCommentsFromProductWithDeleted(int id, int page) {
        Product gotProduct = productService.getAllCommentsFromProduct(id);
        if (gotProduct == null) {
            return null;
        }
        List<Comment> comments = repository.findAllByProduct(PageRequest.of(page, PAGE_SIZE), gotProduct);
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

    public CommentReadModel createComment(CommentWriteModel comment, int pid) {
        Comment newComment = comment.toComment();
        repository.save(newComment);
        try {
            productService.addCommentToSet(newComment, pid);
            repository.save(newComment);
        } catch (NullPointerException e) {
            e.getMessage();
            return null;
        }
        return new CommentReadModel(newComment);
    }

    public void deleteComment(int id) {
        Optional<Comment> toDelete = repository.findById(id);
        toDelete.ifPresent(comment -> {
            comment.remove();
            repository.save(comment);
        });
    }

    public CommentReadModel updateCooment(CommentWriteModel comment, int cId, int pId) {
        if ((productService.readSingleProduct(pId) == null) || (repository.findById(cId).isEmpty())) {
            return null;
        }
        Comment source = comment.toComment();
        Comment destination = repository.findById(cId)
                .orElse(null);
        try {
            destination.update(source);
        } catch (IllegalStateException e) {
            System.out.println("Cannot update comment " + cId);
        }
        repository.save(destination);
        return new CommentReadModel(destination);
    }
}