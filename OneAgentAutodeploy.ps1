# Dynatrace OneAgent Autodeploy
# Garrett Haines (Sprint)

Add-Type -AssemblyName 'PresentationFramework'



# YOUR host group
$hostGroup = "Autodeploy"

# YOUR tenant ID
$tenantID = "dkz99748"

# YOUR token
$token = "dt0c01.ZLABM3EQTSL7CRIFVTOM6667.WZHKGFVVF6IEXAQLI7GM4QUMWNFX2RKHSEWCRE6RGWASCI2A7ZFQC5RHK7ON3DAQ"



function install {
	# Download Dynatrace OneAgent installer for Windows
	Invoke-Expression -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
								Invoke-WebRequest -Uri 'https://$($tenantID).sprint.dynatracelabs.com/api/v1/deployment/installer/agent/windows/default/latest?arch=x86&flavor=default'
										  -Headers @{ 'Authorization' = 'Api-Token $($token)' }
										  -OutFile 'Dynatrace-OneAgent-Installer-Windows.exe'"

	# Run file and begin installation
	Invoke-Expression -Command ".\Dynatrace-OneAgent-Installer-Windows.exe
					--set-infra-only=false
					--set-app-log-content-access=true
					--set-host-group=$($hostGroup)
					--quiet"
}


$alreadyInstalled = Get-WmiObject win32_product -filter "Name like 'Dynatrace OneAgent'"

if ($alreadyInstalled) {
	$continue = "Yes"
	$continue = [System.Windows.MessageBox]::Show($message, $caption, 'YesNo');
	
	$caption = "*** IT APPEARS THIS IS A FACTORY KEY ***"  
   	$message = "Are you Sure You Want To Proceed:"
	 
	if ($continue -eq 'Yes') {
		install
	}
	else {
		echo "Installation aborted."
	}
} 
else {
	install
}
