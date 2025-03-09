function Test-AzLogin {
    [CmdletBinding()]
    [OutputType([boolean])]
    [Alias()]
    Param()

    Begin {
    }
    Process {
        # Verify we are signed into an Azure account
        try {
            try{
                Remove-Module AzureRM.Profile -Force -ErrorAction SilentlyContinue  # AzureRM causes a conflict with Az modules
                Enable-AzureRmAlias -Scope CurrentUser -ErrorAction SilentlyContinue  # solves type implementation exception

                Write-CustomHost "Checking Azure login status..." -ForegroundColor Cyan

                if (!(Get-Module -ListAvailable -Name Az.Accounts)) {
                    Install-Module -Name Az.Accounts -Repository PSGallery -AllowClobber -Force -Scope CurrentUser  
                }
                Import-Module Az.Accounts
            }
            catch {}
            Write-Verbose 'Testing Azure login'
            $isLoggedIn = [bool](Get-AzContext -ErrorAction Stop)
            if(!$isLoggedIn){                
                Write-Verbose 'Not logged into Azure. Initiate login now.'
                Write-Host 'Enter your credentials in the pop-up window' -ForegroundColor Yellow
                $isLoggedIn = Connect-AzAccount
            }
        }
        catch [System.Management.Automation.PSInvalidOperationException] {
            Write-Verbose 'Not logged into Azure. Initiate login now.'
            Write-Host 'Enter your credentials in the pop-up window' -ForegroundColor Yellow
            $isLoggedIn = Connect-AzAccount
        }
        catch {
            Throw $_.Exception.Message
        }
        [bool]$isLoggedIn
    }
    End {
        
    }
}