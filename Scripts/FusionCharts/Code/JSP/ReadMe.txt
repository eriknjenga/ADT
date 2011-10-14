This version works with MySQL database whose database-creation scripts are provided along with the web application in the DB folder.
We have used JSP 2.0 and jdk1.6.0_10 for the development of this demo.

Prerequisites:
1. Java version - jdk1.4.2_02 or above

2. Apache Tomcat version - jakarta-tomcat-5.0.25 or above 

3. MySQL 5.0

Installation Instructions:
1. Java version - jdk6 which can be downloaded from the following link:
http://java.sun.com/javase/downloads/index.jsp

2. After downloading and installing java,JAVA_HOME environment variable has to be set to the base path of the JDK.
To set this variable on Windows do the following:
Go to MyComputer, right click to view properties -> advanced tab ->environment variables 
Set a new Variable name: JAVA_HOME with Value as the installation directory. For eg: 
C:\jdk1.6.0_10

3. Apache Tomcat version - tomcat6.0 which can be downloaded from the following link:
http://tomcat.apache.org/download-60.cgi

Click on the core zip file. Download it.Extract it to some folder. Configure tomcat as per the tomcat docs.

4. Copy the FusionCharts_JSP.war present in Deployable folder to "CATALINA_HOME"/webapps folder when the tomcat server is running.

5. In order to configure the MySQL database:
   Open the file "CATALINA_HOME"/webapps/FusionCharts_JSP/META-INF/context.xml.	
   In this xml,please change the username,password,url according to your database.
context.xml also contains the web application context, please modify it if you have changed the context.
Run the scripts FactoryDBCreation.sql and UTFExampleTablesCreation.sql to create the required tables and sample data.

6.If you are using MySQL as the database, please start your MySQL instance.

7.Start the tomcat server.

8.Access the application by opening the browser window with the following address:
http://localhost:8080/FusionCharts_JSP/Code/JSP/default.htm


Note: "CATALINA_HOME" refers to the installation directory of Tomcat


---

For source code of the java files please see the folder SourceCode.


---

If you do not want to use the war file (as described above), you can use deploy all the folders and files in your tomcat. 
For this,
1. Create a folder in "CATALINA_HOME"/webapps say FusionChartsv3_JSP.
2. Copy the Download Package > Code folder into "CATALINA_HOME"/webapps/FusionChartsv3_JSP folder. 
3. Move the WEB-INF folder present in Code/JSP folder to "CATALINA_HOME"/webapps/FusionChartsv3_JSP folder.
4. Move the META-INF folder present in Code/JSP folder to "CATALINA_HOME"/webapps/FusionChartsv3_JSP folder.
5. Finally, copy the FusionCharts folder from Download Package > Code to "CATALINA_HOME"/webapps/FusionChartsv3_JSP folder.
6. Access the application by opening the browser window with the following address:
http://localhost:8080/FusionChartsv3_JSP/Code/JSP/default.htm