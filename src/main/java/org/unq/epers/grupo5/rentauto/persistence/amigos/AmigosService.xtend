package org.unq.epers.grupo5.rentauto.persistence.amigos

import java.util.List
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.unq.epers.grupo5.rentauto.model.Usuario
import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager

class AmigosService implements WithGlobalEntityManager, EntityManagerOps {
	def home(GraphDatabaseService graph) {
		new AmigosHome(graph)
	}	
	
	def amigosDe(Usuario usuario, List<Usuario> usuarios) {
		Neo4JService.run[
			val home = home(it)
			
			home.crearNodo(usuario)
			
			usuarios.forEach[amigo |
				home.crearNodo(amigo)
				home.amigoDe(usuario, amigo)
			]	
			
			null 
		]
	}
	
	def amigosDe(Usuario usuario) {
		Neo4JService.run[ home(it).amigosDe(usuario).map[nodeToAmigo].toList ]		
	}
	
	def Usuario nodeToAmigo(Node node) {
		find(Usuario, node.getProperty("id"))
	}
}