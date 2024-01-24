package com.example.crudApp.logic;

import com.example.crudApp.dto.CategoryReadModel;
import com.example.crudApp.dto.CategoryWriteModel;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
class CategoryServiceTests {
    @Autowired
    private CategoryService service;

    @Test
    public void createCategoryTest() {
        CategoryWriteModel toCreate = new CategoryWriteModel();
        toCreate.setName("Video Games");
        CategoryReadModel created = service.createCategory(toCreate);

        CategoryWriteModel toCreate2 = new CategoryWriteModel();
        toCreate2.setName("Gym Equipment");
        CategoryReadModel created2 = service.createCategory(toCreate2);

        CategoryWriteModel toCreate3 = new CategoryWriteModel();
        toCreate3.setName("PC Parts");
        CategoryReadModel created3 = service.createCategory(toCreate3);

        assertEquals(3, service.findAll(0).size());
    }
}