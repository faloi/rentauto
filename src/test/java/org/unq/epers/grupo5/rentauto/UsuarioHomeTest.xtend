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

class UsuarioHomeTest extends DatabaseTest {
	static val SCHEMA_PATH = "src/main/resources/tp1.sql"
	val home = new UsuarioHome()
	
	@Before
	def void setUp() {
		val schemaDdlCommands = new String(Files.readAllBytes(Paths.get(SCHEMA_PATH))).split(";").filter[it != "\n" && it != "\r"]
		schemaDdlCommands.forEach [ executeCommand(it) ]
	}
	
	@Test
	def void insertAgregaUnNuevoUsuario() {
		home.insert(new Usuario() => [
			nombre = "Miguel"
			apellido = "Del Sel"
			username = "miguelds"
			password = "dameLaPresidencia"
			email = "miguelds@pro.gov.ar"
			nacimiento = new Date(1957,7,3)
			codigo_validacion = "1234567890"
		])
				
		val usuarioDesdeSql = home.getById(1)
		assertEquals(usuarioDesdeSql.id, 1)
		assertEquals(usuarioDesdeSql.nombre, "Miguel")
		assertEquals(usuarioDesdeSql.apellido, "Del Sel")
		assertEquals(usuarioDesdeSql.username, "miguelds")
		assertEquals(usuarioDesdeSql.password, "dameLaPresidencia")
		assertEquals(usuarioDesdeSql.email, "miguelds@pro.gov.ar")	
		assertEquals(usuarioDesdeSql.nacimiento, new Date(1957, 7, 3))
		assertEquals(usuarioDesdeSql.codigo_validacion, "1234567890")
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
}