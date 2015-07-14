package org.unq.epers.grupo5.rentauto.persistence

import org.uqbarproject.jpa.java8.extras.EntityManagerOps
import org.uqbarproject.jpa.java8.extras.WithGlobalEntityManager
import org.uqbarproject.jpa.java8.extras.transaction.TransactionalOps

abstract class BasePersistenceTest implements WithGlobalEntityManager, EntityManagerOps, TransactionalOps {
}