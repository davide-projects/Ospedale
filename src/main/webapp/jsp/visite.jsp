<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Gestione delle visite mediche: elenco completo, pazienti, medici, date e descrizioni delle visite registrate. Sistema semplice, veloce e intuitivo.">
    <title>Ospedale — Visite</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JS personalizzato -->
    <script src="${pageContext.request.contextPath}/js/modal.js"></script>

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

        .btn-elimina {
            background: none;
            border: 1px solid #e53935;
            color: #e53935;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
        }
        .btn-elimina:hover {
            background: #e53935;
            color: white;
        }
    </style>
</head>
<body>

<header>
    <h1>🏥 <strong> Sistema Gestione Ospedale </strong></h1>
</header>
<nav>
    <a href="${pageContext.request.contextPath}/medici">👨‍⚕️ Medici</a>
    <a href="${pageContext.request.contextPath}/visite">📋 Visite</a>
    <a href="${pageContext.request.contextPath}/visita">➕ Nuova Visita</a>
</nav>

<main>

<div class="container">
    <div class="card">

        <div class="card-header">
            <h2>📋<strong> Lista Visite </strong></h2>
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
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="v" items="${visite}">
                <tr>
                    <td>${v.id}</td>
                    <td>${v.dataFormattata}</td>
                    <td><span class="badge-paziente">👤 ${v.paziente.nome}</span></td>
                    <td><span class="badge-medico">👨‍⚕️ ${v.medico.nome}</span></td>
                    <td>${v.descrizione}</td>
                    <td>
                        <form method="post"
                              action="${pageContext.request.contextPath}/visite"
                              onsubmit="event.preventDefault(); apriModalElimina('${v.dataFormattata}', '${v.paziente.nome}', this);">
                            <input type="hidden" name="action" value="elimina"/>
                            <input type="hidden" name="id" value="${v.id}"/>
                            <button type="submit" class="btn-elimina">🗑️ Elimina</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty visite}">
                <tr><td colspan="6" class="empty">Nessuna visita registrata.</td></tr>
            </c:if>

            <div class="modal fade" id="modalConfermaElimina" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">

                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title">Conferma Eliminazione</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <p>Vuoi davvero eliminare la visita del <strong id="modalData"></strong> per il paziente <strong id="modalPaziente"></strong>?</p>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Annulla</button>
                            <button class="btn btn-danger" onclick="confermaEliminazione()">Elimina</button>
                        </div>

                    </div>
                </div>
            </div>

            </main>
            </tbody>
        </table>

    </div>
</div>

</body>
</html>
