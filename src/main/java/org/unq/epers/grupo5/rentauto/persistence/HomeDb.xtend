package org.unq.epers.grupo5.rentauto.persistence

import java.sql.Connection
import java.sql.ResultSet
import java.util.Map
import org.unq.epers.grupo5.rentauto.exceptions.EntidadNoExisteException

abstract class HomeDb<T> implements Home<T> {
	protected val Connection connection
	protected val String tableName
	 
	new(Database db, String tableName) {
		this.tableName = tableName
		this.connection = db.getConnection()
	}
	
	def getPkName () { "id" }
	
	abstract def T resultSetToEntity(ResultSet rs)
	
	override getById(int id) {
		findBy('''«pkName» = «id»''')
	}
	
	def findBy(String whereFilter) {
		val statement = connection.prepareStatement('''SELECT «columnsStr» FROM «tableName» WHERE «whereFilter»''')		
		val resultSet = statement.executeQuery();

		statement.close

		if (!resultSet.next)	
			throw new EntidadNoExisteException()

		resultSetToEntity(resultSet)		
	}
	
	abstract def Map<String, Integer> columns()
	
	def String columnsStr() {		
		columns.keySet.join(",")
	}

	abstract override insert(T objeto)
	
	abstract override update(T objeto) 
}