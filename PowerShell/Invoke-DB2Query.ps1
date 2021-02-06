function Invoke-DB2Query
{
    <#
        .SYNOPSIS
            This function runs a query against a DB2 database.

        .DESCRIPTION
            This function runs a query against a DB2 database using the account of the user executing the command.

        .PARAMETER Server
            Specify name of the database server to connect to.

        .PARAMETER dbName
            Specify name of the database to connect to.

        .PARAMETER port
            Specify port # of the database server to connect to.

        .PARAMETER Query
            Specify the Query to run against the database.

        .EXAMPLE
        Invoke-DB2Query -Server '' -dbName ''  -Query "SELECT *
          FROM syscat.tables
         ORDER BY TABNAME ASC
         FETCH FIRST 10 ROWS;"

        Description
        -----------
        Establishes a connection to the server & database specified, then runs the query specified.  The results are retuend formatted.

        .EXAMPLE
        Invoke-DB2Query -Server '' -dbName '' -Query "SELECT *
          FROM syscat.tables
         ORDER BY TABNAME ASC
         FETCH FIRST 10 ROWS;
         
         SELECT *
          FROM syscat.tables
         ORDER BY TABNAME DESC
         FETCH FIRST 10 ROWS;"

        Description
        -----------
        Establishes a connection to the server & database specified, then runs two queries.  The results are retuend formatted separately.
    #>

    [CmdletBinding()]
    param(
    [parameter(Mandatory=$true)]
    [string] $Server,

    [parameter(Mandatory=$true)]
    [string] $dbName,

    [parameter(Mandatory=$false)]
    $port,

    [parameter(Mandatory=$true)]
    [string] $Query
    )

#Define connection string for the database
$cn = new-object system.data.OleDb.OleDbConnection("server=$($server);Provider=IBMDADB2;DSN=$($dbName);trusted_connection=true;");
#Define data set for first query
$ds = new-object "System.Data.DataSet" "ds"
#Define query to run
$Query
# Define data object given the specific query and connection string
$da = new-object "System.Data.OleDb.OleDbDataAdapter" ($Query, $cn)
# Fill the data set - essentially run the query. 
$da.Fill($ds) | Out-Null
# Print the result
foreach ($Table in $ds.Tables)
        {
        $Table.Rows | Format-Table -AutoSize
        }

# Close the Connection
$cn.close()
}
