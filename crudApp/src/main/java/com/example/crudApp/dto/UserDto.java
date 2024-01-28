package com.example.crudApp.dto;

import com.example.crudApp.model.Role;
import com.example.crudApp.model.User;
import com.example.crudApp.repository.RoleRepository;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;

@Getter
@Setter
@NoArgsConstructor
public class UserDto {
    private int id;
    @NotBlank
    private String username;
    @NotBlank
    private String password;
    private Role role;
    private String roleName;

    public UserDto(String username, String password, String roleName) {
        this.username = username;
        this.password = password;
        this.roleName = roleName;
    }

    public User toUser() {
        return new User(username, password, role);
    }

    public UserDto(User source) {
        this.id = source.getId();
        this.username = source.getUsername();
        this.password = source.getPassword();
        this.role = source.getRole();
        this.roleName = source.getRole().toString();
    }
}