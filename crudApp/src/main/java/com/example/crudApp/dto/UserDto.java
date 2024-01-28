package com.example.crudApp.dto;

import com.example.crudApp.model.Role;
import com.example.crudApp.model.User;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    private int id;
    @NotBlank
    private String username;
    @NotBlank
    private String password;
    @NotNull
    private Role role;

    public User toUser() {
        return new User(username, password, role);
    }

    public UserDto(User source) {
        this.id = source.getId();
        this.username = source.getUsername();
        this.password = source.getPassword();
        this.role = source.getRole();
    }
}