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
        String hql = switch (ordinamento != null ? ordinamento : "") {
            case "paziente" -> "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.paziente.nome ASC";
            case "medico" -> "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.medico.nome ASC";
            case "data_asc" -> "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.dataVisita ASC";
            case "data_desc" -> "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.dataVisita DESC";
            default -> "FROM Visita v JOIN FETCH v.medico JOIN FETCH v.paziente ORDER BY v.dataVisita DESC";
        };
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(hql, Visita.class).list();
        }
    }

    public void delete(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Visita v = session.get(Visita.class, id);
            if (v != null) {
                session.remove(v);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }
}