package org.unq.epers.grupo5.rentauto

import java.sql.Connection
import java.sql.DriverManager
import org.unq.epers.grupo5.rentauto.dbutils.Credentials
import org.eclipse.xtend.lib.annotations.Accessors

class Database 
{
	var String databaseName 
	var Connection conn
	
	new(String databaseName)
	{
		this.databaseName = databaseName
		this.conn = getConnection
	}

	def Connection getConnection() {
		
		Class.forName("com.mysql.jdbc.Driver")

		val credentials = this.credentials
		DriverManager.getConnection('''jdbc:mysql://localhost/«databaseName»''', credentials.user, credentials.password)
	}

	def getCredentials() {
		Credentials.loadFromFile("src/main/resources/db.properties")
	}
	
}