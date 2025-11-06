package ultimoej;


import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.Random;

public class Ej {
	/**
	 * RandomSeekExample
	 *
	 * Ejecuta en Eclipse como Java Application. Crea y manipula ficheros usando RandomAccessFile
	 * para demonstrate seek aleatorio y escritura aleatoria, y escritura en orden inverso sin usar arrays ni buffers.
	 */


	    private static final Random rnd = new Random();

	    public static void main(String[] args) {
	        try {
	            File baseDir = new File(System.getProperty("user.dir")); // directorio del proyecto en Eclipse
	            File inputA = new File(baseDir, "input_a.txt");
	            File randomOut = new File(baseDir, "random_out.txt");
	            File inputABCDE = new File(baseDir, "input_abcde.txt");
	            File reversedOut = new File(baseDir, "reversed_letters.txt");
	            File inputWithNumbers = new File(baseDir, "input_with_numbers.txt");
	            File reversedWithNumbers = new File(baseDir, "reversed_with_numbers.txt");

	            // 1) Crea fichero con una sola letra "a"
	            createSingleLetterFile(inputA, 'a');

	            // 2) Leer de forma aleatoria (seek) y escribir 5 veces en otro documento también aleatoriamente
	            randomReadAndWriteFiveTimes(inputA, randomOut, 5);

	            // 3) Aumentar el documento de lectura hasta 'e' en lineas separadas (a\n b\n c\n d\n e\n)
	            createLettersFile(inputABCDE, 'a', 'e');

	            // 4) Crear método que escriba esas letras en otro de forma inversa
	            writeLinesInReverse(inputABCDE, reversedOut, " "); // separador: espacio

	            // 5) Crear fichero con letra+numero (a1\n b2\n ...) y hacer la misma operación (debe quedar e5 d4 c3 b2 a1)
	            createLettersWithNumbersFile(inputWithNumbers, 'a', 'e');
	            writeLinesInReverse(inputWithNumbers, reversedWithNumbers, " ");

	            System.out.println("Hecho. Ficheros creados en: " + baseDir.getAbsolutePath());
	            System.out.println(" - " + inputA.getName());
	            System.out.println(" - " + randomOut.getName());
	            System.out.println(" - " + inputABCDE.getName());
	            System.out.println(" - " + reversedOut.getName());
	            System.out.println(" - " + inputWithNumbers.getName());
	            System.out.println(" - " + reversedWithNumbers.getName());
	            System.out.println("\nAbre los ficheros creados para ver los resultados.");
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }

	    // Crea un fichero con una sola letra (sin newline)
	    private static void createSingleLetterFile(File f, char c) throws IOException {
	        try (RandomAccessFile raf = new RandomAccessFile(f, "rw")) {
	            raf.setLength(0);
	            raf.write((byte) c);
	        }
	    }

	    /**
	     * Lee aleatoriamente un byte del fichero 'in' y escribe 5 veces en posiciones aleatorias
	     * dentro de 'out'. No usa arrays ni buffers, sólo RandomAccessFile.
	     */
	    private static void randomReadAndWriteFiveTimes(File in, File out, int times) throws IOException {
	        try (RandomAccessFile rafIn = new RandomAccessFile(in, "r");
	             RandomAccessFile rafOut = new RandomAccessFile(out, "rw")) {

	            long inLen = rafIn.length();
	            if (inLen == 0) return;

	            // Preparar fichero de salida con un tamaño mínimo (times bytes)
	            rafOut.setLength(Math.max(rafOut.length(), times));

	            for (int i = 0; i < times; i++) {
	                // elegir posición aleatoria en el fichero de entrada
	                long posIn = (inLen == 1) ? 0 : rnd.nextInt((int) inLen); // si solo hay 1 byte, pos=0
	                rafIn.seek(posIn);
	                int b = rafIn.read(); // leer 1 byte

	                // elegir posicion aleatoria en fichero de salida dentro del rango [0, times-1]
	                long posOut = rnd.nextInt(times);
	                rafOut.seek(posOut);
	                rafOut.write(b);
	            }
	        }
	    }

	    // Crea fichero con letras desde start hasta end (inclusive), cada letra en su propia línea
	    private static void createLettersFile(File f, char start, char end) throws IOException {
	        try (RandomAccessFile raf = new RandomAccessFile(f, "rw")) {
	            raf.setLength(0);
	            for (char c = start; c <= end; c++) {
	                raf.write((byte) c);
	                raf.write((byte) '\n');
	            }
	        }
	    }

	    // Crea fichero con letra + número por linea: a1\n b2\n ...
	    private static void createLettersWithNumbersFile(File f, char start, char end) throws IOException {
	        try (RandomAccessFile raf = new RandomAccessFile(f, "rw")) {
	            raf.setLength(0);
	            int number = 1;
	            for (char c = start; c <= end; c++, number++) {
	                raf.write((byte) c);
	                // escribir el dígito (asume números de 1 dígito para este ejemplo)
	                String num = Integer.toString(number);
	                for (int i = 0; i < num.length(); i++) {
	                    raf.write((byte) num.charAt(i));
	                }
	                raf.write((byte) '\n');
	            }
	        }
	    }

	    /**
	     * Escribe las líneas del fichero 'in' en 'out' en orden inverso, sin usar arrays ni buffering.
	     * La estrategia:
	     *  - Se recorre el fichero de atrás hacia delante para localizar el final y el principio de cada línea.
	     *  - Una vez identificado el tramo [start..end] de la línea, se leen esos bytes en avance y se escriben
	     *    directamente en el fichero de salida.
	     *
	     *  separador: cadena que se escribirá entre líneas en el fichero de salida (ej: " " o "\n")
	     */
	    private static void writeLinesInReverse(File in, File out, String separador) throws IOException {
	        try (RandomAccessFile rafIn = new RandomAccessFile(in, "r");
	             RandomAccessFile rafOut = new RandomAccessFile(out, "rw")) {

	            rafOut.setLength(0); // limpiar fichero salida

	            long pos = rafIn.length() - 1;
	            while (pos >= 0) {
	                // saltar posibles newlines al final
	                while (pos >= 0) {
	                    rafIn.seek(pos);
	                    int b = rafIn.read();
	                    if (b == '\n' || b == '\r') {
	                        pos--;
	                    } else {
	                        break;
	                    }
	                }
	                if (pos < 0) break;

	                long end = pos;

	                // buscar inicio de la línea (posición del primer byte de esta línea)
	                long start = pos;
	                while (start - 1 >= 0) {
	                    rafIn.seek(start - 1);
	                    int prev = rafIn.read();
	                    if (prev == '\n' || prev == '\r') {
	                        break;
	                    }
	                    start--;
	                }

	                // leer de start a end (ambos inclusive) y escribir a out
	                for (long p = start; p <= end; p++) {
	                    rafIn.seek(p);
	                    int b = rafIn.read();
	                    rafOut.write(b);
	                }

	                // escribir separador (por ejemplo " " o "\n") entre líneas si se desea
	                if (separador != null && !separador.isEmpty()) {
	                    for (int i = 0; i < separador.length(); i++) {
	                        rafOut.write((byte) separador.charAt(i));
	                    }
	                }

	                // continuar desde el byte anterior al inicio encontrado
	                pos = start - 1;
	            }
	        }
	    }
	}



