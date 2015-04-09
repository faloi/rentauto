package org.unq.epers.grupo5.rentauto

import org.unq.epers.grupo5.rentauto.entities.Usuario
import org.unq.epers.grupo5.rentauto.exceptions.LoginIncorrectoException
import org.unq.epers.grupo5.rentauto.exceptions.NuevaPasswordInvalidaException
import org.unq.epers.grupo5.rentauto.exceptions.ValidacionException
import org.unq.epers.grupo5.rentauto.persistence.Database
import org.unq.epers.grupo5.rentauto.persistence.UsuarioHome

class Sistema {
	val home = new UsuarioHome()
	
	def void registrar(Usuario usuario) {
		home.insert(usuario)
	}
	
	def void validarCuenta(Usuario usuario, String codigoValidacion) {
		if (usuario.codigo_validacion != codigoValidacion)
			throw new ValidacionException
			
		usuario.is_validado = true
		
		home.update(usuario)
	}
	
	def Usuario login(String username, String password) {
		val usuario = home.findByUsername(username)
		
		if (usuario.password != password)
			throw new LoginIncorrectoException
			
		usuario
	}
	
	def void cambiarPassword(Usuario usuario, String nuevaPassword) {
		if (usuario.password == nuevaPassword)
			throw new NuevaPasswordInvalidaException
			
		usuario.password = nuevaPassword
		
		home.update(usuario)
	}
}