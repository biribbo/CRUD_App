package com.example.crudApp.security;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;

@Getter
@Setter
public class AuthRequest {
    @NotNull
    private String username;

    @NotNull
    @Length(min = 5, max = 10)
    private String password;
}