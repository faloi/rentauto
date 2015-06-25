package org.unq.epers.grupo5.rentauto.persistence

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Calificacion
import org.unq.epers.grupo5.rentauto.model.Comentario
import org.unq.epers.grupo5.rentauto.model.Usuario
import org.unq.epers.grupo5.rentauto.model.Visibilidad
import org.unq.epers.grupo5.rentauto.persistence.comentarios.ComentariosService

import static org.junit.Assert.*

class ComentariosServiceTest extends BasePersistenceTest {
	Usuario pablo
	Auto fiat600
	
	ComentariosService service
	
	Comentario comentarioPabloFiat
	
	@Before
	def void setUp() {
		beginTransaction()
		
		service = new ComentariosService
		
		pablo = create(new Usuario)
		fiat600 = create(new Auto)
		
		comentarioPabloFiat = new Comentario(fiat600, Calificacion.MALO, "La proxima voy en carreta", Visibilidad.PUBLICO)
		service.crear(comentarioPabloFiat)
	}
	
	@After
	def void tearDown() {
		rollbackTransaction()
		service.dropAll()
	}
	
	@Test
	def void puedenRecuperarseComentariosPorId() {
		assertEquals(comentarioPabloFiat, service.get(comentarioPabloFiat.id))
	}
	
	def <T> create(T entity) {
		persist(entity)
		entity
	}	
}