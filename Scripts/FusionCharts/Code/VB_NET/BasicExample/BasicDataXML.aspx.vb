Imports InfoSoftGlobal
Imports System.Text
Partial Class BasicDataXML
    Inherits System.Web.UI.Page

    Public Function GetMonthlySalesChartHtml() As String
        'This page demonstrates the ease of generating charts using FusionCharts.
        'For this chart, we've used a string variable to contain our entire XML data.
        'Ideally, you would generate XML data documents at run-time, after interfacing with
        'forms or databases etc.Such examples are also present.
        'Here, we've kept this example very simple.
        'Create an XML data document in a string variable
        Dim xmlData As StringBuilder = New StringBuilder()
        xmlData.Append("<chart caption='Monthly Unit Sales' xAxisName='Month' yAxisName='Units' showValues='0' formatNumberScale='0' showBorder='1'>")
        xmlData.Append("<set label='Jan' value='462' />")
        xmlData.Append("<set label='Feb' value='857' />")
        xmlData.Append("<set label='Mar' value='671' />")
        xmlData.Append("<set label='Apr' value='494' />")
        xmlData.Append("<set label='May' value='761' />")
        xmlData.Append("<set label='Jun' value='960' />")
        xmlData.Append("<set label='Jul' value='629' />")
        xmlData.Append("<set label='Aug' value='622' />")
        xmlData.Append("<set label='Sep' value='376' />")
        xmlData.Append("<set label='Oct' value='494' />")
        xmlData.Append("<set label='Nov' value='761' />")
        xmlData.Append("<set label='Dec' value='960' />")
        xmlData.Append("</chart>")
        'Create the chart - Column 3D Chart with data from xmlData variable using dataXML method
        Return FusionCharts.RenderChartHTML("../FusionCharts/Column3D.swf", "", xmlData.ToString(), "myNext", "600", "300", False)
    End Function
End Class
