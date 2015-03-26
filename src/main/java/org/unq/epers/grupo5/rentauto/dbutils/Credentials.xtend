package org.unq.epers.grupo5.rentauto.dbutils

import java.io.FileInputStream
import java.io.FileNotFoundException
import java.util.Properties
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Credentials {
	String user
	String password

	new(String user, String password) {
		this.user = user
		this.password = password
	}
	
	def static loadFromFile(String fileName) {
		try {
			val in = new FileInputStream(fileName)
	
			val props = new Properties()
			props.load(in)
			
			in.close()
	
			new Credentials(props.getProperty("jdbc.username"), props.getProperty("jdbc.password"))		
		} catch (FileNotFoundException e) {
			throw new CredentialsNotFoundException(e, fileName)
		}
	}
}

class CredentialsNotFoundException extends RuntimeException {
	new(Exception e, String fileName) {
		super('''
			No se encontro el archivo «fileName» con las credenciales! 
			Por favor crealo con el siguiente formato:
			
			jdbc.username=root
			jdbc.password=tupassword 
		''', e)
	}
}
