package org.unq.epers.grupo5.rentauto

import java.sql.ResultSet
import java.sql.Types
import java.sql.PreparedStatement

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
						rs.getString("cod_verif"), 
						rs.getBoolean("validado")	)
	}
	
	override insert(Usuario objeto) {
		var PreparedStatement stmt = conn.prepareStatement("
			INSERT INTO usuario (nombre, apellido, username, passwd, email, nacimiento, cod_verif, validado)
				VALUES  (?,?,?,?,?,?,?,?) ")

		stmt.setString(1,objeto.nombre)
		stmt.setString(2,objeto.apellido)
		stmt.setString(3,objeto.username)
		stmt.setString(4,objeto.passwd)
		stmt.setString(5,objeto.email)
		stmt.setObject(6,objeto.nacimiento, Types.DATE)
		stmt.setString(7,objeto.cod_verif)
		stmt.setBoolean(8,objeto.validado)

		stmt.execute()
	}
	
	override update(Usuario objeto) {
		var PreparedStatement stmt = conn.prepareStatement("
			INSERT INTO usuario (nombre, apellido, username, passwd, email, nacimiento, cod_verif, validado)
				VALUES  (?,?,?,?,?,?,?,?) ")

		stmt.setString(1,objeto.nombre)
		stmt.setString(2,objeto.apellido)
		stmt.setString(3,objeto.username)
		stmt.setString(4,objeto.passwd)
		stmt.setString(5,objeto.email)
		stmt.setObject(6,objeto.nacimiento, Types.DATE)
		stmt.setString(7,objeto.cod_verif)
		stmt.setBoolean(8,objeto.validado)

		stmt.execute
		stmt.close
		
		
	}
	
	override colunms() {
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