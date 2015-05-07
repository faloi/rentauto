package org.unq.epers.grupo5.rentauto.model

import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.unq.epers.grupo5.rentauto.dbutils.EntityManagerHelper.*

class PersistenceTest {
	@Before
	def void before() {
		beginTransaction()
	}

	@After
	def void after() {
		rollback()
	}

	@Test
	def void testName() {
		entityManager.persist(new Familiar)
	}
}