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
using DataConnection;

public partial class DB_dataURL_PieData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //This page generates the XML data for the Pie Chart contained in
        //Default.aspx. 	

        //For the sake of ease, we've used an Access database which is present in
        //../App_Data/FactoryDB.mdb. It just contains two tables, which are linked to 
        //each other. 


        //xmlData will be used to store the entire XML document generated
        StringBuilder xmlData = new StringBuilder();


        //Default.aspx has passed us a property animate. We request that.
        string animateChart;
        animateChart = Request["animate"];
        //Set default value of 1
        if (animateChart != null && animateChart.Length == 0)
        {
            animateChart = "1";
        }

        //Generate the chart element
        xmlData.AppendFormat("<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation='{0}'>", animateChart);

        //create recordset to get details for the factories
        string query = "select a.FactoryId, a.FactoryName, sum(b.Quantity) as TotQ from .Factory_Master a, Factory_Output b where a.FactoryId=b.FactoryID group by a.FactoryId, a.FactoryName";
        DbConn oRs = new DbConn(query);

        //Iterate through each factory
        while (oRs.ReadData.Read())
        {
            //Generate <set name='..' value='..' />		
            xmlData.AppendFormat("<set label='{0}' value='{1}' />", oRs.ReadData["FactoryName"].ToString(), oRs.ReadData["TotQ"].ToString());
        }
        oRs.ReadData.Close();

        //Close chart element
        xmlData.Append("</chart>");

        //Set Proper output content-type
        Response.ContentType = "text/xml";
        //Just write out the XML data
        //NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
        Response.Write(xmlData.ToString());

    }
}
