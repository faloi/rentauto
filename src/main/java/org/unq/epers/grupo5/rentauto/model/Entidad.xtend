package org.unq.epers.grupo5.rentauto.model

import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.MappedSuperclass
import org.eclipse.xtend.lib.annotations.Accessors

@MappedSuperclass
@Accessors
class Entidad {
	@Id
	@GeneratedValue
	long id
}