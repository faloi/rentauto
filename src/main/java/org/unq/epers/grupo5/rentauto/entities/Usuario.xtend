package org.unq.epers.grupo5.rentauto.entities

import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors 
class Usuario {
	var int id
	var String nombre
	var String apellido
	var String username
	var String password
	var String email
	var Date nacimiento
	var String codigo_validacion
	var boolean is_validado

	new(int id, String nombre, String apellido, String username, String password, String email, Date nacimiento, String cod_verif, boolean validado) 
	{
		this.id = id
		this.nombre = nombre 
		this.apellido = apellido
		this.username = username 
		this.password = password
		this.email = email
		this.nacimiento = nacimiento 
		this.codigo_validacion = cod_verif
		this.is_validado = validado 	
	}
	
}