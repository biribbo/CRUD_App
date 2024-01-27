package com.example.crudApp.logic;

import com.example.crudApp.model.Comment;
import com.example.crudApp.model.Product;
import com.example.crudApp.repository.CommentRepository;
import com.example.crudApp.dto.CommentReadModel;
import com.example.crudApp.dto.CommentWriteModel;
import com.example.crudApp.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class CommentService {
    private final CommentRepository repository;
    private final ProductRepository productRepository;

    @Autowired
    public CommentService(CommentRepository repository, ProductRepository productRepository) {
        this.repository = repository;
        this.productRepository = productRepository;
    }

    public List<CommentReadModel> getAllCommentsFromProduct(int id) {
        Product product = productRepository.findById(id)
                .orElse(null);
        if (product == null) {
            return null;
        }
        List<Comment> comments = repository.findAllByIsDeletedIsFalseAndProduct(product);
        return comments.stream()
                .map(CommentReadModel::new)
                .collect(Collectors.toList());
    }

    public List<CommentReadModel> getAllCommentsFromProductWithDeleted(int id) {
        Product product = productRepository.findById(id)
                .orElse(null);
        if (product == null) {
            return null;
        }
        List<Comment> comments = repository.findAllByProduct(product);
        return comments.stream()
                .map(CommentReadModel::new)
                .collect(Collectors.toList());
    }

    public CommentReadModel getCommentById(int id, int productId) {
        Product product = productRepository.findById(productId)
                .orElse(null);
        if (product == null) {
            return null;
        }
        return repository.findById(id)
                .map(CommentReadModel::new)
                .orElse(null);
    }

    @Transactional
    public CommentReadModel createComment(CommentWriteModel comment, int pid) {
        Product product = productRepository.findById(pid)
                .orElse(null);
        if (product == null) {
            return null;
        }
        Comment newComment = comment.toComment();
        repository.save(newComment);
        product.addComment(newComment);
        System.out.println(product.getComments());
        productRepository.save(product);
        System.out.println(product.getComments());
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

    public CommentReadModel updateCooment(CommentWriteModel comment, int cId, int pId) {
        Product product = productRepository.findById(pId)
                .orElse(null);
        if (product == null || !repository.existsById(cId)) {
            return null;
        }
        Comment source = comment.toComment();
        Comment destination = repository.findById(cId)
                .orElse(null);
        destination.update(source);
        repository.save(destination);
        return new CommentReadModel(destination);
    }
}