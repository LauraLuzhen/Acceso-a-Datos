package bd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
	public static void main(String[] args) throws SQLException {
		conectarBD();
	}

	public static Connection conectarBD() throws SQLException {
		String url = "jdbc:mysql://dns11036.phdns11.es:3306/ad2526_laura_luzhen";
		String usuario= "ad2526_laura_luzhen";
		String contrasena = "12345";
		
		try {
            // Cargar driver (opcional en versiones modernas, pero está bien)
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            
            // Conexión
            Connection conn = DriverManager.getConnection(url, usuario, contrasena);
            System.out.println("✅ Conectado correctamente a la base de datos.");
            
            return conn;

        } catch (ClassNotFoundException e) {
            System.out.println("❌ No se encuentra el driver JDBC. Revisa el .jar");
        } catch (SQLException e) {
            System.out.println("❌ Error al conectar: " + e.getMessage());
        }
		
		return null;
	}
}
