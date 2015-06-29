package org.unq.epers.grupo5.rentauto.persistence.amigos

import org.neo4j.graphdb.factory.GraphDatabaseFactory
import org.neo4j.graphdb.GraphDatabaseService
import org.eclipse.xtext.xbase.lib.Functions.Function1

class Neo4JService {

	static private GraphDatabaseService _graphDb

	static synchronized def GraphDatabaseService getGraphDb() {
		if (_graphDb == null) {
			_graphDb = new GraphDatabaseFactory()
				.newEmbeddedDatabaseBuilder("./target/neo4j")
				.newGraphDatabase();
				registerShutDownHook
		}
		_graphDb
	}
	
	static def <T> T run(Function1<GraphDatabaseService, T> command){
		val tx = getGraphDb.beginTx
		try{
			val t = command.apply(getGraphDb)
			tx.success
			t
		}catch(Exception e){
			tx.failure
			throw e
		}finally{
			tx.close
		}
	}
	
	static def registerShutDownHook() {
    	Runtime.runtime.addShutdownHook(new Thread([|
    		graphDb.shutdown
    	]))
  	}
}
