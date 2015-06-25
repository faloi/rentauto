package org.unq.epers.grupo5.rentauto.persistence.comentarios

import net.vz.mongodb.jackson.DBQuery
import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Comentario
import org.unq.epers.grupo5.rentauto.model.Usuario
import org.unq.epers.grupo5.rentauto.model.Visibilidad
import org.unq.epers.grupo5.rentauto.persistence.amigos.AmigosService
import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager

class ComentariosService implements WithGlobalEntityManager, EntityManagerOps {
	val home = SistemDB.instance().collection(Comentario)
	val amigosService = new AmigosService
	
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
		comentariosSegun(target, interesado)
		.toArray
		.map[cargarDatosDeSQL]
	}
	
	private def comentariosSegun(Usuario target, Usuario interesado) {
		if (amigosService.esAmigoDe(target, interesado)) {
			home.mongoCollection
			.find(DBQuery.is("autor._id", target.id).and(DBQuery.in("visibilidad", #[Visibilidad.PUBLICO, Visibilidad.SOLO_AMIGOS])))
		} else {
			home.mongoCollection
			.find(new Comentario() => [ autor = target ; visibilidad = Visibilidad.PUBLICO ])
		}
	}

	private def cargarDatosDeSQL(Comentario comentario) {
		comentario.autor = find(Usuario, comentario.autor.id)
		comentario.auto = find(Auto, comentario.auto.id)
		comentario  
	}
}