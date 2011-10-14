Imports DataConnection
Imports InfoSoftGlobal
Imports System.Text

Partial Class DBExample_Detailed
    Inherits System.Web.UI.Page

    Public Function GetFactoryDetailedChartHtml() As String
        'This page is invoked from Default.asp. When the user clicks on a pie
        'slice in Default.aspx, the factory Id is passed to this page. We need
        'to get that factory id, get information from database and then show
        'a detailed chart.
        'First, get the factory Id
        Dim factoryId As String
        'Request the factory Id from Querystring
        factoryId = Request("FactoryId")

        'xmlData will be used to store the entire XML document generated
        Dim xmlData As New StringBuilder()

        'Generate the chart element string
        xmlData.Append("<chart palette='2' caption='Factory " & factoryId & " Output ' subcaption='(In Units)' xAxisName='Date (dd/MM)' showValues='1' labelStep='2' >")

        'Now, we get the data for that factory
        Dim query As String = "select DatePro, Quantity from Factory_Output where FactoryId=" & factoryId
        Dim oRs As New DbConn(query)
        'Iterate through each record
        While oRs.ReadData.Read()
            'Convert date from database into dd/mm format
            'Generate <set name='..' value='..' />		    
            xmlData.Append("<set label='" & Convert.ToDateTime(oRs.ReadData("DatePro")).ToString("dd/MM") & "' value='" & oRs.ReadData("Quantity").ToString() & "'/>")

        End While
        oRs.ReadData.Close()
        'Close <chart> element
        xmlData.Append("</chart>")
        'Create the chart - Column 2D Chart with data from xmlData
        Return FusionCharts.RenderChart("../FusionCharts/Column2D.swf", "", xmlData.ToString(), "FactoryDetailed", "600", "300", False, False)
    End Function
End Class
