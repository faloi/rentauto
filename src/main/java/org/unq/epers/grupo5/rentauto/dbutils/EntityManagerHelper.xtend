package org.unq.epers.grupo5.rentauto.dbutils

import com.google.common.base.Supplier
import javax.persistence.EntityManager
import javax.persistence.EntityManagerFactory
import javax.persistence.Persistence
import javax.persistence.Query

class EntityManagerHelper {

	private static EntityManagerFactory emf
	private static ThreadLocal<EntityManager> threadLocal

	def static EntityManager getEntityManager() {
		if (emf == null) {
			emf = Persistence.createEntityManagerFactory("db")
			threadLocal = new ThreadLocal<EntityManager>()
		}

		var manager = threadLocal.get()
		if (manager == null || !manager.isOpen()) {
			manager = emf.createEntityManager()
			threadLocal.set(manager)
		}
		return manager
	}

	def static void closeEntityManager() {
		val em = threadLocal.get()
		threadLocal.set(null)
		em.close()
	}

	def static void beginTransaction() {
		val em = EntityManagerHelper.getEntityManager()
		val tx = em.getTransaction()

		if (!tx.isActive()) {
			tx.begin()
		}
	}

	def static void commit() {
		val em = EntityManagerHelper.getEntityManager()
		val tx = em.getTransaction()

		if (tx.isActive()) {
			tx.commit()
		}
	}

	def static void rollback() {
		val em = EntityManagerHelper.getEntityManager()
		val tx = em.getTransaction()
		if (tx.isActive()) {
			tx.rollback()
		}
	}

	def static Query createQuery(String query) {
		return getEntityManager().createQuery(query)
	}

	def static void withTransaction(Runnable action) {
		withTransaction[
			action.run()
			return null
		]
	}

	def static <A> A withTransaction(Supplier<A> action) {
		beginTransaction()
		try {
			val result = action.get()
			commit()
			return result
		} catch (Throwable e) {
			rollback()
			throw e
		}
	}
}