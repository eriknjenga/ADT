<%@ Page Language="C#" MasterPageFile="MasterPage.master" CodeFile="Default.aspx.cs" Inherits="_Default" Title="FusionCharts Example - Using ASP.NET 2.0 Master Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script language="javascript" type="text/javascript" src="../FusionCharts/FusionCharts.js"></script>
    <%
        //Included FusionCharts.js to embed FusionCharts easily in web pages
        //The following code will generate a chart from code behind file Default.aspx.cs
    %>
    <%=GetMonthlySalesChartHtml() %>
    
</asp:Content>