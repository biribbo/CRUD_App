package com.example.crudApp.repository;

import com.example.crudApp.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoleRepository extends JpaRepository<Role, String> {
    Role save(Role role);
    Role findByName(String name);
}