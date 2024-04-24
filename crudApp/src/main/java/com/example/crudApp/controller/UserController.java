package com.example.crudApp.controller;

import com.example.crudApp.dto.UserDto;
import com.example.crudApp.logic.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping(path = "/users")
public class UserController {
    private final UserService service;

    @Autowired
    public UserController(UserService service) {
        this.service = service;
    }

    @PostMapping
    ResponseEntity<UserDto> createUser (@RequestBody @Valid UserDto toCreate) {
        UserDto user = service.createUser(toCreate);
        return ResponseEntity.created(URI.create("/users/" + user.getUsername())).body(user);
    }

    @PutMapping(path = "/{name}")
    //@RolesAllowed({"ADMIN"})
    ResponseEntity<UserDto> editUser (@RequestBody @Valid UserDto toCreate, @PathVariable String name) {
        UserDto user = service.editUser(toCreate, name);
        return user != null
                ? ResponseEntity.ok(user)
                : ResponseEntity.notFound().build();
    }

    @GetMapping(path = "/{role}")
    ResponseEntity<List<UserDto>> readUsersByRole (@PathVariable String role) {
        return ResponseEntity.ok(service.readAllByRole(role));
    }
}