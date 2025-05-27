package com.example.backend;

import com.example.backend.model.Event;
import com.example.backend.model.EventRegistration;
import com.example.backend.model.User;
import com.example.backend.repository.EventRegistrationRepository;
import com.example.backend.service.EventRegistrationService;
import com.example.backend.service.EventService;
import com.example.backend.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class EventRegistrationServiceTest {

    @Mock
    private EventRegistrationRepository eventRegistrationRepository;
    @Mock
    private UserService userService;
    @Mock
    private EventService eventService;

    @InjectMocks
    private EventRegistrationService service;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void shouldRegisterUserToEventSuccessfully() {
        User user = new User(); user.setId(1L);
        Event event = new Event(); event.setId(2L); event.setMaxParticipants(10);

        when(userService.getUserById(1L)).thenReturn(Optional.of(user));
        when(eventService.getEventById(2L)).thenReturn(Optional.of(event));
        when(eventRegistrationRepository.countByEventId(2L)).thenReturn(5);
        when(eventRegistrationRepository.existsByUserIdAndEventId(1L, 2L)).thenReturn(false);

        service.registerUserToEvent(1L, 2L);

        verify(eventRegistrationRepository).save(any(EventRegistration.class));
    }

    @Test
    void shouldThrowWhenUserNotFound() {
        when(userService.getUserById(1L)).thenReturn(Optional.empty());

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                service.registerUserToEvent(1L, 2L));

        assertEquals("User not found", ex.getMessage());
    }

    @Test
    void shouldThrowWhenEventNotFound() {
        User user = new User(); user.setId(1L);
        when(userService.getUserById(1L)).thenReturn(Optional.of(user));
        when(eventService.getEventById(2L)).thenReturn(Optional.empty());

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                service.registerUserToEvent(1L, 2L));

        assertEquals("Event not found", ex.getMessage());
    }

    @Test
    void shouldThrowWhenEventIsFull() {
        User user = new User(); user.setId(1L);
        Event event = new Event(); event.setId(2L); event.setMaxParticipants(2);

        when(userService.getUserById(1L)).thenReturn(Optional.of(user));
        when(eventService.getEventById(2L)).thenReturn(Optional.of(event));
        when(eventRegistrationRepository.countByEventId(2L)).thenReturn(2);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
                service.registerUserToEvent(1L, 2L));

        assertEquals("Event has reached max participants", ex.getMessage());
    }

    @Test
    void shouldThrowWhenUserAlreadyRegistered() {
        User user = new User(); user.setId(1L);
        Event event = new Event(); event.setId(2L); event.setMaxParticipants(10);

        when(userService.getUserById(1L)).thenReturn(Optional.of(user));
        when(eventService.getEventById(2L)).thenReturn(Optional.of(event));
        when(eventRegistrationRepository.countByEventId(2L)).thenReturn(1);
        when(eventRegistrationRepository.existsByUserIdAndEventId(1L, 2L)).thenReturn(true);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
                service.registerUserToEvent(1L, 2L));

        assertEquals("User is already registered for this event", ex.getMessage());
    }

    @Test
    void shouldGetAllRegistrations() {
        when(eventRegistrationRepository.findAll()).thenReturn(List.of(new EventRegistration()));
        assertEquals(1, service.getAllEventRegistrations().size());
    }

    @Test
    void shouldReturnRegistrationById() {
        EventRegistration reg = new EventRegistration();
        reg.setId(10L);
        when(eventRegistrationRepository.findById(10L)).thenReturn(Optional.of(reg));

        assertEquals(10L, service.getEventRegistrationById(10L).getId());
    }

    @Test
    void shouldReturnUserRegistrations() {
        when(eventRegistrationRepository.findByUserId(1L)).thenReturn(List.of(new EventRegistration()));
        assertEquals(1, service.getEventRegistrationsOfUser(1L).size());
    }

    @Test
    void shouldDeleteRegistrationById() {
        service.deleteEventRegistrationById(99L);
        verify(eventRegistrationRepository).deleteById(99L);
    }
}
