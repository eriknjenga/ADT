<%@ Page Language="VB" MasterPageFile="MasterPage.master" codeFile="Default.aspx.vb" Inherits="_Default" title="FusionCharts Example - Using ASP.NET 2.0 Master Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script language="javascript" type="text/javascript" src="../FusionCharts/FusionCharts.js"></script>
    <%
        'Included FusionCharts.js to embed FusionCharts easily in web pages
        'The following code will generate a chart from code behind file Default.aspx.cs
    %>
    <%=GetMonthlyalesChartHtml()%> 

</asp:Content>
