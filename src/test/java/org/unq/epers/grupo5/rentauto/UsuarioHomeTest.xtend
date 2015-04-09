package org.unq.epers.grupo5.rentauto

import java.nio.file.Files
import java.nio.file.Paths
import java.sql.Date
import org.junit.Before
import org.junit.Test
import org.unq.epers.grupo5.rentauto.entities.Usuario
import org.unq.epers.grupo5.rentauto.persistence.UsuarioHome

import static org.junit.Assert.*

class UsuarioHomeTest extends DatabaseTest {
	static val SCHEMA_PATH = "src/main/resources/tp1.sql"
	
	@Before
	def void setUp() {
		val schemaDdlCommands = new String(Files.readAllBytes(Paths.get(SCHEMA_PATH))).split(";").filter[it != "\n" && it != "\r"]
		schemaDdlCommands.forEach [ executeCommand(it) ]
	}
	
	@Test
	def void testInsert() {
		var usuario = new Usuario(1, "Miguel", "Del Sel", "miguelds", "dameLaPresidencia", "miguelds@pro.gov.ar", new Date(1957,7,3), "123467890", true)
		var home = new UsuarioHome()
		
		home.insert(usuario)
		assertEquals(usuario, home.getById(1))
	}
}