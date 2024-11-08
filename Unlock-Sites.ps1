# Load SharePoint PowerShell snap-in if not loaded
if ((Get-PSSnapin -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null) {
    Add-PSSnapin Microsoft.SharePoint.PowerShell
}

# Define the URL of your web application
$webAppUrl = "http://your-webapp-url"
# Define the output CSV file path
$outputFile = "C:\UnlockedSitesReport.csv"

# Initialize an array to store site information
$siteStatusList = @()

# Get the Web Application object
$webApp = Get-SPWebApplication $webAppUrl

# Iterate through each site collection in the web application
foreach ($site in $webApp.Sites) {
    try {
        # Check if the site is already unlocked (not ReadOnly and not WriteLocked)
        $isAlreadyUnlocked = -not ($site.ReadOnly -or $site.WriteLocked)
        $lockStatus = if ($isAlreadyUnlocked) { "Already Unlocked" } else { "Unlocked" }
        
        # If not already unlocked, remove the lock by setting ReadOnly and WriteLocked to false
        if (!$isAlreadyUnlocked) {
            $site.ReadOnly = $false
            $site.WriteLocked = $false
            $site.Update()
        }

        # Collect site information for the CSV report
        $siteStatusList += [PSCustomObject]@{
            URL           = $site.Url
            LockStatus    = $lockStatus
            TimeUnlocked  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        Write-Host "$lockStatus for site collection:" $site.Url -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to process site collection:" $site.Url -ForegroundColor Red
    }
    finally {
        # Dispose of the site object to free up resources
        $site.Dispose()
    }
}

# Export the site status list to a CSV file
$siteStatusList | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "All site collections in the web application have been processed. Report saved to $outputFile" -ForegroundColor Cyan
