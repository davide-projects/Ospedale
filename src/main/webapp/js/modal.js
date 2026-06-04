let modalElimina;
let formDaInviare = null;

document.addEventListener("DOMContentLoaded", () => {
    modalElimina = new bootstrap.Modal(document.getElementById("modalConfermaElimina"));
});

function apriModalElimina(data, paziente, form) {
    formDaInviare = form;

    document.getElementById("modalData").textContent = data;
    document.getElementById("modalPaziente").textContent = paziente;

    modalElimina.show();
}

function confermaEliminazione() {
    if (formDaInviare) {
        formDaInviare.submit();
    }
}
