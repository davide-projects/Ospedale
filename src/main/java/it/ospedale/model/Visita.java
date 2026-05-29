package it.ospedale.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "visite")
public class Visita {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "paziente_id", nullable = false)
    private Paziente paziente;

    @ManyToOne
    @JoinColumn(name = "medico_id", nullable = false)
    private Medico medico;

    @Column(name = "data_visita", nullable = false)
    private LocalDate dataVisita;

    @Column(name = "descrizione")
    private String descrizione;

    // Costruttori
    public Visita() {}

    public Visita(Paziente paziente, Medico medico, LocalDate dataVisita, String descrizione) {
        this.setPaziente(paziente);
        this.setMedico(medico);
        this.setDataVisita(dataVisita);
        this.setDescrizione(descrizione);
    }

    // Getter e Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Paziente getPaziente() { return paziente; }
    public void setPaziente(Paziente paziente) { this.paziente = paziente; }

    public Medico getMedico() { return medico; }
    public void setMedico(Medico medico) { this.medico = medico; }

    public LocalDate getDataVisita() { return dataVisita; }
    public void setDataVisita(LocalDate dataVisita) { this.dataVisita = dataVisita; }

    public String getDescrizione() { return descrizione; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }

    @Override
    public String toString() {
        return "Visita{id=" + id + ", paziente=" + paziente.getNome() +
                ", medico=" + medico.getNome() + ", data=" + dataVisita + "}";
    }
}