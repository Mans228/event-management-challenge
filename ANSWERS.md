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

- Flutter Widget Lifecycle 
  StatelessWidget:
  Kein Lifecycle – build() wird einmalig aufgerufen, danach nur bei Änderungen des Parents neu aufgebaut.

  StatefulWidget Lifecycle:

  createState() → Erstellt das zugehörige State-Objekt.

  initState() → Wird einmal beim Start aufgerufen.

  build() → Baut das UI, kann mehrfach aufgerufen werden.

  didUpdateWidget() → Bei Änderung von Widget-Parametern.

  dispose() → Bei Entfernen des Widgets – Ressourcen hier aufräumen.

- State Management: Welche Libraries und warum?
  Empfohlen:

  Provider:
  Einfach, im Flutter SDK empfohlen, ideal für kleine & mittlere Projekte.

  Alternativen:

  Riverpod:
  Sicherer als Provider, kein BuildContext nötig.

  Bloc/Cubit:
  Besser für komplexe Business-Logik & größere Projekte (z. B. Event-basierte Architektur).
- StatelessWidget vs StatefulWidget
  StatelessWidget kann Zustand nicht speicher und StatefulWidget speichert Zustand im State-Objekt<br />
  StatelessWidget ist jedoch leichtgewichtiger und schneller und Stateful durch State-Handlinh schwerer <br />
  Stateless wird daher eher im UI mit reinem Input verwendet und Stateful im interaktiven UI

  