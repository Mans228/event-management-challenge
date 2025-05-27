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

Theoretische Fragen:
- @OneToMany bedeutet, dass eine Entity mit vielen Anderen verknüpft werden kann. In unserem Beispiel kann ein User mehrere Events haben
- @ManyToOne bedeutet umgekehrt, dass viele Entities auf ein eine gemeinsame Entity verweisen. In unserem Beispiel können viele Events denselben User als Organisator haben
- @Controller:
  Wird in traditionellen Webanwendungen verwendet, um Views (z. B. Thymeleaf, JSP) zurückzugeben.
- @RestController:
  Kombination aus @Controller + @ResponseBody. Wird verwendet für REST-APIs, gibt direkt JSON zurück.

- Wie würdest du die Performance deiner App messen? Im Backend könnte man Prometheus+Grafana anwenden
- Wie würdest du das Testing der App verbessern, wenn du mehr Zeit investieren
  würdest ? Mehr Integrationstests, MockMvc mit Testcontainers, um echte DB zu simulieren