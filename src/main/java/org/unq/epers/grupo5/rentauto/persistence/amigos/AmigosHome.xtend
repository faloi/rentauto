package org.unq.epers.grupo5.rentauto.persistence.amigos

import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType
import org.unq.epers.grupo5.rentauto.exceptions.BusinessException
import org.unq.epers.grupo5.rentauto.model.Mensaje
import org.unq.epers.grupo5.rentauto.model.Usuario

@Accessors
class AmigosHome {
	GraphDatabaseService graph

	new(GraphDatabaseService graph) {
		this.graph = graph
	}

	def crearNodo(Usuario amigo) {
		validate(amigo)
		crearNodo(Etiquetas.AMIGO, newHashMap("id" -> amigo.id))
	}

	def amigosDe(Usuario amigo) {
		nodosRelacionados(getNodo(amigo), TipoDeRelaciones.ES_AMIGO, Direction.BOTH)
	}
	
	def conexionesDe(Usuario amigo) {
		val nodo = getNodo(amigo)
		
		graph.traversalDescription
			.relationships(TipoDeRelaciones.ES_AMIGO)
			.traverse(nodo)
			.nodes
			.filter[it != nodo]
	}

	def amigoDe(Usuario amigo, Usuario amigo2) {
		getNodo(amigo).crearRelacion(amigo2, TipoDeRelaciones.ES_AMIGO)
	}
	
	def enviarMensaje(Mensaje mensaje) {
		crearNodo(Etiquetas.MENSAJE, newHashMap("mensaje" -> mensaje.mensaje))
			.crearRelacion(mensaje.emisor, TipoDeRelaciones.ENVIADO_POR)
			.crearRelacion(mensaje.receptor, TipoDeRelaciones.RECIBIDO_POR)
	}
	
	def mensajesEnviadosPor(Usuario amigo) {
		mensajesDe(amigo, TipoDeRelaciones.ENVIADO_POR)
	}
	
	def mensajesRecibidosPor(Usuario amigo) {
		mensajesDe(amigo, TipoDeRelaciones.RECIBIDO_POR)
	}
	
	private def mensajesDe(Usuario amigo, TipoDeRelaciones tipo) {
		nodosRelacionados(getNodo(amigo), tipo, Direction.INCOMING)
	}
	
	private def getNodo(Usuario amigo) {
		validate(amigo)
		graph.findNodes(Etiquetas.AMIGO, "id", amigo.id).head
	}
	
	private def validate(Usuario amigo) {
		if (amigo.id.equals(0))
			throw new BusinessException("Para poder usar este servicio, primero se debe persistir al amigo en SQL")
	}

	private def nodosRelacionados(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}
	
	private def crearNodo(Etiquetas label, Map<String, Object> properties) {
		val nodo = graph.createNode(label)
		properties.forEach[key, value | nodo.setProperty(key, value)]
		
		nodo
	}
	
	private def crearRelacion(Node node, Usuario amigo, TipoDeRelaciones relacion) {
		node.createRelationshipTo(getNodo(amigo), relacion)
		node
	}
}