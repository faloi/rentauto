package org.unq.epers.grupo5.rentauto.model

import java.util.Date
import java.util.List
import javax.persistence.Entity
import javax.persistence.EntityListeners
import javax.persistence.OneToMany
import javax.persistence.OneToOne
import org.eclipse.xtend.lib.annotations.Accessors
import org.unq.epers.grupo5.rentauto.persistence.CacheListener

@Entity
@Accessors
@EntityListeners(CacheListener)
class Auto extends Entidad {
	String marca
	String modelo
	Integer año
	String patente
	Double costoBase
	
	@OneToOne(cascade = ALL) Categoria categoria
	@OneToOne(cascade = ALL) Ubicacion ubicacionInicial
	
	//Debe estar ordenado
	@OneToMany(cascade = ALL) List<Reserva> reservas = newArrayList()

	new() {}

	new(String marca, String modelo, Integer anio, String patente, Categoria categoria, Double costoBase, Ubicacion ubicacionInicial){
		this.marca = marca
		this.modelo = modelo
		this.año = anio
		this.patente = patente
		this.costoBase = costoBase
		this.categoria = categoria
		this.ubicacionInicial = ubicacionInicial
	}

	def getUbicacion(){
		this.ubicacionParaDia(new Date());
	}
	
	def ubicacionParaDia(Date unDia){
		val encontrado = reservas.findLast[ it.fin <= unDia ]
		if(encontrado != null){
			return encontrado.destino
		}else{
			return ubicacionInicial
		}
	}
	
	def Boolean estaLibre(Date desde, Date hasta){
		reservas.forall[ !seSuperpone(desde,hasta) ]
	}
	
	def agregarReserva(Reserva reserva){
		reserva.validar
		reservas.add(reserva)
		reservas.sortInplaceBy[inicio]
	}
	
	def costoTotal(){
		return categoria.calcularCosto(this)
	}
	
}
