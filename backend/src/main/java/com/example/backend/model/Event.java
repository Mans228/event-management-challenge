package com.example.backend.model;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.Date;
@Entity
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    private String description;
    private LocalDate date;
    private String location;
    private int maxParticipants;
    @ManyToOne
    @JoinColumn(name = "organizer_id")
    private User organizer;
}
