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

public partial class DB_JS_dataURL_FactoryData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        //This page is invoked from Default.aspx. When the user clicks on a pie
        //slice in Default.aspx, the factory Id is passed to this page. We need
        //to get that factory id, get information from database and then write XML.

        //First, get the factory Id
        string factoryId;
        //Request the factory Id from Querystring
        factoryId = Request["FactoryId"];

        //xmlData will be used to store the entire XML document generated
        StringBuilder xmlData=new StringBuilder();

        //Create recordset to get details for the selected factory 
        string query = "select DatePro,Quantity from Factory_Output where FactoryId=" + factoryId;
        DbConn oRs = new DbConn(query);

        //Generate the chart element
        xmlData.AppendFormat("<chart palette='2' caption='Factory {0} Output ' subcaption='(In Units)' xAxisName='Date (dd/MM)' showValues='1' labelStep='2' >",factoryId);

        //Iterate through each record
        while (oRs.ReadData.Read()){
            //Convert date from database into dd/mm format
            //Generate <set name='..' value='..' /> 
            xmlData.AppendFormat("<set label='{0}' value='{1}'/>",((DateTime)oRs.ReadData["DatePro"]).ToString("dd/MM"),oRs.ReadData["Quantity"].ToString());
                    
        }
        oRs.ReadData.Close();
        //Close <chart> element
        xmlData.Append("</chart>");

        //Just write out the XML data
        Response.ContentType = "text/xml";
        //NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
        Response.Output.Write(xmlData.ToString());
    } 
}
