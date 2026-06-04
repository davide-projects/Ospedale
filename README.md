# 🏥 Sistema Gestione Visite Ospedaliere

Web application Java per la gestione dei medici e delle visite dei pazienti di un ospedale.

## Stack Tecnologico

- **Java 17**
- **Hibernate 6** — ORM per la persistenza dei dati
- **MySQL** — Database relazionale
- **Jakarta Servlet 6** — Layer web
- **JSTL 3** — Template engine per le JSP
- **Jetty 11** — Server embedded
- **Maven** — Gestione dipendenze e build
---

## Struttura del Progetto

```
src/
└── main/
    ├── java/
    │   └── it.ospedale/
    │       ├── dao/
    │       │   ├── MedicoDAO.java
    │       │   ├── PazienteDAO.java
    │       │   └── VisitaDAO.java
    │       ├── hibernate/
    │       │   └── HibernateUtil.java
    │       ├── model/
    │       │   ├── Medico.java
    │       │   ├── Paziente.java
    │       │   └── Visita.java
    │       ├── service/
    │       │   ├── OspedaleExecutorService.java
    │       │   └── ProcessaVisitaTask.java
    │       └── servlet/
    │           ├── MediciServlet.java
    │           ├── VisitaServlet.java
    │           └── VisiteServlet.java
    ├── resources/
    │   └── hibernate.cfg.xml
    └── webapp/
        ├── jsp/
        │   ├── medici.jsp
        │   ├── visita.jsp
        │   └── visite.jsp
        └── index.jsp
pom.xml
```
 
---

## Modello ER

```
PAZIENTI               MEDICI
--------               ------
id (PK)                id (PK)
nome                   nome
email (unique)         specializzazione
 
VISITE
------
id (PK)
paziente_id   (FK → pazienti.id)
medico_id     (FK → medici.id)
data_visita
descrizione
esito
durata_ms
medico_thread
```
 
---

## Funzionalità

- **Lista Medici** — visualizzazione di tutti i medici con filtro per specializzazione
- **Nuova Visita** — form per registrare una visita con selezione medico e paziente
- **Lista Visite** — visualizzazione di tutte le visite con ordinamento per data, paziente o medico
- **Cancellazione Visita** — eliminazione di una visita con modal di conferma per prevenire cancellazioni accidentali (pattern confirm-before-delete)
- **Validazione email** — controllo formato email sui pazienti
- **Pattern PRG** — Post-Redirect-Get per evitare il doppio submit
- **Elaborazione in background** — le visite vengono elaborate da un thread pool senza bloccare l'utente
---

## Elaborazione Visite in Background

Il sistema utilizza un `ExecutorService` per elaborare le visite in background in modo non bloccante.

### Flusso

1. L'utente inserisce una nuova visita tramite form.
2. La servlet salva immediatamente la visita nel database.
3. Un thread del pool elabora la visita in background:
    - simula la durata della visita
    - determina un esito (`OK`, `Follow-up`, `Urgente`)
    - aggiorna la visita nel database con esito, durata e nome del thread
4. L'utente viene subito reindirizzato alla lista medici, senza attendere.
### Componenti

**`it.ospedale.service.OspedaleExecutorService`**

Gestisce il pool di thread condiviso dall'applicazione:
- 3 thread fissi
- esecuzione non bloccante
- thread nominati automaticamente (`pool-1-thread-X`)
  **`it.ospedale.service.ProcessaVisitaTask`**

Task `Runnable` eseguito per ogni nuova visita:
- simula una durata casuale (1–3 secondi)
- determina un esito tra quelli previsti
- aggiorna la visita tramite Hibernate con i campi `esito`, `durata_ms` e `medico_thread`
---

## Installazione e Avvio

### Prerequisiti

- Java 17+
- Maven
- MySQL
### 1. Crea il database

```sql
CREATE DATABASE IF NOT EXISTS ospedale;
USE ospedale;
 
CREATE TABLE pazienti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);
 
CREATE TABLE medici (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    specializzazione VARCHAR(100) NOT NULL
);
 
CREATE TABLE visite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paziente_id INT NOT NULL,
    medico_id INT NOT NULL,
    data_visita DATE NOT NULL,
    descrizione TEXT,
    esito VARCHAR(255),
    durata_ms BIGINT,
    medico_thread VARCHAR(255),
    FOREIGN KEY (paziente_id) REFERENCES pazienti(id),
    FOREIGN KEY (medico_id) REFERENCES medici(id)
);
```

> Se stai aggiornando un database esistente, aggiungi le nuove colonne con:
> ```sql
> ALTER TABLE visite
>   ADD COLUMN esito VARCHAR(255),
>   ADD COLUMN durata_ms BIGINT,
>   ADD COLUMN medico_thread VARCHAR(255);
> ```

### 2. Configura le credenziali

Apri `src/main/java/it/ospedale/hibernate/HibernateUtil.java` e aggiorna:

```java
config.setProperty("hibernate.connection.password", "TUA_PASSWORD");
```

### 3. Avvia il server

```bash
mvn jetty:run
```
 
---

## URL

| Pagina | URL |
|--------|-----|
| Lista Medici | http://localhost:8080/ospedale/medici |
| Nuova Visita | http://localhost:8080/ospedale/visita |
| Lista Visite | http://localhost:8080/ospedale/visite |
 