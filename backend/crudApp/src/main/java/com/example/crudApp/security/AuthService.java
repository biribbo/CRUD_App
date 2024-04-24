package com.example.crudApp.security;

import com.example.crudApp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

@Service
public class AuthService {
    private final UserRepository repo;
    private final JwtTokenUtil jwtUtils;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;

    @Autowired
    public AuthService(UserRepository repo, JwtTokenUtil jwtUtils, PasswordEncoder passwordEncoder, AuthenticationManager authenticationManager) {
        this.repo = repo;
        this.jwtUtils = jwtUtils;
        this.passwordEncoder = passwordEncoder;
        this.authenticationManager = authenticationManager;
    }

    public AuthResponse login(AuthRequest request){
        AuthResponse response = new AuthResponse();
        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword()));
            var user = repo.findByUsername(request.getUsername())
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));
            System.out.println("USER IS: " + user);
            var jwt = jwtUtils.generateToken(user);
            var refreshToken = jwtUtils.generateRefreshToken(new HashMap<>(), user);
            response.setAccessToken(jwt);
            response.setRefreshToken(refreshToken);
            response.setMessage("Successfully Signed In");
            response.setUsername(user.getUsername());
            response.setAuthorities(new String[]{user.getRole().toString()});
        } catch (Exception e){
            System.out.println("error " + e.getMessage());
            return null;
        }
        return response;
    }
}
