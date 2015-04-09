package org.unq.epers.grupo5.rentauto

import java.nio.file.Files
import java.nio.file.Paths
import org.junit.Before
import org.junit.Test

class UsuarioHomeTest extends DatabaseTest {
	static val SCHEMA_PATH = "src/main/resources/tp1.sql"
	
	@Before
	def void setUp() {
		val schemaDdlCommands = new String(Files.readAllBytes(Paths.get(SCHEMA_PATH))).split(";").filter[it != "\n"]
		schemaDdlCommands.forEach [ executeCommand(it) ]
	}
	
	@Test
	def void dummy() {}
}