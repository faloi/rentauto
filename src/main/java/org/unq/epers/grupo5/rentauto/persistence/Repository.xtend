package org.unq.epers.grupo5.rentauto.persistence

import java.util.Date
import org.eclipse.xtend.lib.annotations.Data
import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Categoria
import org.unq.epers.grupo5.rentauto.model.Ubicacion
import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager

@Data
class ReservaExample {
	Date inicio
	Date fin
	Ubicacion origen	
	Ubicacion destino
	Categoria categoria
}

class Repository implements WithGlobalEntityManager, EntityManagerOps {
	def autosDisponibles(Ubicacion ubicacion, Date date) {
		createQuery("from Auto", Auto).resultList.filter[ubicacionParaDia(date).nombre == ubicacion.nombre]
	}
	
	def autosConReservas(ReservaExample example) {
		createQuery('''
			select a 
			from Reserva as r 
			join r.auto as a
			where r.destino = :destino
				and r.origen = :origen
				and r.inicio = :inicio
				and r.fin = :fin
				and a.categoria = :categoria 
		''', Auto)
		.setParameter("origen", example.origen)
		.setParameter("destino", example.destino)
		.setParameter("inicio", example.inicio)
		.setParameter("fin", example.fin)
		.setParameter("categoria", example.categoria)
		.resultList
	}
}