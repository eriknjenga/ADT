Pre-requisites : 
--------------
Ruby 1.8.6-26 or above
Rails 2.2.2 or above
MySQL 4.0 or above
gem install mysql
WEBrick or any other HTTP server


Database Creation: 
-----------------
Modify config/database.yml to enter the database name, user and password of your database.
There are two ways to create the tables: 
	I. Using migrations
		Run the following rake commands, from the application root folder: 
		rake db:create
		rake db:schema:load
		Database with all tables will be created.
		Manually create the foreign key on 'factory_master_id' column of 'factory_output_quantities' table 
		to 'id' column of 'factory_masters' table(this step is optional)
	II.Using sql scripts (MySQL specific)
		Create the database using sql command (CREATE DATABASE ...) or run rake db:create
		The sql scripts are present in db folder. Run the following script:
		create_tables.sql
		Database with all tables will be created.

Execute the script insert_sample_data.sql in your database to insert the sample data.
Also execute the sql script create_utfexample_tables_data.sql in your database to convert the database to UTF-8 charSet 
and create the neccessary tables for UTF-8 examples. 


Viewing The Charts: 
------------------
Start The Server:
Run the command, 
ruby script/server 
from the application root folder.

View The Default Page:
Open the browser and type the address 
http://localhost:3000/fusioncharts/index
to view the index page of this application. 

The address to be typed in the address bar, 
may vary based on the server configuration on your computer.