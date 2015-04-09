package org.unq.epers.grupo5.rentauto

import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet
import java.util.Map
import org.unq.epers.grupo5.rentauto.exceptions.EntidadNoExisteException

abstract class HomeDb<T,E> implements IHome<T,E> {
	
	var Connection conn ;
	val String pkName ; 
	val String tableName ; 
	 
	new(Database db, String pkName, String tableName) {
		this.pkName = pkName
		this.tableName = tableName
		this.conn = db.getConnection()
	}
	
	def getConn() { this.conn }
	def getTableName () { this.tableName }
	def getPkName () { this.pkName }
	
	abstract def T rsToEntity(ResultSet rs)
	
	abstract override findBy(String conditions)
	
	override getById(E pk) 
	{
		var PreparedStatement stmt = conn.prepareStatement("SELECT " + colunmsStr + " FROM " + tableName + " WHERE " + pkName + " = ?")
		var ResultSet rs
	
		stmt.setObject(1, pk, columns.get(pkName))
		rs  = stmt.executeQuery();

		stmt.close

		if ( ! rs.next )	
			throw new EntidadNoExisteException()

		rsToEntity(rs)
	}
	
	abstract def Map<String, Integer> columns()
	
	def String colunmsStr() {		
		columns.keySet.join(",")
	}

	abstract override insert(T objeto)
	
	abstract override update(T objeto) 
	
	
	
}