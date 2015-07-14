package org.unq.epers.grupo5.rentauto.persistence

import javax.persistence.PrePersist
import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Reserva

class CacheListener {
	@PrePersist
	def void clearCache(Object entity) {
		RedisCache.clearFor(entity.ubicacion)
	}

	private def ubicacion(Object entity) {
		switch (entity) {
			Auto: entity.ubicacion
			Reserva: entity.origen
		}
	}
}