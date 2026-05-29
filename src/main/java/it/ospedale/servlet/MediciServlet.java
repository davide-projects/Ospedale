package it.ospedale.servlet;

import it.ospedale.dao.MedicoDAO;
import it.ospedale.model.Medico;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * GET /ospedale/medici                        → lista tutti i medici
 * GET /ospedale/medici?specializzazione=X     → filtra per specializzazione
 */
@WebServlet("/medici")
public class MediciServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(MediciServlet.class.getName());

    private MedicoDAO medicoDAO;

    @Override
    public void init() throws ServletException {
        medicoDAO = new MedicoDAO();
        logger.info("[MediciServlet] Inizializzata.");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String specializzazione = req.getParameter("specializzazione");

        List<Medico> medici;

        if (specializzazione != null && !specializzazione.isBlank()) {
            medici = medicoDAO.trovaPerSpecializzazione(specializzazione);
        } else {
            medici = medicoDAO.trovaTutti();
        }

        req.setAttribute("medici", medici);
        req.setAttribute("specializzazione", specializzazione);
        req.setAttribute("totale", medici.size());
        req.setAttribute("filtro", specializzazione != null && !specializzazione.isBlank()
                ? "Filtro: " + specializzazione
                : "Tutti i medici");

        req.getRequestDispatcher("/jsp/medici.jsp").forward(req, resp);
    }

    @Override
    public void destroy() {
        logger.info("[MediciServlet] Distrutta.");
    }
}