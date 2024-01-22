package com.example.crudApp.security;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDto {
    @NotBlank
    private String username;
    @NotBlank
    private String password;
    @NotNull
    private Role role;

    public User toUser() {
        return new User(username, password, role);
    }

    public UserDto() {}

    public UserDto(User source) {
        this.password = source.getPassword();
        this.role = source.getRole();
    }
}