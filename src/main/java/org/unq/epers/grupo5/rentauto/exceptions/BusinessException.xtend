package org.unq.epers.grupo5.rentauto.exceptions

class BusinessException extends RuntimeException {
	new(Exception exception) {
		super(exception)
	}	
	
	new(String reason) {
		super(reason)
	}
	
	new() {}
}