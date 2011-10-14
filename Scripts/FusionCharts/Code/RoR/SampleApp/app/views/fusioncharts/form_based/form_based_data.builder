# Builds xml for sales of various product categories 
# of a Restaurant to be shown in form of a pie-chart.
# The values required here are got as parameters
# Expected parameters: str_soups,str_salads,str_sandwiches,str_beverages,str_desserts
xml = Builder::XmlMarkup.new
xml.chart(:caption=>'Sales by Product Category', :subCaption=>'For this week', :showPercentValues=>'1', :pieSliceDepth=>'30', :showBorder=>'1') do
  xml.set(:label=>'Soups',:value=>str_soups) 
  xml.set(:label=>'Salads',:value=>str_salads) 
  xml.set(:label=>'Sandwiches',:value=>str_sandwiches)
  xml.set(:label=>'Beverages',:value=>str_beverages)
  xml.set(:label=>'Desserts',:value=>str_desserts)
end