package org.unq.epers.grupo5.rentauto.persistence

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.unq.epers.grupo5.rentauto.model.Mensaje
import org.unq.epers.grupo5.rentauto.model.Usuario
import org.unq.epers.grupo5.rentauto.persistence.amigos.AmigosService
import org.unq.epers.grupo5.rentauto.persistence.amigos.NoSePuedeEnviarMensajeException
import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager
import org.uqbarproject.jpa.java8.extras.transaction.TransactionalOps

import static org.junit.Assert.*

class AmigosServiceTest implements WithGlobalEntityManager, EntityManagerOps, TransactionalOps {
	Usuario juli
	Usuario fede
	Usuario laChina
	Usuario diego
	Usuario marian
	
	AmigosService service
	
	@Before
	def void setUp() {
		beginTransaction()
		
		juli = crearUsuario()
		fede = crearUsuario()
		laChina = crearUsuario()
		diego = crearUsuario()
		marian = crearUsuario()
		
		service = new AmigosService
		
		service.amigosDe(juli, #[fede, laChina])
		service.amigosDe(fede, #[diego])
		service.amigosDe(diego, #[marian])
		
		service.enviarMensaje(laChina, juli, "hola")
		service.enviarMensaje(fede, juli, "sale un te?")
		service.enviarMensaje(fede, diego, "estas en Lanus?")
	}

	@After
	def void tearBack() {
		rollbackTransaction()
	}
	
	@Test
	def void sePuedenConsultarAmigos() {		
		assertEquals(#[diego, juli], service.amigosDe(fede))
	}
	
	@Test
	def void sePuedenConsultarConexiones() {		
		assertEquals(#[diego, marian, juli, laChina], service.conexionesDe(fede))
	}
	
	@Test(expected=NoSePuedeEnviarMensajeException)
	def void noSePuedenDejarMensajesAUsuariosNoAmigos() {
		service.enviarMensaje(fede, marian, "ola ke ase")
	}

	@Test
	def void sePuedenConsultarMensajesEnviados() {		
		val enviados = #[new Mensaje(fede, diego, "estas en Lanus?"), new Mensaje(fede, juli, "sale un te?")]
		assertEquals(enviados, service.mensajesEnviadosPor(fede))
	}
	
	@Test
	def void sePuedenConsultarMensajesRecibidos() {		
		val enviados = #[new Mensaje(fede, juli, "sale un te?"), new Mensaje(laChina, juli, "hola")]
		assertEquals(enviados, service.mensajesRecibidosPor(juli))
	}	
	
	def crearUsuario() {
		val usuario = new Usuario
		persist(usuario)
		
		usuario
	}
}