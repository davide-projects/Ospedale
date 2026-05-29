package it.ospedale.model;

import jakarta.persistence.*;

@Entity
@Table(name = "pazienti")
public class Paziente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "nome", nullable = false)
    private String nome;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    // Costruttori
    public Paziente() {}

    public Paziente(String nome, String email) {
        this.setNome(nome);
        this.setEmail(email);
    }

    // Getter e Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) {
        if (email == null || !email.matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$")) {
            throw new IllegalArgumentException("Email non valida: " + email);
        }
        this.email = email;
    }

    @Override
    public String toString() {
        return "Paziente{id=" + id + ", nome='" + nome + "', email='" + email + "'}";
    }
}