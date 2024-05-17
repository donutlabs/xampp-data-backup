# Script Name: XAMPP Data Backup
# Author: Christopher Spradlin
# Version: 1.0
# Description: PowerShell Script to Backup XAMPP Data
# Date: 11/5/2022
#------------------------------------------------------------


# Define the XAMPP directories
$xamppDir = "C:\xampp"
$mysqlDataDir = "$xamppDir\mysql\data"
$htdocsDir = "$xamppDir\htdocs"

# Define the backup directory
$backupDir = "C:\xampp_backup"
$backupDate = Get-Date -Format "yyyyMMddHHmm"
$backupMySQLDir = "$backupDir\mysql_$backupDate"
$backupHtdocsDir = "$backupDir\htdocs_$backupDate"

# Create backup directories
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir
}
New-Item -ItemType Directory -Path $backupMySQLDir
New-Item -ItemType Directory -Path $backupHtdocsDir

# Stop XAMPP services to ensure data integrity during backup
Write-Host "Stopping XAMPP services..."
Stop-Process -Name "httpd" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "mysqld" -Force -ErrorAction SilentlyContinue

# Backup MySQL data
Write-Host "Backing up MySQL data..."
Copy-Item -Recurse $mysqlDataDir $backupMySQLDir

# Backup htdocs directory
Write-Host "Backing up htdocs directory..."
Copy-Item -Recurse $htdocsDir $backupHtdocsDir

# Start XAMPP services after backup
Write-Host "Starting XAMPP services..."
Start-Process "$xamppDir\apache\bin\httpd.exe"
Start-Process "$xamppDir\mysql\bin\mysqld.exe"

Write-Host "Backup completed successfully. Backup is located at $backupDir"
