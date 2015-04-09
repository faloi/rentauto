package org.unq.epers.grupo5.rentauto.entities

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors 
class Usuario extends Entity {
	var String nombre
	var String apellido
	var String username
	var String password
	var String email
	var Date nacimiento
	var String codigo_validacion
	var boolean is_validado
}