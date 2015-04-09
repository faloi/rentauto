package org.unq.epers.grupo5.rentauto

import java.sql.Connection
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

class DatabaseDummyTest extends DatabaseTest {
	static val DATABASE_NAME = "EPERS_TEST"
	Connection connection

	@Before
	def void setUp() {
		executeCommand('''CREATE DATABASE «DATABASE_NAME»''')
		connection = getConnection(DATABASE_NAME)
	}

	@After
	def void tearDown() {
		connection.close()
		executeCommand('''DROP DATABASE «DATABASE_NAME»''')
	}

	@Test
	def void dummy() {
		val tableName = "Dummy"

		val createTable = '''
			CREATE TABLE `«DATABASE_NAME»`.`«tableName»` (
			  `ID` INTEGER  NOT NULL AUTO_INCREMENT,
			  `NOMBRE` VARCHAR(255)  NOT NULL,
			  `CODIGO` VARCHAR(3)  NOT NULL,
			  PRIMARY KEY (`ID`),
			  INDEX `CODIGO`(`CODIGO`)
			)
		'''

		connection.createStatement.executeUpdate(createTable)

		val ps = connection.prepareStatement('''INSERT INTO «tableName» (NOMBRE, CODIGO) VALUES (?,?)''');
		ps.setString(1, "UnaAerolinea");
		ps.setString(2, "UNA");

		try {
			ps.execute();
			assertEquals("Se espera que haya podido insertar 1 registro", 1, ps.getUpdateCount());
		} finally {
			if (ps != null)
				ps.close();
		}
	}
}