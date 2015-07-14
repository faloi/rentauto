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

import static ar.edu.unq.epers.extensions.DateExtensions.*

import static extension org.junit.Assert.*

class RepositoryTest extends BasePersistenceTest {
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
		
		hilux.agregarReserva(reservaHilux)
		persist(reservaHilux)
	}

	@After
	def void tearDown() {
		rollbackTransaction()
	}
	
	@Test
	def void autosDisponiblesEnUbicacionEnDiaPosteriorALaUltimaDevolucion() {
		#[gol, hilux].assertEquals(repository.autosDisponibles(marDelPlata, nuevaFecha(2015, 11, 1)))
	}
	
	@Test
	def void autosDisponiblesEnUbicacionAntesDeLaPrimeraReserva() {
		#[gol].assertEquals(repository.autosDisponibles(flores, nuevaFecha(2015, 10, 28)))
	}
	
	@Test
	def void autosDisponiblesEnUbicacionEntreReservas() {
		val sanMartin = new Ubicacion("San Martin")
		persist(sanMartin)
		
		val reservaGol = new Reserva => [
			numeroSolicitud = 999
			auto = gol
			origen = flores
			destino = sanMartin
			inicio = nuevaFecha(2015, 10, 25)
			fin = nuevaFecha(2015, 10, 26)
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
		
		#[gol].assertEquals(repository.autosDisponibles(sanMartin, nuevaFecha(2015, 10, 27)))
	}	
	
	@Test
	def void unAutoSinReservasTomaLaUbicacionInicialComoActual() {
		val devoto = new Ubicacion("Devoto")
		val scenic = new Auto("Renault", "Scenic", 2007, "FTS381", new Familiar, 105000d, devoto)
		
		persist(scenic)
		
		#[scenic].assertEquals(repository.autosDisponibles(devoto, nuevaFecha(2015, 10, 29)))
	}
	
	@Test
	def void autosReservables() {
		val gesell = new Ubicacion("Villa Gesell")
		persist(gesell)
		
		val reservaExample = new ReservaExample(
			nuevaFecha(2015, 11, 1), 
			nuevaFecha(2015, 11, 9),
			marDelPlata,
			gesell,
			todoTerreno
		)
		
		#[hilux].assertEquals(repository.autosReservables(reservaExample))
	}
}