# Voraussetzungen für das Backend
- Java 17
- Maven
- Docker Compose

## Setup für das Backend
zum Starten der MySQL Datenbank muss man nur das Befehl ausführen
<pre>docker compose up --build </pre>
Zum Starten SpringBoot Anwendung muss das Befehl ausführen
<pre>./mvnw spring-boot:run</pre>

Wichtigste Architektur Entscheidungen:
* Layered Architecture:
  * Controller Layer: Verantwortlich für HTTP-Requests/Responses
  * Service Layer: Business Logic
  * Repository Layer: Zugriff auf die Datenbank mit Spring Data JPA
  * Model Layer: Entity Definition
* MySQL DB in Container -> schneller und einfacher in der Verwendung und leichter beim Setup für den Nutzer


Flutter App wurde aus Zeitgründen und fehlender Flutter Kenntnissen nicht abgeschlossen. Fokus lag auf der Backend-Architektur und Tests.