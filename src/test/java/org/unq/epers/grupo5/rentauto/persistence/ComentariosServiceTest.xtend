package org.unq.epers.grupo5.rentauto.persistence

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.unq.epers.grupo5.rentauto.model.Auto
import org.unq.epers.grupo5.rentauto.model.Calificacion
import org.unq.epers.grupo5.rentauto.model.Comentario
import org.unq.epers.grupo5.rentauto.model.Usuario
import org.unq.epers.grupo5.rentauto.model.Visibilidad
import org.unq.epers.grupo5.rentauto.persistence.amigos.AmigosService
import org.unq.epers.grupo5.rentauto.persistence.comentarios.ComentariosService

import static org.junit.Assert.*

class ComentariosServiceTest extends BasePersistenceTest {
	Usuario pablo
	Usuario ronny
	Usuario desconocido
	
	ComentariosService comentariosService
	
	Comentario comentarioPabloPrivado
	Comentario comentarioPabloSoloAmigos
	Comentario comentarioPabloPublico
	
	@Before
	def void setUp() {
		beginTransaction()
		
		comentariosService = new ComentariosService
		
		pablo = create(new Usuario)
		ronny = create(new Usuario)
		desconocido = create(new Usuario)
		
		val amigosService = new AmigosService
		amigosService.amigosDe(pablo, #[ronny])
		
		val fiat600 = create(new Auto)
		comentarioPabloPrivado = new Comentario(pablo, fiat600, Calificacion.MALO, "La proxima voy en carreta", Visibilidad.PRIVADO)
		
		val gol3puertas = create(new Auto)
		comentarioPabloSoloAmigos = 
			new Comentario(pablo, gol3puertas, Calificacion.REGULAR, "Para ir de camping zafa", Visibilidad.SOLO_AMIGOS)
			
		val toyotaHilux = create(new Auto)
		comentarioPabloPublico = 
			new Comentario(pablo, toyotaHilux, Calificacion.EXCELENTE, "El unico auto que alquilaria", Visibilidad.PUBLICO)			
		
		comentariosService.crear(comentarioPabloPrivado, comentarioPabloPublico, comentarioPabloSoloAmigos)
	}
	
	@After
	def void tearDown() {
		rollbackTransaction()
		comentariosService.dropAll()
	}
	
	@Test
	def void puedenRecuperarseComentariosPorId() {
		assertEquals(comentarioPabloPrivado, comentariosService.get(comentarioPabloPrivado.id))
	}
	
	@Test
	def void losDesconocidosSoloVenComentariosPublicos() {
		assertEquals(#[comentarioPabloPublico] , comentariosService.verPerfilSegun(pablo, desconocido))
	}
	
	@Test
	def void losAmigosVenComentariosPublicosYParaAmigos() {
		assertEquals(#[comentarioPabloPublico, comentarioPabloSoloAmigos] , comentariosService.verPerfilSegun(pablo, ronny))
	}	
	
	def <T> create(T entity) {
		persist(entity)
		entity
	}	
}