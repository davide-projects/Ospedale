<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Ospedale — Stato Visite</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: Arial, sans-serif;
            background: #f0f4f8;
            min-height: 100vh;
        }

        /* HEADER */
        header {
            background: #1a3c5c;
            color: white;
            padding: 18px 0;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        header h1 { font-size: 24px; letter-spacing: 1px; }

        /* NAV */
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

        /* CARD */
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-top: 30px;
        }

        /* INFO BAR */
        .info-bar {
            padding: 10px 20px;
            font-size: 13px;
            color: #666;
            border-bottom: 1px solid #e0e0e0;
            background: #fafafa;
        }

        /* TABELLA */
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #1565c0;
            color: white;
            padding: 13px 20px;
            text-align: left;
            font-size: 14px;
        }
        td {
            padding: 12px 20px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
            color: #333;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #e8f4fd; }

        .empty { text-align: center; color: #999; padding: 30px; font-style: italic; }
    </style>
</head>

<body>

<header>
    <h1>🏥<strong> Sistema Gestione Ospedale </strong</h1>
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

        <div class="info-bar">
            Stato aggiornato delle visite — aggiornamento automatico ogni 5 secondi
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Paziente</th>
                <th>Medico</th>
                <th>Data</th>
                <th>Esito</th>
                <th>Durata (ms)</th>
                <th>Thread</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="v" items="${visite}">
                <tr>
                    <td><strong>${v.id}</strong></td>
                    <td>${v.paziente.nome}</td>
                    <td>${v.medico.nome}</td>
                    <td>${v.dataVisita}</td>

                    <td>
                        <c:choose>
                            <c:when test="${v.esito == 'OK'}">
                                <span class="badge bg-success">OK</span>
                            </c:when>
                            <c:when test="${v.esito == 'Follow-up'}">
                                <span class="badge bg-warning text-dark">Follow-up</span>
                            </c:when>
                            <c:when test="${v.esito == 'Urgente'}">
                                <span class="badge bg-danger">Urgente</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">In attesa</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>${v.durataMs}</td>
                    <td>${v.medicoThread}</td>
                </tr>
            </c:forEach>

            <c:if test="${empty visite}">
                <tr><td colspan="7" class="empty">Nessuna visita trovata.</td></tr>
            </c:if>

            </tbody>
        </table>

    </div>
</div>
</main>

</body>
</html>
