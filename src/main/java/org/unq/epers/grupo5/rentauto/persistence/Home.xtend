package org.unq.epers.grupo5.rentauto.persistence

import org.unq.epers.grupo5.rentauto.entities.Entity

interface Home<TEntity extends Entity> {
	def TEntity getById(Integer id)
	def void insert(TEntity entity)
	def void update(TEntity entity) 
}