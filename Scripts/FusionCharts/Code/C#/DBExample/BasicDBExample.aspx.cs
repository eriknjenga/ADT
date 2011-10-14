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

public partial class DBExample_BasicDBExample : System.Web.UI.Page
{

    public string GetFactorySummaryChartHtml()
    {
        //In this example, we show how to connect FusionCharts to a database.
        //For the sake of ease, we've used an Access database which is present in
        //../App_Data/FactoryDB.mdb. It just contains two tables, which are linked to each
        //other. 

        //xmlData will be used to store the entire XML document generated
        StringBuilder xmlData=new StringBuilder();

        //Generate the chart element
        xmlData.Append("<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units'>");

        //Create recordset to get details for the factories
        string factoryQuery = "select a.FactoryId,a.FactoryName,sum(b.Quantity) as TotQ from Factory_Master a,Factory_Output b where a.FactoryId=b.FactoryID group by a.FactoryId,a.FactoryName";
        DbConn oRs = new DbConn(factoryQuery);

        //Iterate through each record
        while (oRs.ReadData.Read()){
            //Generate <set name='..' value='..' />		
            xmlData.AppendFormat("<set label='{0}' value='{1}' />",oRs.ReadData["FactoryName"].ToString(), oRs.ReadData["TotQ"].ToString() );
        }
        
        oRs.ReadData.Close();
        //Close chart element
        xmlData.Append("</chart>");
       
        //Create the chart - Pie 3D Chart with data from xmlData
        return FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", xmlData.ToString(), "FactorySum", "600", "300", false, false);
    }
}
