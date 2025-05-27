package com.example.backend.repository;

import com.example.backend.model.EventRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EventRegistrationRepository extends JpaRepository<EventRegistration,Long> {
    List<EventRegistration> findByUserId(Long userId);

}
