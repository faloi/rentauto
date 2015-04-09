package org.unq.epers.grupo5.rentauto

import org.unq.epers.grupo5.rentauto.entities.Usuario
import org.unq.epers.grupo5.rentauto.exceptions.NuevaPasswordInvalidaException
import org.unq.epers.grupo5.rentauto.exceptions.UsuarioNoExistenteException
import org.unq.epers.grupo5.rentauto.exceptions.UsuarioYaExisteException
import org.unq.epers.grupo5.rentauto.exceptions.ValidacionException

class Sistema {
	
	def void RegistrarUsuario(Usuario usuarioNuevo) throws UsuarioYaExisteException
	{
		
	}
	
	def void ValidarCuenta(String codigoValidacion) throws ValidacionException
	{
		
	}
	
	def Usuario IngresarUsuario(String username, String password) throws UsuarioNoExistenteException
	{
		
	}
	
	def void CambiarPassword( String username, String password, String nuevaPassword) throws NuevaPasswordInvalidaException 
	{
		
	}
}

