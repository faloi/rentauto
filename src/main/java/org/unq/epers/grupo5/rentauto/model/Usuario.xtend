package org.unq.epers.grupo5.rentauto.model

import java.util.Date
import java.util.List
import javax.persistence.Entity
import javax.persistence.OneToMany
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors 
class Usuario extends Entidad {
	String nombre
	String apellido
	String username
	String password
	String email
	Date nacimiento
	String codigo_validacion
	boolean is_validado
	
	@OneToMany List<Reserva> reservas = newArrayList
	
	def agregarReserva(Reserva unaReserva) {
		reservas.add(unaReserva)
	}
	
	override def toString() {
		id.toString()
	}
}