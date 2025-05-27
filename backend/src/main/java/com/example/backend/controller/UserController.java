package com.example.backend.controller;

import com.example.backend.model.User;
import com.example.backend.service.UserService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController("/api/users")
public class UserController {
    private UserService userService;

    public UserController(UserService userService){
        this.userService = userService;
    }
    @PostMapping("/register")
    public void register(@RequestBody User user){
        userService.saveUser(user);
    }

    @PostMapping("/login")
    public void login(User user){
    }
}
