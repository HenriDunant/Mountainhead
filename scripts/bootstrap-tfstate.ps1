
<#
.SYNOPSIS
  Bootstrap Azure Storage for Terraform remote state and write backend.hcl.
.USAGE
  pwsh -File .\scripts\bootstrap-tfstate.ps1 -SubscriptionId "<SUB_ID>" -Location "southeastasia"  
  #>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$SubscriptionId,
  [Parameter(Mandatory = $true)][string]$Location,                #  Regions e.g., southeastasia
  [Parameter()][string]$ResourceGroupName = "rg-tfstate-shared",
  [Parameter()][string]$StorageAccountName,                     # optional; if omitted a unique one is generated
  [Parameter()][string]$ContainerName = "tfstate",
  [Parameter()][string]$Key = "platform.terraform.tfstate"
)

function Test-AzCli {
  if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw "Azure CLI 'az' not found. Install from https://aka.ms/azure-cli."
  }
}

function Initialize-Login {
  try {
    $null = az account show --only-show-errors 2>$null
  }
  catch {
    Write-Host "=> Running 'az login'..." -ForegroundColor Yellow
    az login --only-show-errors | Out-Null
  }
}

function Set-SubscriptionContext {
  Write-Host "=> Using subscription: $SubscriptionId" -ForegroundColor Cyan
  az account set --subscription $SubscriptionId | Out-Null
  $subOk = az account show --query "id" -o tsv 2>$null
  if (-not $subOk) { throw "Failed to set subscription $SubscriptionId" }
}

function Initialize-ResourceGroup {
  param([string]$Name, [string]$Loc)
  Write-Host "=> Ensuring resource group '$Name' in '$Loc'..." -ForegroundColor Cyan
  $exists = az group show -n $Name --query "name" -o tsv 2>$null
  if (-not $exists) {
    az group create -n $Name -l $Loc -o none | Out-Null
  }
}

function Initialize-StorageAccount {
  param([string]$Rg, [string]$Loc, [string]$Name)
  if (-not $Name) {
    # Generate globally-unique: st + random + timestamp (<=24 chars, lowercase)
    $rand = Get-Random -Maximum 999999
    $ts = (Get-Date -Format "MMddHHmm")
    $Name = ("st" + $rand + $ts).ToLower()
  }
  Write-Host "=> Ensuring storage account '$Name'..." -ForegroundColor Cyan

  $available = az storage account check-name -n $Name --query "nameAvailable" -o tsv
  if ($available -eq "true") {
    az storage account create -n $Name -g $Rg -l $Loc --sku Standard_LRS -o none | Out-Null
  }
  else {
    $existing = az storage account list -g $Rg --query "[0].name" -o tsv
    if ($existing) {
      Write-Host "   Name unavailable; reusing existing storage account '$existing' in RG '$Rg'." -ForegroundColor Yellow
      $Name = $existing
    }
    else {
      throw "Storage account name '$Name' is not available and no SA exists in RG '$Rg'. Provide -StorageAccountName."
    }
  }
  return $Name
}

function Initialize-StorageContainer {
  param([string]$Rg, [string]$Sa, [string]$Container)
  Write-Host "=> Ensuring blob container '$Container'..." -ForegroundColor Cyan
  $conn = az storage account show-connection-string -g $Rg -n $Sa --query connectionString -o tsv
  az storage container create -n $Container --connection-string $conn -o none | Out-Null
}

try {
  Test-AzCli
  Initialize-Login
  Set-SubscriptionContext
  Initialize-ResourceGroup -Name $ResourceGroupName -Loc $Location
  $StorageAccountName = Initialize-StorageAccount -Rg $ResourceGroupName -Loc $Location -Name $StorageAccountName
  Initialize-StorageContainer -Rg $ResourceGroupName -Sa $StorageAccountName -Container $ContainerName

  $backendDir = Join-Path $PSScriptRoot "..\infra\platform"
  $backendPath = Join-Path $backendDir "backend.hcl"
  if (-not (Test-Path $backendDir)) {
    throw "Expected directory not found: $backendDir"
  }

  @"
resource_group_name  = "$ResourceGroupName"
storage_account_name = "$StorageAccountName"
container_name       = "$ContainerName"
key                  = "$Key"
"@ | Out-File -FilePath $backendPath -Encoding utf8 -Force

  Write-Host "=> Wrote backend config: $backendPath" -ForegroundColor Green
  Write-Host "=> Next in VS Code Dev Container:" -ForegroundColor Yellow
  Write-Host "   cd infra/platform" -ForegroundColor Yellow
  Write-Host "   terraform init -backend-config=backend.hcl" -ForegroundColor Yellow
  Write-Host "   terraform plan -var=""location=$Location""" -ForegroundColor Yellow

}
catch {
  Write-Error $_
  exit 1
}
