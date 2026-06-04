package it.ospedale.service;

import it.ospedale.hibernate.HibernateUtil;
import it.ospedale.model.Visita;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class ProcessaVisitaTask implements Runnable {

    private final int visitaId;

    public ProcessaVisitaTask(int visitaId) {
        this.visitaId = visitaId;
    }

    @Override
    public void run() {

        long durata = 1000 + (long) (Math.random() * 2000);

        try {
            Thread.sleep(durata);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String medicoThread = Thread.currentThread().getName();
        String esito = durata < 1500 ? "OK" :
                durata < 2500 ? "Follow-up" : "Urgente";

        System.out.println("🔥 [TASK] Aggiornamento visita ID " + visitaId +
                " | thread = " + medicoThread +
                " | durata = " + durata + " ms" +
                " | esito = " + esito);

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();

            Visita visita = session.get(Visita.class, visitaId);

            if (visita != null) {
                visita.setEsito(esito);
                visita.setDurataMs(durata);
                visita.setMedicoThread(medicoThread);
                session.merge(visita);
            }

            tx.commit();
        }
    }
}
