package com.example.backend.controller;

import com.example.backend.model.EventRegistration;
import com.example.backend.model.User;
import com.example.backend.service.EventRegistrationService;
import com.example.backend.service.EventService;
import com.example.backend.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api")
public class EventRegistrationController {

    private final EventRegistrationService eventRegistrationService;
    private final EventService eventService;
    private final UserService userService;

    public EventRegistrationController(EventRegistrationService eventRegistrationService,
                                       EventService eventService,
                                       UserService userService) {
        this.eventRegistrationService = eventRegistrationService;
        this.eventService = eventService;
        this.userService = userService;
    }

    @PostMapping("/events/{eventId}/register")
    public ResponseEntity<String> registerForEvent(@PathVariable Long eventId,
                                                   @RequestBody User user) {
        try {
            eventRegistrationService.registerUserToEvent(user.getId(), eventId);
            return ResponseEntity.status(HttpStatus.CREATED).body("User registered for event");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }


    @GetMapping("/users/{userId}/registrations")
    public List<EventRegistration> getRegistrationsOfUser(@PathVariable Long userId) {
        return eventRegistrationService.getEventRegistrationsOfUser(userId);
    }
}