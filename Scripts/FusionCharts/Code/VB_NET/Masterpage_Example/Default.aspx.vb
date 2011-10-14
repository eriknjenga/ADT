Imports InfoSoftGlobal
Partial Class _Default
    Inherits System.Web.UI.Page

    ''' <summary>
    ''' FusionCharts in Master Page
    ''' </summary>
    Public Function GetMonthlyalesChartHtml() As String

        'For a head start we have kept the example simple
        'You can use complex code to render chart taking data streaming from 
        'database etc.

        'Create the chart - Column 3D Chart with data from Data/Data.xml
        Return FusionCharts.RenderChart("../FusionCharts/Column3D.swf", "Data/Data.xml", "", "myFirst", "600", "300", False, True)
    End Function
End Class
