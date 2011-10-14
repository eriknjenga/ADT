/*
 * Created on Oct 25, 2006
 * 
 *
 */
package com.infosoftglobal.fusioncharts;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.sql.DataSource;
import com.infosoftglobal.fusioncharts.Constants;

/**
 * 
 * Contains methods to get a connection to the database.<br>
 * The database could be MS Access or MySQL<br>
 * This class contains database specific code to connect to the database Access or MySQL<br>
 * Only one instance of this class should ideally be used throughtout your application.<br>
 * For demo purpose, we have kept the default constructor available to all classes.<br>
 * Ideally you would override the default constructor and write a getInstance method which will<br>
 * return a single DBConnection instance always,thus making it a singleton class.<br>
 * In the current application,<code>InitServlet</code> instantiates this class and sets all the <br>
 * variables like dbName,accessDBPath & mySQLDSN and puts that instance in the application context<br>
 * so that it is available to all the jsps.<br>
 * 
 * @deprecated Please use classes from com.fusioncharts.database package
 * 
 * @author InfoSoft Global (P) Ltd.
 * 
 */
public class DBConnection {
    
    /**
     * Name of the database to be used
     */
    private String dbName="";
    /**
     * Path to the access DB
     */
    private String accessDBPath="";
    /**
     * DSN for the MySql DB
     */
    private String mySQLDSN="";
    
    /**
     * Returns a connection to a database as configured earlier.<br>
     * This method can be used by all the jsps to get a connection.<br>
     * The jsps do not have to worry about which db to connect to etc.<br>
     * This has been configured in this class by the InitServlet.<br>
     * @return Connection - a connection to the specific database based on the configuration
     */
    public Connection getConnection() {
	Connection oConn=null;
	if(this.dbName.equals(Constants.ACCESSDB)){
	    //Connection to the Access DB needs a path 
	   oConn = getConnection(this.accessDBPath);
	}
	else if(this.dbName.equals(Constants.MYSQLDB)){
	    // Connection to the mySQL DB
	    oConn = getConnectionByDSN(this.mySQLDSN);
	}
	return oConn;
    }
   
    /**
     * Gets a connection to the specific database as given in configuration file.<br>
     * First it checks connection to which database is required<br>
     * then it calls the appropriate getConnection method<br> 
     * In real world applications,some sort of connection pooling mechanism <br>
     * would be used for getting the connection and proper care would be taken to<br>
     * close it when the work is done.
     * 
     * @param context ServletContext of the server requesting connection
     * @return Connection - a connection to the database given in configuration file of the server.
     * 
     */
    public Connection getConnection(ServletContext context) {
	Connection oConn=null;
	String dbName=context.getInitParameter("dbName");
	this.dbName=dbName;
	String pathToDB=context.getInitParameter("AccessDBPath");
	this.accessDBPath=pathToDB;
	String dsName=context.getInitParameter("dataSourceName");
	this.mySQLDSN=dsName;
	if(dbName.equals(Constants.ACCESSDB)){
	    //Connection to the Access DB needs a path 
	   oConn = getConnection(pathToDB);
	}
	else if(dbName.equals(Constants.MYSQLDB)){
	    // Connection to the mySQL DB
	    oConn = getConnectionByDSN(dsName);
	}
	return oConn;
    }
    /**
     * Opens the connection to the MySQL Database<br>
     * Using the DataSource Name specified in the config file of the server in which it is deployed.<br>
     * In real world applications,some sort of connection pooling mechanism <br>
     * would be used for getting the connection and proper care would be taken to<br>
     * close it when the work is done.<br>
     *  
     * @return Connection a connection to the MySQL database
     */
    private Connection getConnectionByDSN(String dataSourceName) {
	Connection oConn = null;

	try {
    	  	Context initContext = new InitialContext();
    	  	Context envContext  = (Context)initContext.lookup("java:/comp/env");
    	  	DataSource ds = (DataSource)envContext.lookup(dataSourceName);//"jdbc/FusionChartsDB"
    	  	oConn = ds.getConnection();
    
	} catch (SQLException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	} catch (NamingException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}
	return oConn;
    }
    /**
     * Opens the connection to the Access Database<br>
     * The complete path to the mdb comes from configuration file web.xml.<br>
     * Here we are just printing the stack trace in case of any exception.<br>
     * In real world applications,some kind of exception-handling needs to be done.<br>
     * Further,in real world applications,some sort of connection pooling mechanism <br>
     * would be used for getting the connection and proper care would be taken to<br>
     * close it when the work is done. 
     * @param pathToDB - the path to the mdb file
     * @return Connection - a connection to the Access database
     */
    private Connection getConnection(String pathToDB) {
	Connection oConn = null;

	try {
	    Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");

	    String absolutePath = pathToDB;
	   /* add connection mode here if required */
	    String connString = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ="
		    + absolutePath;

	    oConn = DriverManager.getConnection(connString, "", "");
	} catch (ClassNotFoundException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	} catch (SQLException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}
	return oConn;
    }
    
    /**
     * Gets the path to the Access DB
     * @return String - path to the Access DB
     */
    public String getAccessDBPath() {
        return accessDBPath;
    }
    /**
     * Sets the path to the AccessDB
     * @param accessDBPath - path to the Access DB
     */
    public void setAccessDBPath(String accessDBPath) {
        this.accessDBPath = accessDBPath;
    }
    /**
     * Gets the Database Name for the current instance
     * @return String - the Database name
     */
    public String getDbName() {
        return dbName;
    }
    /**
     * Sets the Database Name for the current instance
     * @param dbName
     */
    public void setDbName(String dbName) {
        this.dbName = dbName;
    }
    /**
     * Gets the DSN for MySQLDB
     * @return String - the DSN for MySQLDB
     */
    public String getMySQLDSN() {
        return mySQLDSN;
    }
    /**
     * Sets the DSN for MySQLDB
     * @param mySQLDSN
     */
    public void setMySQLDSN(String mySQLDSN) {
        this.mySQLDSN = mySQLDSN;
    }

}
