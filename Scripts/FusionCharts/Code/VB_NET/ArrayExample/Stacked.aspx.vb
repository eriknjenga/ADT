Imports InfoSoftGlobal
Imports System.Text

Partial Class ArrayExample_Stacked
    Inherits System.Web.UI.Page

    Public Function GetProductSalesChartHtml() As String
        'In this example, we plot a Stacked chart from data contained
        'in an array. The array will have three columns - first one for Quarter Name
        'and the next two for data values. The first data value column would store sales information
        'for Product A and the second one for Product B.
        Dim arrData(,) As String = _
            { _
                {"Quarter 1", "567500", "547300"}, _
                {"Quarter 2", "815300", "594500"}, _
                {"Quarter 3", "556800", "754000"}, _
                {"Quarter 4", "734500", "456300"} _
            }


        'Now, we need to convert this data into multi-series XML. 
        'We convert using string concatenation.
        'xmlData - Stores the entire XML
        'strCategories - Stores XML for the <categories> and child <category> elements
        'strDataProdA - Stores XML for current year's sales
        'strDataProdB - Stores XML for previous year's sales
        Dim strDataProdB As New StringBuilder()
        Dim xmlData As New StringBuilder()
        Dim categories As New StringBuilder()
        Dim strDataProdA As New StringBuilder()
        'Initialize <chart> element
        xmlData.Append("<chart caption='Sales' numberPrefix='$' formatNumberScale='0'>")
        'Initialize <categories> element - necessary to generate a stacked chart
        categories.Append("<categories>")
        'Initiate <dataset> elements
        strDataProdA.Append("<dataset seriesName='Product A'>")
        strDataProdB.Append("<dataset seriesName='Product B'>")

        'Iterate through the data    
        Dim i As Integer
        For i = arrData.GetLowerBound(0) To arrData.GetUpperBound(0)
            'Append <category name='...' /> to strCategories
            categories.Append("<category name='" & arrData(i, 0) & "' />")
            'Add <set value='...' /> to both the datasets
            strDataProdA.Append("<set value='" & arrData(i, 1) & "' />")
            strDataProdB.Append("<set value='" & arrData(i, 2) & "' />")
        Next

        'Close <categories> element
        categories.Append("</categories>")
        'Close <dataset> elements
        strDataProdA.Append("</dataset>")
        strDataProdB.Append("</dataset>")

        'Assemble the entire XML now
        xmlData.Append(categories.ToString() & strDataProdA.ToString() & strDataProdB.ToString())
        xmlData.Append("</chart>")

        'Create the chart - Stacked Column 3D Chart with data contained in xmlData
        Return FusionCharts.RenderChart("../FusionCharts/StackedColumn3D.swf", "", xmlData.ToString(), "productSales", "500", "300", False, False)
    End Function

End Class
