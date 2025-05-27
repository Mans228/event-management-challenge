package com.example.backend.controller;

import com.example.backend.model.Event;
import com.example.backend.service.EventService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController("/api/")
public class EventManagementController {
    private EventService eventService;
    public EventManagementController(EventService eventService){
        this.eventService = eventService;
    }

    @GetMapping("/events")
    public List<Event> getAllEvents(){
        return eventService.getAllEvents();
    }
    @GetMapping("/events/{id}")
    public Event getEventById(@PathVariable Long id){
        return eventService.getEventById(id);
    }
    @PostMapping("/events")
    public void createEvent(@RequestBody Event event){
        eventService.saveEvent(event);
    }
    @DeleteMapping("/events/{id}")
    public void delete(@PathVariable Long id){
        eventService.deleteEventById(id);
    }
}
