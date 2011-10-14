Imports Microsoft.VisualBasic
Imports System.web
Imports System.Text

Namespace InfoSoftGlobal
    ''' <summary>
    ''' Summary description for FusionCharts.
    ''' </summary>
    Public Class FusionCharts

        ''' <summary>
        ''' encodes the dataURL before it's served to FusionCharts
        ''' If you have parameters in your dataURL, you'll necessarily need to encode it
        ''' </summary>
        ''' <param name="dataURL">dataURL to be fed to chart</param>
        ''' <param name="noCacheStr">Whether to add aditional string to URL to disable caching of data</param>
        ''' <returns>Encoded dataURL, ready to be consumed by FusionCharts</returns>
        Public Shared Function EncodeDataURL(ByVal dataURL As String, ByVal noCacheStr As Boolean) As String
            Dim result As String = dataURL
            If noCacheStr = True Then

                result = result & IIf(dataURL.IndexOf("?") <> -1, "&", "?")
                'Replace : in time with _, as FusionCharts cannot handle : in URLs
                result = result & "FCCurrTime=" & DateTime.Now.ToString().Replace(":", "_")
            End If

            Return HttpUtility.UrlEncode(result)
        End Function

        ''' <summary>
        ''' Generate html code for rendering chart
        ''' This function assumes that you've already included the FusionCharts JavaScript class in your page
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <param name="registerWithJS">Whether to ask chart to register itself with JavaScript</param>
        ''' <param name="transparent">Whether transparent chart (true / false)</param>
        ''' <param name="bgColor">Back Ground Color</param>
        ''' <param name="scaleMode">Set Scale Mode</param>
        ''' <param name="language">Set SWF file language</param>
        ''' <returns>JavaScript + HTML code required to embed a chart</returns>
        Private Shared Function RenderChartALL(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean, ByVal registerWithJS As Boolean, ByVal transparent As Boolean, ByVal bgColor As String, ByVal scaleMode As String, ByVal language As String) As String


            Dim builder As New StringBuilder

            builder.Append("<!-- START Script Block for Chart " & chartId & " -->" + Environment.NewLine)

            builder.Append("<div id='" & chartId & "Div' >" & Environment.NewLine)
            builder.Append("Chart." & Environment.NewLine)
            builder.Append("</div>" & Environment.NewLine)
            builder.Append("<script type=""text/javascript"">" & Environment.NewLine)
            builder.AppendFormat("var chart_" & chartId & " = new FusionCharts(""" & chartSWF & """, """ & chartId & """, """ & chartWidth & """, """ & chartHeight & """, """ & boolToNum(debugMode) & """, """ & boolToNum(registerWithJS) & """, """ & bgColor & """, """ & scaleMode & """, """ & language & """ );" & Environment.NewLine)

            If (strXML.Length = 0) Then
                builder.Append("chart_" & chartId & ".setDataURL(""" & strURL & """);" + Environment.NewLine)
            Else
                builder.Append("chart_" & chartId & ".setDataXML(""" & strXML & """);" & Environment.NewLine)
            End If

            If transparent = True Then
                builder.Append("chart_" & chartId & ".setTransparent(true);" + Environment.NewLine)
            End If

            builder.Append("chart_" & chartId & ".render(""" & chartId & "Div"");" & Environment.NewLine)
            builder.Append("</script>" + Environment.NewLine)
            builder.AppendFormat("<!-- END Script Block for Chart " & chartId & " -->" & Environment.NewLine)
            Return builder.ToString()
        End Function

        ''' <summary>
        ''' Generate html code for rendering chart
        ''' This function assumes that you've already included the FusionCharts JavaScript class in your page
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <param name="registerWithJS">Whether to ask chart to register itself with JavaScript</param>
        ''' <returns>JavaScript + HTML code required to embed a chart</returns>
        Public Shared Function RenderChart(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean, ByVal registerWithJS As Boolean) As String

            Return RenderChartALL(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, registerWithJS, False, "", "noScale", "EN")
        End Function

        ''' <summary>
        ''' Generate html code for rendering chart
        ''' This function assumes that you've already included the FusionCharts JavaScript class in your page
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <param name="registerWithJS">Whether to ask chart to register itself with JavaScript</param>
        ''' <param name="transparent">Whether transparent chart (true / false)</param>
        ''' <returns>JavaScript + HTML code required to embed a chart</returns>
        Public Shared Function RenderChart(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean, ByVal registerWithJS As Boolean, ByVal transparent As Boolean) As String

            Return RenderChartALL(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, registerWithJS, transparent, "", "noScale", "EN")
        End Function

        ''' <summary>
        ''' Generate html code for rendering chart
        ''' This function assumes that you've already included the FusionCharts JavaScript class in your page
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <param name="registerWithJS">Whether to ask chart to register itself with JavaScript</param>
        ''' <param name="transparent">Whether transparent chart (true / false)</param>
        ''' <param name="bgColor">Back Ground Color</param>
        ''' <param name="scaleMode">Set Scale Mode</param>
        ''' <param name="language">Set SWF file language</param>
        ''' <returns>JavaScript + HTML code required to embed a chart</returns>
        Public Shared Function RenderChart(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean, ByVal registerWithJS As Boolean, ByVal transparent As Boolean, ByVal bgColor As String, ByVal scaleMode As String, ByVal language As String) As String

            Return RenderChartALL(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, registerWithJS, transparent, bgColor, scaleMode, language)
        End Function


        ''' <summary>
        ''' Renders the HTML code for the chart. This
        ''' method does NOT embed the chart using JavaScript class. Instead, it uses
        ''' direct HTML embedding. So, if you see the charts on IE 6 (or above), you'll
        ''' see the "Click to activate..." message on the chart.
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <returns></returns>

        Public Shared Function RenderChartHTML(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean) As String

            Return RenderChartHTMLALL(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, False, False, "", "noScale", "EN")
        End Function

        ''' <summary>
        ''' Renders the HTML code for the chart. This
        ''' method does NOT embed the chart using JavaScript class. Instead, it uses
        ''' direct HTML embedding. So, if you see the charts on IE 6 (or above), you'll
        ''' see the "Click to activate..." message on the chart.
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <param name="registerWithJS">Whether to ask chart to register itself with JavaScript</param>
        ''' <returns></returns>

        Public Shared Function RenderChartHTML(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean, ByVal registerWithJS As Boolean) As String

            Return RenderChartHTMLALL(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, registerWithJS, False, "", "noScale", "EN")
        End Function

        ''' <summary>
        ''' Renders the HTML code for the chart. This
        ''' method does NOT embed the chart using JavaScript class. Instead, it uses
        ''' direct HTML embedding. So, if you see the charts on IE 6 (or above), you'll
        ''' see the "Click to activate..." message on the chart.
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <param name="registerWithJS">Whether to ask chart to register itself with JavaScript</param>
        ''' <param name="transparent">Whether transparent chart (true / false)</param>
        ''' <returns></returns>
        Public Shared Function RenderChartHTML(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean, ByVal registerWithJS As Boolean, ByVal transparent As Boolean) As String

            Return RenderChartHTMLALL(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, registerWithJS, transparent, "", "noScale", "EN")
        End Function

        ''' <summary>
        ''' Renders the HTML code for the chart. This
        ''' method does NOT embed the chart using JavaScript class. Instead, it uses
        ''' direct HTML embedding. So, if you see the charts on IE 6 (or above), you'll
        ''' see the "Click to activate..." message on the chart.
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <param name="registerWithJS">Whether to ask chart to register itself with JavaScript</param>
        ''' <param name="transparent">Whether transparent chart (true / false)</param>
        ''' <param name="bgColor">Back Ground Color</param>
        ''' <param name="scaleMode">Set Scale Mode</param>
        ''' <param name="language">Set SWF file language</param>
        ''' <returns></returns>
        Public Shared Function RenderChartHTML(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean, ByVal registerWithJS As Boolean, ByVal transparent As Boolean, ByVal bgColor As String, ByVal scaleMode As String, ByVal language As String) As String

            Return RenderChartHTMLALL(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, registerWithJS, transparent, bgColor, scaleMode, language)
        End Function

        ''' <summary>
        ''' Renders the HTML code for the chart. This
        ''' method does NOT embed the chart using JavaScript class. Instead, it uses
        ''' direct HTML embedding. So, if you see the charts on IE 6 (or above), you'll
        ''' see the "Click to activate..." message on the chart.
        ''' </summary>
        ''' <param name="chartSWF">SWF File Name (and Path) of the chart which you intend to plot</param>
        ''' <param name="strURL">If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)</param>
        ''' <param name="strXML">If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)</param>
        ''' <param name="chartId">Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.</param>
        ''' <param name="chartWidth">Intended width for the chart (in pixels)</param>
        ''' <param name="chartHeight">Intended height for the chart (in pixels)</param>
        ''' <param name="debugMode">Whether to start the chart in debug mode</param>
        ''' <param name="registerWithJS">Whether to ask chart to register itself with JavaScript</param>
        ''' <param name="transparent">Whether transparent chart (true / false)</param>
        ''' <param name="bgColor">Back Ground Color</param>
        ''' <param name="scaleMode">Set Scale Mode</param>
        ''' <param name="language">Set SWF file language</param>
        ''' <returns></returns>
        Private Shared Function RenderChartHTMLALL(ByVal chartSWF As String, ByVal strURL As String, ByVal strXML As String, ByVal chartId As String, ByVal chartWidth As String, ByVal chartHeight As String, ByVal debugMode As Boolean, ByVal registerWithJS As Boolean, ByVal transparent As Boolean, ByVal bgColor As String, ByVal scaleMode As String, ByVal language As String) As String

            'Generate the FlashVars string based on whether dataURL has been provided
            'or dataXML.
            Dim strFlashVars As New StringBuilder()
            Dim flashVariables As New StringBuilder()
            Dim strwmode As String = ""
            Dim mBGColor As String = ""

            If strXML.Length = 0 Then
                'DataURL Mode
                flashVariables.Append(String.Format("&chartWidth={0}&chartHeight={1}&debugMode={2}&registerWithJS={3}&DOMId={4}&dataURL={5}", chartWidth, chartHeight, boolToNum(debugMode), (registerWithJS), chartId, strURL))
            Else
                'DataXML Mode
                flashVariables.Append(String.Format("&chartWidth={0}&chartHeight={1}&debugMode={2}&registerWithJS={3}&DOMId={4}&dataXML={5}", chartWidth, chartHeight, boolToNum(debugMode), boolToNum(registerWithJS), chartId, strXML))
            End If

            flashVariables.Append(String.Format("&scaleMode={0}&lang={1}", scaleMode, language))

            'Checks for protocol type.
            Dim isHTTPS As String
            isHTTPS = HttpContext.Current.Request.ServerVariables("HTTPS")
            'Checks browser type.
            Dim isMSIE As Boolean
            isMSIE = HttpContext.Current.Request.ServerVariables("HTTP_USER_AGENT").Contains("MSIE")
            'Protocol initially sets to http.
            Dim HTTPS As String
            HTTPS = "http"
            If (isHTTPS.ToLower() = "on".ToLower()) Then
                HTTPS = "https"
            End If
            'Transparency check.
            If (transparent = True) Then
                strwmode = "wmode=""" + transparent + """"
            End If

            strFlashVars.AppendFormat("<!-- START Code Block for Chart {0} -->" + Environment.NewLine, chartId)
            If (isMSIE) Then
                strFlashVars.Append("<object classid=""clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"" codebase=""" & HTTPS & "://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"" width=""" & chartWidth & """ height=""" & chartHeight & """ name=""" & chartId & """ id=""" & chartId & """ >" & Environment.NewLine)
                strFlashVars.Append("<param name=""allowScriptAccess"" value=""always"" />" & Environment.NewLine)
                strFlashVars.Append("<param name=""movie"" value=""" & chartSWF & """/>" & Environment.NewLine)
                strFlashVars.Append("<param name=""FlashVars"" value=""" & flashVariables.ToString() & """ />" & Environment.NewLine)
                strFlashVars.Append("<param name=""quality"" value=""high"" />" & Environment.NewLine)
                If bgColor <> "" Then
                    strFlashVars.Append(String.Format("<param name=""bgcolor"" value=""{0}"" />" & Environment.NewLine, bgColor))

                End If
                If (transparent = True) Then
                    strFlashVars.Append("<param name=""wmode"" value=""transparent"" />" & Environment.NewLine)
                End If
                strFlashVars.Append("</object>" & Environment.NewLine)
            Else
                If bgColor <> "" Then
                    mBGColor = " bgcolor=""" & bgColor & """"
                End If
               
                strFlashVars.Append("<embed src=""" & chartSWF & """ FlashVars=""" & flashVariables.ToString() & """ quality=""high"" width=""" & chartWidth & """ height=""" & chartHeight & """ name=""" & chartId & """ id=""" & chartId & """ allowScriptAccess=""always"" type=""application/x-shockwave-flash"" pluginspage=""" & HTTPS & "://www.macromedia.com/go/getflashplayer"" " & strwmode & mBGColor & " />" & Environment.NewLine)
                End If

                strFlashVars.Append(String.Format("<!-- END Code Block for Chart {0} -->" & Environment.NewLine, chartId))

                Dim FlashXML As New StringBuilder()
                FlashXML.Append(String.Format("<div id='{0}Div' >", chartId))
                FlashXML.Append(String.Format("{0}</div>", strFlashVars.ToString()))
                Return FlashXML.ToString()

        End Function

        ''' <summary>
        ''' Transform the meaning of boolean value in integer value
        ''' </summary>
        ''' <param name="value">true/false value to be transformed</param>
        ''' <returns>1 if the value is true, 0 if the value is false</returns>
        Private Shared Function boolToNum(ByVal value As Boolean) As Integer

            Return IIf(value = True, 1, 0)
        End Function

    End Class


End Namespace
