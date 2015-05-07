package org.unq.epers.grupo5.rentauto.model

import java.util.List

interface IUsuario {
	def void agregarReserva(Reserva unaReserva)
	def List<Reserva> getReservas()
}