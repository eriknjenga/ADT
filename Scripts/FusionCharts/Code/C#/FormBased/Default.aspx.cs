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

public partial class FormBased_Default : System.Web.UI.Page
{
    
    private void Page_Load(object sender, System.EventArgs e)
		{
       
			if (!IsPostBack)
			{
                DivSubmission.Visible = false;
				DivFormParameters.Visible = true;
			}
			else
			{
				DivSubmission.Visible = true;
				DivFormParameters.Visible = false;
			}
		}
    	
		public void ButtonChart_Click(object sender, System.EventArgs e)
		{
			//We first request the data from the form (Default.aspx)
			string soups, salads, sandwiches, beverages, desserts;
            soups = TextBoxSoups.Text;
			salads = TextboxSalads.Text;
			sandwiches = TextboxSandwiches.Text;
			beverages = TextboxBeverages.Text;
			desserts   = TextboxDesserts.Text;
	
			//In this example, we're directly showing this data back on chart.
			//In your apps, you can do the required processing and then show the 
			//relevant data only.
	
			//Now that we've the data in variables, we need to convert this into XML.
			//The simplest method to convert data into XML is using string concatenation.	
            StringBuilder xmlData = new StringBuilder();
			//Initialize <chart> element
			xmlData.Append("<chart caption='Sales by Product Category' subCaption='For this week' showPercentValues='1' pieSliceDepth='30' showBorder='1'>");
			//Add all data
			xmlData.AppendFormat("<set label='Soups' value='{0}' />",soups);
			xmlData.AppendFormat("<set label='Salads' value='{0}' />",salads);
			xmlData.AppendFormat("<set label='Sandwiches' value='{0}' />", sandwiches);
            xmlData.AppendFormat("<set label='Beverages' value='{0}' />", beverages);
			xmlData.AppendFormat("<set label='Desserts' value='{0}' />",desserts);
			//Close <chart> element
			xmlData.Append("</chart>");
                        
			//Create the chart - Pie 3D Chart with data from xmlData
            LiteralChart.Text = FusionCharts.RenderChart("../FusionCharts/Pie3D.swf", "", xmlData.ToString(), "Sales", "500", "300", false, false);
		}
}
