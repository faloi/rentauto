package org.unq.epers.grupo5.rentauto.persistence

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Categoria
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
	Auto gol
	Auto hilux
	Ubicacion flores
	Ubicacion boedo
	Ubicacion marDelPlata
	Categoria todoTerreno
	
	@Before
	def void setUp() {
		beginTransaction()
		
		repository = new Repository()
		
		flores = new Ubicacion("Flores")
		gol = new Auto("Volkswagen", "Gol", 2006, "FPK437", new Familiar, 75000d, flores)

		marDelPlata = new Ubicacion("Mar del Plata")
		
		val reservaGol = new Reserva => [
			numeroSolicitud = 999
			auto = gol
			origen = flores
			destino = marDelPlata
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
		
		gol.agregarReserva(reservaGol)
		persist(reservaGol)		
		
		boedo = new Ubicacion("Boedo")
		todoTerreno = new TodoTerreno
		hilux = new Auto("Toyota", "Hilux", 2015, "OOP123", todoTerreno, 500000d, boedo)

		val reservaHilux = new Reserva => [
			numeroSolicitud = 888
			auto = hilux
			origen = boedo
			destino = marDelPlata
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
		
		persist(reservaHilux)
	}

	@After
	def void tearDown() {
		rollbackTransaction()
	}
	
	@Test
	def void autosDisponiblesEnUbicacionEnDia() {
		gol.assertEquals(repository.autosDisponibles(flores, nuevaFecha(2015, 10, 29)).head)
		assertTrue(repository.autosDisponibles(flores, nuevaFecha(2015, 11, 29)).empty)
	}
	
	@Test
	def void autosConReservas() {
		val reservaExample = new ReservaExample(
			nuevaFecha(2015, 10, 29), 
			nuevaFecha(2015, 10, 31),
			boedo,
			marDelPlata,
			todoTerreno
		)
		
		#[hilux].assertEquals(repository.autosConReservas(reservaExample))
	}
}