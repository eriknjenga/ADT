Imports DataConnection
Imports InfoSoftGlobal
Imports System.Text

Partial Class DBExample_Default
    Inherits System.Web.UI.Page

    Public Function GetFactorySummaryChartHtml() As String
        'In this example, we show how to connect FusionCharts to a database.
        'For the sake of ease, we've used an Access database which is present in
        '../App_Data/FactoryDB.mdb. It just contains two tables, which are linked to each
        'other. 
        'xmlData will be used to store the entire XML document generated
        Dim xmlData As New StringBuilder()
        'We also keep a flag to specify whether we've to animate the chart or not.
        'If the user is viewing the detailed chart and comes back to this page, he shouldn't
        'see the animation again.
        Dim animateChart As String
        animateChart = Request("animate")
        'Set default value of 1
        If ((Not (animateChart) Is Nothing) AndAlso (animateChart.Length = 0)) Then
            animateChart = "1"
        End If

        'Generate the chart element
        xmlData.Append("<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation=' " & animateChart & "'>")

        'create recordset to get details for the factories
        Dim factoryQuery As String = "select a.FactoryId, a.FactoryName, sum(b.Quantity) as TotQ from .Factory_Master a, Factory_Output b where a.FactoryId=b.FactoryID group by a.FactoryId, a.FactoryName"
        Dim oRs As New DbConn(factoryQuery)

        'Iterate through each record
        While oRs.ReadData.Read()
            'Generate <set name='...' value='...' link='...'/>	
            'The link causes drill-down by loading a another page
            'The page is passed the factoryId
            'Accordingly the page creates a detailed chart against that FactoryId
            xmlData.Append("<set label='" & oRs.ReadData("FactoryName").ToString() & "' value='" & oRs.ReadData("TotQ").ToString() & "' link='" & Server.UrlEncode("Detailed.aspx?FactoryId=" & oRs.ReadData("FactoryId").ToString()) & "'/>")

        End While

        oRs.ReadData.Close()
        'Finally, close <chart> element
        xmlData.Append("</chart>")

        'Create the chart - Pie 3D Chart with data from xmlData
        Return FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", xmlData.ToString(), "FactorySum", "600", "300", False, False)
    End Function
End Class
