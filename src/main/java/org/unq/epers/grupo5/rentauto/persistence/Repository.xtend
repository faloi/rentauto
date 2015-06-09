package org.unq.epers.grupo5.rentauto.persistence

import java.util.Date
import javax.persistence.Query
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
	def autosDisponibles(Ubicacion ubicacion, Date dia) {
		createQuery('''
			select a
			from Auto as a
			left join a.reservas as r 
			where 
				r is null and a.ubicacionInicial = :ubicacion
			or
				r.fin <= :dia and 
				r.destino = :ubicacion and 
				r.fin = (select max(r1.fin) from Reserva as r1 where r1.auto = a)
			or
				r.inicio >= :dia and 
				r.origen = :ubicacion and 
				r.inicio = (select min(r1.inicio) from Reserva as r1 where r1.auto = a)				
		''', Auto)
		.setParameter("ubicacion", ubicacion)
		.setParameter("dia", dia)
		.resultList
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
		.setParametersFromExample(example)
		.resultList
	}
	
	static def <T extends Query> setParametersFromExample(T query, Object example) {
		example.class.declaredFields
			.map[name -> example.getPropertyValue(name)]
			.forEach[query.setParameter(key, value)]
			
		query
	}
	
	static def getPropertyValue(Object object, String propertyName) {
		val getter = object.class.getMethod('''get«propertyName.toFirstUpper»''')
		getter.invoke(object)
	}
}