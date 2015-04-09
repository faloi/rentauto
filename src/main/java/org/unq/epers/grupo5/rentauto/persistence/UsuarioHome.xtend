package org.unq.epers.grupo5.rentauto.persistence

import java.sql.PreparedStatement
import java.sql.ResultSet
import java.sql.Types
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
						rs.getString("passwd"), 
						rs.getString("email"), 
						rs.getDate("nacimiento"), 
						rs.getString("codigo_validacion"), 
						rs.getBoolean("is_validado")	)
	}
	
	override insert(Usuario objeto) {
		val valuesPlaceholder = columns.keySet.filter [ it != pkName ].map [ "?" ].join(",")
		executeStatement(objeto, '''INSERT INTO «tableName» («columnsStr») VALUES («valuesPlaceholder»)''')
	}
	
	override update(Usuario objeto) {
		val valuesPlaceholder = columns.keySet.filter [ it != pkName ].map [ '''«it» = ?''' ].join(",")
		executeStatement(objeto, '''UPDATE «tableName» SET «valuesPlaceholder» WHERE «pkName»=«objeto.id»''')
	}
	
	def executeStatement(Usuario entity, String query) {
		val statement = connection.prepareStatement(query)

		setColumnas(statement, entity)

		statement.execute
		statement.close		
	}
	
	def setColumnas(PreparedStatement stmt, Usuario entity) {
		stmt.setString(1, entity.nombre)
		stmt.setString(2, entity.apellido)
		stmt.setString(3, entity.username)
		stmt.setString(4, entity.getPassword)
		stmt.setString(5, entity.email)
		stmt.setObject(6, entity.nacimiento, Types.DATE)
		stmt.setString(7, entity.codigo_validacion)
		stmt.setBoolean(8, entity.is_validado)		
	}
	
	override columns() {
		#{ 	
			"id"		-> Types.INTEGER,
			"nombre" 	-> Types.VARCHAR, 
			"apellido" 	-> Types.VARCHAR, 
			"username" 	-> Types.VARCHAR, 
			"password"  	-> Types.VARCHAR, 
			"email" 	-> Types.VARCHAR, 
			"nacimiento"-> Types.DATE, 
			"codigo_validacion" -> Types.VARCHAR, 
			"is_validado" 	-> Types.VARCHAR
		}
	}
	
	def findByUsername(String username) {
		findBy('''username = «username»''')
	}
}