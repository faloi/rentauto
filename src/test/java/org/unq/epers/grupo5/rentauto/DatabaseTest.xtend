package org.unq.epers.grupo5.rentauto

import java.io.FileInputStream
import java.sql.Connection
import java.sql.DriverManager
import java.util.Properties
import org.eclipse.xtend.lib.annotations.Accessors
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

@Accessors
class Credentials {
	String user
	String password

	new(String user, String password) {
		this.user = user
		this.password = password
	}
}

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

		val credentials = this.credentials
		DriverManager.getConnection('''jdbc:mysql://localhost/«databaseName»''', credentials.user, credentials.password)
	}

	def getCredentials() {
		val props = new Properties()
		val in = new FileInputStream("src/main/resources/db.properties")
		props.load(in)
		in.close()

		new Credentials(props.getProperty("jdbc.username"), props.getProperty("jdbc.password"))
	}

	def executeCommand(String command) {
		val connection = this.connection
		val statement = connection.createStatement

		statement.executeUpdate(command)

		statement.close
		connection.close
	}
}