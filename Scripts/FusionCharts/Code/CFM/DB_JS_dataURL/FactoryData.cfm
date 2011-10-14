<cfsilent>
<!---
	This page is invoked from Default.cfm. When the user clicks on a pie
	slice in Default.cfm, the factory Id is passed to this page. We need
	to get that factory id, get information from database and then write XML.
	
	First, get the factory Id
--->
	<cfset FactoryId = URL.FactoryId>
	
	<cfset intCounter = 0>
	
	<!--- Generate the chart element string --->
	<cfset strXML = "<chart palette='2' caption='Factory " & FactoryId &" Output ' subcaption='(In Units)' xAxisName='Date' showValues='1' labelStep='2' >">

	<!--- Now, we get the data for that factory --->
	<cfquery name="qry" datasource="dev">
		select * from Factory_Output where FactoryId=#FactoryId#
	</cfquery>

	<cfloop query="qry">
		<cfset strXML = strXML & "<set label='" & datePart("d",qry.DatePro) & "/" & datePart("m",qry.DatePro) & "' value='" & qry.Quantity & "'/>">
	</cfloop>
	
	<!--- Close <chart> element --->
	<cfset strXML = strXML & "</chart>">
	
	<!---
	Just write out the XML data
	NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
	--->
</cfsilent><cfoutput>#strXML#</cfoutput>