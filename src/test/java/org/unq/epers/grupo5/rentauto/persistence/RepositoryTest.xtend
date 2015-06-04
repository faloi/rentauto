package org.unq.epers.grupo5.rentauto.persistence

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Familiar
import org.unq.epers.grupo5.rentauto.model.Reserva
import org.unq.epers.grupo5.rentauto.model.TodoTerreno
import org.unq.epers.grupo5.rentauto.model.Ubicacion
import org.unq.epers.grupo5.rentauto.model.Usuario
import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager
import org.uqbarproject.jpa.java8.extras.transaction.TransactionalOps

import static ar.edu.unq.epers.extensions.DateExtensions.*

import static extension org.junit.Assert.*

class RepositoryTest implements WithGlobalEntityManager, EntityManagerOps, TransactionalOps {
	Repository repository
	
	@Before
	def void setUp() {
		repository = new Repository()
		beginTransaction()
	}

	@After
	def void tearDown() {
		rollbackTransaction()
	}
	
	@Test
	def void autosDisponiblesEnUbicacionEnDia() {
		val flores = new Ubicacion("Flores")
		val gol = new Auto("Volkswagen", "Gol", 2006, "FPK437", new Familiar, 75000d, flores)

		val reserva = new Reserva => [
			numeroSolicitud = 999
			auto = gol
			origen = flores
			destino = new Ubicacion("Mar del Plata")
			inicio = nuevaFecha(2015, 10, 29)
			fin = nuevaFecha(2015, 10, 31)
			usuario = new Usuario => [
				nombre = "Miguel"
				apellido = "Del Sel"
				username = "miguelds"
				password = "dameLaPresidencia"
				email = "miguelds@pro.gov.ar"
				nacimiento = nuevaFecha(1957, 7, 3)
				codigo_validacion = "1234567890"				
			]
		]
		
		gol.agregarReserva(reserva)
		persist(reserva)
		
		val hilux = new Auto("Toyota", "Hilux", 2015, "OOP123", new TodoTerreno, 500000d, new Ubicacion("Boedo"))
		persist(hilux)
		
		gol.assertEquals(repository.autosDisponibles(flores, nuevaFecha(2015, 10, 29)).head)
		assertTrue(repository.autosDisponibles(flores, nuevaFecha(2015, 11, 29)).empty)
	}
}