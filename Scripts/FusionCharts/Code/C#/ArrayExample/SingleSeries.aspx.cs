using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using InfoSoftGlobal;

public partial class ArrayExample_SingleSeries : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public string GetProductSalesChartHtml()
    {
        //In this example, we plot a single series chart from data contained
        //in an array. The array will have two columns - first one for data label
        //and the next one for data values.

        //Let's store the sales data for 6 products in our array). We also store
        //the name of products. 
        object[,] arrData = new object[6, 2];
        //Store Name of Products
        arrData[0, 0] = "Product A";
        arrData[1, 0] = "Product B";
        arrData[2, 0] = "Product C";
        arrData[3, 0] = "Product D";
        arrData[4, 0] = "Product E";
        arrData[5, 0] = "Product F";
        //Store sales data
        arrData[0, 1] = 567500;
        arrData[1, 1] = 815300;
        arrData[2, 1] = 556800;
        arrData[3, 1] = 734500;
        arrData[4, 1] = 676800;
        arrData[5, 1] = 648500;

        //Now, we need to convert this data into XML. We convert using StringBuilder concatenation.
        StringBuilder xmlData=new StringBuilder();
        //Initialize <chart> element
        xmlData.Append("<chart caption='Sales by Product' numberPrefix='$' formatNumberScale='0'>");
        //Convert data to XML and append
        for (int i = 0; i < arrData.GetLength(0); i++)
        {
            xmlData.AppendFormat("<set label='{0}' value='{1}' />",arrData[i, 0],arrData[i, 1]);
        }
        //Close <chart> element
        xmlData.Append("</chart>");

        //Create the chart - Column 3D Chart with data contained in xmlData
        return FusionCharts.RenderChart("../FusionCharts/Column3D.swf", "", xmlData.ToString(), "productSales", "600", "300", false, false);
    }
}
