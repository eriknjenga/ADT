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

public partial class DB_JS_dataURL_Default : System.Web.UI.Page
{

    public string GetFactorySummaryChartHtml()
    {
        //xmlData will be used to store the entire XML document generated
        StringBuilder xmlData=new StringBuilder();

        //Generate the chart element
        xmlData.Append("<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' >");

        //Create recordset to get details for the factories
        string factoryQuery = "select a.FactoryId, a.FactoryName, sum(b.Quantity) as TotQ from .Factory_Master a, Factory_Output b where a.FactoryId=b.FactoryID group by a.FactoryId, a.FactoryName ";
        DbConn oRs=new DbConn(factoryQuery);

        //Iterate through each record
        while(oRs.ReadData.Read()){
            //Generate <set name='..' value='..' link='...'/>	
            //The link causes drill-down by calling (here) a JavaScript function
            //The function is passed the Factory id
            //The function updates the second chart 
            xmlData.AppendFormat("<set label='{0}' value='{1}' link='javaScript:updateChart({2})' />", oRs.ReadData["FactoryName"].ToString(), oRs.ReadData["TotQ"].ToString(), oRs.ReadData["FactoryId"].ToString());
                                    
        }
        //Close chart element
        xmlData.Append("</chart>");
                
        //Create the chart - Pie 3D Chart with data from xmlData
        return FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", xmlData.ToString(), "FactorySum", "500", "250", false, true);


    }

    public string GetFactoryDetailedChartHtml()
    {
        //Column 2D Chart with changed "No data to display" message
        //We initialize the chart with <chart></chart>
        return FusionCharts.RenderChart("../FusionCharts/Column2D.swf?ChartNoDataText=Please select a factory from pie chart above to view detailed data.", "", "<chart></chart>", "FactoryDetailed", "600", "250", false, true);
                
    }
}
