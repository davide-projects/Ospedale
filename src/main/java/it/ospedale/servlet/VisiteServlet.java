package it.ospedale.servlet;

import it.ospedale.dao.VisitaDAO;
import it.ospedale.model.Visita;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/visite")
public class VisiteServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(VisiteServlet.class.getName());
    private VisitaDAO visitaDAO;

    @Override
    public void init() throws ServletException {
        visitaDAO = new VisitaDAO();
        logger.info("[VisiteServlet] Inizializzata.");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String ordinamento = req.getParameter("ordina");

        List<Visita> visite = visitaDAO.trovaTutti(ordinamento);

        req.setAttribute("visite", visite);
        req.setAttribute("totale", visite.size());
        req.setAttribute("ordinamento", ordinamento);

        req.getRequestDispatcher("/jsp/visite.jsp").forward(req, resp);
    }

    @Override
    public void destroy() {
        logger.info("[VisiteServlet] Distrutta.");
    }
}