package com.example.backend.service;

import com.example.backend.model.Event;
import com.example.backend.model.EventRegistration;
import com.example.backend.repository.EventRegistrationRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class EventRegistrationService {
    private EventRegistrationRepository eventRegistrationRepository;

    public EventRegistrationService(EventRegistrationRepository eventRegistrationRepository){
        this.eventRegistrationRepository = eventRegistrationRepository;
    }

    public EventRegistration saveEventRegistration(EventRegistration eventRegistration){
        return eventRegistrationRepository.save(eventRegistration);
    }
    public Iterable<EventRegistration> getAllEventRegistrations() {
        List<EventRegistration> eventRegistrations = new ArrayList<>();
        eventRegistrationRepository.findAll().forEach(eventRegistrations::add);
        return eventRegistrations;
    }
    public EventRegistration getEventRegistrationById(Long id) {
        return eventRegistrationRepository.findById(id).orElse(null);
    }

    public void deleteEventRegistrationById(Long id) {
        eventRegistrationRepository.deleteById(id);
    }

}
