package com.example.crudApp.security;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AuthController {

    private final AuthService service;

    @Autowired
    public AuthController(AuthService service) {
        this.service = service;
    }

    @PostMapping("/auth/login")
    //@RolesAllowed({"ADMIN", "USER"})
    public ResponseEntity<?> login(@RequestBody @Valid AuthRequest request) {
        return service.login(request) != null
                ? ResponseEntity.ok(service.login(request))
                : ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
}