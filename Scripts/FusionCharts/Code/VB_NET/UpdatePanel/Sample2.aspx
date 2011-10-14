<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Sample2.aspx.vb"
    Inherits="UpdatePanel_Sample2" %>

<html>
<head id="Head1" runat="server">
    <title>FusionCharts Examples - Using ASP.NET.AJAX UpdatePanel
        #2</title>

    <script language="javascript" type="text/javascript" src="../FusionCharts/FusionCharts.js"></script>
	   <style type="text/css">
            <!--
            body {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 12px;
            }
            .text{
                font-family: Arial, Helvetica, sans-serif;
                font-size: 12px;
            }
             -->
        </style>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server" />
            <table style="border: 1px dotted #aaaaaa;" width="950px"
                cellpadding="5">
                <tr>
                    <td align="center" valign="middle" colspan="2">
                        <h2>
                            FusionCharts Example - UpdatePanel #2</h2>
                        <h4>
                            Using ASP.NET.AJAX</h4>
                        <h5>
                            Please Click on a Factory on the Pie chart below to
                            see details</h5>
                    </td>
                </tr>
                <tr>
                    <td valign="middle" style="width: 450px; height: 299px;
                        border-right: #cdcdcd 1px dotted; border-top: #cdcdcd 1px dotted;
                        border-left: #cdcdcd 1px dotted; border-bottom: #cdcdcd 1px solid;"
                        align="center">

                        <script language="javascript" type="text/javascript">
                            //Call Ajax PostBack Function
                            function updateChart(factoryId){
	                            // Call drillDown VB function by Ajax
	                            //we pass the name of the function ('drillDown') to call 
	                            //and the parameter (i.e. factoryId) to be passed to it
	                            //both separated by a delimiter(here we use $, you can use anything)
	                            __doPostBack("Panel1","drillDown$" + factoryId);
	                        }
                        </script>

                        <% 'Show Pie Chart %>
                        <%showPieChart()%>
                    </td>
                    <td valign="middle" style="border: 1px dotted #cdcdcd;">
                        <asp:UpdatePanel ID="FusionChartsUP" runat="server">
                            <ContentTemplate>
                                <asp:Panel ID="Panel1" runat="server" Height="350px"
                                    Width="450px">
                                </asp:Panel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdateProgress ID="UpdateProgress2" runat="server"
                            DisplayAfter="1">
                            <ProgressTemplate>
                                <img src="Images/loading.gif" style="position: absolute;
                                    top: 297px; left: 660px; z-index: 5;" />
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </td>
                </tr>
            </table>
        </div>
    </form>
	<center>
	<h5><a href='../default.aspx'>« Back to list of examples</a></h5>
    <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
	</center>
</body>
</html>
