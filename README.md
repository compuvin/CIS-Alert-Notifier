# CIS-Alert-Notifier
Provides email notification functionality for the CIS-CAT Pro Dashboard

***Updated for CCPD v3.x. You will need MySQL Connector NET to interface with the new CCPD v3 as it uses a MariaDB now.***
<br><br>
This Powershell script interfaces with the backend database for your CIS-CAT Pro Dashboard installation. It profides much needed notification functionality for alerts within the dashboard.
<br><br>
To set up, simply copy the Powershell script to a new folder on your database server. Edit the lines indicated near the top of the script. Save it and then use Task Scheduler to schedule it to run at intervals (e.g. every 15 minutes).
<br><br>
For simplicity, this script was designed for use with an in-house email server that allows local SMPT connections. However, it can easily be edited to support modern secure email servers.
<br><br>
<a href="https://www.codefactor.io/repository/github/compuvin/cis-alert-notifier"><img src="https://www.codefactor.io/repository/github/compuvin/cis-alert-notifier/badge" alt="CodeFactor" /></a>
