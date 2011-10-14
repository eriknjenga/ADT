Imports DataConnection
Imports System.Text
Partial Class DB_dataURL_PieData
    Inherits System.Web.UI.Page

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'This page generates the XML data for the Pie Chart contained in
        'Default.asp.     
        'For the sake of ease, we've used an Access database which is present in
        '../App_Data/FactoryDB.mdb. It just contains two tables, which are linked to each
        'other. 

        'xmlData will be used to store the entire XML document generated
        Dim xmlData As New StringBuilder()


        'Default.aspx has passed us a property animate. We request that.
        Dim animateChart As String
        animateChart = Request("animate")
        'Set default value of 1
        If ((Not (animateChart) Is Nothing) AndAlso (animateChart.Length = 0)) Then
            animateChart = "1"
        End If

        'Generate the chart element
        xmlData.Append("<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation='" & animateChart & "'>")

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

        'Set Proper output content-type
        Response.ContentType = "text/xml"
        'Just write out the XML data
        'NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
        Response.Write(xmlData.ToString())

    End Sub
End Class
