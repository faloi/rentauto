package org.unq.epers.grupo5.rentauto.persistence

import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Ubicacion
import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager
import java.util.Date

class Repository implements WithGlobalEntityManager, EntityManagerOps {
	def autosDisponibles(Ubicacion ubicacion, Date date) {
		createQuery('''from Auto''', Auto).resultList.filter[ubicacionParaDia(date).nombre == ubicacion.nombre]
	}	
}