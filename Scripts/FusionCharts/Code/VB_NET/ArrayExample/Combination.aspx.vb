Imports InfoSoftGlobal
Imports System.Text

Partial Class ArrayExample_Combination
    Inherits System.Web.UI.Page

    Public Function GetProductSalesChartHtml() As String
        'In this example, we plot a Combination chart from data contained
        'in an array. The array will have three columns - first one for Quarter Name
        'second one for sales figure and third one for quantity. 

        Dim arrData(,) As String = _
            { _
                {"Quarter 1", "567500", "576"}, _
                {"Quarter 2", "815300", "448"}, _
                {"Quarter 3", "556800", "956"}, _
                {"Quarter 4", "734500", "734"} _
            }

        'Now, we need to convert this data into combination XML. 
        'We convert using string concatenation.
        'strXML - Stores the entire XML
        'strCategories - Stores XML for the <categories> and child <category> elements
        'strDataRev - Stores XML for current year's sales
        'strDataQty - Stores XML for previous year's sales
        Dim strDataQty As New StringBuilder()
        Dim strXML As New StringBuilder()
        Dim strCategories As New StringBuilder()
        Dim strDataRev As New StringBuilder()
        'Initialize <chart> element
        strXML.Append("<chart palette='4' caption='Product A - Sales Details' PYAxisName='Revenue' SYAxisName='Quantity (in Units)' numberPrefix='$' formatNumberScale='0' showValues='0' decimals='0' >")
        'Initialize <categories> element - necessary to generate a multi-series chart
        strCategories.Append("<categories>")
        'Initiate <dataset> elements
        strDataRev.Append("<dataset seriesName='Revenue'>")
        strDataQty.Append("<dataset seriesName='Quantity' parentYAxis='S'>")
        'Iterate through the data    
        Dim i As Integer
        For i = arrData.GetLowerBound(0) To arrData.GetUpperBound(0)
            'Append <category name='...' /> to strCategories
            strCategories.Append("<category name='" & arrData(i, 0) & "' />")
            'Add <set value='...' /> to both the datasets
            strDataRev.Append("<set value='" & arrData(i, 1) & "' />")
            strDataQty.Append("<set value='" & arrData(i, 2) & "' />")
        Next
        'Close <categories> element
        strCategories.Append("</categories>")
        'Close <dataset> elements
        strDataRev.Append("</dataset>")
        strDataQty.Append("</dataset>")

        'Assemble the entire XML now
        strXML.Append(strCategories.ToString() & strDataRev.ToString() & strDataQty.ToString())
        strXML.Append("</chart>")

        'Create the chart - MS Column 3D Line Combination Chart with data contained in strXML
        Return FusionCharts.RenderChart("../FusionCharts/MSColumn3DLineDY.swf", "", strXML.ToString(), "productSales", "600", "300", False, False)

    End Function
End Class
