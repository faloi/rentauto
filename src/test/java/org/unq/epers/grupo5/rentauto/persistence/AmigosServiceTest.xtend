package org.unq.epers.grupo5.rentauto.persistence

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.unq.epers.grupo5.rentauto.model.Usuario
import org.unq.epers.grupo5.rentauto.persistence.amigos.AmigosService
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
	
	def crearUsuario() {
		val usuario = new Usuario
		persist(usuario)
		
		usuario
	}
}