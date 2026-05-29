package it.ospedale.dao;

import it.ospedale.hibernate.HibernateUtil;
import it.ospedale.model.Paziente;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PazienteDAO {

    private static final Logger logger = Logger.getLogger(PazienteDAO.class.getName());

    public void inserisci(Paziente paziente) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(paziente);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            logger.log(Level.SEVERE, "Errore inserimento paziente", e);
        }
    }

    public List<Paziente> trovaTutti() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Paziente", Paziente.class).list();
        }
    }

    public Paziente trovaPerId(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Paziente.class, id);
        }
    }
}