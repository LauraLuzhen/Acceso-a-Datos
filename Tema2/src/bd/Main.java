package bd;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.Connection;

public class Main {
	
	static Scanner sc = new Scanner(System.in);
	Connection conn;

	public void menu() throws SQLException {
		int opc = 0;
		
		do {
			Menus.Principal();
			opc = sc.nextInt();
			sc.nextLine();
			
			switch(opc) {
			case 1 -> {
				// conectar
				Conexion.conectarBD();
			}
			case 2 -> {
				// crearTablas
				crearTablas();
			}
			case 3 -> {
				// insertar
			}
			case 4 -> {
				// listar
			}
			case 5 -> {
				// modificar
			}
			case 6 -> {
				// borrar
			}
			case 7 -> {
				// eliminar tablas
			}
			case 0 -> {
				System.out.println("Saliendo...");
			}
			default -> {
				System.out.println("Opción no válida");
			}
			}
				
		} while (opc != 0);
		
		
		sc.close();
	}
	
	private void crearTablas() throws SQLException {
		String sql = "";
		int opc = 0;
		
		do {
			Menus.ElegirTabla();
			opc = sc.nextInt();
			sc.nextLine();
			
			try (Statement st = conn.createStatement()) {
				switch(opc) {
				case 1 -> {
					// Player
					if (existeTabla("Player")) {
						System.out.println("Ya existe la tabla Player");
					} else {
						sql = Tablas.crearPlayer();
						System.out.println("Tabla Player creada correctamente");
						st.execute(sql);
					}
				}
				case 2 -> {
					// Compras
					if (existeTabla("Compras") ) {
						System.out.println("Ya existe la tabla Compras");
					} else {
						if (existeTabla("Player") && existeTabla("Games")) {
							sql = Tablas.crearCompras();
							System.out.println("Tabla Compras creada correctamente");
							st.execute(sql);
						} else {
							System.out.println("Es necesario crearse antes las tablas Player y Games");
						}
					}
				}
				case 3 -> {
					// Games
					if (existeTabla("Games")) {
						System.out.println("Ya existe la tabla Games");
					} else {
						sql = Tablas.crearGames();
						System.out.println("Tabla Games creada correctamente");
						st.execute(sql);
					}
				}
				case 4 -> {
					// Todas
					if (!existeTabla("Player")) {
						sql = Tablas.crearPlayer();
						st.execute(sql);
					}
				}
				case 5 -> {
					menu();
				}
				default -> {
					System.out.println("Opción no válida");
				}
				}
			} catch (SQLException e) {
				System.out.println("Tabla creada correctamente");
			}
				
		} while (opc != 0);
	}
	
	private boolean existeTabla(String tabla) {
		   boolean existe = false;
		   try (ResultSet rs = conn.getMetaData().getTables(null, null, tabla, null)) {
		       existe = rs.next();
		   } catch (SQLException e) {
		       existe = false;
		   }
		   return existe;
	}
	
}
