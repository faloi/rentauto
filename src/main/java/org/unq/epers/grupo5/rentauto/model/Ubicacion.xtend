package org.unq.epers.grupo5.rentauto.model

import java.util.List
import javax.persistence.Entity
import javax.persistence.OneToMany
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors 
class Ubicacion extends Entidad {
	String nombre
	
	new(String nombre){
		this.nombre = nombre
	}
}

@Entity
@Accessors 
class UbicacionVirtual extends Ubicacion {
	@OneToMany List<Ubicacion> ubicaciones
}
