#Creates xml with values for date of production and quantity for a particular factory
#The values required for building the xml is obtained from the array @factory_data
# present in the controller action factory_details
#It expects an array in which each element as 
#a hash with values for "date_of_production" and "quantity_number"
xml = Builder::XmlMarkup.new
xml.chart(:palette=>'2', :caption=>'Factory' + @factory_id.to_s + ' Output ', :subcaption=>'(In Units)', :xAxisName=>'Date', :showValues=>'1', :labelStep=>'2') do
	for item in @factory_data
		xml.set(:label=>item[:date_of_production],:value=>item[:quantity_number])
	end
end

