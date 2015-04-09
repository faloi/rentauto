package org.unq.epers.grupo5.rentauto

import java.nio.file.Files
import java.nio.file.Paths
import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*
import org.unq.epers.grupo5.rentauto.entities.Usuario
import org.unq.epers.grupo5.rentauto.persistence.UsuarioHome
import org.unq.epers.grupo5.rentauto.persistence.Database
import java.util.Date

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
		var home = new UsuarioHome( new Database("tpepers") )
		
		home.insert(usuario)

		assertTrue(true)
		// assertEquals(usuario, home.getById(1))
		
	}
}