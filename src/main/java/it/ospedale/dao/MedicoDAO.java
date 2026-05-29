package it.ospedale.dao;

import it.ospedale.hibernate.HibernateUtil;
import it.ospedale.model.Medico;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MedicoDAO {

    // Sistema di loggin professionale e robusto
    private static final Logger logger = Logger.getLogger(MedicoDAO.class.getName());

    public void inserisci(Medico medico) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(medico);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            logger.log(Level.SEVERE, "Errore inserimento medico", e);
        }
    }

    public List<Medico> trovaTutti() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Medico", Medico.class).list();
        }
    }

    public Medico trovaPerId(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Medico.class, id);
        }
    }

    public List<Medico> trovaPerSpecializzazione(String specializzazione) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "FROM Medico WHERE specializzazione = :spec", Medico.class)
                    .setParameter("spec", specializzazione)
                    .list();
        }
    }
}