package clasesasociadas;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Ej1 {

	public static void main(String[] args) {

		String carpetas = "src\\clasesasociadas\\carpetas.txt";
		String rutaCarpetas = "C:\\Users\\ll.rodriguez\\";

		try (BufferedReader br = new BufferedReader(new FileReader(carpetas))) {
			String linea;

			while ((linea = br.readLine()) != null) {
				linea = linea.trim();

				if (linea != null) {
					File ruta = new File(rutaCarpetas + linea);

					if (ruta.mkdirs()) {
						System.out.println("Carpeta creada");
					} else {
						System.out.println("No se pudo crear la carpeta");
					}
				}
			}

			br.close();
		} catch (IOException e) {
			e.getMessage();
		}
	}
}
