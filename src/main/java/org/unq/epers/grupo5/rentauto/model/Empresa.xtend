package org.unq.epers.grupo5.rentauto.model

import java.util.List
import javax.persistence.Entity
import javax.persistence.OneToMany
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors 
class Empresa extends Entidad {
	String cuit
	String nombreEmpresa
	int cantidadMaximaDeReservasActivas
	Double valorMaximoPorDia
		
	@OneToMany(cascade = ALL) List<Usuario> usuarios = newArrayList
	@OneToMany(cascade = ALL) List<Reserva> reservas = newArrayList
	@OneToMany(cascade = ALL) List<Categoria> categoriasAdmitidas = newArrayList
	
	def agregarReserva(Reserva unaReserva){
		unaReserva.validarReserva
		reservas.add(unaReserva)
	}
	
	def validarReserva(Reserva unaReserva){
		if(reservasActivas.size == cantidadMaximaDeReservasActivas )
			throw new ReservaException("No se pueden tener más reservas para esta empresa")
		if(unaReserva.costoPorDia > valorMaximoPorDia)
			throw new ReservaException("El costo por dia excede el maximo de la empresa")
		if(!this.usuarios.contains(unaReserva.usuario))
			throw new ReservaException("El usuario no pertenece a la empresa")
		if(!this.categoriasAdmitidas.empty && !this.categoriasAdmitidas.contains(unaReserva.auto.categoria))
			throw new ReservaException("La categoria no esta admitida por la empresa")
	}
	
	def reservasActivas(){
		reservas.filter[activa]
	}
}