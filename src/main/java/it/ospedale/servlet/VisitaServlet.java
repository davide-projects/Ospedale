package it.ospedale.servlet;

import it.ospedale.dao.MedicoDAO;
import it.ospedale.dao.PazienteDAO;
import it.ospedale.dao.VisitaDAO;
import it.ospedale.model.Medico;
import it.ospedale.model.Paziente;
import it.ospedale.model.Visita;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import it.ospedale.service.OspedaleExecutorService;
import it.ospedale.service.ProcessaVisitaTask;


import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Pattern POST-REDIRECT-GET — identico a OrdineServlet:
 *
 * 1. GET  /visita  → mostra il form (lista medici + lista pazienti)
 * 2. POST /visita  → valida i dati, salva la visita
 * 3. redirect GET /medici
 */
@WebServlet("/visita")
public class VisitaServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(VisitaServlet.class.getName());

    private MedicoDAO   medicoDAO;
    private PazienteDAO pazienteDAO;
    private VisitaDAO   visitaDAO;

    @Override
    public void init() throws ServletException {
        medicoDAO   = new MedicoDAO();
        pazienteDAO = new PazienteDAO();
        visitaDAO   = new VisitaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Carica liste per popolare i select nel form
        List<Medico>   medici   = medicoDAO.trovaTutti();
        List<Paziente> pazienti = pazienteDAO.trovaTutti();

        req.setAttribute("medici",   medici);
        req.setAttribute("pazienti", pazienti);

        req.getRequestDispatcher("/jsp/visita.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String medicoIdStr   = req.getParameter("medicoId");
        String pazienteIdStr = req.getParameter("pazienteId");
        String descrizione   = req.getParameter("descrizione");

        if (medicoIdStr == null || medicoIdStr.isBlank() ||
                pazienteIdStr == null || pazienteIdStr.isBlank() ||
                descrizione == null || descrizione.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/visita?errore=campi_mancanti");
            return;
        }

        try {
            int medicoId   = Integer.parseInt(medicoIdStr);
            int pazienteId = Integer.parseInt(pazienteIdStr);

            Medico   medico   = medicoDAO.trovaPerId(medicoId);
            Paziente paziente = pazienteDAO.trovaPerId(pazienteId);

            if (medico == null || paziente == null) {
                resp.sendRedirect(req.getContextPath() + "/visita?errore=non_trovato");
                return;
            }

            Visita visita = new Visita(paziente, medico, LocalDate.now(), descrizione);
            visitaDAO.inserisci(visita);

            OspedaleExecutorService executor = OspedaleExecutorService.getInstance();
            executor.getPool().submit(new ProcessaVisitaTask(visita.getId()));


        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "Formato non valido", e);
            resp.sendRedirect(req.getContextPath() + "/visita?errore=formato_non_valido");
            return;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Errore salvataggio visita", e);
            resp.sendRedirect(req.getContextPath() + "/visita?errore=generico");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/medici?messaggio=visita_creata");
    }
}