package org.unq.epers.grupo5.rentauto.persistence

import java.util.Date
import java.util.List
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
	val cache = new RedisCache(this)
	
	def autosDisponibles(Ubicacion ubicacion, Date dia) {
		cache.get(ubicacion, dia).orElseGet [ getFromSQL(ubicacion, dia) ]
	}
	
	def autosReservables(ReservaExample example) {
		createQuery("origen", "destino", "inicio", "fin", #["a.categoria = :categoria"])
		.setParametersFromExample(example)
		.resultList
	}
	
	def autosById(Iterable<Long> ids) {
		createQuery("select a from Auto as a where a.id in (:ids)", Auto)
		.setParameter("ids", ids)
		.resultList
	}
	
	private def createQuery(String origen, String destino, String inicio, String fin, List<String> extraConditions) {
		createQuery('''
		select a
		from Auto as a
		left join a.reservas as r 
		where «(extraConditions + #[""]).join(" and ")» ( 
			r is null and a.ubicacionInicial = :«origen»
		or
			r.destino = :«origen» and 
			r.fin <= :«inicio» and 
			r.fin = (select max(r1.fin) from Reserva as r1 where r1.auto = a)
		or
			r.origen = :«destino» and
			r.inicio >= :«fin» and 				
			r.inicio = (select min(r1.inicio) from Reserva as r1 where r1.auto = a)
		or
			r.destino = :«origen» and
			r.fin < :«inicio» and
			exists (from Reserva as r2 where r2.auto = a and r != r2 and r2.inicio > :«fin»)
		)
		''', Auto)
	}
	
	private def getFromSQL(Ubicacion ubicacion, Date dia) {
		val results = createQuery("ubicacion", "ubicacion", "dia", "dia", #[])
		.setParameter("ubicacion", ubicacion)
		.setParameter("dia", dia)
		.resultList
		
		cache.save(ubicacion, dia, results)
		
		results
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