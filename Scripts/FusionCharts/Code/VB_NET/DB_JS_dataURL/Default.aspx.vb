Imports DataConnection
Imports InfoSoftGlobal
Imports System.Text

Partial Class DB_JS_dataURL_Default
    Inherits System.Web.UI.Page
    Public Function GetFactorySummaryChartHtml() As String

        'xmlData will be used to store the entire XML document generated
        Dim xmlData As New StringBuilder()

        'Generate the chart element
        xmlData.Append("<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units'>")

        'create recordset to get details for the factories
        Dim factoryQuery As String = "select a.FactoryId, a.FactoryName, sum(b.Quantity) as TotQ from .Factory_Master a, Factory_Output b where a.FactoryId=b.FactoryID group by a.FactoryId, a.FactoryName"
        Dim oRs As New DbConn(factoryQuery)

        'Iterate through each record
        While oRs.ReadData.Read()
            'Generate <set name='..' value='..' link='...'/>	
            'The link causes drill-down by calling (here) a JavaScript function
            'The function is passed the Factory id
            'The function updates the second chart 
            xmlData.Append("<set label='" & oRs.ReadData("FactoryName").ToString() & "' value='" & oRs.ReadData("TotQ").ToString & "' link='JavaScript:updateChart(" & oRs.ReadData("FactoryId").ToString() & ")' />")

        End While
        oRs.ReadData.Close()

        'Close chart element
        xmlData.Append("</chart>")

        'Create the chart - Pie 3D Chart with data from xmlData
        Return FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", xmlData.ToString(), "FactorySum", "500", "250", False, True)
    End Function

    Public Function GetFactoryDetailedChartHtml() As String
        'Column 2D Chart with changed "No data to display" message
        'We initialize the chart with <chart></chart>
        Return FusionCharts.RenderChart("../FusionCharts/Column2D.swf?ChartNoDataText=Please select a factory from pie chart above to view detailed data.", "", "<chart></chart>", "FactoryDetailed", "600", "250", False, True)
    End Function
End Class
