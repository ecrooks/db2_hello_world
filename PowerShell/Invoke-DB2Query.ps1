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

        .PARAMETER OutputAs
            Specify the results of the query (or queries) should be returned.  The options are DataTables, DataSet, or Text.

        .EXAMPLE
        Invoke-DB2Query -Server '' -dbName ''  -Query "SELECT *
          FROM syscat.tables
         ORDER BY TABNAME ASC
         FETCH FIRST 10 ROWS;"

        Description
        -----------
        Establishes a connection to the server & database specified, then runs the query specified.  The results are retuend as a DataTable (un-formatted).

        .EXAMPLE
        Invoke-DB2Query -Server '' -dbName '' -OutputAs DataTables -Query "SELECT *
          FROM syscat.tables
         ORDER BY TABNAME ASC
         FETCH FIRST 10 ROWS;"

        Description
        -----------
        Establishes a connection to the server & database specified, then runs two queries.  The results are retuend as a collection of DataTables (un-formatted).

        .EXAMPLE
        $Results = Invoke-DB2Query -Server '' -dbName '' -OutputAs DataTables -Query "SELECT *
          FROM syscat.tables
         ORDER BY TABNAME ASC
         FETCH FIRST 10 ROWS;
         
         SELECT *
          FROM syscat.tables
         ORDER BY TABNAME DESC
         FETCH FIRST 10 ROWS;"

        Description
        -----------
        Establishes a connection to the server & database specified, then runs two queries.  The results are retuend as a collection of DataTables (un-formatted).
        The resulting DataTables can be accessed separatly $Results[0], $Results[1].

        .EXAMPLE
        Invoke-DB2Query -Server '' -dbName '' -OutputAs Text -Query "SELECT *
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

        .EXAMPLE
        Invoke-DB2Query -Server '' -dbName '' -OutputAs DataSet -Query "SELECT *
          FROM syscat.tables
         ORDER BY TABNAME ASC
         FETCH FIRST 10 ROWS;
         
         SELECT *
          FROM syscat.tables
         ORDER BY TABNAME DESC
         FETCH FIRST 10 ROWS;"

        Description
        -----------
        Establishes a connection to the server & database specified, then runs two queries.  The results are retuend as a single DataSet object.
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
    [string] $Query,
    
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [ValidateSet("DataTables","DataSet","Text")]
    $OutputAs
    )

#Define connection string for the database
$cn = new-object system.data.OleDb.OleDbConnection("server=$($server);Provider=IBMDADB2;DSN=$($dbName);trusted_connection=true;");
#Define data set for first query
$ds = new-object "System.Data.DataSet" "ds"
#Define query to run
#$Query
# Define data object given the specific query and connection string
$da = new-object "System.Data.OleDb.OleDbDataAdapter" ($Query, $cn)
# Fill the data set - essentially run the query. 
$da.Fill($ds) | Out-Null
# Print the result
Switch($OutputAs)
{
    'DataSet'{
        Write-Output @(,$ds)
    }
    'DataTables'{
        Write-Output @(,$ds.Tables)
    }
    'Text'{foreach ($Table in $ds.Tables)
        {
        $Table.Rows | Format-Table
        }
    }
}


# Close the Connection
$cn.close()
}
