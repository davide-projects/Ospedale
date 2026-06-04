<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
        <meta name="description" content="Elenco dei medici dell'Ospedale: nomi, specializzazioni e gestione anagrafica. Consultazione rapida e sistema intuitivo per organizzare il personale medico.">
    <title>Ospedale — Medici</title>
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

        /* CONTENUTO CENTRATO */
        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        /* MESSAGGIO SUCCESSO */
        .successo {
            background: #e3f2fd;
            border-left: 4px solid #1565c0;
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 4px;
            color: #0d47a1;
            font-weight: bold;
        }

        /* CARD CONTENITORE */
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        /* FILTRI */
        .filtri-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            padding: 16px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e0e0e0;
            align-items: center;
        }
        .filtri-bar span { font-size: 13px; color: #666; margin-right: 4px; }
        .filtri-bar a {
            padding: 5px 14px;
            background: #1565c0;
            color: white;
            border-radius: 20px;
            text-decoration: none;
            font-size: 13px;
            transition: background 0.2s;
        }
        .filtri-bar a:hover { background: #1a3c5c; }
        .filtri-bar a.attivo { background: #1a3c5c; }

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

        /* BADGE SPECIALIZZAZIONE */
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            background: #e3f2fd;
            color: #1565c0;
        }

        .empty { text-align: center; color: #999; padding: 30px; font-style: italic; }
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

    <c:if test="${param.messaggio == 'visita_creata'}">
        <div class="successo">✅ Visita registrata correttamente!</div>
    </c:if>

    <div class="card">

        <div class="filtri-bar">
            <span>Filtra:</span>
            <a href="${pageContext.request.contextPath}/medici">Tutti</a>
            <a href="${pageContext.request.contextPath}/medici?specializzazione=Cardiologia">Cardiologia</a>
            <a href="${pageContext.request.contextPath}/medici?specializzazione=Ortopedia">Ortopedia</a>
            <a href="${pageContext.request.contextPath}/medici?specializzazione=Neurologia">Neurologia</a>
            <a href="${pageContext.request.contextPath}/medici?specializzazione=Pediatria">Pediatria</a>
        </div>

        <div class="info-bar">
            <strong>${filtro}</strong> — ${totale} medici trovati
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Specializzazione</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${medici}">
                    <tr>
                        <td>${m.id}</td>
                        <td><strong>${m.nome}</strong></td>
                        <td><span class="badge">${m.specializzazione}</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty medici}">
                    <tr><td colspan="3" class="empty">Nessun medico trovato.</td></tr>
                </c:if>
            </tbody>
        </table>

    </div>
</div>
</main>
</body>
</html>