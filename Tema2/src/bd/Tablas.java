package bd;

public class Tablas {
	
	private static String sql = "";
	
	public static String crearPlayer() {
		// idPlayer int
		// nick varchar(45)
		// password varchar(128)
		// email varchar(100)
		sql = """
				CREATE TABLE IF NOT EXISTS Player (
					idPlayer INT PRIMARY KEY,
					nick VARCHAR(45),
					password VARCHAR(128),
					email VARCHAR(100)
				);
				""";
		
		return sql;
	}
	
	public static String crearCompras() {
		// idCompra int
		// idPlayer int
		// idGames int
		// cosa varchar(25)
		// precio decimal(6,2)
		// fechaCompra date
		sql = """ 
				CREATE TABLE IF NOT EXISTS Compras (
					idCompra INT PRIMARY KEY,
					idPlayer INT,
					idGames INT,
					cosa VARCHAR(25),
					precio DECIMAL(6, 2),
					fechaCompra DATE
					FOREIGN KEY (idPlayer) REFERENCES Player(idPlayer),
					FOREIGN KEY (idGames) REFERENCES Games(idGames)
				);
				""";
		return sql;
	}
	
	public static String crearGames() {
		// idGames int
		// nombre varchar(45)
		// tiempoJugado time
		sql = """
				CREATE TABLE IF NOT EXISTS Games (
					idGames INT PRIMARY KEY,
					nombre VARCHAR(45),
					tiempoJugado TIME
				);
				""";
		return sql;
	}
}
