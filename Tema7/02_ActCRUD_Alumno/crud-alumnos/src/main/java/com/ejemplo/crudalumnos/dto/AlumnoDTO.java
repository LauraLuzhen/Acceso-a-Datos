package com.ejemplo.crudalumnos.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class AlumnoDTO {

    @NotNull(message = "Email requerido")
    @NotBlank(message = "Email no vacío")
    @Email(message = "Formato inválido")
    private String email;

    @NotBlank(message = "Nombre obligatorio")
    private String nombre;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}