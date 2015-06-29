package org.unq.epers.grupo5.rentauto.model

import net.vz.mongodb.jackson.ObjectId
import org.codehaus.jackson.annotate.JsonProperty
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class Comentario {
	@ObjectId
	@JsonProperty("_id")
	String id
	
	new() {}
	
	new(Usuario autor, Auto auto, Calificacion calificacion, String observaciones, Visibilidad visibilidad) {
		this.autor = autor
		this.auto = auto
		this.calificacion = calificacion
		this.observaciones = observaciones
		this.visibilidad = visibilidad
	}
	
	Usuario autor
	Auto auto
	Calificacion calificacion
	String observaciones
	Visibilidad visibilidad	
}

enum Calificacion { MALO, BUENO, REGULAR, EXCELENTE }
enum Visibilidad { PRIVADO, SOLO_AMIGOS, PUBLICO }