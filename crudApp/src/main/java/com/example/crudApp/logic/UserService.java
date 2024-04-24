package com.example.crudApp.logic;

import com.example.crudApp.dto.UserDto;
import com.example.crudApp.model.Role;
import com.example.crudApp.model.User;
import com.example.crudApp.repository.RoleRepository;
import com.example.crudApp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserService {

    private final UserRepository repo;
    private final RoleRepository roleRepo;

    @Autowired
    public UserService(UserRepository repo, RoleRepository roleRepo) {
        this.repo = repo;
        this.roleRepo = roleRepo;
    }

    public UserDto createUser(UserDto toCreate) {
        String name = toCreate.getRoleName();
        Role role = roleRepo.findByName(name);
        toCreate.setRole(role);
        User newUser = toCreate.toUser();
        repo.save(newUser);
        return new UserDto(newUser);
    }

    public UserDto editUser(UserDto source, String username) {
        User toUpdate = repo.findByUsername(username)
                .orElse(null);
        User sourceUser = source.toUser();
        toUpdate.update(sourceUser);
        repo.save(toUpdate);
        return new UserDto(toUpdate);
    }

    public List<UserDto> readAllByRole(String name) {
        Role role = roleRepo.findByName(name);
        if (role == null) {
            return null;
        }
        List<User> users = repo.findAllByRole(role);
        return users.stream()
                .map(UserDto::new)
                .collect(Collectors.toList());
    }
}
