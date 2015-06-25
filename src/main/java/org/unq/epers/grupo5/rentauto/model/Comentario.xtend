package org.unq.epers.grupo5.rentauto.model

import net.vz.mongodb.jackson.ObjectId
import org.codehaus.jackson.annotate.JsonProperty
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Comentario {
	@ObjectId
	@JsonProperty("_id")
	String id
	
	new() {}
	
	new(Auto auto, Calificacion calificacion, String observaciones, Visibilidad visibilidad) {
		this.auto = auto
		this.calificacion = calificacion
		this.observaciones = observaciones
		this.visibilidad = visibilidad
	}
	
	Auto auto
	Calificacion calificacion
	String observaciones
	Visibilidad visibilidad	
}

enum Calificacion { MALO, BUENO, REGULAR, EXCELENTE }
enum Visibilidad { PRIVADO, SOLO_AMIGOS, PUBLICO }