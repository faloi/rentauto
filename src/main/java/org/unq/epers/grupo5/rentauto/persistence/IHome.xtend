package org.unq.epers.grupo5.rentauto.persistence

import java.util.List

interface IHome<T, E> {
	def List<T> findBy(String conditions)
	def T getById(E pk)
	def void insert(T objeto)
	def void update(T objeto) 
}