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

/// <summary>
/// FusionCharts in Master Page
/// </summary>
public partial class _Default : System.Web.UI.Page
{
    public string GetMonthlySalesChartHtml()
    {
        //For a head start we have kept the example simple
        //You can use complex code to render chart taking data streaming from 
        //database etc.

        //Create the chart - Column 3D Chart with data from Data/Data.xml
        return FusionCharts.RenderChart("../FusionCharts/Column3D.swf", "Data/Data.xml", "", "myFirst", "600", "300", false, false);
    }    
}
