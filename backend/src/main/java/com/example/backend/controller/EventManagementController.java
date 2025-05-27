package com.example.backend.controller;

import com.example.backend.model.Event;
import com.example.backend.service.EventService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class EventManagementController {
    private final EventService eventService;
    public EventManagementController(EventService eventService){
        this.eventService = eventService;
    }

    @GetMapping("/events")
    public List<Event> getAllEvents(){
        return eventService.getAllEvents();
    }
    @GetMapping("/events/{id}")
    public ResponseEntity<Event> getEventById(@PathVariable Long id) {
        return eventService.getEventById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/events")
    public ResponseEntity<Event> createEvent(@Valid @RequestBody Event event){
        Event created = eventService.saveEvent(event);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
    @DeleteMapping("/events/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        eventService.deleteEventById(id);
        return ResponseEntity.noContent().build();
    }
}
