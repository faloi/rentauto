package org.unq.epers.grupo5.rentauto.persistence

import java.text.SimpleDateFormat
import java.util.Date
import java.util.List
import java.util.Optional
import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Ubicacion
import redis.clients.jedis.Jedis

class RedisCache {
	val jedis = new Jedis("localhost")
	Repository repository
	
	new(Repository repository) {
		this.repository = repository
	}
	
	def Optional<List<Auto>> get(Ubicacion ubicacion, Date dia) {
		Optional.ofNullable(jedis.get(makeKey(ubicacion, dia))).map[toAutos]
	}	
	
	def save(Ubicacion ubicacion, Date dia, List<Auto> autos) {
		jedis.set(makeKey(ubicacion, dia), autos.toRedisValue)		
	}
	
	def clear() {
		jedis.flushDB
	}
	
	private def String makeKey(Ubicacion ubicacion, Date dia) {
		'''«ubicacion.id»/«new SimpleDateFormat('yyyy-MM-dd').format(dia)»'''
	}
	
	private def toAutos(String redisValue) {
		repository.autosById(redisValue.split(",").map[Long.valueOf(it)])
	}	
	
	private def toRedisValue(List<Auto> autos) {
		autos.map [ id.toString ].join(",")
	}	
}