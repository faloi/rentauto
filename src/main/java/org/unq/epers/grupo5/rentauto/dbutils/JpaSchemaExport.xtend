package org.unq.epers.grupo5.rentauto.dbutils

import java.io.IOException;
import java.util.Properties;

import org.hibernate.cfg.Configuration;
import org.hibernate.ejb.Ejb3Configuration;
import org.hibernate.tool.hbm2ddl.SchemaExport;

/**
 * Run with args: <code>db schema.sql true true</code>
 * 
 * @author internet
 *
 */
@SuppressWarnings("deprecation")
class JpaSchemaExport {

   def static void main(String[] args) throws IOException {
      execute("db", "schema.sql", true, true);
   }

   def static void execute(String persistenceUnitName, String destination, boolean create,
         boolean format) {
      System.out.println("Starting schema export");
      val cfg = new Ejb3Configuration().configure(persistenceUnitName,
            new Properties());
      val hbmcfg = cfg.getHibernateConfiguration();
      val schemaExport = new SchemaExport(hbmcfg);
      schemaExport.setOutputFile(destination);
      schemaExport.setFormat(format);
      schemaExport.execute(true, false, false, create);
      System.out.println("Schema exported to " + destination);
   }
}