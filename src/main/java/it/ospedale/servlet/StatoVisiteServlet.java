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

@WebServlet("/stato-visite")
public class StatoVisiteServlet extends HttpServlet {

    private VisitaDAO visitaDAO;

    @Override
    public void init() throws ServletException {
        visitaDAO = new VisitaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Visita> visite = visitaDAO.trovaTutti("id DESC");

        req.setAttribute("visite", visite);
        req.getRequestDispatcher("/jsp/stato-visite.jsp").forward(req, resp);
    }
}
