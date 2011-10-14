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

public partial class DBExample_Detailed : System.Web.UI.Page
{

    public string GetFactoryDetailedChartHtml()
    {
        //This page is invoked from Default.aspx. When the user clicks on a pie
        //slice in Default.aspx, the factory Id is passed to this page. We need
        //to get that factory id, get information from database and then show
        //a detailed chart.

        //First, get the factory Id
        string factoryId;
        //Request the factory Id from Querystring
        factoryId = Request["FactoryId"];

        //xmlData will be used to store the entire XML document generated
        StringBuilder xmlData=new StringBuilder();

        //Generate the chart element string
        xmlData.AppendFormat("<chart palette='2' caption='Factory {0} Output ' subcaption='(In Units)' xAxisName='Date (dd/MM)' showValues='1' labelStep='2' >",factoryId);

        //Now, we get the data for that factory
        string query = "select DatePro,Quantity from Factory_Output where FactoryId=" + factoryId;
        DbConn oRs = new DbConn(query);

        //Iterate through each record
        while (oRs.ReadData.Read())
         {
            //Convert date from database into dd/mm format
            //Generate <set name='..' value='..' />		    
            xmlData.AppendFormat("<set label='{0}' value='{1}' />",((DateTime)oRs.ReadData["DatePro"]).ToString("dd/MM"),oRs.ReadData["Quantity"].ToString());
         
        }
        oRs.ReadData.Close();

        //Close <chart> element
        xmlData.Append("</chart>");

        //Create the chart - Column 2D Chart with data from xmlData
        return FusionCharts.RenderChart("../FusionCharts/Column2D.swf", "", xmlData.ToString(), "FactoryDetailed", "600", "300", false, false);
    }
}
