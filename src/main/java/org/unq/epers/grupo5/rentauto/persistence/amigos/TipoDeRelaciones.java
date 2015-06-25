package org.unq.epers.grupo5.rentauto.persistence.amigos;

import org.neo4j.graphdb.RelationshipType;

public enum TipoDeRelaciones implements RelationshipType {
	ES_AMIGO, ENVIADO_POR, RECIBIDO_POR
}