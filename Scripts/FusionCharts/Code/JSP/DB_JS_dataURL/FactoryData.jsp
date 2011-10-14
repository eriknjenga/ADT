<%@ include file="../Includes/DBConn.jsp"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
	/*
	This page is invoked from Default.jsp. When the user clicks on a pie
	slice in Default.asp, the factory Id is passed to this page. We need
	to get that factory id, get information from database and then write XML.
	*/
	//First, get the factory Id
	String factoryId=null;
	//Request the factory Id from Querystring
	factoryId = request.getParameter("factoryId");
	String strXML="";
	if(null!=factoryId){
	
		ResultSet rs;
		String strQuery;
		Statement st;
		java.sql.Date date=null;
		java.util.Date uDate=null;
		String uDateStr="";
		String quantity="";

		//Generate the chart element string
		strXML = "<chart palette='2' caption='Factory " +factoryId+" Output ' subcaption='(In Units)' xAxisName='Date' showValues='1' labelStep='2' >";
		//Now, we get the data for that factory
		strQuery = "select * from Factory_Output where FactoryId=" + factoryId;
		st=oConn.createStatement();
		rs = st.executeQuery(strQuery);

		while(rs.next()){
			date=rs.getDate("DatePro");
			quantity=rs.getString("Quantity");
			if(date!=null) {
			  uDate=new java.util.Date(date.getTime());
			  SimpleDateFormat sdf=new SimpleDateFormat("dd/MM");
			  uDateStr=sdf.format(uDate);
			}
			strXML += "<set label='" +uDateStr+"' value='" +quantity+"'/>";
		}
		//Close <chart> element
		strXML +="</chart>";
		try {
			if(null!=rs){
				rs.close();
				rs=null;
			}
		}catch(java.sql.SQLException e){
			 //do something
			 System.out.println("Could not close the resultset");
		}			
		try {
			if(null!=st) {
				st.close();
				st=null;
			}
		    }catch(java.sql.SQLException e){
			 	System.out.println("Could not close the statement");
			}
		try {
			if(null!=oConn) {
			    oConn.close();
			    oConn=null;
			}
		    }catch(java.sql.SQLException e){
			 	System.out.println("Could not close the connection");
			}
		//Just write out the XML data
		//NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
		response.setContentType("text/xml");
	}
%>
<%=strXML%>