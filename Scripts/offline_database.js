function initDatabase() {  
    try {  
        if (!window.openDatabase) {  
            alert('Databases are not supported in this browser.');  
        } else {  
            var shortName = 'ADT_Local_Database';  
            var version = '1.0';  
            var displayName = 'ADT LocalDatabase';  
            var maxSize = 10000000; //  bytes  
            DEMODB = openDatabase(shortName, version, displayName, maxSize);  
            createTables();  
            //selectAll();  
        }  
    } catch(e) {  
  
        if (e == 2) {  
            // Version number mismatch.  
            console.log("Invalid database version.");  
        } else {  
            console.log("Unknown error "+e+".");  
        }  
        return;  
    }  
}  

function createTables(){  
    DEMODB.transaction(  
        function (transaction) {  
            transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen(id INTEGER NOT NULL PRIMARY KEY, regimen_code TEXT NOT NULL,regimen_desc TEXT NOT NULL, category TEXT, line TEXT, type_of_service TEXT, remarks TEXT, enabled TEXT);', [], nullDataHandler, errorHandler);
            transaction.executeSql('CREATE TABLE IF NOT EXISTS supporter(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
            transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen_service_type(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
            transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_source(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);  
        }  
    );   
} 

function Populate(sql){  
	 
    DEMODB.transaction(  
        function (transaction) {   
        transaction.executeSql(sql, [], nullDataHandler, errorHandler);  
        }  
    );  
}  
 
function errorHandler(transaction, error){
    if (error.code==1){
        // DB Table already exists
    } else {
        // Error is a human-readable string.
        console.log('Oops.  Error was '+error.message+' (Code '+error.code+')');
    }
    return false;
}


function nullDataHandler(){
    console.log("SQL Query Succeeded");
}

function dropTables(){  
    DEMODB.transaction(  
        function (transaction) {  
            transaction.executeSql("DROP TABLE regimen;", [], nullDataHandler, errorHandler);  
            transaction.executeSql("DROP TABLE supporter;", [], nullDataHandler, errorHandler);  
            transaction.executeSql("DROP TABLE regimen_service_type;", [], nullDataHandler, errorHandler);  
            transaction.executeSql("DROP TABLE patient_source;", [], nullDataHandler, errorHandler);  
        }  
    );  
    location.reload();  
}  

function selectAll(table, dataSelectHandler){  
    DEMODB.transaction(  
        function (transaction) {  
        	var sql = "select * from "+table;
            transaction.executeSql(sql, [],  
                dataSelectHandler, errorHandler);  
        }  
    );  
} 
function selectServiceRegimen(service, dataSelectHandler){  
    DEMODB.transaction(  
        function (transaction) {  
        	var sql = "select * from regimen where type_of_service = '"+service+"'";
            transaction.executeSql(sql, [],  
                dataSelectHandler, errorHandler);  
        }  
    );  
}
 
  
 