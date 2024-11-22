# SharePoint 2019 Site Unlock Script

This PowerShell script cycles through all site collections within a specified SharePoint 2019 on-premises web application and removes any read only restrictions that are set. 

## Prerequisites

+ Environment: Run this script in the SharePoint Management Shell.
+ Permissions: Ensure you have administrative rights to manage site collections.
+ Variables to Configure:
  + $webAppUrl: Update this with the URL of the target SharePoint web application.
  + $outputFile: Specify the path for the CSV output file.

## Explanation of use

+ Lock Removal: Sets both $site.ReadOnly and $site.WriteLocked properties to $false, removing the access restriction.
+ Status Check: Checks if the site is already unlocked, identified by -not ($site.ReadOnly -or $site.WriteLocked).
+ Report: Exports a CSV report with each site's URL, whether it was "Already Unlocked" or "Unlocked," and the timestamp of the unlock action.

## CSV Report
The CSV file contains:

+ URL: The URL of each site collection.
+ LockStatus: Indicates if the site was "Already Unlocked" or newly "Unlocked."
+ TimeUnlocked: Timestamp for when the lock was removed.
