package it.ospedale.model;

import jakarta.persistence.*;

@Entity
@Table(name = "medici")
public class Medico {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "nome", nullable = false)
    private String nome;

    @Column(name = "specializzazione", nullable = false)
    private String specializzazione;

    // Costruttori
    public Medico() {}

    public Medico(String nome, String specializzazione) {
        this.setNome(nome);
        this.setSpecializzazione(specializzazione);
    }

    // Getter e Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getSpecializzazione() { return specializzazione; }
    public void setSpecializzazione(String specializzazione) { this.specializzazione = specializzazione; }

    @Override
    public String toString() {
        return "Medico{id=" + id + ", nome='" + nome + "', specializzazione='" + specializzazione + "'}";
    }
}