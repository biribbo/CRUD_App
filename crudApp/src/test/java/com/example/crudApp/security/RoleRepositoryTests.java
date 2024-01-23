package com.example.crudApp.security;

import com.example.crudApp.model.Role;
import com.example.crudApp.repository.RoleRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class RoleRepositoryTests {
    @Autowired
    private RoleRepository repository;

    @Test
    public void testCreateRoles() {
        Role admin = new Role("ADMIN", "Deleted products, edits users.");
        Role user = new Role("USER", "Adds new products, comments and categories. Edits their own comments.");

        repository.save(admin);
        repository.save(user);

        long count = repository.count();
        assertEquals(2, count);
    }
}