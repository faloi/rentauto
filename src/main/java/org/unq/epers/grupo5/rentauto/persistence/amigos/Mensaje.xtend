package org.unq.epers.grupo5.rentauto.persistence.amigos

import org.eclipse.xtend.lib.annotations.Data
import org.unq.epers.grupo5.rentauto.model.Usuario

@Data
class Mensaje {
	Usuario emisor
	Usuario receptor
	String mensaje
}