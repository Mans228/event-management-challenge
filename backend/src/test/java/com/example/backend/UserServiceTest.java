package com.example.backend;


import com.example.backend.model.User;
import com.example.backend.repository.UserRepository;
import com.example.backend.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this); // Initialize @Mock and @InjectMocks
    }

    @Test
    void shouldSaveUser() {
        User user = new User();
        user.setUsername("alice");

        when(userRepository.save(user)).thenReturn(user);

        User saved = userService.saveUser(user);

        assertEquals("alice", saved.getUsername());
        verify(userRepository).save(user);
    }

    @Test
    void shouldReturnAllUsers() {
        User u1 = new User(); u1.setUsername("john");
        User u2 = new User(); u2.setUsername("jane");

        when(userRepository.findAll()).thenReturn(List.of(u1, u2));

        List<User> result = userService.getAllUsers();

        assertEquals(2, result.size());
        verify(userRepository).findAll();
    }

    @Test
    void shouldReturnUserById() {
        User user = new User();
        user.setId(1L);
        user.setUsername("test");

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        Optional<User> found = userService.getUserById(1L);

        assertTrue(found.isPresent());
        assertEquals("test", found.get().getUsername());
    }

    @Test
    void shouldDeleteUserById() {
        Long userId = 99L;

        doNothing().when(userRepository).deleteById(userId);

        userService.deleteUserById(userId);

        verify(userRepository).deleteById(userId);
    }
}

