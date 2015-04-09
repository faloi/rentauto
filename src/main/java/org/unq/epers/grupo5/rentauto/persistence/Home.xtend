package org.unq.epers.grupo5.rentauto.persistence

import java.util.List

interface Home<TEntity> {
	def List<TEntity> findBy(String conditions)
	def TEntity getById(int id)
	def void insert(TEntity entity)
	def void update(TEntity entity) 
}