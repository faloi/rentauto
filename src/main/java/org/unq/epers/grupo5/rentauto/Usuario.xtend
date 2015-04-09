package org.unq.epers.grupo5.rentauto

import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors 
class Usuario {
	var String nombre
	var String apellido
	var String username
	var String passwd
	var String email
	var Date nacimiento
	var String cod_verif
	var boolean validado


	new(String nombre, String apellido, String username, String passwd, String email, Date nacimiento, String cod_verif, boolean validado) 
	{
		this.nombre = nombre 
		this.apellido = apellido
		this.username = username 
		this.passwd = passwd
		this.email = email
		this.nacimiento = nacimiento 
		this.cod_verif = cod_verif
		this.validado = validado 	
	}
	
}