package com.example.backend.service;

import com.example.backend.model.Event;
import com.example.backend.model.EventRegistration;
import com.example.backend.repository.EventRegistrationRepository;

public class EventRegistrationService {
    private EventRegistrationRepository eventRegistrationRepository;

    public EventRegistrationService(EventRegistrationRepository eventRegistrationRepository){
        this.eventRegistrationRepository = eventRegistrationRepository;
    }

    public EventRegistration saveEventRegistration(EventRegistration eventRegistration){
        return eventRegistrationRepository.save(eventRegistration);
    }
    public Iterable<EventRegistration> getAllEventRegistrations() {
        return eventRegistrationRepository.findAll();
    }
    public EventRegistration getEventRegistrationById(Long id) {
        return eventRegistrationRepository.findById(id).orElse(null);
    }

    public void deleteEventRegistrationById(Long id) {
        eventRegistrationRepository.deleteById(id);
    }

}
