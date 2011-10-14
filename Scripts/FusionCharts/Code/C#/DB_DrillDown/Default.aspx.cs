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
using DataConnection;

public partial class DBExample_Default : System.Web.UI.Page
{

    public string GetFactorySummaryChartHtml()
    {
        //In this example, we show how to connect FusionCharts to a database.
        //For the sake of ease, we've used an Access database which is present in
        //../App_Data/FactoryDB.mdb. It just contains two tables, which are linked to each
        //other. 

        //xmlData will be used to store the entire XML document generated
        StringBuilder xmlData=new StringBuilder();

        //We also keep a flag to specify whether we've to animate the chart or not.
        //If the user is viewing the detailed chart and comes back to this page, he shouldn't
        //see the animation again.
        string animateChart;
        animateChart = Request["animate"];
        //Set default value of 1
        if (animateChart != null && animateChart.Length == 0)
        {
            animateChart = "1";
        }
        //Generate the chart element
        xmlData.AppendFormat("<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation='{0}' >",animateChart);

        //Create recordset to get details for the factories
        string factoryQuery = "select a.FactoryId,a.FactoryName,sum(b.Quantity) as TotQ from Factory_Master a,Factory_Output b where a.FactoryId=b.FactoryID group by a.FactoryId,a.FactoryName";
        DbConn oRs = new DbConn(factoryQuery);
        
        //Iterate through each factory
        while (oRs.ReadData.Read()){
            //Generate <set name='...' value='...' link='...'/>	
            //The link causes drill-down by loading a another page
            //The page is passed the factoryId
            //Accordingly the page creates a detailed chart against that FactoryId         
            xmlData.AppendFormat("<set label='{0}' value='{1}' link='{2}'/>", oRs.ReadData["FactoryName"].ToString(), oRs.ReadData["TotQ"].ToString(), Server.UrlEncode("Detailed.aspx?FactoryId=" + oRs.ReadData["FactoryId"].ToString()));
                    
        }

        //Finally, close <chart> element
        xmlData.Append("</chart>");

        //Create the chart - Pie 3D Chart with data from xmlData
        return FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", xmlData.ToString(), "FactorySum", "600", "300", false, false);
    }
}
