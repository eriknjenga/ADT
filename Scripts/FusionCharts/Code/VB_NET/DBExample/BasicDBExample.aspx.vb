Imports InfoSoftGlobal
Imports System.Text
'
Imports DataConnection
Partial Class DBExample_BasicDBExample
    Inherits System.Web.UI.Page

    Public Function GetFactorySummaryChartHtml() As String
        'In this example, we show how to connect FusionCharts to a database.
        'For the sake of ease, we've used an Access database which is present in
        '../App_Data/FactoryDB.mdb. It just contains two tables, which are linked to each
        'other. 
        'xmlData will be used to store the entire XML document generated
        Dim xmlData As New StringBuilder()
        'Generate the chart element
        xmlData.Append("<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units'>")

        'create recordset to get details for the factories
        Dim factoryQuery As String = "select a.FactoryId, a.FactoryName, sum(b.Quantity) as TotQ from .Factory_Master a, Factory_Output b where a.FactoryId=b.FactoryID group by a.FactoryId, a.FactoryName"
        Dim oRs As New DbConn(factoryQuery)

        'Iterate through each record
        While oRs.ReadData.Read()
            'Generate <set name='..' value='..' />		
            xmlData.Append("<set label='" & oRs.ReadData("FactoryName").ToString() & "' value='" & oRs.ReadData("TotQ").ToString & "' />")
        End While
        oRs.ReadData.Close()

        'Close chart element
        xmlData.Append("</chart>")

        'Create the chart - Pie 3D Chart with data from xmlData
        Return FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", xmlData.ToString(), "FactorySum", "600", "300", False, False)
    End Function
End Class
