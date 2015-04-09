package org.unq.epers.grupo5.rentauto

import java.sql.Connection
import java.sql.DriverManager
import org.unq.epers.grupo5.rentauto.dbutils.Credentials

class DatabaseTest {
	def Connection getConnection(String databaseName) {
		Class.forName("com.mysql.jdbc.Driver")

		val credentials = Credentials.loadFromFile("src/main/resources/db.properties")
		DriverManager.getConnection('''jdbc:mysql://localhost/«databaseName»''', credentials.user, credentials.password)
	}

	def executeCommand(String command) {
		val connection = this.getConnection("")
		val statement = connection.createStatement

		statement.execute(command)

		statement.close
		connection.close
	}		
}