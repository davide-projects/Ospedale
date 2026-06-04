
raw
Readme · MD
# 🏥 Sistema Gestione Visite Ospedaliere

Web application Java per la gestione di medici, pazienti e visite ospedaliere. Espone sia una UI tradizionale con JSP che un'API REST JSON consumata da una dashboard dinamica con aggiornamento in tempo reale via AJAX.

![Java](https://img.shields.io/badge/Java-17-blue?style=flat-square)
![Hibernate](https://img.shields.io/badge/Hibernate-6-purple?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-8-orange?style=flat-square)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-6-red?style=flat-square)
![Jetty](https://img.shields.io/badge/Jetty-11-green?style=flat-square)
![Gson](https://img.shields.io/badge/Gson-2.10-teal?style=flat-square)
![Maven](https://img.shields.io/badge/Maven-build-pink?style=flat-square)
 
---

## Indice

1. [Stack Tecnologico](#1-stack-tecnologico)
2. [Struttura del Progetto](#2-struttura-del-progetto)
3. [Modello ER](#3-modello-er)
4. [Funzionalità](#4-funzionalità)
5. [Elaborazione Visite in Background](#5-elaborazione-visite-in-background)
6. [API REST — Stato Visite](#6-api-rest--stato-visite)
7. [Dashboard Stato Visite](#7-dashboard-stato-visite)
8. [Installazione e Avvio](#8-installazione-e-avvio)
9. [URL dell'Applicazione](#9-url-dellapplicazione)
---

## 1. Stack Tecnologico

| Tecnologia | Versione | Ruolo |
|---|---|---|
| Java | 17 | Linguaggio principale |
| Hibernate | 6 | ORM per la persistenza dei dati |
| MySQL | 8 | Database relazionale |
| Jakarta Servlet | 6 | Layer web (HTTP request/response) |
| JSTL | 3 | Template engine per le JSP |
| Jetty | 11 | Server embedded (`mvn jetty:run`) |
| Gson | 2.10 | Serializzazione JSON per l'API REST |
| Maven | — | Build tool e gestione dipendenze |
 
---

## 2. Struttura del Progetto

```
src/
└── main/
    ├── java/it.ospedale/
    │   ├── api/
    │   │   ├── LocalDateAdapter.java        ← adapter Gson per LocalDate
    │   │   └── VisiteApiServlet.java         ← endpoint GET /api/visite
    │   ├── dao/
    │   │   ├── MedicoDAO.java
    │   │   ├── PazienteDAO.java
    │   │   └── VisitaDAO.java               ← include findAll()
    │   ├── hibernate/
    │   │   └── HibernateUtil.java
    │   ├── model/
    │   │   ├── Medico.java
    │   │   ├── Paziente.java
    │   │   └── Visita.java
    │   ├── service/
    │   │   ├── OspedaleExecutorService.java
    │   │   └── ProcessaVisitaTask.java
    │   ├── servlet/
    │   │   ├── MediciServlet.java
    │   │   ├── StatoVisiteServlet.java       ← serve /stato-visite
    │   │   ├── VisitaServlet.java
    │   │   └── VisiteServlet.java
    │   └── util/
    │       └── DateFormatterService.java
    ├── resources/
    │   └── hibernate.cfg.xml
    └── webapp/
        ├── js/
        │   └── stato-visite.js              ← AJAX, filtri, ordinamento
        ├── jsp/
        │   ├── medici.jsp
        │   ├── stato-visite.jsp             ← dashboard HTML
        │   ├── visita.jsp
        │   └── visite.jsp
        └── index.jsp
pom.xml
```
 
---

## 3. Modello ER

```
PAZIENTI                    MEDICI
────────                    ──────
id (PK)                     id (PK)
nome                        nome
email (UNIQUE)              specializzazione
 
VISITE
──────
id (PK)
paziente_id   FK → pazienti.id
medico_id     FK → medici.id
data_visita
descrizione
esito                       ← popolato in background (OK | Follow-up | Urgente)
durata_ms                   ← popolato in background
medico_thread               ← popolato in background
```

### Script SQL

```sql
CREATE DATABASE IF NOT EXISTS ospedale;
USE ospedale;
 
CREATE TABLE pazienti (
    id    INT AUTO_INCREMENT PRIMARY KEY,
    nome  VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);
 
CREATE TABLE medici (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    nome             VARCHAR(100) NOT NULL,
    specializzazione VARCHAR(100) NOT NULL
);
 
CREATE TABLE visite (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    paziente_id   INT NOT NULL,
    medico_id     INT NOT NULL,
    data_visita   DATE NOT NULL,
    descrizione   TEXT,
    esito         VARCHAR(255),
    durata_ms     BIGINT,
    medico_thread VARCHAR(255),
    FOREIGN KEY (paziente_id) REFERENCES pazienti(id),
    FOREIGN KEY (medico_id)   REFERENCES medici(id)
);
```

> **Aggiornamento DB esistente** — se stai aggiornando un database già popolato:
> ```sql
> ALTER TABLE visite
>   ADD COLUMN esito         VARCHAR(255),
>   ADD COLUMN durata_ms     BIGINT,
>   ADD COLUMN medico_thread VARCHAR(255);
> ```
 
---

## 4. Funzionalità

| Funzionalità | Descrizione |
|---|---|
| Lista Medici | Visualizzazione di tutti i medici con filtro per specializzazione |
| Nuova Visita | Form per registrare una visita con selezione medico e paziente |
| Lista Visite | Tabella con ordinamento per data, paziente o medico |
| Cancellazione Visita | Eliminazione con modal di conferma (pattern confirm-before-delete) |
| Validazione email | Controllo formato email sui pazienti |
| Pattern PRG | Post-Redirect-Get per evitare il doppio submit |
| Elaborazione async | Le visite vengono elaborate da un thread pool in background |
| API REST JSON | Endpoint `GET /api/visite` con risposta JSON aggiornata |
| Dashboard AJAX | Pagina `/stato-visite` con polling automatico ogni 5 secondi |
 
---

## 5. Elaborazione Visite in Background

Il sistema utilizza un `ExecutorService` per elaborare le visite in modo non bloccante, garantendo un'esperienza utente fluida.

### Flusso

1. L'utente compila e invia il form della nuova visita.
2. La servlet salva immediatamente la visita nel DB (`esito` e `durata_ms` ancora `null`).
3. Un thread del pool riceve il task e inizia l'elaborazione in background (1–3 s simulati).
4. Il thread aggiorna la visita con `esito`, `durata_ms` e `medico_thread`.
5. L'utente viene reindirizzato immediatamente alla lista medici senza attendere.
### Componenti

| Classe | Responsabilità |
|---|---|
| `OspedaleExecutorService` | Pool fisso di 3 thread; ciclo di vita legato all'applicazione |
| `ProcessaVisitaTask` | `Runnable`: simula durata, calcola esito, aggiorna DB via Hibernate |

### Esiti possibili

| Esito | Significato |
|---|---|
| `OK` | Visita completata senza problemi |
| `Follow-up` | Necessario un controllo successivo |
| `Urgente` | Richiesta attenzione immediata |
 
---

## 6. API REST — Stato Visite

### Endpoint

```
GET /ospedale/api/visite
```

### Risposta JSON

Ogni visita nell'array contiene:

| Campo | Tipo | Descrizione |
|---|---|---|
| `id` | number | Identificatore univoco |
| `dataVisita` | string | Data ISO 8601 (es. `2026-06-04`) |
| `esito` | string \| null | `OK` \| `Follow-up` \| `Urgente` \| `null` se in elaborazione |
| `durataMs` | number \| null | Durata simulata in ms (`null` se in elaborazione) |
| `medicoThread` | string | Nome del thread che ha elaborato la visita |
| `paziente` | object | `{ id, nome }` |
| `medico` | object | `{ id, nome, specializzazione }` |

### Esempio di risposta

```json
[
  {
    "id": 12,
    "dataVisita": "2026-06-04",
    "esito": "OK",
    "durataMs": 1788,
    "medicoThread": "pool-1-thread-1",
    "paziente": { "id": 3, "nome": "Mario Rossi" },
    "medico":   { "id": 1, "nome": "Dr. Bianchi", "specializzazione": "Cardiologia" }
  }
]
```

### Note tecniche

- **`LocalDateAdapter`** — Gson non supporta nativamente `LocalDate`: l'adapter in `it.ospedale.api` lo serializza in stringa ISO e viene registrato tramite `GsonBuilder`.
- **Cache** — la risposta include `Cache-Control: no-cache` per garantire dati freschi ad ogni polling.
- **Content-Type** — `application/json; charset=UTF-8`.
---

## 7. Dashboard Stato Visite

La pagina `/ospedale/stato-visite` è una dashboard dinamica che mostra lo stato di tutte le visite in tempo reale.

### Funzionalità

- ✔ Aggiornamento automatico ogni 5 secondi tramite polling AJAX (`fetch` API)
- ✔ Filtri rapidi: **Tutte — OK — Follow-up — Urgenti — In attesa** (esito `null`)
- ✔ Ordinamento cliccando su qualsiasi colonna (toggle asc/desc)
- ✔ Badge colorati per esito: 🟢 OK · 🟡 Follow-up · 🔴 Urgente · ⚫ In attesa
- ✔ Skeleton loading al primo caricamento
- ✔ Navbar unificata con tutte le altre pagine
- ✔ Contatore «N di M visite» aggiornato con il filtro attivo
### Componenti

| File | Percorso | Ruolo |
|---|---|---|
| `StatoVisiteServlet.java` | `it.ospedale.servlet/` | Forward a `stato-visite.jsp` |
| `stato-visite.jsp` | `webapp/jsp/` | Layout HTML e stili della dashboard |
| `stato-visite.js` | `webapp/js/` | Logica AJAX, filtri, ordinamento |
| `VisiteApiServlet.java` | `it.ospedale.api/` | Fornisce i dati JSON |
| `LocalDateAdapter.java` | `it.ospedale.api/` | Serializza `LocalDate` → stringa ISO |
 
---

## 8. Installazione e Avvio

### Prerequisiti

- Java 17+
- Maven 3.x
- MySQL 8+
### 1 — Crea il database

Esegui lo script SQL nella sezione [Modello ER](#3-modello-er) oppure usa il file `dati-esempio.sql` incluso nel repository.

### 2 — Configura le credenziali

In `HibernateUtil.java` aggiorna la password:

```java
config.setProperty("hibernate.connection.password", "TUA_PASSWORD");
```

### 3 — Aggiungi la dipendenza Gson

Nel `pom.xml`, dentro `<dependencies>`:

```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.10.1</version>
</dependency>
```

### 4 — Avvia il server

```bash
mvn jetty:run
```
 
---

## 9. URL dell'Applicazione

| Pagina | URL | Metodo |
|---|---|---|
| Lista Medici | `http://localhost:8080/ospedale/medici` | GET |
| Nuova Visita | `http://localhost:8080/ospedale/visita` | GET / POST |
| Lista Visite | `http://localhost:8080/ospedale/visite` | GET |
| Dashboard Stato | `http://localhost:8080/ospedale/stato-visite` | GET |
| API REST JSON | `http://localhost:8080/ospedale/api/visite` | GET |