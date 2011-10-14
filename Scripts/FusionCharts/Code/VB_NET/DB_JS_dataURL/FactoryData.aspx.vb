Imports DataConnection
Imports System.Text

Partial Class DB_JS_dataURL_FactoryData
    Inherits System.Web.UI.Page

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'This page is invoked from Default.asp. When the user clicks on a pie
            'slice in Default.asp, the factory Id is passed to this page. We need
            'to get that factory id, get information from database and then write XML.
            'First, get the factory Id
            Dim factoryId As String
            'Request the factory Id from Querystring
            factoryId = Request("FactoryId")

            'xmlData will be used to store the entire XML document generated
            Dim xmlData As New StringBuilder()
            'Generate the chart element string
            xmlData.Append("<chart palette='2' caption='Factory " & factoryId & " Output ' subcaption='(In Units)' xAxisName='Date (dd/MM)' showValues='1' labelStep='2' >")

            'Now, we get the data for that factory
            Dim query As String = ("select DatePro, Quantity from Factory_Output where FactoryId=" & factoryId)
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

            Response.ContentType = "text/xml"
            'Just write out the XML data
            'NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
            Response.Output.Write(xmlData.ToString())
        End If
    End Sub
End Class
