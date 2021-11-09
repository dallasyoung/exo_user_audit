# Overview
The *Get-365UserAccess.ps1* script simply iterates over all Distribution Groups and Mailboxes in an O365 tenant and prints out all the items that the target user will have access to. With larger tenants this can take a few minutes to fully complete

## Prerequisites
  - The [Exchange Online PowerShell module](https://docs.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps) installed on the computer running the script

  - 365 login credentials of a Global Admin account

## Usage
```
. 'c:\example\exo_user_audit\Get-365UserAccess.ps1' -TargetEmailAddress <user email address> [-AdminEmailAddress <admin email address>]
```

Where:
  - <**user email address**> is the *UserPrincipalName* (primary O365 email address) of the user you are auditing
  - <**admin email address**> is an optional email address of the admin account you'd like to connect to the tenant as

## Example output
```
PS C:\example\exo_user_audit> . 'c:\example\exo_user_audit\Get-365UserAccess.ps1' -TargetEmailAddress Test.User@example.com -AdminEmailAddress admin@example.com
Distribution Groups for 'test.user@example.com':
================================
Fake DL 1        (Example-Fake-DL-1)
Fake DL 2       (Example-Fake-DL-2)
...

Delegated mailboxes to 'test.user@example.com.com':
================================
Other User
Vacation Calendar
Shared Info Mailbox
...

PS C:\example\exo_user_audit>
```
