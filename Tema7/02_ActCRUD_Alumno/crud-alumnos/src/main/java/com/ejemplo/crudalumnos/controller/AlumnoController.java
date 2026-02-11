package com.ejemplo.crudalumnos.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.ejemplo.crudalumnos.model.Alumno;
import com.ejemplo.crudalumnos.repository.AlumnoRepository;

import java.util.List;
import java.util.Optional;

// Imports para la ACT3
import com.ejemplo.crudalumnos.dto.AlumnoDTO;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/alumnos")
public class AlumnoController {

    @Autowired
    private AlumnoRepository repo;

    // READ: Listar todos
    @GetMapping
    public List<Alumno> listar() {
        return repo.findAll();
    }

    // READ: Buscar por ID
    @GetMapping("/{id}")
    public ResponseEntity<Alumno> buscarPorId(@PathVariable Long id) {
        Optional<Alumno> alumno = repo.findById(id);
        return alumno.map(ResponseEntity::ok)
                      .orElse(ResponseEntity.notFound().build());
    }

    // CREATE: Crear alumno para la ACT3 con validaciones
    @PostMapping
    public ResponseEntity<Alumno> crear(@Valid @RequestBody AlumnoDTO dto) {

        Alumno alumno = new Alumno();
        alumno.setNombre(dto.getNombre());
        alumno.setEmail(dto.getEmail());

        Alumno creado = repo.save(alumno);

        return ResponseEntity.status(201).body(creado);
    }

    // UPDATE: Actualizar alumno
    @PutMapping("/{id}")
    public ResponseEntity<Alumno> actualizar(@PathVariable Long id, @RequestBody Alumno alumnoDetalles) {
        Optional<Alumno> optionalAlumno = repo.findById(id);
        if (!optionalAlumno.isPresent()) {
            return ResponseEntity.notFound().build();
        }
        Alumno alumno = optionalAlumno.get();
        alumno.setNombre(alumnoDetalles.getNombre());
        alumno.setEmail(alumnoDetalles.getEmail());
        Alumno actualizado = repo.save(alumno);
        return ResponseEntity.ok(actualizado);
    }

    // DELETE: Eliminar alumno
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        if (!repo.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}