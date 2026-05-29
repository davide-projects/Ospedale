<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Ospedale — Visite</title>
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
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .card-header {
            padding: 16px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header h2 { color: #1a3c5c; font-size: 18px; }
        .card-header span { font-size: 13px; color: #666; }

        /* ORDINAMENTO */
        .ordina-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            padding: 14px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e0e0e0;
            align-items: center;
        }
        .ordina-bar span { font-size: 13px; color: #666; margin-right: 4px; }
        .ordina-bar a {
            padding: 5px 14px;
            background: #e3f2fd;
            color: #1565c0;
            border-radius: 20px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            transition: background 0.2s;
        }
        .ordina-bar a:hover { background: #1565c0; color: white; }
        .ordina-bar a.attivo { background: #1565c0; color: white; }

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

        .badge-medico {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            background: #e3f2fd;
            color: #1565c0;
        }

        .badge-paziente {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            background: #e8f5e9;
            color: #2e7d32;
        }

        .empty {
            text-align: center;
            color: #999;
            padding: 40px;
            font-style: italic;
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
    <a href="${pageContext.request.contextPath}/visita">➕ Nuova Visita</a>
</nav>

<div class="container">
    <div class="card">

        <div class="card-header">
            <h2>📋 Lista Visite</h2>
            <span>${totale} visite registrate</span>
        </div>

        <div class="ordina-bar">
            <span>Ordina per:</span>
            <a href="${pageContext.request.contextPath}/visite?ordina=data_desc"
               class="${ordinamento == 'data_desc' || ordinamento == null ? 'attivo' : ''}">
                📅 Data ↓
            </a>
            <a href="${pageContext.request.contextPath}/visite?ordina=data_asc"
               class="${ordinamento == 'data_asc' ? 'attivo' : ''}">
                📅 Data ↑
            </a>
            <a href="${pageContext.request.contextPath}/visite?ordina=paziente"
               class="${ordinamento == 'paziente' ? 'attivo' : ''}">
                👤 Paziente
            </a>
            <a href="${pageContext.request.contextPath}/visite?ordina=medico"
               class="${ordinamento == 'medico' ? 'attivo' : ''}">
                👨‍⚕️ Medico
            </a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Data</th>
                    <th>Paziente</th>
                    <th>Medico</th>
                    <th>Descrizione</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="v" items="${visite}">
                    <tr>
                        <td>${v.id}</td>
                        <td>${v.dataVisita}</td>
                        <td><span class="badge-paziente">👤 ${v.paziente.nome}</span></td>
                        <td><span class="badge-medico">👨‍⚕️ ${v.medico.nome}</span></td>
                        <td>${v.descrizione}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty visite}">
                    <tr><td colspan="5" class="empty">Nessuna visita registrata.</td></tr>
                </c:if>
            </tbody>
        </table>

    </div>
</div>

</body>
</html>