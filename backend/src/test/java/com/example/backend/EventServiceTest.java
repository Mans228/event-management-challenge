package com.example.backend;

import com.example.backend.model.Event;
import com.example.backend.repository.EventRepository;
import com.example.backend.service.EventService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class EventServiceTest {

    @Mock
    private EventRepository eventRepository;

    @InjectMocks
    private EventService eventService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void shouldSaveEvent() {
        Event event = new Event();
        event.setTitle("Test Event");

        when(eventRepository.save(event)).thenReturn(event);

        Event saved = eventService.saveEvent(event);

        assertEquals("Test Event", saved.getTitle());
        verify(eventRepository).save(event);
    }

    @Test
    void shouldReturnAllEvents() {
        Event e1 = new Event(); e1.setTitle("E1");
        Event e2 = new Event(); e2.setTitle("E2");

        when(eventRepository.findAll()).thenReturn(List.of(e1, e2));

        List<Event> result = eventService.getAllEvents();

        assertEquals(2, result.size());
        verify(eventRepository).findAll();
    }

    @Test
    void shouldReturnEventById() {
        Event event = new Event();
        event.setId(1L);
        event.setTitle("Event 1");

        when(eventRepository.findById(1L)).thenReturn(Optional.of(event));

        Optional<Event> found = eventService.getEventById(1L);

        assertTrue(found.isPresent());
        assertEquals("Event 1", found.get().getTitle());
    }

    @Test
    void shouldDeleteEventById() {
        Long eventId = 1L;

        doNothing().when(eventRepository).deleteById(eventId);

        eventService.deleteEventById(eventId);

        verify(eventRepository).deleteById(eventId);
    }
}
