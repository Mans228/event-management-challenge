package com.example.backend.service;

import com.example.backend.model.Event;
import com.example.backend.model.EventRegistration;
import com.example.backend.model.User;
import com.example.backend.repository.EventRegistrationRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class EventRegistrationService {
    private final EventRegistrationRepository eventRegistrationRepository;
    private final UserService userService;
    private final EventService eventService;

    public EventRegistrationService(EventRegistrationRepository eventRegistrationRepository,
                                    UserService userService,
                                    EventService eventService){
        this.eventRegistrationRepository = eventRegistrationRepository;
        this.userService = userService;
        this.eventService = eventService;
    }

    public EventRegistration saveEventRegistration(EventRegistration eventRegistration){
        return eventRegistrationRepository.save(eventRegistration);
    }
    public List<EventRegistration> getAllEventRegistrations() {
        return eventRegistrationRepository.findAll();
    }
    public EventRegistration getEventRegistrationById(Long id) {
        return eventRegistrationRepository.findById(id).orElse(null);
    }

    public void deleteEventRegistrationById(Long id) {
        eventRegistrationRepository.deleteById(id);
    }
    public List<EventRegistration> getEventRegistrationsOfUser(Long id){
        return eventRegistrationRepository.findByUserId(id);
    }

    public void registerUserToEvent(Long userId, Long eventId) {
        User user = userService.getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Event event = eventService.getEventById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found"));

        // Count current registrations
        int currentRegistrations = eventRegistrationRepository.countByEventId(eventId);
        if (currentRegistrations >= event.getMaxParticipants()) {
            throw new IllegalStateException("Event has reached max participants");
        }

        // Optional: Prevent duplicate registration
        boolean alreadyRegistered = eventRegistrationRepository.existsByUserIdAndEventId(userId, eventId);
        if (alreadyRegistered) {
            throw new IllegalStateException("User is already registered for this event");
        }

        EventRegistration registration = new EventRegistration();
        registration.setUser(user);
        registration.setEvent(event);
        registration.setRegistrationDate(LocalDate.now());

        eventRegistrationRepository.save(registration);
    }



}
