Imports InfoSoftGlobal
Imports System.Text

Partial Class ArrayExample_SingleSeries
    Inherits System.Web.UI.Page

    Public Function GetProductSalesChartHtml() As String

        'In this example, we plot a single series chart from data contained
        'in an array. The array will have two columns - first one for data label
        'and the next one for data values.
        'Let's store the sales data for 6 products in our array). We also store
        'the name of products. 
        Dim arrData(,) As String = _
            { _
                {"Product A", "567500"}, _
                {"Product B", "815300"}, _
                {"Product C", "556800"}, _
                {"Product D", "734500"}, _
                {"Product E", "676800"}, _
                {"Product F", "648500"} _
            }


        'Now, we need to convert this data into XML. We convert this using String Builder.
        Dim xmlData As New StringBuilder()
        'Initialize <chart> element
        xmlData.Append("<chart caption='Sales by Product' numberPrefix='$' formatNumberScale='0'>")

        'Convert data to XML and append
        Dim i As Integer 
        For i = arrData.GetLowerBound(0) To arrData.GetUpperBound(0)
            xmlData.Append("<set label='" & arrData(i, 0) & "' value='" & arrData(i, 1) & "' />")
        Next

        'Close <chart> element
        xmlData.Append("</chart>")

        'Create the chart - Column 3D Chart with data contained in xmlData
        Return FusionCharts.RenderChart("../FusionCharts/Column3D.swf", "", xmlData.ToString(), "productSales", "600", "300", False, False)
    End Function
End Class
