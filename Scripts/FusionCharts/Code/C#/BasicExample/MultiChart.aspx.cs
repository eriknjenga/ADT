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
using InfoSoftGlobal;
public partial class MultiChart : System.Web.UI.Page
{

    public string GetMonthlySales3DChartHtml()
    {
        
        //This page demonstrates how you can show multiple charts on the same page.
        //For this example, all the charts use the pre-built Data.xml (contained in /Data/ folder)
        //However, you can very easily change the data source for any chart. 

        //IMPORTANT NOTE: Each chart necessarily needs to have a unique ID on the page.
        //If you do not provide a unique Id, only the last chart might be visible.
        //Here, we've used the ID chart1, chart2 and chart3 for the 3 charts on page.

        //Create the chart - Column 3D Chart with data from Data/Data.xml
        return FusionCharts.RenderChart("../FusionCharts/Column3D.swf", "Data/Data.xml", "", "chart1", "600", "300", false, false);

        
    }

    public string GetMonthlySales2DChartHtml()
    {
        //This page demonstrates how you can show multiple charts on the same page.
        //For this example, all the charts use the pre-built Data.xml (contained in /Data/ folder)
        //However, you can very easily change the data source for any chart. 

        //IMPORTANT NOTE: Each chart necessarily needs to have a unique ID on the page.
        //If you do not provide a unique Id, only the last chart might be visible.
        //Here, we've used the ID chart1, chart2 and chart3 for the 3 charts on page.

        //Now, create a Column 2D Chart
        return FusionCharts.RenderChart("../FusionCharts/Column2D.swf", "Data/Data.xml", "", "chart2", "600", "300", false, false);

        
    }

    public string GetMonthlySalesLineChartHtml()
    {
        
        //This page demonstrates how you can show multiple charts on the same page.
        //For this example, all the charts use the pre-built Data.xml (contained in /Data/ folder)
        //However, you can very easily change the data source for any chart. 

        //IMPORTANT NOTE: Each chart necessarily needs to have a unique ID on the page.
        //If you do not provide a unique Id, only the last chart might be visible.
        //Here, we've used the ID chart1, chart2 and chart3 for the 3 charts on page.

        //Now, create a Line 2D Chart
        return FusionCharts.RenderChart("../FusionCharts/Line.swf", "Data/Data.xml", "", "chart3", "600", "300", false, false);

        
    }
}
