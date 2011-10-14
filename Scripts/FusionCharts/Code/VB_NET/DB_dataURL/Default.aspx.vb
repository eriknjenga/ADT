Imports InfoSoftGlobal
Partial Class DB_dataURL_Default
    Inherits System.Web.UI.Page

    Public Function GetQuantityChartHtml() As String
        'In this example, we show how to connect FusionCharts to a database 
        'using dataURL method. In our other examples, we've used dataXML method
        'where the XML is generated in the same page as chart. Here, the XML data
        'for the chart would be generated in PieData.asp.
        'To illustrate how to pass additional data as querystring to dataURL, 
        'we've added an animate    property, which will be passed to PieData.asp. 
        'PieData.asp would handle this animate property and then generate the 
        'XML accordingly.
        'For the sake of ease, we've used an Access database which is present in
        '../DB/FactoryDB.mdb. It just contains two tables, which are linked to each
        'other.
        'Variable to contain dataURL
        'Set DataURL with animation property to 1
        'NOTE: It's necessary to encode the dataURL if you've added parameters to it
        Dim dataURL As String = Server.UrlEncode("PieData.aspx?animate=1")
        'Create the chart - Pie 3D Chart with dataURL as strDataURL
        Return FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", dataURL, "", "FactorySum", "600", "300", False, False)
    End Function
End Class
