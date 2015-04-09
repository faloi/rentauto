package org.unq.epers.grupo5.rentauto

import java.nio.file.Files
import java.nio.file.Paths
import java.sql.Date
import org.junit.Before
import org.junit.Test
import org.unq.epers.grupo5.rentauto.entities.Usuario
import org.unq.epers.grupo5.rentauto.exceptions.UsuarioYaExisteException
import org.unq.epers.grupo5.rentauto.persistence.UsuarioHome

import static org.junit.Assert.*
import org.unq.epers.grupo5.rentauto.exceptions.EntidadNoExisteException

class UsuarioHomeTest extends DatabaseTest {
	static val SCHEMA_PATH = "src/main/resources/tp1.sql"
	
	val home = new UsuarioHome()
	var Usuario miguelDelSel
	
	@Before
	def void setUp() {
		dropAndCreateDatabase()
		
		miguelDelSel = new Usuario() => [
			id = 1
			nombre = "Miguel"
			apellido = "Del Sel"
			username = "miguelds"
			password = "dameLaPresidencia"
			email = "miguelds@pro.gov.ar"
			nacimiento = new Date(1957,7,3)
			codigo_validacion = "1234567890"
		]
	}	
	
	@Test(expected = EntidadNoExisteException)
	def void getByIdFallaSiNoExisteElUsuario() {
		home.getById(28)
	}
	
	@Test
	def void insertAgregaUnNuevoUsuario() {
		home.insert(miguelDelSel)
				
		val usuarioDesdeSql = home.getById(1)
		assertEquals(1, usuarioDesdeSql.id)
		assertEquals("Miguel", usuarioDesdeSql.nombre)
		assertEquals("Del Sel", usuarioDesdeSql.apellido)
		assertEquals("miguelds", usuarioDesdeSql.username)
		assertEquals("dameLaPresidencia", usuarioDesdeSql.password)
		assertEquals("miguelds@pro.gov.ar", usuarioDesdeSql.email)	
		assertEquals(new Date(1957, 7, 3), usuarioDesdeSql.nacimiento)
		assertEquals("1234567890", usuarioDesdeSql.codigo_validacion)
	}
	
	@Test(expected = UsuarioYaExisteException)
	def void noSePuedenCrearDosUsuariosConElMismoUsername() {
		val macri = new Usuario() => [ 
			username = "mm2015" 
			password = "cerremosUnaEscuela"
		]
		
		home.insert(macri)
		home.insert(macri)
	}
	
	@Test
	def void updateActualizaTodasLasPropiedadesDelObjeto() {
		home.insert(miguelDelSel)
		
		miguelDelSel.password = "yoTraigoLasChicas"
		miguelDelSel.apellido = "Torres Del Sel"
		
		home.update(miguelDelSel)
		
		val usuarioDesdeSql = home.getById(1)
		assertEquals(1, usuarioDesdeSql.id)
		assertEquals("Miguel", usuarioDesdeSql.nombre)
		assertEquals("Torres Del Sel", usuarioDesdeSql.apellido)
		assertEquals("miguelds", usuarioDesdeSql.username)
		assertEquals("yoTraigoLasChicas", usuarioDesdeSql.password)
		assertEquals("miguelds@pro.gov.ar", usuarioDesdeSql.email)	
		assertEquals(new Date(1957, 7, 3), usuarioDesdeSql.nacimiento)
		assertEquals("1234567890", usuarioDesdeSql.codigo_validacion)
	}
	
	@Test
	def void findByUsernamePuedeTraerUnUsuario() {
		home.insert(miguelDelSel)
		home.insert(new Usuario() => [ username = "mm2015" ; password = "123456" ])
		
		val macri = home.findByUsername("mm2015")
		assertEquals("mm2015", macri.username)
		assertEquals("123456", macri.password)
	}
	
	@Test(expected = EntidadNoExisteException)
	def void findByUsernameFallaSiNoExisteNingunUsuario() {
		home.findByUsername("faloi")
	}	
	
	def dropAndCreateDatabase() {
		val schemaDdlCommands = new String(Files.readAllBytes(Paths.get(SCHEMA_PATH))).split(";").filter[it != "\n" && it != "\r"]
		schemaDdlCommands.forEach [ executeCommand(it) ]
	}	
}