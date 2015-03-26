package org.unq.epers.grupo5.rentauto

import java.sql.Connection
import java.sql.DriverManager
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

class DatabaseTest {
	static val DATABASE_NAME = "EPERS_TEST"
	
	@Before
	def void setUp() {
		executeCommand('''CREATE DATABASE «DATABASE_NAME»''')
	}
	
	@After
	def void tearDown() {
		executeCommand('''DROP DATABASE «DATABASE_NAME»''')
	}

	@Test
	def void dummy() {
		val conn = this.getConnection(DATABASE_NAME)
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
		
		conn.createStatement.executeUpdate(createTable)
		
		val ps = conn.prepareStatement('''INSERT INTO «tableName» (NOMBRE, CODIGO) VALUES (?,?)''');
		ps.setString(1, "UnaAerolinea");
		ps.setString(2, "UNA");

		try {
			ps.execute();
			assertEquals("Se espera que haya podido insertar 1 registro", 1, ps.getUpdateCount());
			ps.close();
		} finally {
			if (ps != null)
				ps.close();
			if (conn != null)
				conn.close();
		}
	}

	def Connection getConnection() {
		this.getConnection("")
	}
	
	def Connection getConnection(String databaseName) {
		Class.forName("com.mysql.jdbc.Driver")
		DriverManager.getConnection('''jdbc:mysql://localhost/«databaseName»''', "root", "root")
	}	
	
	def executeCommand(String command) {
		val connection = this.connection
		val statement = connection.createStatement
		
		statement.executeUpdate(command)
		
		statement.close
		connection.close
	}
}