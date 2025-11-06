package bd;

public class Menus {

	public static void Principal() {
		System.out.println("------------MENÚ------------");
		System.out.println("1. Conectar a la BD");
		System.err.println("2. Crear tablas");
		System.out.println("3. Insertar");
		System.out.println("4. Listar");
		System.out.println("5. Modificar");
		System.out.println("6. Borrar");
		System.out.println("7. Eliminar tablas");
	}
	
	public static void ElegirTabla() {
		System.out.println("------------ELIGE UNA TABLA------------");
		System.out.println("1. Player");
		System.out.println("2. Compras");
		System.out.println("3. Games");
		System.out.println("4. Todas las tablas");
		System.out.println("5. Volver atrás");
}
}
