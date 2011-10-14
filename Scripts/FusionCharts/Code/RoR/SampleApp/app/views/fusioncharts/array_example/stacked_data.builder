#Creates xml with values for sales data of product A and product B 
#in each quarter.
#The values required for building the xml is obtained as parameter arr_data
#It expects an array in which each element is 
#itself an array with first element as label, second element as sales of product A
#and third element as sales of product B
xml = Builder::XmlMarkup.new
xml.chart(:caption=>'Sales', :numberPrefix=>'$', :formatNumberScale=>'0') do
  # Run a loop to create the <category> tags within <categories>
  xml.categories do
		for item in arr_data
			xml.category(:name=>item[0])
		end
 end
 # Run a loop to create the <set> tags within dataset for series 'Product A'
  xml.dataset(:seriesName=>'Product A') do
		for item in arr_data
			xml.set(:value=>item[1])
		end
  end
  # Run a loop to create the <set> tags within dataset for series 'Product B'
  xml.dataset(:seriesName=>'Product B') do
		for item in arr_data
			xml.set(:value=>item[2])
		end
  end
end