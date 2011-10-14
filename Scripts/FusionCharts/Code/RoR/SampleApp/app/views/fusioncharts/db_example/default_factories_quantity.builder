#Creates xml with values for Factory Output
#along with their names and a link to detailed action for each factory.
#The values required for building the xml is obtained as parameter factory_data
#It expects an array in which each element as 
#a hash with values for "factory_name", "factory_output" and "str_data_url"
xml = Builder::XmlMarkup.new
xml.chart(:caption=>'Factory Output report', :subCaption=>'By Quantity', :pieSliceDepth=>'30', :showBorder=>'1', :formatNumberScale=>'0', :numberSuffix=>' Units', :animation=>animate_chart ) do
	for item in factory_data
		xml.set(:label=>item[:factory_name],:value=>item[:factory_output],:link=>item[:str_data_url])
	end
end
