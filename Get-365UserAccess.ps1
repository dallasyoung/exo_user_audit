# Matches provided email address against AAD PrimarySMTPAddress. Maybe should iterate through all email addresses instead?
# Does not include M365 groups for user-created, Teams, SPO, etc

param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    $TargetEmailAddress,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $AdminEmailAddress
)

Function ConnectTo-Exo {
    If(-Not $script:connected) { 
        If($AdminEmailAddress) {
            Connect-ExchangeOnline -UserPrincipalName $AdminEmailAddress
        } Else {
            Connect-ExchangeOnline
        }
        $script:connected = $true
    }
}

Function Get-365Data {
    $script:all_mailboxes = (Get-Mailbox)
    $script:all_distro_lists  = Get-DistributionGroup | sort DisplayName
}

Function Check-DistributionGroups {
    Write-Host "Distribution Groups for '$TargetEmailAddress':"
    Write-Host "================================"
    $all_distro_lists |  % {
        Write-Verbose "Getting distro group members for $($_.DisplayName) ($($_.Name))..."
        $all_members = Get-DistributionGroupMember -Identity $_.Name
        Foreach($member in $all_members) {
            If($member.PrimarySmtpAddress.toLower() -eq $TargetEmailAddress) {
                Write-Host "$($_.DisplayName)`t($($_.Name))"
                break
            }
        }
    }
    Write-Host ""
}

Function Check-DelegatedMailboxes {
    Write-Host "Delegated mailboxes to '$TargetEmailAddress':"
    Write-Host "================================"
    $all_mailboxes | % {
        Write-Verbose "Mailbox '$_':"
        Write-Verbose "Checking mailbox permission for $($_.PrimarySmtpAddress)..."

        $permissions = ($_ | Get-MailboxPermission)
        ForEach($permission in $permissions) {
            Write-Verbose "Checking '$permission'"
            If($permission.User -eq $TargetEmailAddress) {
                Write-Host $_
            }        
        }
    }
    Write-Host ""
}

Function List-AllMailboxPermissions {
    $all_mailboxes | % {
        Write-Host "Mailbox '$_':"
        Write-Host "==========================="

        $_ | Get-MailboxPermission

        Write-Host ""
    }
}

ConnectTo-Exo
Get-365Data
Check-DistributionGroups
Check-DelegatedMailboxes