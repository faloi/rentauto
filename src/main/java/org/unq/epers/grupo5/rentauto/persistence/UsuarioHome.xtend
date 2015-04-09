package org.unq.epers.grupo5.rentauto.persistence

import java.sql.PreparedStatement
import java.sql.ResultSet
import org.unq.epers.grupo5.rentauto.entities.Usuario

class UsuarioHome extends HomeDb<Usuario> {
	new(Database db) {
		super(db, "usuario")
	}

	override resultSetToEntity(ResultSet rs) 
	{	
		new Usuario(	rs.getInt("id"),
						rs.getString("nombre"),
						rs.getString("apellido"),  
						rs.getString("username"), 
						rs.getString("password"), 
						rs.getString("email"), 
						rs.getDate("nacimiento"), 
						rs.getString("codigo_validacion"), 
						rs.getBoolean("is_validado")	)
	}
		
	override setColumnas(PreparedStatement stmt, Usuario entity) {
		stmt.setString(1, entity.nombre)
		stmt.setString(2, entity.apellido)
		stmt.setString(3, entity.username)
		stmt.setString(4, entity.password)
		stmt.setString(5, entity.email)
		stmt.setDate(6, entity.nacimiento)
		stmt.setString(7, entity.codigo_validacion)
		stmt.setBoolean(8, entity.is_validado)		
	}
	
	
	def findByUsername(String username) {
		findBy('''username = «username»''')
	}
	
	override columns() {
		#[	"id",
			"nombre", 
			"apellido", 
			"username", 
			"password", 
			"email", 
			"nacimiento", 
			"codigo_validacion", 
			"is_validado" 
		]

	}
	
// obsoleto por ahora
//	
//	override columnTypes() {
//		#{ 	
//			"id"		-> Types.INTEGER,
//			"nombre" 	-> Types.VARCHAR, 
//			"apellido" 	-> Types.VARCHAR, 
//			"username" 	-> Types.VARCHAR, 
//			"password"  -> Types.VARCHAR, 
//			"email" 	-> Types.VARCHAR, 
//			"nacimiento"-> Types.DATE, 
//			"codigo_validacion" -> Types.VARCHAR, 
//			"is_validado" 	-> Types.BOOLEAN
//		}
//	}
}