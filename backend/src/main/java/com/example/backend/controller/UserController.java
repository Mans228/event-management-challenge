package com.example.backend.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController("/api/users")
public class UserController {

    @PostMapping("/register")
    public void register(){

    }

    @PostMapping("/login")
    public void login(){

    }
}
