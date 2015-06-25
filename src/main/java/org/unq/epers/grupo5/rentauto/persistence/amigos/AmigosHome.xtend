package org.unq.epers.grupo5.rentauto.persistence.amigos

import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.DynamicLabel
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType
import org.neo4j.kernel.Traversal
import org.unq.epers.grupo5.rentauto.exceptions.BusinessException
import org.unq.epers.grupo5.rentauto.model.Usuario

@Accessors
class AmigosHome {
	GraphDatabaseService graph

	new(GraphDatabaseService graph) {
		this.graph = graph
	}

	def amigoLabel() {
		DynamicLabel.label("Amigo")
	}

	def crearNodo(Usuario amigo) {
		validate(amigo)		
		graph.createNode(amigoLabel).setProperty("id", amigo.id)
	}

	def amigosDe(Usuario amigo) {
		nodosRelacionados(getNodo(amigo), TipoDeRelaciones.AMIGO, Direction.BOTH)
	}
	
	def conexionesDe(Usuario amigo) {
		val nodo = getNodo(amigo)
		
		graph.traversalDescription
			.relationships(TipoDeRelaciones.AMIGO)
			.traverse(nodo)
			.nodes
			.filter[it != nodo]
	}

	def amigoDe(Usuario amigo, Usuario amigo2) {
		getNodo(amigo).createRelationshipTo(getNodo(amigo2), TipoDeRelaciones.AMIGO)
	}
	
	private def getNodo(Usuario amigo) {
		validate(amigo)		
		graph.findNodes(amigoLabel, "id", amigo.id).head
	}
	
	private def validate(Usuario amigo) {
		if (amigo.id.equals(0))
			throw new BusinessException("Para poder usar este servicio, primero se debe persistir al amigo en SQL")
	}

	private def nodosRelacionados(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}	
}