package com.example.crudApp.logic;

import com.example.crudApp.dto.CommentReadModel;
import com.example.crudApp.dto.CommentWriteModel;
import com.example.crudApp.model.Product;
import com.example.crudApp.repository.CommentRepository;
import com.example.crudApp.repository.ProductRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class CommentServiceTests {
    @Autowired
    private CommentService service;
    @Autowired
    private CommentRepository repo;
    @Autowired
    private ProductRepository productRepo;

    @Test
    public void createCommentTest() {
        Product product21 = productRepo.findById(21)
                .orElse(null);
        Product product23 = productRepo.findById(23)
                .orElse(null);
        Product product24 = productRepo.findById(24)
                .orElse(null);

        CommentWriteModel toCreate1 = new CommentWriteModel("first comment of product 21");
        CommentWriteModel toCreate2 = new CommentWriteModel("second comment of product 21");
        CommentWriteModel toCreate3 = new CommentWriteModel("first comment of product 23");
        CommentWriteModel toCreate4 = new CommentWriteModel("first comment of product 24");

        CommentReadModel comm1 = service.createComment(toCreate1, 21);
        CommentReadModel comm2 = service.createComment(toCreate2, 21);
        CommentReadModel comm3 = service.createComment(toCreate3, 23);
        CommentReadModel comm4 = service.createComment(toCreate4, 24);

        assertThat(product21.getComments().size()).isEqualTo(2);
        assertThat(product23.getComments().size()).isEqualTo(1);
        assertThat(product24.getComments().size()).isEqualTo(1);

        assertThat(comm1.getProductId()).isEqualTo(21);
        assertThat(comm2.getProductId()).isEqualTo(21);
        assertThat(comm3.getProductId()).isEqualTo(23);
        assertThat(comm4.getProductId()).isEqualTo(24);
    }

    @Test
    public void neverMind() {
        CommentWriteModel toCreate = new CommentWriteModel("test comment");
        service.createComment(toCreate, 44);

        Product testProduct = productRepo.findById(44)
                .orElse(null);

        System.out.println(testProduct.getComments());
        assertThat(testProduct.getComments().size()).isEqualTo(5);
    }

    @Test
    public void readTest() {
        List<CommentReadModel> comments = service.getAllCommentsFromProduct(21);

        assertThat(comments.size()).isEqualTo(2);
    }

    @Test
    public void readWithDeletedTest() {
        List<CommentReadModel> comments1 = service.getAllCommentsFromProductWithDeleted(21);
        List<CommentReadModel> comments2 = service.getAllCommentsFromProductWithDeleted(44);

        assertThat(comments1.size()).isEqualTo(2);
        assertThat(comments2.size()).isEqualTo(5);
    }

    @Test
    public void updateTest() {
        CommentWriteModel toUpdate1 = new CommentWriteModel("first comment of product 21 - all tests passed");
        CommentReadModel updated = service.updateCooment(toUpdate1, 202,21);

        assertThat(updated.getDescription()).isEqualTo(toUpdate1.getDescription());
    }
}