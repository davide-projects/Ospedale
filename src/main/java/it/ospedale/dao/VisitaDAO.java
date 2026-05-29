package it.ospedale.dao;

import it.ospedale.hibernate.HibernateUtil;
import it.ospedale.model.Visita;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VisitaDAO {

    private static final Logger logger = Logger.getLogger(VisitaDAO.class.getName());

    public void inserisci(Visita visita) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(visita);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            logger.log(Level.SEVERE, "Errore inserimento visita", e);
        }
    }

    public List<Visita> trovaTutti(String ordinamento) {
        String hql;
        switch (ordinamento != null ? ordinamento : "") {
            case "paziente":
                hql = "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.paziente.nome ASC";
                break;
            case "medico":
                hql = "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.medico.nome ASC";
                break;
            case "data_asc":
                hql = "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.dataVisita ASC";
                break;
            case "data_desc":
                hql = "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.dataVisita DESC";
                break;
            default:
                hql = "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.dataVisita DESC";
                break;
        }
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(hql, Visita.class).list();
        }
    }
}