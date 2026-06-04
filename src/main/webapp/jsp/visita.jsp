<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Inserimento Visita Medica ">
    <title>Ospedale — Nuova Visita</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: Arial, sans-serif;
            background: #f0f4f8;
            min-height: 100vh;
        }

        header {
            background: #1a3c5c;
            color: white;
            padding: 18px 0;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        header h1 { font-size: 24px; letter-spacing: 1px; }

        nav {
            background: #1565c0;
            display: flex;
            justify-content: center;
            gap: 30px;
            padding: 10px 0;
        }
        nav a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
            padding: 6px 16px;
            border-radius: 4px;
            transition: background 0.2s;
        }
        nav a:hover { background: rgba(255,255,255,0.15); }

        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 30px;
        }

        .card h2 {
            color: #1a3c5c;
            margin-bottom: 20px;
            font-size: 20px;
            border-bottom: 2px solid #e3f2fd;
            padding-bottom: 10px;
        }

        label {
            display: block;
            margin-top: 18px;
            font-weight: bold;
            color: #333;
            font-size: 14px;
        }

        select, textarea {
            width: 100%;
            padding: 10px 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            color: #333;
            transition: border-color 0.2s;
        }

        select:focus, textarea:focus {
            outline: none;
            border-color: #1565c0;
            box-shadow: 0 0 0 3px rgba(21,101,192,0.1);
        }

        textarea { height: 90px; resize: vertical; }

        .info {
            color: #525252;
            font-size: 12px;
            margin-top: 6px;
        }

        button {
            margin-top: 24px;
            width: 100%;
            padding: 12px;
            background: #1565c0;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            transition: background 0.2s;
        }
        button:hover { background: #1a3c5c; }

        .errore {
            background: #ffebee;
            border-left: 4px solid #c62828;
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 4px;
            color: #b71c1c;
            font-size: 14px;
        }
    </style>
</head>
<body>

<header>
    <h1>🏥 Sistema Gestione Ospedale</h1>
</header>

<nav>
    <a href="${pageContext.request.contextPath}/medici">👨‍⚕️ Medici</a>
    <a href="${pageContext.request.contextPath}/visite">📋 Visite</a>
    <a href="${pageContext.request.contextPath}/stato-visite">📊 Stato Visite</a>
    <a href="${pageContext.request.contextPath}/visita">➕ Nuova Visita</a>
</nav>

<main>
<div class="container">
    <div class="card">
        <h2>📋 Registra Nuova Visita</h2>

        <c:if test="${not empty param.errore}">
            <div class="errore">
                <c:choose>
                    <c:when test="${param.errore == 'campi_mancanti'}">⚠️ Compila tutti i campi del form.</c:when>
                    <c:when test="${param.errore == 'non_trovato'}">⚠️ Medico o paziente non trovato nel database.</c:when>
                    <c:when test="${param.errore == 'formato_non_valido'}">⚠️ Valore non valido inserito.</c:when>
                    <c:otherwise>⚠️ Errore durante la registrazione della visita.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/visita" method="post">

            <label for="medicoId">Medico:</label>
            <select name="medicoId" id="medicoId" required>
                <option value="">-- Seleziona un medico --</option>
                <c:forEach var="m" items="${medici}">
                    <option value="${m.id}">${m.nome} — ${m.specializzazione}</option>
                </c:forEach>
            </select>

            <label for="pazienteId">Paziente:</label>
            <select name="pazienteId" id="pazienteId" required>
                <option value="">-- Seleziona un paziente --</option>
                <c:forEach var="p" items="${pazienti}">
                    <option value="${p.id}">${p.nome} (${p.email})</option>
                </c:forEach>
            </select>

            <label for="descrizione">Descrizione:</label>
            <textarea name="descrizione" id="descrizione" required
                      placeholder="Es. Visita di controllo, dolore al petto..."></textarea>
            <p class="info">📅 La data della visita verrà impostata automaticamente a oggi.</p>

            <button type="submit">✅ Registra Visita</button>

        </form>
    </div>
</div>
<main>
</body>
</html>