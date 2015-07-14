package org.unq.epers.grupo5.rentauto.persistence

import javax.persistence.PrePersist
import org.unq.epers.grupo5.rentauto.model.Auto

class CacheListener {
    @PrePersist
    def void clearCache(Auto auto) {
    	RedisCache.clearFor(auto.ubicacion)
    }	
}