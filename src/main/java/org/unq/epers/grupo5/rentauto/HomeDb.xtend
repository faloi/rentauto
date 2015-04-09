package org.unq.epers.grupo5.rentauto

import org.unq.epers.grupo5.rentauto.IHome
import java.sql.Connection
import java.sql.ResultSet
import java.sql.PreparedStatement
import java.util.List
import java.util.Map

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
	
		stmt.setObject(1, pk, colunms.get(pkName))
		rs  = stmt.executeQuery();

		stmt.close

		if ( ! rs.next )	
			throw new EntidadNoExiste()

		rsToEntity(rs)
	}
	
	abstract def Map<String, Integer> colunms()
	
	def String colunmsStr() {		
		colunms.keySet.join(",")
	}

	abstract override insert(T objeto)
	
	abstract override update(T objeto) 
	
	
	
}