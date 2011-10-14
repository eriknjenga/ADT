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

public partial class ArrayExample_Stacked : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public string GetProductSalesChartHtml()
    {
        //In this example, we plot a Stacked chart from data contained
        //in an array. The array will have three columns - first one for Quarter Name
        //and the next two for data values. The first data value column would store sales information
        //for Product A and the second one for Product B.

        object[,] arrData = new object[4, 3];
        //Store Name of Products
        arrData[0, 0] = "Quarter 1";
        arrData[1, 0] = "Quarter 2";
        arrData[2, 0] = "Quarter 3";
        arrData[3, 0] = "Quarter 4";
        //Sales data for Product A
        arrData[0, 1] = 567500;
        arrData[1, 1] = 815300;
        arrData[2, 1] = 556800;
        arrData[3, 1] = 734500;
        //Sales data for Product B
        arrData[0, 2] = 547300;
        arrData[1, 2] = 594500;
        arrData[2, 2] = 754000;
        arrData[3, 2] = 456300;

        //Now, we need to convert this data into multi-series XML. 
        //We convert using string concatenation.
        //xmlData - Stores the entire XML
        //strCategories - Stores XML for the <categories> and child <category> elements
        //strDataProdA - Stores XML for current year's sales
        //strDataProdB - Stores XML for previous year's sales
        StringBuilder xmlData=new StringBuilder();
        StringBuilder categories=new StringBuilder();
        StringBuilder strDataProdA=new StringBuilder();
        StringBuilder strDataProdB=new StringBuilder();

        //Initialize <chart> element
        xmlData.Append("<chart caption='Sales' numberPrefix='$' formatNumberScale='0'>");

        //Initialize <categories> element - necessary to generate a stacked chart
        categories.Append("<categories>");

        //Initiate <dataset> elements
        strDataProdA.Append("<dataset seriesName='Product A'>");
        strDataProdB.Append("<dataset seriesName='Product B'>");

        //Iterate through the data	
        for (int i = 0; i < arrData.GetLength(0); i++)
        {
            //Append <category name='...' /> to strCategories
            categories.AppendFormat("<category name='{0}' />",arrData[i, 0]);
            //Add <set value='...' /> to both the datasets
            strDataProdA.AppendFormat("<set value='{0}' />",arrData[i, 1]);
            strDataProdB.AppendFormat("<set value='{0}' />",arrData[i, 2]);
        }

        //Close <categories> element
        categories.Append("</categories>");

        //Close <dataset> elements
        strDataProdA.Append("</dataset>");
        strDataProdB.Append("</dataset>");

        //Assemble the entire XML now
        xmlData.Append(categories.ToString());
        xmlData.Append(strDataProdA.ToString());
        xmlData.Append(strDataProdB.ToString());
        xmlData.Append("</chart>");

        //Create the chart - Stacked Column 3D Chart with data contained in xmlData
        return FusionCharts.RenderChart("../FusionCharts/StackedColumn3D.swf", "", xmlData.ToString(), "productSales", "500", "300", false, false);
    }
}
