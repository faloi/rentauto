package org.unq.epers.grupo5.rentauto.persistence

import java.sql.PreparedStatement
import java.sql.ResultSet
import java.sql.Types
import org.unq.epers.grupo5.rentauto.entities.Usuario

class UsuarioHome extends HomeDb<Usuario, String> {

	new(Database db) {
		super(db, "username", "usuario")
	}

	override findBy(String conditions) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	

	override rsToEntity(ResultSet rs) 
	{	
		new Usuario(	rs.getString("nombre"),
						rs.getString("apellido"),  
						rs.getString("username"), 
						rs.getString("passwd"), 
						rs.getString("email"), 
						rs.getDate("nacimiento"), 
						rs.getString("codigo_validacion"), 
						rs.getBoolean("is_validado")	)
	}
	
	override insert(Usuario objeto) {
		
		var String valoresStr = columns.keySet.filter[ it != pkName ].map [ [ | return "?" ] ].join(",")
		
		var PreparedStatement stmt = conn.prepareStatement("
			INSERT INTO " + tableName + " (" + columns + ")
				VALUES  (" + valoresStr + ") ")

		stmt.setString(1,objeto.nombre)
		stmt.setString(2,objeto.apellido)
		stmt.setString(3,objeto.username)
		stmt.setString(4,objeto.passwd)
		stmt.setString(5,objeto.email)
		stmt.setObject(6,objeto.nacimiento, Types.DATE)
		stmt.setString(7,objeto.codigo_validacion)
		stmt.setBoolean(8,objeto.is_validado)

		stmt.execute()
	}
	
	override update(Usuario objeto) {
		
		var String valoresStr = columns.keySet.filter[ it != pkName ].map [ [ | return "?" ] ].join(",")
		
		var PreparedStatement stmt = conn.prepareStatement("
			UPDATE " + colunmsStr)

		stmt.setString(1,objeto.nombre)
		stmt.setString(2,objeto.apellido)
		stmt.setString(3,objeto.username)
		stmt.setString(4,objeto.passwd)
		stmt.setString(5,objeto.email)
		stmt.setObject(6,objeto.nacimiento, Types.DATE)
		stmt.setString(7,objeto.codigo_validacion)
		stmt.setBoolean(8,objeto.is_validado)

		stmt.execute
		stmt.close
		

		
	}
	
	override columns() {
		#{ 	"nombre" 	-> Types.VARCHAR, 
			"apellido" 	-> Types.VARCHAR, 
			"username" 	-> Types.VARCHAR, 
			"passwd"  	-> Types.VARCHAR, 
			"email" 	-> Types.VARCHAR, 
			"nacimiento"-> Types.DATE, 
			"cod_verif" -> Types.VARCHAR, 
			"validado" 	-> Types.VARCHAR
		}
	}
		
}