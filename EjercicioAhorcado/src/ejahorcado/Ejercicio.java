package ejahorcado;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Collections;

public class Ejercicio {

	public static void main(String[] args) {
		// Rutas
		String rutaInicial = "src\\palabrasOrdenadas.txt";     
        String rutaFinal = "src\\palabrasOrdenadasFinal.txt";  

        // Lista de palabras
        ArrayList<String> palabras = new ArrayList<>();

        // Creamos el BufferReader para leer el fichero
        try (BufferedReader br = new BufferedReader(new FileReader(rutaInicial))) {
            String linea;
            
            // Leemos linea a linea
            while ((linea = br.readLine()) != null) {
                linea = linea.trim();
                
                if (!linea.isEmpty()) {
                	// La guardamos en la lista de palabras
                    palabras.add(linea);
                }
            }
        } catch (IOException e) {
        	// Lanzamos un error
            System.out.println("Error: " + e.getMessage());
            return;
        }

        // Ordenamos alfabéticamente la lista de palabras
        Collections.sort(palabras);

        // Escribimos en el fichero las palabras ya ordenadas
        try (RandomAccessFile raf = new RandomAccessFile(rutaFinal, "ruta")) {
            // Limpiamos el contenido del fichero si existía
        	raf.setLength(0);

        	// Escribimos cada palabra
            for (String p : palabras) {
                raf.writeBytes(p + "\r\n");
            }
        } catch (IOException e) {
        	// Lanzamos un error
            System.out.println("Error: " + e.getMessage());
            return;
        }
	}
}
