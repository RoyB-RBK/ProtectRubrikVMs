<#
.SYNOPSIS
Read a CSV with defined SLA Policies and Create those SLAs in Rubrik Cluster

.DESCRIPTION
Script will read from the provided CSV of SLA Polcies and then Create them on the Rubrik Cluster

.PARAMETER RubrikCluster
Requires the Name or IP Address of the Rubrik Cluster

.PARAMETER RubrikCreds
Requires an input for Credentials of the Rubrik Cluster you want to Log in to for joining RBS Hosts to Rubrik

.PARAMETER CSV
Optional - Location of the CSV file (which lists VM Names and SLA Policies) for import through the script

.EXAMPLE
.\CreateSLA.ps1 -RubrikCluster 172.21.8.51 -CSVLoc C:\temp\

.NOTES
    Name:               CreateSLA
    Created:            4/28/2020
    Author:             Roy Berkowitz
#>

Start-Transcript - Path 'C:\output.txt'

param(
    # Rubrik Cluster name or ip address
    [Parameter(Mandatory=$true)]
    [string]$RubrikCluster,

    # Credential to log into Rubrik Cluster
    [Parameter(Mandatory=$true)]
    [pscredential]$RubrikCreds,

    # Location of CSV file for import
    [Parameter(Mandatory=$false)]
    [string]$CSVLoc = "C:\"
      )  
           
Import-Module Rubrik
      
##########################
# Set External Variables #
##########################

$csv = Import-Csv $CSVLoc"\sla.csv"

Connect-Rubrik -Server $RubrikCluster -Credential $RubrikCreds | Out-Null

foreach ($line in $csv)
{

##########################
# Set Internal Variables #
##########################

    $SLAName = $line.Name
    $HF = $line.HourlyFrequency
    $HR  = $line.HourlyRetention
    $DF = $line.DailyFrequency
    $DR  = $line.DailyRetention
    $MF = $line.MonthlyFrequency
    $MR  = $line.MonthlyRetention
    $YF = $line.YearlyFrequency
    $YR  = $line.YearlyRetention

 New-RubrikSLA -SLA $SLAName -HourlyFrequency $HF -HourlyRetention $HR -DailyFrequency $DF -DailyRetention $DR -MonthlyFrequency $MF -MonthlyRetention $MR -YearlyFrequency $YF -YearlyRetention $YR
 

}
Stop-Transcript

