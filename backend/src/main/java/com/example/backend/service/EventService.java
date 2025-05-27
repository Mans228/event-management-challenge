package com.example.backend.service;

import com.example.backend.model.Event;
import com.example.backend.model.User;
import com.example.backend.repository.EventRepository;

public class EventService {
    private EventRepository eventRepository;

    public EventService(EventRepository eventRepository){
        this.eventRepository = eventRepository;
    }

    public Event saveEvent(Event event){
        return eventRepository.save(event);
    }
    public Iterable<Event> getAllEvents() {
        return eventRepository.findAll();
    }
    public Event getEventById(Long id) {
        return eventRepository.findById(id).orElse(null);
    }

    public void deleteEventById(Long id) {
        eventRepository.deleteById(id);
    }
}
