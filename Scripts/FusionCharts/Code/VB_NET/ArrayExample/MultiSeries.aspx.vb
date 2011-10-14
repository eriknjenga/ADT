Imports InfoSoftGlobal
Imports System.Text

Partial Class ArrayExample_MultiSeries
    Inherits System.Web.UI.Page

    Public Function GetProductSalesChartHtml() As String
        'In this example, we plot a multi series chart from data contained
        'in an array. The array will have three columns - first one for data label (product)
        'and the next two for data values. The first data value column would store sales information
        'for current year and the second one for previous year.
        'Let//s store the sales data for 6 products in our array. We also store
        'the name of products. 
        Dim arrData(,) As String = _
            { _
                {"Product A", "567500", "547300"}, _
                {"Product B", "815300", "584500"}, _
                {"Product C", "556800", "754000"}, _
                {"Product D", "734500", "456300"}, _
                {"Product E", "676800", "754500"}, _
                {"Product F", "648500", "437600"} _
            }


        'Now, we need to convert this data into multi-series XML. 
        'We convert using string concatenation.
        'xmlData - Stores the entire XML
        'categories - Stores XML for the <categories> and child <category> elements
        'currentYear - Stores XML for current year's sales
        'previousYear - Stores XML for previous year's sales
        Dim previousYear As New StringBuilder()
        Dim xmlData As New StringBuilder()
        Dim categories As New StringBuilder()
        Dim currentYear As New StringBuilder()

        'Initialize <chart> element
        xmlData.Append("<chart caption='Sales by Product' numberPrefix='$' formatNumberScale='1' rotateValues='1' placeValuesInside='1' decimals='0' >")
        'Initialize <categories> element - necessary to generate a multi-series chart
        categories.Append("<categories>")
        'Initiate <dataset> elements
        currentYear.Append("<dataset seriesName='Current Year'>")
        previousYear.Append("<dataset seriesName='Previous Year'>")

        'Iterate through the data    
        Dim i As Integer
        For i = arrData.GetLowerBound(0) To arrData.GetUpperBound(0)
            'Append <category name='...' /> to strCategories
            categories.Append("<category name='" & arrData(i, 0) & "' />")
            'Add <set value='...' /> to both the datasets
            currentYear.Append("<set value='" & arrData(i, 1) & "' />")
            previousYear.Append("<set value='" & arrData(i, 2) & "' />")
        Next

        'Close <categories> element
        categories.Append("</categories>")
        'Close <dataset> elements
        currentYear.Append("</dataset>")
        previousYear.Append("</dataset>")

        'Assemble the entire XML now
        xmlData.Append(categories.ToString() & currentYear.ToString() & previousYear.ToString())

        xmlData.Append("</chart>")

        'Create the chart - MS Column 3D Chart with data contained in xmlData
        Return FusionCharts.RenderChart("../FusionCharts/MSColumn3D.swf", "", xmlData.ToString(), "productSales", "600", "300", False, False)

    End Function
End Class
