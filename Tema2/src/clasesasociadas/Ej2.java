package clasesasociadas;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class Ej2 {

	public static void main(String[] args) {

		String nombre = "Laura Luzhen Rodríguez Morán";
        File carpetaRaiz = new File("C:\\Users\\ll.rodriguez\\AD"); 

        File[] carpetas = carpetaRaiz.listFiles();
        
        if (carpetas != null) {
            for (File carpeta : carpetas) {
                if (carpeta.isDirectory()) {
                    File ficheroHTML = new File(carpeta, "index.html");
                    
                    try (FileWriter fw = new FileWriter(ficheroHTML)) {
                        String contenido = "<html>\n" +
                                "   <head>\n" +
                                "      <title>" + carpeta.getName() + "</title>\n" +
                                "   </head>\n" +
                                "   <body>\n" +
                                "      <h1>" + carpeta.getName() + "</h1>\n" +
                                "      <h3>Autor: " + nombre + "</h3>\n" +
                                "   </body>\n" +
                                "</html>";
                        
                        fw.write(contenido);
                        
                        System.out.println("Creado");
                        
                    } catch (IOException e) {
                        e.getMessage();
                    }
                }
            }
        }
	}

}
