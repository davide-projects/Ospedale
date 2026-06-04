package it.ospedale.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import it.ospedale.dao.VisitaDAO;
import it.ospedale.model.Visita;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/api/visite")
public class VisiteApiServlet extends HttpServlet {

    private VisitaDAO visitaDAO;
    private Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .create();
    
    @Override
    public void init() throws ServletException {
        visitaDAO = new VisitaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Visita> visite = visitaDAO.trovaTutti("id DESC");

        resp.setContentType("application/json");
        resp.getWriter().write(gson.toJson(visite));
    }
}
