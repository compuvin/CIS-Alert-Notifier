##################################
#Edit these values as you see fit
$DBLocation = "localhost"
$DBSchema = "CCPD"
$DBUser = "user"
$DBPass = "password"

$MailFromEmail = "email@domain.com"
$MailServer = "mail.domain.com"
##################################

#Get last read record from .dat file
$LastReadRec = 0
if (Test-Path -Path LastReadRec.dat -PathType Leaf)
{
    $LastReadRec = Get-Content LastReadRec.dat
} else {
    $LastReadRec | Set-Content LastReadRec.dat
}

#Open SQL Connection
$myconnection = New-Object System.Data.SqlClient.SqlConnection
$myconnection.ConnectionString = "Database=" + $DBSchema + ";server=" + $DBLocation + ";Persist Security Info=false;user id=" + $DBUser + ";pwd=" + $DBPass + ";"
$myconnection.Open()
$command = $myconnection.CreateCommand()

#Get user list
#$command.CommandText = "select id, first_name, email from dbo.ccpd_user";
#$Usertable = New-Object System.Data.DataTable
#$UserTable.Load($command.ExecuteReader())

#Get unread alerts
$command.CommandText = "select AlertTb.id, AlertTb.title, AlertTb.message, UserTb.first_name, UserTb.email from dbo.alert_instance as AlertTb inner join dbo.ccpd_user as UserTb on AlertTb.recipient_id = UserTb.id where AlertTb.is_read=0 and AlertTb.id>" + $LastReadRec + " order by AlertTb.id;"
$AlertTable = New-Object System.Data.DataTable
$AlertTable.Load($command.ExecuteReader())

#$AlertTable | Format-Table

#Loop through new alerts and send emails
foreach ($Row in $AlertTable)
{
    $command.CommandText = "select element_name, element_value from dbo.alert_instance_data where alert_instance_id=" + $Row.id + ";";
    $reader = $command.ExecuteReader()
    $count = 0

    $outputl = "<p>" + $Row.first_name + ",</p><p>You have a new alert in the CIS-CAT Pro Dashboard.</p>"
    $outputl = $outputl + "<p>"

    #Old way for version <2.2.5
    while ($reader.Read()) {
        if (($Reader["element_value"].ToString()).Length -gt 0) {
            $outputl = $outputl + $Reader["element_name"].ToString() + " : " + $Reader["element_value"].ToString() + "<br>"
            $count++
        }
    }
    $reader.close()
    
    #New way for version =>2.2.5
    if ($count -eq 0) {
        $outputl = $outputl + $Row.message + "<br>"
    }

    $outputl = $outputl + "</p>"

    #send the email
    if ($Row.email -notcontains "@ciscatpro.org"){
        Send-MailMessage -From $MailFromEmail -To $Row.email -SmtpServer $MailServer -Subject ("CCPD Alert: " + $Row.title) -Body $outputl -BodyAsHtml
    }
}

if ($AlertTable.Rows.Count -gt 0) {$AlertTable.Rows[$AlertTable.Rows.Count-1].id | Set-Content LastReadRec.dat}

#Close SQL Connection
$myconnection.Close()