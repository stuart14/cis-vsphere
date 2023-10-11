# Prompt the user for a custom name for the output file
$outputFileName = Read-Host -Prompt "Enter the name for the output
file (e.g., vspherecluster.txt)"

# Construct the full path for the output file in the working directory
$outputFilePath = Join-Path -Path $PSScriptRoot -ChildPath $outputFileName

# Redirect output to the custom text file
Start-Transcript -Path $outputFilePath

# Import scripts from controls folder
Import-Module -Name $PSScriptRoot\controls\install.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\communication.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\vmachines.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\storage.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\logging.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\access.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\console.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\network.ps1 -Force

# A function to connect to vCenter/ESXi Server using the
Connect-VIServer cmdlet and store the connection in a variable
function Connect-VCServer {
    # Asking the user for the vCenter/ESXi Server Hostname or IP Address
    $server = Read-Host -Prompt "Enter the vCenter/ESXi Server
Hostname or IP Address"

    # Set InvalidCertificateAction to warn instead of stop without
user interaction
    Write-Host "Setting InvalidCertificateAction to Warn instead of Stop..."
    Set-PowerCLIConfiguration -Scope User -InvalidCertificateAction
warn -Confirm:$false

    # Print the connection details
    Write-Host "Connecting to $server"

    # Connect to the vCenter/ESXi Server using https, stop if the
connection fails
    Connect-VIServer -Server $server -Protocol https -ErrorAction Stop
    Write-Host "Successfully connected to $server" -ForegroundColor Green
}

# Connect to the vCenter/ESXi Server
Connect-VCServer

# Run the command to retrieve software versions and store the results
in the transcript
Write-Host "Querying software versions of all hosts..."
Get-VMHost | Select-Object Name, Version, Build

# Run the CIS Benchmark checks and store the results in a variable
# 1.Install
Write-Host "`n* These controls contain recommendations for settings
related to 1.Install" -ForegroundColor Blue
Ensure-ESXiIsProperlyPatched
Ensure-VIBAcceptanceLevelIsConfiguredProperly
Ensure-UnauthorizedModulesNotLoaded
Ensure-DefaultSaultIsConfiguredProperly

# 2.Communication
Write-Host "`n* These controls contain recommendations for settings
related to 2.Communication" -ForegroundColor Blue
Ensure-NTPTimeSynchronizationIsConfiguredProperly
Ensure-ESXiHostFirewallIsProperlyConfigured
Ensure-MOBIsDisabled
Ensure-DefaultSelfSignedCertificateIsNotUsed
Ensure-SNMPIsConfiguredProperly
Ensure-dvfilterIsDisabled
Ensure-DefaultExpiredOrRevokedCertificateIsNotUsed
Ensure-vSphereAuthenticationProxyIsUsedWithAD
Ensure-VDSHealthCheckIsDisabled

# 3.Logging
Write-Host "`n* These controls contain recommendations for settings
related to 3.Logging" -ForegroundColor Blue
Ensure-CentralizedESXiHostDumps
Ensure-PersistentLoggingIsConfigured
Ensure-RemoteLoggingIsConfigured

# 4.Access
Write-Host "`n* These controls contain recommendations for settings
related to 4.Access" -ForegroundColor Blue
Ensure-NonRootExistsForLocalAdmin
Ensure-PasswordsAreRequiredToBeComplex
Ensure-LoginAttemptsIsSetTo5
Ensure-AccountLockoutIsSetTo15Minutes
Ensure-Previous5PasswordsAreProhibited
Ensure-ADIsUsedForAuthentication
Ensure-OnlyAuthorizedUsersBelongToEsxAdminsGroup
Ensure-ExceptionUsersIsConfiguredManually

# 5.Console
Write-Host "`n* These controls contain recommendations for settings
related to 5.Console" -ForegroundColor Blue
Ensure-DCUITimeOutIs600
Ensure-ESXiShellIsDisabled
Ensure-SSHIsDisabled
Ensure-CIMAccessIsLimited
Ensure-NormalLockDownIsEnabled
Ensure-StrickLockdownIsEnabled
Ensure-SSHAuthorisedKeysFileIsEmpty
Ensure-IdleESXiShellAndSSHTimeout
Ensure-ShellServicesTimeoutIsProperlyConfigured
Ensure-DCUIHasTrustedUsersForLockDownMode
Ensure-ContentsOfExposedConfigurationsNotModified

# 6.Storage
Write-Host "`n* These controls contain recommendations for settings
related to 6.Storage" -ForegroundColor Blue
Ensure-BidirectionalCHAPAuthIsEnabled
Ensure-UniquenessOfCHAPAuthSecretsForiSCSI
Ensure-SANResourcesAreSegregatedProperly

# 7.Network
Write-Host "`n* These controls contain recommendations for settings
related to 7.Network" -ForegroundColor Blue
Ensure-vSwitchForgedTransmitsIsReject
Ensure-vSwitchMACAdressChangeIsReject
Ensure-vSwitchPromiscuousModeIsReject
Ensure-PortGroupsNotNativeVLAN
Ensure-PortGroupsNotUpstreamPhysicalSwitches
Ensure-PortGroupsAreNotConfiguredToVLAN0and4095
Ensure-VirtualDistributedSwitchNetflowTrafficSentToAuthorizedCollector
Ensure-PortLevelConfigurationOverridesAreDisabled

# 8.Virtual Machines
Write-Host "`n* These controls contain recommendations for settings
related to 8.Virtual Machines" -ForegroundColor Blue
Ensure-InformationalMessagesFromVMToVMXLimited
Ensure-OnlyOneRemoteConnectionIsPermittedToVMAtAnyTime
Ensure-UnnecessaryFloppyDevicesAreDisconnected
Ensure-UnnecessaryCdDvdDevicesAreDisconnected
Ensure-UnnecessaryParallelPortsAreDisconnected
Ensure-UnnecessarySerialPortsAreDisabled
Ensure-UnnecessaryUsbDevicesAreDisconnected
Ensure-UnauthorizedModificationOrDisconnectionOfDevicesIsDisabled
Ensure-UnauthorizedConnectionOfDevicesIsDisabled
Ensure-PciPcieDevicePassthroughIsDisabled
Ensure-UnnecessaryFunctionsInsideVMsAreDisabled
Ensure-UseOfTheVMConsoleIsLimited
Ensure-SecureProtocolsAreUsedForVirtualSerialPortAccess
Ensure-StandardProcessesAreUsedForVMDeployment
Ensure-AccessToVMsThroughDvFilterNetworkAPIsIsConfiguredCorrectly
Ensure-AutologonIsDisabled
Ensure-BIOSBBSIsDisabled
Ensure-GuestHostInteractionProtocolIsDisabled
Ensure-UnityTaskBarIsDisabled
Ensure-UnityActiveIsDisabled
Ensure-UnityWindowContentsIsDisabled
Ensure-UnityPushUpdateIsDisabled
Ensure-DragAndDropVersionGetIsDisabled
Ensure-DragAndDropVersionSetIsDisabled
Ensure-ShellActionIsDisabled
Ensure-DiskRequestTopologyIsDisabled
Ensure-TrashFolderStateIsDisabled
Ensure-GuestHostInterationTrayIconIsDisabled
Ensure-UnityIsDisabled
Ensure-UnityInterlockIsDisabled
Ensure-GetCredsIsDisabled
Ensure-HostGuestFileSystemServerIsDisabled
Ensure-GuestHostInteractionLaunchMenuIsDisabled
Ensure-memSchedFakeSampleStatsIsDisabled
Ensure-VMConsoleCopyOperationsAreDisabled
Ensure-VMConsoleDragAndDropOprerationsIsDisabled
Ensure-VMConsoleGUIOptionsIsDisabled
Ensure-VMConsolePasteOperationsAreDisabled
Ensure-VMLimitsAreConfiguredCorrectly
Ensure-HardwareBased3DAccelerationIsDisabled
Ensure-NonPersistentDisksAreLimited
Ensure-VirtualDiskShrinkingIsDisabled
Ensure-VirtualDiskWipingIsDisabled
Ensure-TheNumberOfVMLogFilesIsConfiguredProperly
Ensure-HostInformationIsNotSentToGuests
Ensure-VMLogFileSizeIsLimited

# Close the transcript
Stop-Transcript
