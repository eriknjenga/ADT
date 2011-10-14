package com.infosoftglobal.fusioncharts;


import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;


/**
 * Servlet implementation class for Servlet: InitServlet
 * Initializes the database name,path,DSN.Also, it instantiates the DBConnection class<br>
 * and puts it in the Application context so that all jsps can use this instance of<br>
 * DBConnection class which has all the db related parameters configured.
 * 
 * @deprecated Please use classes from com.fusioncharts package
 * 
 * @author InfoSoft Global (P) Ltd.
 */
 public class InitServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
       /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public InitServlet() {
		super();
	} 
	
	/** 
	  * @see javax.servlet.Servlet#destroy()
	  */
	public void destroy() {
		// TODO Auto-generated method stub
		super.destroy();
	}   	 	  	  	
	
       /** 
	 * @see javax.servlet.Servlet#getServletInfo()
	 */
	public String getServletInfo() {
		// TODO Auto-generated method stub
		return super.getServletInfo();
	}
	/**
	 * Init method of the servlet.<br>
	 * Reads the ServletContext parameters, instantiates DBConnection class<br>
	 * and sets these values to it.
	 * @param config ServletConfig 
	 */
	public void init(ServletConfig config) throws ServletException {
	    // TODO Auto-generated method stub
		
		DBConnection dbConn=new DBConnection();
		
		ServletContext ctx = config.getServletContext(); 
		String dbName=ctx.getInitParameter("dbName");
		String accessDBPath=ctx.getInitParameter("AccessDBPath");
		String mySQLDSN=ctx.getInitParameter("dataSourceName");
		
		dbConn.setAccessDBPath(accessDBPath);
		dbConn.setDbName(dbName);
		dbConn.setMySQLDSN(mySQLDSN);
		ctx.setAttribute("dbConn", dbConn);
		
	    super.init(config);
	}
}