package com.example.__Act;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ControladorAPI {

	@GetMapping("/hola")
	    public String hola() {
	        return "¡Hola Mundo desde Spring Boot!";
	    }

	
}
