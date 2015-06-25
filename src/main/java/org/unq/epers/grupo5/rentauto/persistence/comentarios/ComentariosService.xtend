package org.unq.epers.grupo5.rentauto.persistence.comentarios

import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Comentario
import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager

class ComentariosService implements WithGlobalEntityManager, EntityManagerOps {
	def home() { SistemDB.instance().collection(Comentario) }
	
	def crear(Comentario comentario) {
		val result = home.insert(comentario)
		comentario.id = result.savedId
	}
	
	def get(String id) {
		val comentario = home.mongoCollection.findOneById(id)
		comentario.auto = getAuto(comentario.auto.id)
		comentario
	}
	
	def getAuto(long id) {
		find(Auto, id)
	}
	
	def dropAll() {
		home.mongoCollection.drop
	}
	
}