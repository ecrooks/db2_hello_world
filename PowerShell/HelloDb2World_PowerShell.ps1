# Source File with connection variables set
$Path = $PSScriptRoot
. "$Path\HelloDb2World_PowerShell_variables.ps1"

#Define connection string for the database
$cn = new-object system.data.OleDb.OleDbConnection("Provider=IBMDADB2;DSN=$dbName;User Id=;Password=;");
#Define data set for first query
$ds = new-object "System.Data.DataSet" "ds"
#Define query to run
$q = "select * from hello_world"
# Define data object given the specific query and connection string
$da = new-object "System.Data.OleDb.OleDbDataAdapter" ($q, $cn)
# Fill the data set - essentially run the query. 
$da.Fill($ds) | Out-Null
# Print the result
foreach ($Row in $ds.Tables[0].Rows)
        {
        write-host  "$($Row.C1)"  
        }
