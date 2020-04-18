<#
.SYNOPSIS
Find VMs in Rubrik Cluster and Protect with Appropriate SLA Policy

.DESCRIPTION
Script will read from the provided CSV of VM Names to protect. It will then take that list and assign an appropriate SLA Policy for that VM

.PARAMETER RubrikCluster
Requires the Name or IP Address of the Rubrik Cluster

.PARAMETER RubrikCreds
Requires an input for Credentials of the Rubrik Cluster you want to Log in to for joining RBS Hosts to Rubrik

.PARAMETER CSV
Optional - Location of the CSV file (which lists VM Names and SLA Policies) for import through the script

.EXAMPLE
.\ProtectRubrikVMs.ps1 -RubrikCluster 172.21.8.51 -CSVLoc C:\temp\

.NOTES
    Name:               Install and Register RBS
    Created:            3/17/2020
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

$csv = Import-Csv $CSVLoc"\hosts.csv"
$Out = "C:\RubrikBackupService.zip"

Connect-Rubrik -Server $RubrikCluster -Credential $RubrikCreds | Out-Null

foreach ($line in $csv)
{

##########################
# Set Internal Variables #
##########################

    $vmName = $line.VMName
    $SLA    = $line.SLAName
    $vmID = (Get-RubrikVM $vmName).id 
    $slaID = (Get-RubrikSLA -Name $SLA).id

    Protect-RubrikVM -id $vmID -SLAID $slaID 

 
}
Stop-Transcript



vector in python vs powershell???