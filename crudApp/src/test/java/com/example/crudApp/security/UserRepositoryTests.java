package com.example.crudApp.security;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class UserRepositoryTests {
    @Autowired UserRepository repo;
    @Autowired
    RoleRepository roleRepo;

    @Test
    public void createUserTest() {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        String password = passwordEncoder.encode("admin");
        String username = "admin";
        Role role = roleRepo.findByName("ADMIN");
        User user = new User(username, password, role);
        repo.save(user);

        assertThat(user).isNotNull();

        User storedUser = repo.findByUsername(user.getUsername()).orElse(null);
        assertThat(storedUser).isNotNull();
        assertThat(storedUser.getUsername()).isEqualTo(user.getUsername());
    }
}