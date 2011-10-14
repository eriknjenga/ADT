#Creates xml with values for sales data of products 
#along with their names.
#The values required for building the xml is obtained from the corresponding controller action pie_data
#It accesses the factory_data array from the controller.
#It expects factory_data to be an array in which each element is 
#itself an array with first element as label and second element as value
#Here, it is used for building xml for pie chart with factory name and total output.
xml = Builder::XmlMarkup.new
xml.chart(:caption=>'Factory Output report', :subCaption=>'By Quantity', :pieSliceDepth=>'30', :showBorder=>'1', :formatNumberScale=>'0', :numberSuffix=>' Units', :animation=>@animate_chart) do
	for item in @factory_data
		xml.set(:label=>item[0],:value=>item[1])
	end
end
