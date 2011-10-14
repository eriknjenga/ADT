<%
'*************************************************************************************
'*
'*   FUSIONCHARTS V3 API ASP CLASS 
'*   Author  :  Infosoft Global Pvt. Ltd. 
'*   version :  FusionCharts V3
'*   Company :  Infosoft Global Pvt. Ltd. 
'*  
'*   Version: 1.0 (30 July 2008)
'*   
'*   FusionCharts Class easily handles All FusionCharts XML Structures like
'*   chart, categories, dataset, set, Trend Lines, vline, styles etc.
'*   Its easy to use, it binds data into FusionCharts XML Structures
'*
'************************************************************************************
  
Class FusionCharts
	
	' Charts SWF array
	Public  chartType               ' Chart Friendly Name 
	Private chartID                 ' ID of the Chart for JS interactivity(optional)
	Private SWFFile                 ' SWF file
	Private SWFPath                 ' Relative path to FusionCharts SWF files
	Private width                   ' FusionCharts width
	Private height                  ' FusionCharts height
	
	' Separator/Delimiter for list of Parameters
	Private del
	
	' Chart XML string 
	Private strXML
	
	' Chart Series Types : 1 => single series, 2=> multi-series
	' For Future Use : 3=> scatter and bubble, 4=> MSStacked
	Private seriesType 
	
	' Charts Atribute array
    Private chartParams
	
	Private categoriesParam         ' Categories Parameter Setting 
	Private categorySet             ' Category array for storing Category set
	Private categorySetCounter      ' Category array counter
	
	Private dataSet                    ' Dataset array
	Private dataSetParam               ' Dataset parameter setting array
	Private dataSetCounter             ' Dataset array counter
	Private setCounter                 ' Set array counter 
	
	 ' trendLines array
    Private trendLines				' trendLines array
	Private tLineCounter            ' trendLines array counter
	
	'Chart messages
	Private chartMSG
	
	Private chartsSWF               ' Name of the required FusionCharts SWF file
	
	' Default Color Array
	Private arr_FCColors(23)        ' Colorset to be applied to dataplots
	Private ColorParam              ' String to store User defined colors 
    Private UserColorON             ' Flag : User defined color : true or false
	
	' Advanced Chart settings
	Private JSC
		
	Private noCache  				' Flag - Range : true/false : Stops caching chart SWFs
	Private wMode   				' Transparent Mode
	
	' Addtional variables for MSStacked charts
	
	Private msdataset               ' Dataset array for MSStackedColumn2D
	Private msdataSetParam          ' msdataset parameter setting
	
	Private msDataSetCounter        ' msdataset array counter
    Private msSubDataSetCounter     ' ms sub dataset array counter
	Private msSetCounter            ' msset array counter
	
	' lineset 
	Private lineSet                 ' lineSet array
	Private lineSetParam            ' lineSet Parameter setting array
	  
	Private lineCounter             ' line array counter 
	Private lineSetCounter          ' lineset array counter
	Private lineIDCounter           ' lineID counter
	
	' vtrendLines array
    Private vtrendLines		    	' vtrendLines array
	Private vtLineCounter           ' vtrendLines array counter

   
    ' style array
    Private style			        ' style array
    Private defCounter              ' define counter
	Private appCounter              ' apply counter
	
	' Class Initialize. Initialize all variable and array class
	Private Sub Class_Initialize()
	
   		' All Array class Initialize
		Set chartParams=New AssocArray
		Set chartsSWF=New AssocArray
		Set categorySet=New AssocArray
		set dataSet=New AssocArray
		set dataSetParam=New AssocArray
		set msdataset=New AssocArray
		set style=New AssocArray
		set trendLines=New AssocArray
		set vtrendLines=New AssocArray
		set lineSet=New AssocArray
		set lineSetParam=New AssocArray
		set msdataSetParam=New AssocArray
		set JSC=New AssocArray
		
		' Default Delimiter
		del=";"
		
		' Chart Array List
		Call setChartArrays()
		
		
		' Default Color Array List
	    Call colorInit()
		
		' User Color Initialize
        UserColorON=false
		ColorParam=""
		
		' Default Cache Off
	    noCache=false	
	
		' Chart  Message
		chartMSG=""
		
		' JS Constructor
		JSC("debugmode")=false          ' debugmode default is false
		JSC("registerwithjs")=false     ' registerwithJS default is false
	    JSC("bgcolor")=""               ' bgcolor default not set
	    JSC("scalemode")="noScale"		' scalemode default noScale
	    JSC("lang")="EN"				' Language default EN
			  
		' XML store Variables 
		strXML=""  
		
		
		
		' Default Transparent off
		wMode=false
		
		' SWF Path Default
		SWFPath="Charts/"
		
		' Category
        categoriesParam=""
		categorySetCounter=1
		  
	    ' Create Category Array
		Call createCategory(categorySetCounter)
		  
	    ' Dataset   
	    dataSetCounter=0
        setCounter= 0
		  
	    ' MsDataset
		  
		msDataSetCounter=0
		msSubDataSetCounter=0
		msSetCounter=0
			
		lineCounter=0
        lineSetCounter=0
		lineIDCounter=0
         
		  
	    ' vTrendLines Array inisialize
		vtLineCounter=1
	      
		  
	    ' TrendLines Array inisialize
		tLineCounter=1
		  		
	    ' Styles Array inisialize
		defCounter=1
	    appCounter=1
	
	 	Call createStyles("definition")
        Call createSubStyles("definition","style")
        Call createSubStylesParam("definition","style",defCounter)
		
  	End Sub
	
	 

	'''''''''''''''''' PUBLIC METHODS ''''''''''''''''''''
	
	' set FusionCharts Type
	Public Sub setChartType(mchartType)
	   chartType=Lcase(mchartType)
	   ' Get Series Type
	   Call getSeriesType()
	   
	   ' SWF Path Default
	   SWFFile=SWFPath & chartsSWF(chartType)("0")  & ".swf"
	   
	   ' Set ChartID, Default is Charts Name
	   ' Create Chart ID Auto when Chart Type blank
	   If chartID="" Then
		   dim chartCounter
		   ' Get chart counter from session
		   chartCounter=Session("chartcount")
		   ' Initialize Chart Counter
		   If chartCounter<=0 or chartCounter="" Then
		        chartCounter=1
		   End If
			
		   ' Set Chart ID Depend on chartType and chart counter		
		   chartID=chartType & chartCounter
		   chartCounter=chartCounter+1
		   ' Store chart counter Session Variable
		   Session("chartcount") =chartCounter
		End If
		 
	End Sub
	
	' Set FusionCharts width and height
	Public Sub setSize(mwidth,mheight)
	   width=mwidth      ' Charts width
	   height=mheight    ' Charts height
	End Sub
	
	' Set ChartID default is Chart Name
	Public Sub setID(mchartsID)
	  ' Set ChartID, Default is Charts Name
	  ' Create Chart ID Auto when Chart Type blank
	  If mchartsID="" Then
		  	dim chartCounter
			' Get chart counter from Session
			chartCounter=Session("chartcount")
			' Initialize Chart Counter
			If chartCounter<=0 or chartCounter="" Then
				chartCounter=1
			End If
			' Set Chart ID Depend on chartType and chart counter	
		    chartID=chartType & chartCounter
			chartCounter=chartCounter+1
			' Store chart counter Session Variable
			Session("chartcount") =chartCounter
			
	  Else
		    ' Set user define chart id
			chartID=mchartsID
	  End If
	
	End Sub
	' set SWF Transparent true and false. default false
	Public function setTransparent(wModeSet)
	    wMode=wModeSet
	End Function
	
	
	
	 ' Set path of SWF file. file name like Column3D.swf
	Public Function setSWFPath(mSWFPath)
	   SWFPath=mSWFPath
	   SWFFile=SWFPath & chartsSWF(chartType)("0")  & ".swf"
	End Function
	
	' Set Parameter Delimiter, Defult Parameter Separator is ";"
	Public Function setParamDelimiter(strDelm)
	   del=strDelm
	End Function
	 
	
	 
	' We can add or change single Chart parameter by setChartParam function
	' its take Parameter Name and its Value
	Public sub setChartParam(paramName, paramValue)
	   chartParams(paramName)=paramValue
    End Sub
	 
	' We can add or change Chart parameter sets by setChartParams function
	' its take parameterset [ caption=xyz caption;subCaption=abcd abcd abcd;xAxisName=x axis;yAxisName=y's axis;bgColor=f2fec0;animation=1 ]
	' Defult Parameter Separator is ";"
	Public Sub setChartParams(strParams)
	   dim listArray, paramValue, i
	   listArray=split(strParams,del)
	   For i=lbound(listArray) to ubound(listArray)
    	   paramValue=split(listArray(i),"=")
		   if validateParam(paramValue)=true then
		     ' Store each parameter into array
			 chartParams(paramValue(0))=encodeSpecialChars(paramValue(1))
		   end if
	   Next
	   
	End Sub
	 
	' Set Categories Parameter into categoriesParam variables
	Public Sub setCategoriesParams(catParams)
	     ' Convert parameter set into XML Attribute
		 categoriesParam = ConvertParamToXMLAttribute(catParams)
	End Sub
	' Add Category and vLine element
	Public sub addCategory(label, catParams, vlineParams)
	     ' Define variables
	   	 dim strCatXML,strParam,listArray,i,paramValue
		 strCatXML=""
		 strParam=""
		 
		 ' Check whether vlineParams is present
		 If vlineParams="" Then

		    ' check whether catParams is absent
		    If catParams<>"" Then
			   ' Convert category Parameters into XML
			   strParam=ConvertParamToXMLAttribute(catParams)
		    End If

			' Add label and parameters to category 
		    strCatXML ="<category label='" & label & "' " & strParam & " />"
          
		 Else
		    ' Conver parameter to XML Attribute
		    strParam=ConvertParamToXMLAttribute(vlineParams)
		    ' add vLine parameters
		    strCatXML="<vLine " & strParam & "  />" 
		 End If
		 
		 ' Store into categorySet array
		 categorySet(categorySetCounter)=strCatXML
		 ' Increase Counter
		 categorySetCounter = categorySetCounter+1  

	End Sub
	  ' Add dataset array element
	 Public Function  addDataset(seriesName, datasetParams)
	   ' Increase DataSet Counter
	   dataSetCounter = dataSetCounter+1
	   ' Create Dataset Array for storing sets
       Call createDataSet(dataSetCounter)
	   
	   ' Increase set Counter
	   setCounter = setCounter + 1
	   ' Create Dataset Array for storing one set
	   Call createSetData(dataSetCounter,"_" & setCounter)
		
	   ' Create seriesName and dataset parameter set
	   dim  tempParam, strColor
	   tempParam ="seriesName='" & seriesName & "' "
	   strColor=""
	   
	   ' Convert parameter to XML Attribute
	   tempParam = tempParam & ConvertParamToXMLAttribute(datasetParams)  
	   
	   ' if UserColor set on then set color in dataset
	   if UserColorON=true then
			If  seriesType>1  Then
			       dim pos
			       ' Check Color Attribute set or not
				   pos=InStr(tempParam," color")
				   if pos<1 then
				     ' Color Attribute not exists then insert color Attribute
					 strColor = " color='" & getColor(dataSetCounter-1) & "'"
				   end if
			End If   
	   	end if
		' setting  dataSetParam array
		dataSetParam(dataSetCounter)=tempParam & strColor
		
	 End Function
	  ' Add set data element
	 Public Function addChartData(mvalue, params, vlineParams)
	     dim strSetXML
		 strSetXML=""
		 
		 ' Choose dataset depending on seriesType and get XML set
		 Select Case seriesType
		 Case 1, 2
           ' For seriesType 1 and 2
		   strSetXML=setSSMSDataArray(mvalue,params,vlineParams)

		 Case 3
		   ' For seriesType 3
		   strSetXML=setScatterBubbleDataArray(mvalue,params,vlineParams) 
		 
		 Case 4
		   ' For seriesType 4
		   strSetXML=setSSMSDataArray(mvalue,params,vlineParams)
		 
		 End Select
		 
		 ' Add xml set to dataset array and Increase set counter
		 Select Case seriesType
		 Case 1
		      dataSet(setCounter)=strSetXML
		      setCounter=setCounter+1
		 Case 2,3 
		      dataSet(dataSetCounter)("_" & setCounter)=strSetXML
		      setCounter=setCounter+1
		 Case 4
			  msdataset(msDataSetCounter)(msSubDataSetCounter)(msSetCounter)=strSetXML
			  msSetCounter=msSetCounter+1
		 End Select
	 End Function
	  ' Create msdataset array element and parameter array
	 Public Sub createMSStDataset()
		 msDataSetCounter=msDataSetCounter+1
		 msdataset(msDataSetCounter)= New AssocArray
		 msdataSetParam(msDataSetCounter)=New AssocArray
	 End Sub
	 ' Add msdataset and parameter	 
	 Public Function addMSStSubDataset(seriesName, datasetParams)
	   msSubDataSetCounter=msSubDataSetCounter+1
       msdataset(msDataSetCounter)(msSubDataSetCounter)= New AssocArray
	   
	   dim tempParam, i, paramValue
	   ' Create seriesName
	   tempParam ="seriesName='" & seriesName & "' "
	   
	   ' Convert parameter into XML Attribute
	   tempParam = tempParam & ConvertParamToXMLAttribute(datasetParams) 
	   		
	   msSetCounter=msSetCounter+1	
	   
	   ' Add Parameter to msDatasetParam array
	   msdataSetParam(msDataSetCounter)(msSubDataSetCounter)=tempParam
	   
	   ' Create Ms Dataset Array
	   Call createMsSetData()
	  
	 End Function
	  ' Add Lineset array and parameter to it
	Public Function addMSLineset(seriesName, linesetParams)
	   ' Create Lineset 
	   Call createLineset()
	   lineSetCounter=lineSetCounter+1
       lineSet(lineCounter)(lineSetCounter)=New AssocArray
	   		
	   dim tempParam
	   tempParam ="seriesName='" & seriesName & "' "
	   
	   ' Convert Parameter to XML Attribute
	   tempParam = tempParam & ConvertParamToXMLAttribute(linesetParams) 
	   
	   ' Increase lineIDCounter		
	   lineIDCounter=lineIDCounter+1
	   
	   ' Set lineSetParam array with Parameter set	
	   lineSetParam(lineSetCounter)=tempParam
	  	  
	End Function
	' Add Line's Set data 
	Public Function addMSLinesetData(mvalue,params,vlineParams)
	     dim strSetXML
		 strSetXML=""
		 ' Get parameter set  
		 strSetXML=setSSMSDataArray(mvalue,params,vlineParams)
         
		 ' Set paramter to lineSet array
		 lineSet(lineCounter)(lineSetCounter)(lineIDCounter)=strSetXML
		 
		 ' Increase lineIDCounter
		 lineIDCounter=lineIDCounter+1
	 End Function
	 ' Sets Grid Param 	
    Public sub setGridParams(gridParams)
	   Call setChartMessage(gridParams)
	End Sub
	' Add TrendLine
	 Public Function addTrendLine(tlineParams)
	   dim listArray, paramValue, i
	   listArray=split(tlineParams,del)
	   For i=lbound(listArray) to ubound(listArray)
    	   paramValue=split(listArray(i),"=")
		   If validateParam(paramValue)=true Then
		     'Store TrendLine parameter value
		     trendLines(tLineCounter)(paramValue(0))=encodeSpecialChars(paramValue(1))
		   End If
	   Next
	   tLineCounter=tLineCounter+1
	 End Function
     
	 ' Add Vertical TrendLine parameter 
	 Public Function addVTrendLine(vtlineParams)
	   dim listArray, paramValue, i
	   listArray=split(vtlineParams,del)
	   for i=lbound(listArray) to ubound(listArray)
    	   paramValue=split(listArray(i),"=")
		   If validateParam(paramValue)=true Then
		      'Store VTrendLine parameter value
			  vtrendLines(vtLineCounter)(paramValue(0))=encodeSpecialChars(paramValue(1))
		   End If
	   Next
	   vtLineCounter=vtLineCounter+1
	 End Function
	 ' Add user color
	Public sub addColors(colorList)
	    ColorParam= ColorParam & colorList
		UserColorON=true
	End Sub 
	
	' Removes all user-defined colors
	Public Sub clearUserColor()
        UserColorON = false
    End Sub
	  ' defineStyle function defines a Charts Style
	 Public Function defineStyle(styleName,styleType,styleParams)
		style("definition")("style")(defCounter)("name")= styleName
		style("definition")("style")(defCounter)("type")= styleType
		
		dim i, listArray
		listArray=split(styleParams,del)
	    for i=lbound(listArray) to ubound(listArray)
    	   dim paramValue
		   paramValue=split(listArray(i),"=") 
		   If validateParam(paramValue)=true Then
		      style("definition")("style")(defCounter)(paramValue(0))= encodeSpecialChars(paramValue(1))
		   End If
		Next   
        defCounter= defCounter+1
    	
	 End Function
    
	 ' applyStyle function applies a define style to chart elements
	 Public Function applyStyle(toObject,styles)
		style("application")("apply")(AppCounter)("toObject")= toObject
		style("application")("apply")(AppCounter)("styles")= styles
		AppCounter=AppCounter+1
	 End Function
	 ' Add Category from Array
	Public Function addCategoryFromArray(categoryArray)
	 		 dim i
	         ' convert array into category set
			 for i=lbound(categoryArray) to  ubound(categoryArray)
			    ' Add category
			    Call addCategory(categoryArray(i),"","")
			 Next
	End Function
	 
	' Create catagory, dataset, set from array
	Public Function addChartDataFromArray(byval dataArray, byval dataCatArray)
	    dim counter
		' Check dataArray is array or not
		if isarray(dataArray)=true Then
			If seriesType=1 Then
			   ' Single series Array
			   ' aa(.., ..)="label" aa(.., ..)="value"
			   For counter=0 to ubound(dataArray,1)-1
				   ' Add set element
				   Call addChartData(dataArray(counter,1),"label=" & dataArray(counter,0), "")
			   Next 		
			Else
			   ' Multi series Array
			   If isarray(dataCatArray)=true then
				   For counter=0 to ubound(dataCatArray)-1
					   ' Add Category element
					   Call addCategory(dataCatArray(counter),"","")
				   next
			   End If
			
			   ' Create Multi Series type XML
			   dim k, l			   
			   dim i, tempArray(2)
			   ' Fetch dataArray
			   For  k=lbound(dataArray,1) to ubound(dataArray,1)-1
	              
				  i=0
				  tempArray(0)="": tempArray(1)=""
				  ' Fetch dataArray
				  For l=lbound(dataArray,2) to ubound(dataArray,2)-1
	                 if i>=2 Then
					   	' Add set element
						Call addChartData(dataArray(k,l), "", "")
					 Else
					    tempArray(i)=dataArray(k,l)
					 End If				 					
				     if i=1 Then
					   ' Add Dataset
					   Call addDataset(tempArray(0),tempArray(1))
					 End If
					 i=i+1
                  Next
                Next
			   
			End If
		End If	
	End Function
	 
	 
      

        
    ' Add Category from Database Recordset
	Public Function addCategoryFromDatabase(oRs, categoryColumn)
			 ' fetch All recordset
			 do while Not oRs.Eof 
				' add category
				Call addCategory(oRs(categoryColumn),"","")
				oRs.MoveNext
			 Loop 
	End Function
	 
	
	
	 ' Add set from Recordset
	 ' query_result = Adodb RecordSet
	 ' db_field_ChartData = field for set value
	 ' db_field_CategoryNames = field for Label
	 ' strParam = set parameter
	 ' link = for set link [abcd.asp?xyz=##fieldname##&abc=##fieldname##]
	 Public Function addDataFromDatabase(query_result, db_field_ChartData, db_field_CategoryNames, strParam, link)
	   	      	   
	   dim paramset, data, label , srtAttrib
	   paramset=""
	   data=""	
	   label=""	   
	   srtAttrib=""
	   ' Fetch all recordset
	   do while not query_result.eof
		  srtAttrib=""
		  if link="" then
			   paramset=""
		  else
			   ' Create link from link
			   paramset="link=" & Server.URLEncode(getLinkFromPattern(query_result,link))
		  end if
		  
		  ' Combine all parameter
		  srtAttrib =  strParam & del & paramset 
	
		  ' Convert to set element and save
		  if db_field_CategoryNames="" then
		        ' Get field for value
				data=query_result(db_field_ChartData)
				
				' Create set with value, Label
				Call addChartData(encodeSpecialChars(data),srtAttrib, "")
				
		  else
		        ' Get field for value
				data=query_result(db_field_ChartData)
				' Get field for Label
				label=query_result(db_field_CategoryNames)
				' Create set with value, Label and link
				Call addChartData(encodeSpecialChars(data),"label=" & encodeSpecialChars(label) & del & srtAttrib, "")
		  end if
         
		 ' Move Next Record
		 query_result.moveNext
	   loop 
   
	 End Function
	 
	 ' Add dataset and set element from recordset
	 ' oRs = Adodb RecordSet
	 ' ctrlField = field Dataset seriesName
	 ' setField = field for set Value
	 ' datasetParamArray = dataset parameter array
	 ' link = for set link [abcd.asp?xyz=##fieldname##&abc=##fieldname##]
	 Public Function addDatasetsFromDatabase(oRs,ctrlField, setField,datsetParamArray,link)
			 dim paramset, tempContrl, arrLimit, i, tempParam
			 paramset=""
			 tempContrl=""
			 arrLimit=0
			 i=0
			 if isArray(datsetParamArray) then
			   arrLimit=ubound(datsetParamArray)
			   i=lbound(datsetParamArray)
			 end if
			 
			 tempParam=""
			 
			 dim k
			 k=1
			 ' Fetch all Recordset
			 do while not oRs.eof
			   If i<=arrLimit Then
					if isArray(datsetParamArray) then
					  tempParam =datsetParamArray(i)  
					end if
				Else
					tempParam=""
				End If
				' Create dataset
				Call addDataset(oRs(ctrlField),tempParam)
				i=i+1
				tempContrl=oRS(ctrlField)
			    ' Control Break on Dataset control Field
				do while tempContrl=oRS(ctrlField)
				   If link="" Then
					  paramset=""
				   Else
					  paramset="link=" & Server.URLEncode(getLinkFromPattern(oRs,link))
				   End IF
				   ' Create set
				   Call addChartData(oRs(setField), paramset, "")
			       k=k+1
				   'Move next record
				   oRs.MoveNext
				   If  oRs.eof=true Then
					 exit do
				   End if
				Loop  
	         Loop
	 End Function
	 
	 
	 ' Sets chart messages
	Public sub setChartMessage(byval msgParam)
	    if chartMSG="" then 
		   chartMSG="?"
		else
		   chartMSG = chartMSG & "&"
		end if    
				
		dim xmlParam, listArray, i
		 xmlParam=""
		 listArray=split(msgParam,del)
		 For i=lbound(listArray) to ubound(listArray)
			   dim paramValue
			   paramValue=split(listArray(i),"=")
			   			   
		       If validateParam(paramValue) = true then
			      
			     ' Create parameter set
			     xmlParam = xmlParam & paramValue(0) & "=" & encodeSpecialChars(paramValue(1)) & "&"
				 
			   End If	
			   
		Next
		
		xmlParam = mid(xmlParam,1,len(xmlParam)-1)
		chartMSG=chartMSG & xmlParam
	End Sub
	 

   
	 
	 

     ' render all store arrays to XML output
	 Public Function getXML()
				
		strXML=""
		' Check line and area for add chart parameter linecolor and areacolor
		If seriesType=1 then
		  call CheckLineArea()
		End if
		strXML  =  "<chart " & getChartParam() & " >"
		' Add Category element
		strXML = strXML & getCategory()
		' Add Dataset element 
		strXML = strXML & getDataSet()
		' Add vTrendLines element
		If seriesType=3 Then
		  strXML = strXML &  getvTrendLines()
		End If  
		'  Add Lineset element
        If seriesType=4 Then
		   strXML = strXML &  getLineSetData()
		End If
		' Add TrendLines element
		strXML = strXML & getTrendLines()
		' Add Styles element
		strXML = strXML & getStyles()
		' Close Chart element
		strXML = strXML & "</chart>"
		
		' Return XML output
		getXML= strXML
	End Function
	' Sets whether chart SWF files are not to be cached 
    Public Function setOffChartCaching(SWFNoCache)
           noCache=SWFNoCache
    End Function
	 
	
	 
	' render FusionCharts bind with XML
	Public Sub renderChart(RenderAsHTML)
		' Get Chart XML
		strXML=getXML()
		' Set SWF path	
		SWFFile=SWFPath & chartsSWF(chartType)("0")  & ".swf"
		
		' Set Cache clear true and false
	    if noCache=true then
		  if chartMSG="" then
		     chartMSG = "?nocache=" & timer
		  else
		     chartMSG = chartMSG  & "&nocache=" & timer
		  end if
		end if
		
		' render chart using RenderAsHTML option, true then render as html and false for render as JS
		if RenderAsHTML=true then
	       Response.Write renderChartHTML(SWFFile & chartMSG,"",strXML,chartID, width, height,JSC("debugmode"), JSC("registerwithjs"), wMode)
		else
		   Response.Write renderChartJS(SWFFile & chartMSG,"",strXML,chartID, width, height,JSC("debugmode"), JSC("registerwithjs"), wMode)
		end if
		
	End Sub 
	
	
	' Renders Chart from External XML data source
	Public Sub renderChartFromExtXML(dataXML, RenderAsHTML)
	  ' render chart using RenderAsHTML option, true then render as html and false for render as JS
	  if RenderAsHTML=true then
	    Response.Write renderChartHTML(SWFFile & chartMSG,"",dataXML,chartID, width, height,JSC("debugmode"), JSC("registerwithjs"), wMode)
	  else
		Response.Write renderChartJS(SWFFile & chartMSG, "", dataXML, chartID, width, height, JSC("debugmode"), JSC("registerwithjs"), wMode)
	  end if	
	
	End Sub
	 ' Set JS constructor of FusionCharts.js
	Public Sub setInitParam(tname,tvalue)
        dim trimName
		trimName=lcase(replace(tname," ",""))
       
		dim JSCKeys, Keys
		set JSCKeys=JSC.getCollections()
		if JSCKeys.Exists(trimName) then
		   JSC(trimName)=tvalue
		End If

	End Sub
	  	
	
	 	
	

   

   
	 
	'''''''''''''''''''' PRIVATE METHODS '''''''''''''''''''''''''''''''''''''
	
	  ' This function returns a color from a list of colors
	Private function getColor(counter)
		dim colorList
		' Check User Color define true
		if UserColorON=true then
		  colorList=split(ColorParam,del)
		  getColor = colorList(counter mod (ubound(colorList) + 1))
		else
		  getColor = arr_FCColors(counter mod (ubound(arr_FCColors) + 1))
		end if 
	End Function
	 
	' Fetch charts array and convert into XML
	 ' and return like "caption='xyz' xAxisName='x side' ............
	 Private Function getChartParam()
		dim partXML, keys, i
		partXML=""	
		' Fetch charts each array and converting into chat parameter
		dim ChartParamColl
		set ChartParamColl=chartParams.getCollections()
		keys = ChartParamColl.Keys
		For i = 0 To ChartParamColl.Count -1 ' Iterate the array.
		    If(chartParams(keys(i))<>"") then
				partXML = partXML & keys(i) & "='" & chartParams(keys(i)) & "' "
			End If
		Next
		' Return Chart Parameter
		getChartParam = partXML
	 End Function
	 
	 ' Get Lineset XML
	 Private Function getLineSetData()
	   Dim partXML 
	   ' If seriesType MSStackedColumn2DLineDY (4) then linset element will be generate
	   If seriesType=4 Then
		   partXML=""
		   dim Col,Key,i
		   set Col=lineSet.getCollections()
		   Key=Col.Keys
		   ' Fetch lineSet array and generating lineset xml element
		   for i=0 to Col.count-1
		     partXML = partXML & "<lineset " & lineSetParam(Key(i)) & " >"
		     dim Col1, Key1, j
			 set Col1=lineSet(Key(i)).getCollections()
			 Key1=Col1.Keys
			 for j=0 to Col1.count - 1 
			     dim Col2, Key2, k
			     set Col2=lineSet(Key(i))(Key1(j)).getCollections()
			     Key2=Col2.Keys
		         for k=0 to Col2.count -1 
				   If lineSet(Key(i))(Key1(j))(Key2(k)) <>"" Then
					  partXML = partXML & lineSet(Key(i))(Key1(j))(Key2(k))
				   End If 
				 Next	 
		      Next
		     partXML = partXML & "</lineset>"
		   Next
		   ' Return lineset element
		   getLineSetData = partXML
	   End If
	 End Function
	 
	 ' Get dataset part XML
	 '     <dataSet seriesName='Product A' color='AFD8F8' showValues='0'>
     '       <set value='30' />
     '       <set value='26' />
     '     </dataSet>
	 Private Function getMultiDataSet()
	   Dim partXML, Col, Key, i 
	   If seriesType>1 Then
		   partXML=""
		   ' Fetch dataSet Collections
		   set Col=dataSet.getCollections()
		   Key=Col.Keys
		   for i=0 to Col.count -1 
		       		   
			   partXML = partXML & "<dataset  " & dataSetParam(Key(i)) & " >"
			   dim Key1, Col1, j
			   set Col1=dataSet(Key(i)).getCollections()
			   Key1= Col1.Keys
			   for j=0 to Col1.count -1 
					   If dataSet(Key(i))(Key1(j)) <> "" Then 
						 ' adding elements 
						 partXML = partXML & dataSet(Key(i))(Key1(j))
					   End If
			   Next
			   partXML = partXML & "</dataset>"
		    Next
		   ' Return dataset element
		   getMultiDataSet = partXML
	   End If
	 End Function
	 
	' Create single set element
    '       <set value='30' />
    '       <set value='26' />
	 Private Function getSingleDataSet()
	   Dim partXML, Col, Key, i
	   If seriesType=1 Then
		   partXML=""
		   'Fetch dataset collections
		   set Col=dataSet.getCollections()
		   Key = Col.Keys
		   For i=0 to Col.count -1 
			   If dataSet(Key(i)) <> "" Then 
				 ' Add elements 
				 partXML = partXML & dataSet(Key(i))
			   End If 
		   Next
		   getSingleDataSet = partXML
	   End IF
	 End Function
	 
	' Create set xml element
	Private Function getDataSet()
       ' Call dataset function depending on seriesType
	   Select case seriesType
	   Case 1 
	     getDataSet = getSingleDataSet()
		 
	   Case 2 
	     getDataSet =getMultiDataSet()

	   Case 3 
	   	 getDataSet = getMultiDataSet()

	   Case 4 
	     getDataSet = getMSDataSet()
		 
	   End Select
	End Function

	 ' Get dataset part XML
	 ' <dataset>
     '     <dataSet seriesName='Product A' color='AFD8F8' showValues='0'>
     '       <set value='30' />
     '       <set value='26' />
     '     </dataSet>
	 ' </dataSet>
	Private Function getMSDataSet()
	   dim partXML
	   If seriesType=4 Then
		   partXML=""
		   dim Col, Key, i
		   ' Fetch Multi Dataset Collections
		   set Col=msdataset.getCollections()
		   Key=Col.Keys
		   for i=0 to Col.count-1 
		     partXML = partXML & "<dataset>"
			 dim Col1, Key1, j
		     set Col1=msdataset(Key(i)).getCollections()
		     Key1=Col1.Keys
		     for j=0 to Col1.count -1 
		        dim Col2, Key2, k
		        set Col2=msdataset(Key(i))(Key1(j)).getCollections()
		        Key2=Col2.Keys
				partXML = partXML & "<dataSet " & msdataSetParam(Key(i))(Key1(j)) & " >"
		        for k=0 to Col2.count-1 
		             If  msdataset(Key(i))(Key1(j))(Key2(k)) <> "" Then
					  partXML = partXML &  msdataset(Key(i))(Key1(j))(Key2(k))
					 End If 
		        Next
		        partXML = partXML & "</dataSet>"
		     Next
		     partXML = partXML & "</dataset>"
		   Next
		   
		   ' Return MSdataset XML
		   getMSDataSet = partXML
	   End IF
	 End Function
	 
	' Get Series Type from Chart Type
	Private sub getSeriesType()
	    dim sValue
		' Get Chart series from chartsSWF array	
		sValue=chartsSWF(chartType)("1")
		if sValue="" then
		  sValue=1
		End If
		'returm series type
		seriesType=sValue 
	 End Sub
	
	' FusionCharts V3 Array list
	Private sub setChartArrays()
	    ' Series Type #1
	    chartsSWF("area2d")("0")="Area2D"
		chartsSWF("area2d")("1")=1
		chartsSWF("bar2d")("0")="Bar2D"
		chartsSWF("bar2d")("1")=1
		chartsSWF("column2d")("0")="Column2D"
		chartsSWF("column2d")("1")=1
		chartsSWF("column3d")("0")="Column3D"
		chartsSWF("column3d")("1")=1
		chartsSWF("doughnut2d")("0")="Doughnut2D"
		chartsSWF("doughnut2d")("1")=1
		chartsSWF("doughnut3d")("0")="Doughnut3D"
		chartsSWF("doughnut3d")("1")=1
		chartsSWF("line")("0")="Line"
		chartsSWF("line")("1")=1
		chartsSWF("line2d")("0")="Line"
		chartsSWF("line2d")("1")=1
		chartsSWF("pie2d")("0")="Pie2D"
		chartsSWF("pie2d")("1")=1		
		chartsSWF("pie3d")("0")="Pie3D"
		chartsSWF("pie3d")("1")=1	
		chartsSWF("grid")("0")="SSGrid"
		chartsSWF("grid")("1")=1
		
		' Series Type #2
		chartsSWF("msarea2d")("0")="MSArea"
		chartsSWF("msarea2d")("1")=2
		chartsSWF("msarea2d")("0")="MSArea2D"
		chartsSWF("msarea2d")("1")=2
		chartsSWF("msbar2d")("0")="MSBar2D"
		chartsSWF("msbar2d")("1")=2
		chartsSWF("msbar3d")("0")="MSBar3D"
		chartsSWF("msbar3d")("1")=2
		chartsSWF("mscolumn2d")("0")="MSColumn2D"
		chartsSWF("mscolumn2d")("1")=2
		chartsSWF("mscolumn3d")("0")="MSColumn3D"
		chartsSWF("mscolumn3d")("1")=2
		chartsSWF("mscolumn3dlinedy")("0")="MSColumn3DLineDY"
		chartsSWF("mscolumn3dlinedy")("1")=2
		chartsSWF("mscolumnline3d")("0")="MSColumnLine3D"
		chartsSWF("mscolumnline3d")("1")=2
		chartsSWF("mscolumn3dline")("0")="MSColumnLine3D"
		chartsSWF("mscolumn3dline")("1")=2
		chartsSWF("mscombi2d")("0")="MSCombi2D"
		chartsSWF("mscombi2d")("1")=2
		chartsSWF("mscombidy2d")("0")="MSCombiDY2D"
		chartsSWF("mscombidy2d")("1")=2
		chartsSWF("msline")("0")="MSLine"
		chartsSWF("msline")("1")=2		
		chartsSWF("msline2d")("0")="MSLine"
		chartsSWF("msline2d")("1")=2		
		chartsSWF("scrollarea2d")("0")="ScrollArea2D"
		chartsSWF("scrollarea2d")("1")=2		
		chartsSWF("scrollcolumn2d")("0")="ScrollColumn2D"
		chartsSWF("scrollcolumn2d")("1")=2		
		chartsSWF("scrollcombi2d")("0")="ScrollCombi2D"
		chartsSWF("scrollcombi2d")("1")=2
		chartsSWF("scrollcombidy2d")("0")="ScrollCombiDY2D"
		chartsSWF("scrollcombidy2d")("1")=2		
		chartsSWF("scrollline2d")("0")="ScrollLine2D"
		chartsSWF("scrollline2d")("1")=2		
		chartsSWF("scrollstackedcolumn2d")("0")="ScrollStackedColumn2D"
		chartsSWF("scrollstackedcolumn2d")("1")=2		
		chartsSWF("stackedarea2d")("0")="StackedArea2D"
		chartsSWF("stackedarea2d")("1")=2		
		chartsSWF("stackedbar2d")("0")="StackedBar2D"
		chartsSWF("stackedbar2d")("1")=2		
		chartsSWF("stackedbar3d")("0")="StackedBar3D"
		chartsSWF("stackedbar3d")("1")=2
		chartsSWF("stackedcolumn2d")("0")="StackedColumn2D"
		chartsSWF("stackedcolumn2d")("1")=2
		chartsSWF("stackedcolumn3d")("0")="StackedColumn3D"
		chartsSWF("stackedcolumn3d")("1")=2		
		chartsSWF("stackedcolumn3dlinedy")("0")="StackedColumn3DLineDY"
		chartsSWF("stackedcolumn3dlinedy")("1")=2		
		chartsSWF("msstackedcolumn2d")("0")="MSStackedColumn2D"
		chartsSWF("msstackedcolumn2d")("1")=2
		
		' Series Type #3
		chartsSWF("bubble")("0")="Bubble"
		chartsSWF("bubble")("1")=3
		chartsSWF("scatter")("0")="Scatter"
		chartsSWF("scatter")("1")=3
		
		' Series Type #3
		chartsSWF("msstackedcolumn2dlinedy")("0")="MSStackedColumn2DLineDY"
        chartsSWF("msstackedcolumn2dlinedy")("1")=4	
	    
	 End Sub
		 
	 ' Create array element with in Categories
	 Private Sub createCategory(catID)
		 categorySet(catID)=New AssocArray
	 End Sub
	  
	 ' Get Category part XML
	 Private Function getCategory()
	   dim partXML,cal,Key, i
	   If seriesType>1 Then
		   partXML=""
		   ' Add categories parameter
		   partXML="<categories " & categoriesParam & " >"
		   set cal=categorySet.getCollections()
		   Key=cal.Keys
		   For i=0 to cal.count-1 
				If categorySet(Key(i)) <>"" Then
					 ' Add elements 
					 partXML = partXML & categorySet(Key(i))
					 
				End If
		   Next
		   partXML = partXML & "</categories>"
		   ' Return categories element
		   getCategory= partXML
	   End If
	 End Function
	 
	 ' Create Lineset array 
	 Private Function createLineset()
		 lineCounter=lineCounter+1
		 lineSet(lineCounter)=New AssocArray
	 End Function
     
	 ' Create set data with in datset
	 Private Sub createMsSetData()
		 msSetCounter=msSetCounter+1
		 msdataset(msDataSetCounter)(msSubDataSetCounter)(msSetCounter)= New AssocArray
	 End Sub
	 
	 ' Create dataSet array element
	 Private Sub createDataSet(dataID)
		 dataSet(dataID)=New AssocArray
	 End Sub
	 
	 ' Create set array element
	 Private Sub createSetData(dataSetID, dataID)
		 dataSet(dataSetID)(dataID)= New AssocArray
	 End Sub
		 
	 ' Add set element to dataset element for seriesType 3 i.e Scatter and Bubble
	 Private Function setScatterBubbleDataArray(mvalue,setParam,vlineParam)
	     dim strSetXML,strParam,listArray, i, paramValue
		 strSetXML=""
		 strParam=""
		 If vlineParam="" Then
		   If setParam<>"" Then
			   ' Convert parameter to XML attribute
			   strParam = ConvertParamToXMLAttribute(setParam)
		   
		   End If
		   ' Add Parameter into set elements
		   strSetXML ="<set  x='" & mvalue & "' " & strParam & " />"
         
		 Else
		   ' Convert parameter to XML attribute
		   strParam = ConvertParamToXMLAttribute(vlineParam)
		   		   		   
		   ' Add vLine element
		   strSetXML="<vLine " & strParam & "  />" 
		 End IF
		 ' Return set element XML
	     setScatterBubbleDataArray=strSetXML
	 End Function
	 
	 ' Add set element within dataset element for seriesType 1 and 2
	 Private function setSSMSDataArray(mvalue,setParam,vlineParam)
	     
		 dim strSetXML, strParam, i, strColor
	     strSetXML=""
		 strParam=""
		 strColor=""
		 		 
		 If vlineParam="" then
		   If setParam<>"" then
			   ' Convert parameter to XML attribute
			   strParam = ConvertParamToXMLAttribute(setParam)
			   
		   End If
		  
		  ' Set color dipending on UserColorON
		  if UserColorON=true then
			  If  seriesType=1  Then
				   dim pos
				   ' Color added or not
				   pos=InStr(strParam," color")
			  	   if pos<1 then
				     ' color add except line and area chart
					 if instr(chartType,"area") < 1 and  instr(chartType,"line") < 1 then
					   ' Add color
					   strColor = " color='" & getColor(setCounter) & "'"
					 end if
				  end if
			  End If   
		  end if	  
		   
		   ' Set set parameter 
		   strSetXML ="<set  value='" & mvalue & "' " & strParam & strColor & " />"
         
		 Else
		   ' Convert parameter to XML attribute
		   strParam = ConvertParamToXMLAttribute(vlineParam)
		   ' Set vline parameter
		   strSetXML="<vLine " & strParam & "  />"
		 End IF
		 ' Return XML
	     setSSMSDataArray = strSetXML
	 End Function
	 	 	 
	 ' Create array element with in style array
	 Private Function createStyles(styleID)
		 style(styleID)=New AssocArray
	 End Function

	 ' Create array element with in style array element with in sub Style array 
	 ' element for store sub element parameter
	 Private Function createSubStyles(styleID,subStyle)
		 style(styleID)(subStyle)= New AssocArray
	 End Function
	 
	 ' Create sub style param
	 Private Function createSubStylesParam(styleID,subStyle,subParam)
		 style(styleID)(subStyle)(subParam)= New AssocArray
	 End Function
	 
	 ' Create sub style array to store parameters
	 Private Function setSubStylesParam(styleID,subStyle,subParam,id,mvalue)
		 style(styleID)(subStyle)(subParam)(id)= mvalue
	 End Function
	
	 ' Its convert pattern link to original link 
     Private Function getLinkFromPattern(byref oRsRec,byval tempLink)
	    dim aa, pos, i, pet		
		aa=split(tempLink,"##")
		For i=lbound(aa) to ubound(aa)
		      pos = instr(aa(i), "=")
			  If pos = 0 Then
			       if aa(i)<> "" then
					pet="##" & aa(i) & "##"
					tempLink=replace(tempLink,pet,oRsRec(aa(i))) 
				   end if	
			  End IF
 		 Next
		 
		 ' Return Link
		 getLinkFromPattern = tempLink
	 End Function		
	 
	 ' Create the style XML from style array
	 '
	 '<styles>
     '  <definition>
     '    <style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />
     '  </definition>
     '  <application>
     '    <apply toObject='Canvas' styles='CanvasAnim' />
     '  </application>   
     '</styles>
     '
	 Private Function getStyles()
		dim partXML, lineXML, Col, Key, i
		partXML=""
		lineXML=""	
		
		set Col=style.getCollections()
		Key= Col.Keys
	    
		' Fetch style array	
		For i=0 to Col.count-1
			 lineXML = lineXML & "<" & Key(i) & ">"
			 dim Key1,Col1,j
			 set Col1=style(Key(i)).getCollections()
			 Key1=Col1.Keys
			 
			 ' Fetch style array with in array	
			 for j=0 to Col1.count -1 
				  
				  ' Create dynamic element depend on array name
				  dim Key2,Col2,k
				  set Col2=style(Key(i))(Key1(j)).getCollections()
			      Key2=Col2.Keys
				  
				  ' Fetch style array with in array	with array element 
				  for k=0 to Col2.count-1 
				  	 dim Key3,Col3, l
		             set Col3=style(Key(i))(Key1(j))(Key2(k)).getCollections()
			         Key3=Col3.Keys
					 lineXML = lineXML & "<" & Key1(j) & " "
					 For l=0 to Col3.count-1 					 
					   If style(Key(i))(Key1(j))(Key2(k))(Key3(l)) <> "" Then 
						 ' Add elements parameter
						 lineXML = lineXML &  Key3(l) & "='" & style(Key(i))(Key1(j))(Key2(k))(Key3(l)) & "' "
						
					   End If 
					 Next
					 lineXML = lineXML & " />"
				  Next
			  
			 Next
			 ' Close open eleement
			 lineXML = lineXML & "</" & Key(i) &  ">"
		Next
		
		' Check element have any attribute or not
		dim pos
		pos = instr(lineXML, "=")
        If pos <> 0 Then
     		partXML = "<styles>" & lineXML & "</styles>"
		Else
	        partXML =""	
		End If
		' Return styles element xml
		getStyles = partXML
	 End Function
	 
	 ' Create TrendLines array
	 Private Sub createTrendLines(lineID) 
		trendLines(lineID) = New AssocArray
	 End Sub
	 	 
	 ' Create TrendLines array
	 Private Function createvTrendLines(lineID)
		vtrendLines(lineID) = New AssocArray
	 End Function
	 
	 ' Create TrendLine parameter 
	 Private Function setTLine(lineID,paramName, paramValue)
		 trendLines(lineID)(paramName)=paramValue
	 End Function

     ' Create TrendLine parameter 
	 Private Function setvTLine(lineID,paramName, paramValue)
		 vtrendLines(lineID)(paramName)=paramValue
	 End Function
	 
	 ' Create XML output depending on trendLines array
	 '  <vTrendlines>
	 '    <line displayValue='vTrendLines' startValue='5' endValue='6' alpha='10' color='ff0000'  />
	 ' </vTrendlines>
	 Private Function getvTrendLines()
		dim partXML, lineXML, Col, Key, i
		partXML=""
		lineXML=""	
		set Col=vtrendLines.getCollections()
		Key=Col.Keys
		' Fetch vtrendLines array
		for i=0 to Col.count -1
		  
		  dim Col1, Key1, j
		  ' line element
		  lineXML = lineXML & "<line "
		  set Col1=vtrendLines(Key(i)).getCollections()
		  Key1=Col1.Keys
		  ' Fetch vtrendLines array with in array element
		  for j=0 to Col1.count -1 
			 If vtrendLines(Key(i))(Key1(j))<>"" Then 
				lineXML = lineXML & Key1(j) & "='" & vtrendLines(Key(i))(Key1(j)) & "' "
			 End If 
		  Next
		  ' close line element
		  lineXML = lineXML & " />"
		Next
		' if line element present then add lineXML with in vtrendLines element 
		dim pos
		pos = instr(lineXML, "=")
        If pos <> 0 Then
		   partXML = "<vTrendlines>" & lineXML & "</vTrendlines>" 
		Else
		   ' return nothing
		   partXML=""
		End If
		' return vtrendLines XML
		getvTrendLines = partXML
	 End Function
	 	 
	 ' Create XML output depending on trendLines array
	 '  <trendLines>
	 '    <line startValue='700000' color='009933' displayvalue='Target' /> 
	 ' </trendLines>
	 Private Function getTrendLines()
	    dim partXML, lineXML, Col, Key, i
		partXML=""
		lineXML=""	
		
		set Col=trendLines.getCollections()
		Key=Col.Keys
		' Fetch trendLines array
		for i=0 to Col.count -1
		  ' line element
		  lineXML = lineXML & "<line "
		  dim Col1, Key1, j
		  set Col1=trendLines(Key(i)).getCollections()
		  Key1=Col1.keys
		  ' Fetch trendLines array with in array element
		  For j=0 to  Col1.count - 1 
			 If trendLines(Key(i))(Key1(j))<>"" Then 
				lineXML = lineXML &  Key1(j) & "='" & trendLines(Key(i))(Key1(j)) & "' "
			 End If 
		  Next
		  ' Close line element
		  lineXML = lineXML & " />"
		Next
		' if line element present then add lineXML with in trendLines element 
		
		dim pos
		pos = instr(lineXML, "=")
		if pos <> 0 then
		   partXML = "<trendLines>" & lineXML & "</trendLines>" 
		Else
		   ' return nothing
		   partXML=""
		End If
		' return trendLines XML
		getTrendLines = partXML
	 End Function
	
	 ' Check Line and Area for color
	 Private sub CheckLineArea()
	   dim strParam
	   strParam=""
	   if instr(chartType,"line")>0 then
	       if instr(chartType," lineColor")<1 then
		       setChartParams("lineColor=" & getColor(0) )
		   end if
	   elseif instr(chartType,"area")>0 then
	       if instr(chartType," areaBgColor")<1 then
		       setChartParams("areaBgColor=" & getColor(0) )
		   end if
	   end if
	 End Sub
	
	 ' Conver ' and " to %26apos; and &quot; 
	 Private Function encodeSpecialChars(strValue)
	   strValue=replace(strValue,"&","%26")
	   strValue=replace(strValue,"'","%26apos;")
	   strValue=replace(strValue,"""","&quot;")
	   strValue=replace(strValue,"<","&lt;")
	   strValue=replace(strValue,">","&gt;")
	   encodeSpecialChars = strValue
	 End Function	 
	 	 
	 ' Convertion of semi colon(;) separeted or User define separeted paramater to XML attribute
	 Private Function ConvertParamToXMLAttribute(byval strParam)
	 	 
		 dim xmlParam, listArray, i
		 xmlParam=""
		 listArray=split(strParam,del)
		 For i=lbound(listArray) to ubound(listArray)
			   dim paramValue
			   paramValue=split(listArray(i),"=")
			   
			   ' Validate parameter			   
		       If validateParam(paramValue) = true then
			      
			     ' Create parameter set
			     xmlParam = xmlParam & paramValue(0) & "='" & encodeSpecialChars(paramValue(1)) & "' "
			   End If	
			   
		 Next
		
		 ' Return XML attribute
         ConvertParamToXMLAttribute=xmlParam
			
	 End Function
		
	 ' Check valid of parameter
     Private Function validateParam(byval paramValue)
           
		   ' Check array with 2 elements or not 	 
		   If ubound(paramValue)>=1 Then
		     	' Check value for 1st element	
				If len(trim(paramValue(0)))=0 Then
				  ' Return false
				  validateParam = false
				  exit function
				End If
				
				' Check value for 2nd element
				If len(trim(paramValue(1)))=0 Then
				  ' Return false
				  validateParam = false
				  exit function
				End If
				' Return false
			    validateParam = true
				exit function
		    Else
			    ' Return false
		    	validateParam = false
				
			End If	
		 
     End Function 
	 	 
	 ''' ----- Pupulate Color and Chart SWF array  ------ ------- ---------------------
	 Private Sub colorInit()
	    arr_FCColors(0) = "AFD8F8"
		arr_FCColors(1) = "F6BD0F"
		arr_FCColors(2) = "8BBA00"
		arr_FCColors(3) = "FF8E46"
		arr_FCColors(4) = "008E8E"
		arr_FCColors(5) = "D64646"
		arr_FCColors(6) = "8E468E"
		arr_FCColors(7) = "588526"
		arr_FCColors(8) = "B3AA00"
		arr_FCColors(9) = "008ED6"
		arr_FCColors(10) = "9D080D"
		arr_FCColors(11) = "A186BE"
		arr_FCColors(12) = "CC6600"
		arr_FCColors(13) = "FDC689"
		arr_FCColors(14) = "ABA000"
		arr_FCColors(15) = "F26D7D"
		arr_FCColors(16) = "FFF200"
		arr_FCColors(17) = "0054A6"
		arr_FCColors(18) = "F7941C"
		arr_FCColors(19) = "CC3300"
		arr_FCColors(20) = "006600"
		arr_FCColors(21) = "663300"
		arr_FCColors(22) = "6DCFF6"
		
	 End Sub
	 
   	'encodeDataURL function encodes the dataURL before it's served to FusionCharts.
	'If you've parameters in your dataURL, you necessarily need to encode it.
	'Param: strDataURL - dataURL to be fed to chart
	'Param: addNoCacheStr - Whether to add aditional string to URL to disable caching of data
	Private Function encodeDataURL(strDataURL, addNoCacheStr)
		'Add the no-cache string if required
		if addNoCacheStr=true then
			'We add ?FCCurrTime=xxyyzz
			'If the dataURL already contains a ?, we add &FCCurrTime=xxyyzz
			'We replace : with _, as FusionCharts cannot handle : in URLs
			if Instr(strDataURL,"?")<>0 then
				strDataURL = strDataURL & "&FCCurrTime=" & Replace(Now(),":","_")
			else
				strDataURL = strDataURL & "?FCCurrTime=" & Replace(Now(),":","_")
			end if
		end if	
		'URL Encode it
		encodeDataURL = Server.URLEncode(strDataURL)
	End Function

	'renderChartJS renders the JavaScript + HTML code required to embed a chart.
	'This function assumes that you've already included the FusionCharts JavaScript class
	'in your page.
	
	' chartSWF - SWF File Name (and Path) of the chart which you intend to plot
	' strURL - If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)
	' strXML - If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)
	' chartId - Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.
	' chartWidth - Intended width for the chart (in pixels)
	' chartHeight - Intended height for the chart (in pixels)
	' debugMode - Whether to start the chart in debug mode
	' registerWithJS - Whether to ask chart to register itself with JavaScript
	' setTransparent - Whether to ask chart to Transparent SWF
	Private Function renderChartJS(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode, registerWithJS, setTransparent)
		
		' Transparent Enable
		dim nSetTransparent
		nSetTransparent="false"
		if setTransparent=true Then
		   nSetTransparent="true"
		end if
		'''''''''''''''''
		
		'First we create a new DIV for each chart. We specify the name of DIV as "chartId"Div.			
		'DIV names are case-sensitive.
	%>
		<!-- START Script Block for Chart <%=chartId%> -->
		<div id='<%=chartId%>Div' >
			Chart.
			<%
			'The above text "Chart" is shown to users before the chart has started loading
			'(if there is a lag in relaying SWF from server). This text is also shown to users
			'who do not have Flash Player installed. You can configure it as per your needs.
			%>
		</div>
			<%
			'Now, we render the chart using FusionCharts Class. Each chart's instance (JavaScript) Id 
			'is named as chart_"chartId".		
			%>
		<script type="text/javascript">	
			//Instantiate the Chart	
			var chart_<%=chartId%> = new FusionCharts("<%=chartSWF%>", "<%=chartId%>", "<%=chartWidth%>", "<%=chartHeight%>", "<%=boolToNum(debugMode)%>", "<%=boolToNum(registerWithJS)%>","<%=JSC("bgcolor")%>","<%=JSC("scalemode")%>","<%=JSC("lang")%>");
			
			<% 
			'Check whether we've to provide data using dataXML method or dataURL method
			if strXML="" then %>
			//Set the dataURL of the chart
			chart_<%=chartId%>.setDataURL("<%=strURL%>");
			<% else %>
			//Provide entire XML data using dataXML method 
			chart_<%=chartId%>.setDataXML("<%=strXML%>");
			<% end if %>	
			// Provide Transparent SWF
			chart_<%=chartId%>.setTransparent(<%=nSetTransparent%>);
			//Finally, render the chart.
			chart_<%=chartId%>.render("<%=chartId%>Div");
		</script>	
		<!-- END Script Block for Chart <%=chartId%> -->
		<%
	End Function

	'renderChartHTML function renders the HTML code for the JavaScript. This
	'method does NOT embed the chart using JavaScript class. Instead, it uses
	'direct HTML embedding. So, if you see the charts on IE 6 (or above), you'll
	'see the "Click to activate..." message on the chart.
	' chartSWF - SWF File Name (and Path) of the chart which you intend to plot
	' strURL - If you intend to use dataURL method for this chart, pass the URL as this parameter. Else, set it to "" (in case of dataXML method)
	' strXML - If you intend to use dataXML method for this chart, pass the XML data as this parameter. Else, set it to "" (in case of dataURL method)
	' chartId - Id for the chart, using which it will be recognized in the HTML page. Each chart on the page needs to have a unique Id.
	' chartWidth - Intended width for the chart (in pixels)
	' chartHeight - Intended height for the chart (in pixels)
	' debugMode - Whether to start the chart in debug mode
	Private Function renderChartHTML(chartSWF, strURL, strXML, chartId, chartWidth, chartHeight, debugMode,registerWithJS, setTransparent)
		'Generate the FlashVars string based on whether dataURL has been provided
		'or dataXML.
		Dim strFlashVars
		if strXML="" then
			'DataURL Mode
			strFlashVars = "&chartWidth=" & chartWidth & "&chartHeight=" & chartHeight & "&debugMode=" & boolToNum(debugMode) & "&dataURL=" & strURL
		else
			'DataXML Mode
			strFlashVars = "&chartWidth=" & chartWidth & "&chartHeight=" & chartHeight & "&debugMode=" & boolToNum(debugMode) & "&dataXML=" & strXML 		
		end if
		
		strFlashVars = strFlashVars & "&scaleMode=" & JSC("scalemode") & "&lang=" & JSC("lang")
		
		dim nregisterWithJS
		' Register with JS
		nregisterWithJS = boolToNum(registerWithJS)
		
		' For Transparent SWF
		dim nsetTransparent
		nsetTransparent=""
		if setTransparent<>"window" then
		  if(setTransparent=false) then
			nsetTransparent="opaque"
		  else
			nsetTransparent="transparent"
		  end if
		else
		  nsetTransparent="window"
		end if
				
		%>
		<!-- START Code Block for Chart <%=chartId%> -->
        <%  
		dim HTTP
		HTTP="http"
        if lcase(Request.ServerVariables("HTTPS"))="on" then
           HTTP="https"
        end if 
		 
		' Check Client Browser type
		dim Strval
        Strval = Request.ServerVariables("HTTP_USER_AGENT")
        If(Instr(1, Strval, "MSIE", 1) <> 0) Then
		 ' For IE Browser 
		%>
		<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="<%=HTTP%>://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="<%=chartWidth%>" height="<%=chartHeight%>" id="<%=chartId%>">
			<param name="allowScriptAccess" value="always" />
			<param name="movie" value="<%=chartSWF%>"/>		
			<param name="FlashVars" value="<%=strFlashVars%>" />
			<param name="quality" value="high" />
			<param name="wmode" value="<%=nsetTransparent%>" />
            <%
		       'Set background color
	           If JSC("bgcolor")<>"" Then 
		          Response.Write "<param name='bgcolor' value=" & JSC("bgcolor") &  " />"
		       End If 	
			%>
         </object>
        <%
		else
		  ' For Mozilla, Opera
		%>   
			<embed src="<%=chartSWF%>" FlashVars="<%=strFlashVars%>&registerWithJS=<%=nregisterWithJS%>" quality="high" width="<%=chartWidth%>" height="<%=chartHeight%>" name="<%=chartId%>" <%  If JSC("bgcolor")<>"" Then Response.Write " bgcolor=""" & JSC("bgcolor") &  """" 			%> allowScriptAccess="always" type="application/x-shockwave-flash" pluginspage="<%=HTTP%>://www.macromedia.com/go/getflashplayer"   wmode="<%=nsetTransparent%>" />
		<% End If %>
		<!-- END Code Block for Chart <%=chartId%> -->
		<%
	End Function

	'boolToNum function converts boolean values to numeric (1/0)
	Private Function boolToNum(bVal)
		Dim intNum
		
		if bVal=true then
			intNum = 1
		else
			intNum = 0
		end if
		boolToNum = intNum
	End Function
End Class

' Array Class
' For Creating ASP Associative Array
Class AssocArray
  Private dicContainer
  
  ' Initialize
  Private Sub Class_Initialize()
   'Create Dictionary type of collection
   Set dicContainer=Server.CreateObject("Scripting.Dictionary")
  End Sub
   
  ' Terminate Dictionary
  Private Sub Class_Terminate()
   Set dicContainer=Nothing   
  End Sub

  ' Get Property
  Public Default Property Get Item(sName)
   If Not dicContainer.Exists(sName) Then
    dicContainer.Add sName,New AssocArray
   End If
   
   If IsObject(dicContainer.Item(sName)) Then
    Set Item=dicContainer.Item(sName)
   Else
    Item=dicContainer.Item(sName)
   End If   
  End Property
  
  ' Let Property
  Public  Property Let Item(sName,vValue)
   If dicContainer.Exists(sName) Then
    If IsObject(vValue) Then
     Set dicContainer.Item(sName)=vValue
    Else
     dicContainer.Item(sName)=vValue
    End If
   Else
    dicContainer.Add sName,vValue    
   End If
  End Property
  
  ' Get Collections
  Public Function getCollections()
    set getCollections=dicContainer
  end function
End Class

%>
