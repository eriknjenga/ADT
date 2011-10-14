<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Sample1.aspx.vb"
    Inherits="UpdatePanel_Sample1" Debug="true" %>

<html>
<head id="Head1" runat="server">
    <title>FusionCharts Examples - Using ASP.NET.AJAX UpdatePanel
        #1</title>

    <script language="javascript" type="text/javascript"
        src="../FusionCharts/FusionCharts.js"></script>
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
            <table style="border: 1px dotted #aaaaaa;" width="778px">
                <tr>
                    <td align="center" valign="middle" colspan="2">
                        <h2>
                            FusionCharts Example - UpdatePanel #1</h2>
                        <h4>
                            Using ASP.NET.AJAX</h4>
                        <h5>
                            Please select a Factory</h5>
                    </td>
                </tr>
                <tr>
                    <td align="center" valign="middle" colspan="2" style="border: 1px dotted #dedede;
                        height: 43px;">
                        <asp:UpdatePanel ID="FactorySelector" runat="server">
                            <ContentTemplate>
                                <asp:RadioButtonList ID="RadioButtonList1" runat="server"
                                    AutoPostBack="True" Height="40px" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged"
                                    Width="400px" RepeatDirection="Horizontal" Style="font-weight: bold;
                                    font-size: 14px; font-family: Verdana" ForeColor="#404040">
                                </asp:RadioButtonList>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td valign="middle" style="width: 320px; height: 299px;
                        border-right: #cdcdcd 1px dotted; border-top: #cdcdcd 1px dotted;
                        border-left: #cdcdcd 1px dotted; border-bottom: #cdcdcd 1px solid;"
                        align="center">
                        <asp:UpdatePanel ID="GridUP" runat="server">
                            <ContentTemplate>
                                <div style="width: 318px; height: 350px; overflow: auto;
                                    overflow-x: hidden; overflow-y: auto;">
                                    <asp:GridView ID="GridView1" runat="server" BackColor="White"
                                        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                                        CellPadding="4" ForeColor="Black" GridLines="Vertical"
                                        Height="350px" Width="300px" AutoGenerateColumns="False">
                                        <FooterStyle BackColor="#CCCC99" />
                                        <RowStyle BackColor="#EFEFEF" Font-Names="Verdana"
                                            Font-Size="10px" />
                                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True"
                                            ForeColor="White" />
                                        <HeaderStyle BackColor="#E0E0E0" Font-Bold="True" ForeColor="#404040"
                                            Font-Names="Verdana" Font-Size="11px" />
                                        <AlternatingRowStyle BackColor="White" />
                                        <Columns>
                                            <asp:BoundField DataField="DatePro" DataFormatString="{0:dd/MM/yyyy}"
                                                HeaderText="Date">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="Quantity" HeaderText="Quantity">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="RadioButtonList1"
                                    EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server"
                            DisplayAfter="1">
                            <ProgressTemplate>
                                <img style="position: absolute; top: 324px; left: 153px;
                                    z-index: 5;" src="Images/loading.gif" />
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </td>
                    <td valign="middle" style="width: 440px; height: 350px;
                        border: 1px dotted #dedede;">
                        <asp:UpdatePanel ID="FusionChartsUP" runat="server">
                            <ContentTemplate>
                                <asp:Panel ID="Panel1" runat="server" Height="350px"
                                    Width="440px">
                                </asp:Panel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdateProgress ID="UpdateProgress2" runat="server"
                            DisplayAfter="1">
                            <ProgressTemplate>
                                <img src="Images/loading.gif" style="position: absolute;
                                    top: 327px; left: 564px; z-index: 5;" />
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
