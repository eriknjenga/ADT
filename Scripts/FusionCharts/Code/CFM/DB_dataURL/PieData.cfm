<cfsilent>
<!---
	This page generates the XML data for the Pie Chart contained in
	Default.cfm. 		
--->
		
	<!--- Default.cfm has passed us a property animate. We request that. --->
	<cfparam name="URL.animate" default="1">
	<cfset animateChart = URL.animate>
		
	<!--- Generate the chart element --->
	<cfset strXML = "<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation=' " & animateChart & "'>">
	
	<!--- Iterate through each factory --->
	<cfquery name="qry" datasource="dev">
		select * from Factory_Master
	</cfquery>
	
	<cfloop query="qry">
		<cfset factoryID = qry.FactoryId>
		<cfset factoryName = qry.FactoryName>
		<!--- Now get details for this factory --->
		<cfquery name="qryDetails" datasource="dev">
			select sum(Quantity) as TotOutput from Factory_Output where FactoryId=#factoryID#
		</cfquery>
		<!--- Generate <set label='..' value='..'/>	--->
		<cfset strXML = strXML & "<set label='#factoryName#' value='#qryDetails.totOutput#' />">
	</cfloop>

	<!--- Finally, close <chart> element --->
	<cfset strXML = strXML & "</chart>">
	
	<!--- 
	Just write out the XML data
	NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
	--->
</cfsilent><cfoutput>#strXML#</cfoutput>
