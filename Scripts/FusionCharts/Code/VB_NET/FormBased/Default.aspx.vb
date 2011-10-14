Imports InfoSoftGlobal
Imports System.Text

Partial Class FormBased_Default
    Inherits System.Web.UI.Page

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            DivSubmission.Visible = False
            DivFormParameters.Visible = True
        Else
            DivSubmission.Visible = True
            DivFormParameters.Visible = False
        End If
    End Sub

    Public Sub ButtonChart_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ButtonChart.Click
        'We first request the data from the form
        Dim desserts As String
        Dim soups As String
        Dim salads As String
        Dim sandwiches As String
        Dim beverages As String
        soups = TextBoxSoups.Text
        salads = TextboxSalads.Text
        sandwiches = TextboxSandwiches.Text
        beverages = TextboxBeverages.Text
        desserts = TextboxDesserts.Text
        'In this example, we're directly showing this data back on chart.
        'In your apps, you can do the required processing and validating
        'before showing the relevant data.
        'Now that we've the data in variables, we need to convert this into XML.
        'The simplest method to convert data into XML is using string concatenation.    
        Dim xmlData As New StringBuilder()
        'Initialize <chart> element
        xmlData.Append("<chart caption='Sales by Product Category' subCaption='For this week' showPercentValues='0' pieSliceDepth='30' showBorder='1'>")
        'Add all data
        xmlData.Append("<set label='Soups' value='" & soups & "' />")
        xmlData.Append("<set label='Salads' value='" & salads & "' />")
        xmlData.Append("<set label='Sandwiches' value='" & sandwiches & "' />")
        xmlData.Append("<set label='Beverages' value='" & beverages & "' />")
        xmlData.Append("<set label='Desserts' value='" & desserts & "' />")

        'Close <chart> element
        xmlData.Append("</chart>")
        'Create the chart - Pie 3D Chart with data from xmlData
        LiteralChart.Text = FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", xmlData.ToString(), "Sales", "500", "300", False, False)
    End Sub
End Class
