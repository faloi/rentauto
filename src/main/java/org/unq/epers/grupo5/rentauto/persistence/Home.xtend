package org.unq.epers.grupo5.rentauto.persistence

interface Home<TEntity> {
	def TEntity getById(int id)
	def void insert(TEntity entity)
	def void update(TEntity entity) 
}