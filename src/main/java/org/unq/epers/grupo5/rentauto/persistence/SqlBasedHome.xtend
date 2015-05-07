package org.unq.epers.grupo5.rentauto.persistence

import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException
import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet
import java.util.List
import org.unq.epers.grupo5.rentauto.exceptions.EntidadNoExisteException
import org.unq.epers.grupo5.rentauto.exceptions.UsuarioYaExisteException
import org.unq.epers.grupo5.rentauto.model.Entidad

abstract class SqlBasedHome<TEntity extends Entidad> {
	static val UNIQUE_KEY_VIOLATION_CODE = 1062
	
	protected val Connection connection
	protected val String tableName

	new(Database db, String tableName) {
		this.tableName = tableName
		this.connection = db.getConnection()
	}

	def getPkName() { "id" }

	abstract def TEntity resultSetToEntity(ResultSet rs)

	def getById(Integer id) {
		findBy('''«pkName» = «id»''')
	}

	def findBy(String whereFilter) {
		var columnsStr = columns.join(",")
		val statement = connection.prepareStatement('''SELECT «columnsStr» FROM «tableName» WHERE «whereFilter»''')
		val resultSet = statement.executeQuery();

		if (!resultSet.next)
			throw new EntidadNoExisteException()

		var entity = resultSetToEntity(resultSet)
		statement.close
		entity

	}

	abstract def List<String> columns()

	def insert(TEntity objeto) {
		var columnsStr = columns.filter[it != pkName].join(",")
		val valuesPlaceholder = columns.filter[it != pkName].map["?"].join(",")
		executeStatement(objeto, '''INSERT INTO «tableName» («columnsStr») VALUES («valuesPlaceholder»)''')
	}

	def update(TEntity objeto) {
		val valuesPlaceholder = columns.filter[it != pkName].map['''«it» = ?'''].join(",")
		executeStatement(objeto, '''UPDATE «tableName» SET «valuesPlaceholder» WHERE «pkName»=«objeto.id»''')
	}

	def executeStatement(TEntity entity, String query) {
		try {
			val statement = connection.prepareStatement(query)
	
			setColumnas(statement, entity)
	
			statement.execute
			statement.close		
		} catch (MySQLIntegrityConstraintViolationException e) {  
			if (e.errorCode == UNIQUE_KEY_VIOLATION_CODE)
				throw new UsuarioYaExisteException(e)			
			else 
				throw e
		}
	}

	abstract def void setColumnas(PreparedStatement stmt, TEntity entity)
}