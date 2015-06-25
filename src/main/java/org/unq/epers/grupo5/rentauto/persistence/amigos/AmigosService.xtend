package org.unq.epers.grupo5.rentauto.persistence.amigos

import java.util.List
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.unq.epers.grupo5.rentauto.exceptions.BusinessException
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
		Neo4JService.run[ home(it).amigosDe(usuario).toAmigos ]		
	}

	def conexionesDe(Usuario usuario) {
		Neo4JService.run[ home(it).conexionesDe(usuario).toAmigos ]
	}

	def enviarMensaje(Usuario emisor, Usuario receptor, String mensaje) {
		if (!emisor.esAmigoDe(receptor))
			throw new NoSePuedeEnviarMensajeException(emisor, receptor)
			
		Neo4JService.run[ home(it).enviarMensaje(new Mensaje(emisor, receptor, mensaje)) ; null ]
	}
	
	def esAmigoDe(Usuario uno, Usuario otro) {
		amigosDe(uno).contains(otro)
	}
	
	def mensajesEnviadosPor(Usuario usuario) {
		Neo4JService.run[ home(it).mensajesEnviadosPor(usuario).toMensajes ]
	}	
	
	def mensajesRecibidosPor(Usuario usuario) {
		Neo4JService.run[ home(it).mensajesRecibidosPor(usuario).toMensajes ]
	}	
	
	private def nodeToAmigo(Node node) {
		find(Usuario, node.getProperty("id"))
	}
	
	private def nodeToMensaje(Node node) {
		new Mensaje(			
			getParticipanteMensaje(node, TipoDeRelaciones.ENVIADO_POR),
			getParticipanteMensaje(node, TipoDeRelaciones.RECIBIDO_POR),
			node.getProperty("mensaje") as String
		)
	}
	
	private def getParticipanteMensaje(Node node, TipoDeRelaciones relacion) {
		nodeToAmigo(node.getSingleRelationship(relacion, Direction.OUTGOING).endNode)
	}
	
	private def toAmigos(Iterable<Node> nodes) {
		nodes.map[nodeToAmigo].toList
	}
	
	private def toMensajes(Iterable<Node> nodes) {
		nodes.map[nodeToMensaje].toList
	}	
}

class NoSePuedeEnviarMensajeException extends BusinessException {
	new(Usuario uno, Usuario otro) {
		super('''«uno» no puede enviar mensajes a «otro» porque no es su amigo''')
	}
}