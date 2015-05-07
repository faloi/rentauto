package org.unq.epers.grupo5.rentauto.model

import org.junit.After
import org.junit.Before
import org.junit.Test

import static ar.edu.unq.epers.extensions.DateExtensions.*
import static org.junit.Assert.*
import static org.unq.epers.grupo5.rentauto.dbutils.EntityManagerHelper.*

class PersistenceTest {
	@Before
	def void before() {
		beginTransaction()
	}

	@After
	def void after() {
		commit()
	}

	@Test
	def void puedenPersistirseYRecuperarseCategorias() {
		val familiar = new Familiar
		entityManager.persist(familiar)
		
		assertEquals(familiar, entityManager.find(Familiar, familiar.id))
	}
	
	@Test
	def void puedenPersistirseYRecuperarseReservas() {
		val flores = new Ubicacion("Flores")
		
		val reserva = new Reserva => [
			numeroSolicitud = 999
			origen = flores
			destino = new Ubicacion("Mar del Plata")
			inicio = nuevaFecha(2015, 10, 29)
			fin = nuevaFecha(2015, 10, 31)
			auto = new Auto("Volkswagen", "Gol", 2006, "FPK437", new Familiar, 75000d, flores)
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
		
		entityManager.persist(reserva)
		
		assertEquals(reserva, entityManager.find(Reserva, reserva.id))
	}	
	
	@Test
	def void puedenPersistirseYRecuperarseEmpresas() {
		val faloi = new Usuario => [ nombre = "Federico" ; apellido = "Aloi" ]
		val todoTerreno = new TodoTerreno
		
		val monotributista = new Empresa => [
			cuit = "20365286001"
			nombreEmpresa = "Federico Aloi"
			cantidadMaximaDeReservasActivas = 8
			valorMaximoPorDia = 2000d
		
			usuarios = #[faloi]
			categoriasAdmitidas = #[new Familiar, todoTerreno]
		]
		
		val boedo = new Ubicacion("boedo")
		
		new ReservaEmpresarial => [ 
			auto = new Auto("Toyota", "Hilux", 2015, "OOP123", todoTerreno, 500000d, boedo)
			usuario = faloi ; origen = boedo
			empresa = monotributista ; nombreContacto = "Fede" ; cargoContacto = "Dueño"
			reservar()
		]
		
		entityManager.persist(monotributista)
		
		assertEquals(monotributista, entityManager.find(Empresa, monotributista.id))		
	} 
}