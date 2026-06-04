<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Stato Visite</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <meta http-equiv="refresh" content="5"> <!-- Aggiorna ogni 5 secondi -->
</head>

<body class="bg-light">

<div class="container mt-4">
    <h2 class="mb-4">Stato delle Visite</h2>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
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
                <td>${v.id}</td>
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
        </tbody>
    </table>

</div>

</body>
</html>
