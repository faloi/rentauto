package org.unq.epers.grupo5.rentauto.persistence.comentarios

import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Comentario
import org.unq.epers.grupo5.rentauto.model.Usuario
import org.unq.epers.grupo5.rentauto.model.Visibilidad
import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager

class ComentariosService implements WithGlobalEntityManager, EntityManagerOps {
	def home() { SistemDB.instance().collection(Comentario) }
	
	def crear(Comentario... comentarios) {
		comentarios.forEach[ 
			val result = home.insert(it)
			it.id = result.savedId
		]
	}
	
	def get(String id) {
		val comentario = home.mongoCollection.findOneById(id)
		cargarDatosDeSQL(comentario)
	}
	
	def dropAll() {
		home.mongoCollection.drop
	}
	
	def verPerfilSegun(Usuario target, Usuario interesado) {
		home.mongoCollection
			.find(new Comentario() => [ autor = target ; visibilidad = Visibilidad.PUBLICO ])
			.toArray
			.map[cargarDatosDeSQL]
	}

	private def cargarDatosDeSQL(Comentario comentario) {
		comentario.autor = find(Usuario, comentario.autor.id)
		comentario.auto = find(Auto, comentario.auto.id)
		comentario  
	}
}