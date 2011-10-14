Imports System.Text
Imports DataConnection
Imports InfoSoftGlobal

Partial Class UpdatePanel_Sample2
    Inherits System.Web.UI.Page
    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'This will execute first time the page loads and not on ajax post back calls
        If IsPostBack = False Then

            ' Show a blank Column2D Chart at first
            showColumnChart()
        Else

            ' Handle Ajax PostBack Call
            ' store Asp.Net Ajax special HTTP request
            ' __EVENTARGUMENT holds value passed by JS function -__doPostBack
            ' The value can be like "drillDown$1"
            'We take $ as delimiter so we get drillDown as the function to call
            'and 1 as the factory id. It can vary depending on the pie slice clicked.

            Dim sEventArguments As String = Request("__EVENTARGUMENT")
            If sEventArguments <> "" Then

                'extract arguments passed to the HTTP Request  
                Dim iDelimiter As Integer = sEventArguments.IndexOf("$")
                Dim sArgument As String = sEventArguments.Substring(iDelimiter + 1)
                ' extract the name of the post back function 
                If sEventArguments.StartsWith("drillDown") = True Then
                    ' call the post back function passing the argument(s)
                    drillDown(sArgument)
                End If
            End If
        End If
    End Sub

    ''' <summary>
    ''' Show Pie Chart on first load
    ''' </summary>
    Public Sub showPieChart()

        If IsPostBack = False Then

            ' SQL Query for Factory wise Total Quantity
            Dim strSQL As String = "select a.FactoryId,a.FactoryName,sum(b.Quantity) as TotQ from Factory_Master a,Factory_Output b where a.FactoryId=b.FactoryID group by a.FactoryId,a.FactoryName"

            ' Connect DataBase and create data reader
            Dim oRs As New DbConn(strSQL)
            ' create strXML for XML 
            Dim strXML As New StringBuilder()
            ' Add chart element
            strXML.AppendFormat("<chart caption='Factory wise Production' subcaption='Total Production in Units' formatNumberScale='0' pieSliceDepth='25'>")
            ' fetch data reader
            While oRs.ReadData.Read()

                ' create link to javascript  function for ajax post back call
                Dim link As String = "javascript:updateChart(" + oRs.ReadData("FactoryId").ToString() + ")"

                'add set element 
                strXML.Append("<set label='" & oRs.ReadData("FactoryName").ToString() & "' value='" & oRs.ReadData("TotQ").ToString() & "' link='" & link & "' />")

            End While

            ' close data reader
            oRs.ReadData.Close()

            ' close chart element
            strXML.Append("</chart>")

            ' create pie chart and store it to output string
            Dim outPut As String = FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", strXML.ToString(), "chart1", "450", "350", False, False)

            ' write the output string
            Response.Write(outPut)
        End If
    End Sub

    ' <summary>
    ' drillDown to show Column2D chart
    ' </summary>
    ' <param name="FacID">Factory Id</param>
    Private Sub drillDown(ByVal FacID As String)

        'SQL Query for Factory Details for the factory Id passed as parameter
        Dim strSQL As String = "select  a.FactoryId,a.FactoryName,b.DatePro,b.Quantity from Factory_Master a,Factory_Output b where a.FactoryId=b.FactoryID and a.FactoryId=" & FacID & " order by b.DatePro"

        ' Create data reader
        Dim oRs As New DbConn(strSQL)

        'strXML for storing XML
        Dim strXML As New StringBuilder()

        'Add Chart element
        strXML.Append("<chart caption='Factory wise Production' subcaption='Factory " & FacID & " : Daily Production' xAxisName='Day' yAxisName='Units' rotateLabels='1' bgAlpha='100' bgColor='ffffff' showBorder='0' showvalues='0' yAxisMaxValue='200'>")

        'Iterate through database
        While oRs.ReadData.Read()

            ' add set element
            strXML.Append("<set label='" & Convert.ToDateTime(oRs.ReadData("DatePro")).ToString("d/M") & "' value='" & oRs.ReadData("Quantity").ToString() & "' />")

        End While
        ' close data reader
        oRs.ReadData.Close()

        ' close chart element
        strXML.Append("</chart>")

        ' create Column2D chart and srore it to output string
        Dim outPut As String = FusionCharts.RenderChartHTML("../FusionCharts/Column2D.swf", "", strXML.ToString(), "chart2", "450", "350", False)

        ' clear the Panel
        Panel1.Controls.Clear()
        ' Add chart to the panel 
        Panel1.Controls.Add(New LiteralControl(outPut))

    End Sub

    ' <summary>
    ' show first blank Column2D chart
    ' </summary>
    Public Sub showColumnChart()

        ' blank chart element       
        Dim strXML As String = "<chart></chart>"

        ' create Column2D chart and srore it to output string
        Dim outPut As String = FusionCharts.RenderChart("../FusionCharts/Column2D.swf?ChartNoDataText=Please click on a pie slice to view detailed data.", "", strXML, "chart3", "450", "350", False, False)

        ' clear the Panel
        Panel1.Controls.Clear()
        ' Add output to Panel
        Panel1.Controls.Add(New LiteralControl(outPut))

    End Sub
End Class
