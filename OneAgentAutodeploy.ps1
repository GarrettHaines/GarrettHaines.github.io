# Dynatrace OneAgent Autodeploy
# Garrett Haines (Sprint)


# YOUR host group
$hostGroup = "Autodeploy"

# YOUR tenant ID
$tenantID = "https://dkz99748.sprint.dynatracelabs.com"

# YOUR token
$token = "dt0c01.ZLABM3EQTSL7CRIFVTOM6667.WZHKGFVVF6IEXAQLI7GM4QUMWNFX2RKHSEWCRE6RGWASCI2A7ZFQC5RHK7ON3DAQ"



# Deploy Dynatrace's OneAgent
function deploy {
	# Download Dynatrace OneAgent installer for Windows
	Invoke-Expression -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '$($tenantID)/api/v1/deployment/installer/agent/windows/default/latest?arch=x86&flavor=default' -Headers @{ 'Authorization' = 'Api-Token $($token)' } -OutFile 'Dynatrace-OneAgent-Installer-Windows.exe'"

	# Run file and begin installation
	Invoke-Expression -Command ".\Dynatrace-OneAgent-Installer-Windows.exe --set-infra-only=false --set-app-log-content-access=true --set-host-group=$($hostGroup) --quiet"
}

Add-Type -AssemblyName 'PresentationFramework'

$alreadyInstalled = Get-WmiObject win32_product -filter "Name like 'Dynatrace OneAgent'"

if ($alreadyInstalled) {
	$caption = "*** IT APPEARS THIS IS A FACTORY KEY ***"  
   	$message = "Are you Sure You Want To Proceed:"
	
	$continue = "Yes"
	$continue = [System.Windows.MessageBox]::Show($message, $caption, 'YesNo');
	 
	if ($continue -eq 'Yes')
		deploy
	else
		echo "Installation aborted."
} 
else {
	deploy
}
