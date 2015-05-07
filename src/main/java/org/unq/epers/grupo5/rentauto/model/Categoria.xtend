package org.unq.epers.grupo5.rentauto.model

import javax.persistence.DiscriminatorColumn
import javax.persistence.DiscriminatorValue
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.Inheritance
import javax.persistence.InheritanceType
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@DiscriminatorColumn(name="Tipo")
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
@Accessors 
abstract class Categoria {
	@Id
	@GeneratedValue
	long id
	
	String nombre
	
	abstract def Double calcularCosto(Auto auto)
}

@Entity
@DiscriminatorValue(value="T")
class Turismo extends Categoria{
	override calcularCosto(Auto auto) {
		if(auto.año > 2000){
			return auto.costoBase * 1.10			
		}else{
			return auto.costoBase - 200
		}
	}
}

@Entity
@DiscriminatorValue(value="F")
class Familiar extends Categoria{
	override calcularCosto(Auto auto) {
		return auto.costoBase + 200
	}
}

@Entity
@DiscriminatorValue(value="D")
class Deportivo extends Categoria{
	override calcularCosto(Auto auto) {
		if(auto.año > 2000){
			return auto.costoBase * 1.30			
		}else{
			return auto.costoBase * 1.20
		}
	}
}

@Entity
@DiscriminatorValue(value="O")
class TodoTerreno extends Categoria{
	override calcularCosto(Auto auto) {
		auto.costoBase * 1.10
	}
}
