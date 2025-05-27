package com.example.backend.service;

import com.example.backend.model.Event;
import com.example.backend.model.EventRegistration;
import com.example.backend.repository.EventRegistrationRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class EventRegistrationService {
    private final EventRegistrationRepository eventRegistrationRepository;

    public EventRegistrationService(EventRegistrationRepository eventRegistrationRepository){
        this.eventRegistrationRepository = eventRegistrationRepository;
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

}
