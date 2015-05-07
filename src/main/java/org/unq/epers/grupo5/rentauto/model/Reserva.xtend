package org.unq.epers.grupo5.rentauto.model

import java.util.Date
import javax.persistence.Entity
import javax.persistence.ManyToOne
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.joda.time.Days

import static ar.edu.unq.epers.extensions.DateExtensions.*
import javax.persistence.OneToOne

@Entity
@Accessors
class Reserva extends Entidad {
	Integer numeroSolicitud
	Date inicio
	Date fin
		
	@OneToOne(cascade = ALL) Ubicacion origen	
	@OneToOne(cascade = ALL) Ubicacion destino
	@ManyToOne(cascade = ALL) Auto auto
	@ManyToOne(cascade = ALL) Usuario usuario

	def costo() {
		val cantidadDeDias = Days.daysBetween(new DateTime(inicio), new DateTime(fin)).days
		return cantidadDeDias * auto.costoTotal;
	}
	
	def void validar(){
		val ubicacionInicial = auto.ubicacionParaDia(inicio)
		
		if(ubicacionInicial != origen)
			throw new ReservaException("El auto no tiene la ubicación de origen buscada")
		
		if(!auto.estaLibre(inicio, fin))
			throw new ReservaException("El auto no esta libre en el periodo pedido")
	}
	
	def isActiva(){
		inicio <= hoy && hoy <= fin
	}
	
	def seSuperpone(Date desde, Date hasta){
		if(inicio <= desde && desde <= fin )
			return true
		if(inicio <= hasta && hasta <= fin )
			return true
		if(desde <= inicio && fin <= hasta)
			return true
			
		return false	
	}
	
	def costoPorDia(){
		return 0
	}
	
	def void reservar(){
		this.auto.agregarReserva(this)
		this.usuario.agregarReserva(this)
	}
}


@Accessors 
class ReservaEmpresarial extends Reserva{
	@ManyToOne Empresa empresa
	String nombreContacto
	String cargoContacto
	
	override reservar(){
		super.reservar()
		this.empresa.agregarReserva(this)
	}
}

class ReservaException extends RuntimeException{
	new(String msg){
		super(msg)
	}
}
