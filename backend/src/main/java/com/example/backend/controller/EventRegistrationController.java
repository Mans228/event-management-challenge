package com.example.backend.controller;

import com.example.backend.model.EventRegistration;
import com.example.backend.service.EventRegistrationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")

public class EventRegistrationController {
    private EventRegistrationService eventRegistrationService;
    public EventRegistrationController(EventRegistrationService eventRegistrationService){
        this.eventRegistrationService = eventRegistrationService;
    }

    @PostMapping("/events/{eventId}/register")
    public void registerForEvent(@PathVariable Long eventId){

    }

    @GetMapping("/users/{userId}/registrations")
    public List<EventRegistration> getRegistrationsOfUser(@PathVariable Long userId){
        return eventRegistrationService.getEventRegistrationsOfUser(userId);
    }

}
